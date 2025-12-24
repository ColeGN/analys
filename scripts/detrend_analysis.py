import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import os
from scipy import stats

def estimate_params(y):
    T = len(y)
    t = np.arange(1, T + 1)
    m_T = (T + 1) / 2
    v_T = T * (T + 1) / 12
    c_T = (np.sum(t * y) - T * (np.mean(y) * (T + 1) / 2)) / (T - 1)
    
    beta = c_T / v_T
    alpha = np.mean(y) - beta * m_T
    
    return {'alpha': alpha, 'beta': beta}


def ME(actual, forecast):
    return np.nanmean(actual - forecast)


def RMSE(actual, forecast):
    return np.sqrt(np.nanmean((actual - forecast) ** 2))


def MAE(actual, forecast):
    return np.nanmean(np.abs(actual - forecast))


def MPE(actual, forecast):
    return np.nanmean(100 * (actual - forecast) / actual)


def MAPE(actual, forecast):
    return np.nanmean(100 * np.abs((actual - forecast) / actual))


def TheilU(actual, forecast):
    n = len(actual)
    if n <= 1:
        return np.nan
    
    actual_shifted = actual[1:]
    forecast_shifted = forecast[:-1]
    actual_current = actual[:-1]
    
    mask = actual_current != 0
    if not np.any(mask):
        return np.nan
    
    numerator = np.nanmean(((forecast_shifted[mask] - actual_shifted[mask]) / actual_current[mask]) ** 2)
    denominator = np.nanmean(((actual_shifted[mask] - actual_current[mask]) / actual_current[mask]) ** 2)
    
    if np.isnan(denominator) or denominator == 0:
        return np.nan
    
    return numerator / denominator


def MSE_decomposition(actual, forecast):
    T = len(actual)
    scale = (T - 1) / T
    
    y_mean = np.nanmean(actual)
    f_mean = np.nanmean(forecast)
    sy = np.sqrt(scale * np.nanvar(actual))
    sf = np.sqrt(scale * np.nanvar(forecast))
    
    valid_mask = ~(np.isnan(actual) | np.isnan(forecast))
    if np.sum(valid_mask) > 1:
        r = np.corrcoef(actual[valid_mask], forecast[valid_mask])[0, 1]
    else:
        r = 0
    
    if np.isnan(r):
        r = 0
    
    bias = (y_mean - f_mean) ** 2
    regression = (sf - r * sy) ** 2
    disturbance = (1 - r ** 2) * sy ** 2
    
    MSE_total = bias + regression + disturbance
    
    if MSE_total == 0 or np.isnan(MSE_total):
        return {'MSE': 0, 'UM': 0, 'UR': 0, 'UD': 0}
    
    UM = bias / MSE_total
    UR = regression / MSE_total
    UD = disturbance / MSE_total
    
    return {'MSE': MSE_total, 'UM': UM, 'UR': UR, 'UD': UD}


def main():
    print("\n" + "=" * 50)
    print("  TIME SERIES DETRENDING ANALYSIS (Python)")
    print("=" * 50 + "\n")
    
    print("📂 Loading data...")
    df = pd.read_csv("data/EconomicsUSA.csv")
    df['date'] = pd.to_datetime(df['date'])
    
    print(f"   Observations: {len(df)}")
    print(f"   Variables: {', '.join(df.columns)}")
    print()
    
    variables = ["indpro", "cpiaucsl"]
    forecasts = {}
    results = []
    
    print("=" * 50)
    print("METHOD 1: LINEAR TREND ESTIMATION")
    print("=" * 50 + "\n")
    
    for i, var_name in enumerate(variables, 1):
        y = df[var_name].values
        
        params = estimate_params(y)
        alpha = params['alpha']
        beta = params['beta']
        
        t = np.arange(1, len(y) + 1)
        trend = alpha + beta * t
        
        forecasts[f"TREND_{i}"] = trend
        
        print(f"{var_name.upper()}:")
        print(f"  Trend equation: TT = {alpha:.6f} + {beta:.6f}*t")
        direction = "Increasing" if beta > 0 else "Decreasing"
        print(f"  Interpretation: {direction} trend by {abs(beta):.6f} per period")
        print()
        
        plt.figure(figsize=(12, 6))
        plt.plot(y, linewidth=2, color='blue', label='Original')
        plt.plot(trend, linewidth=2, color='red', linestyle='--', label='Linear Trend')
        plt.title(f"{var_name.upper()} - Linear Trend", fontsize=14, fontweight='bold')
        plt.xlabel("Time Period")
        plt.ylabel("Value")
        plt.legend()
        plt.grid(True, alpha=0.3)
        plt.tight_layout()
        
        plot_path = f"output/plots/{var_name}_linear_trend.png"
        plt.savefig(plot_path, dpi=120, bbox_inches='tight')
        plt.close()
        
        print(f"  ✅ Saved: {plot_path}\n")
    
    print("=" * 50)
    print("METHOD 2: MOVING AVERAGE (ORDER=4)")
    print("=" * 50 + "\n")
    
    window = 4
    for i, var_name in enumerate(variables, 1):
        y = df[var_name].values
        ma = pd.Series(y).rolling(window=window, center=False).mean().values
        
        forecasts[f"MA_{i}"] = ma
        
        print(f"{var_name.upper()}:")
        print(f"  Moving average window: {window} periods")
        print(f"  First {window-1} values are NaN (not enough data)")
        print()
        
        plt.figure(figsize=(12, 6))
        plt.plot(y, linewidth=2, color='blue', label='Original')
        plt.plot(ma, linewidth=2, color='green', linestyle='--', label=f'Moving Average (k={window})')
        plt.title(f"{var_name.upper()} - Moving Average", fontsize=14, fontweight='bold')
        plt.xlabel("Time Period")
        plt.ylabel("Value")
        plt.legend()
        plt.grid(True, alpha=0.3)
        plt.tight_layout()
        
        plot_path = f"output/plots/{var_name}_moving_average.png"
        plt.savefig(plot_path, dpi=120, bbox_inches='tight')
        plt.close()
        
        print(f"  ✅ Saved: {plot_path}\n")
    
    print("=" * 50)
    print("FORECAST EVALUATION STATISTICS")
    print("=" * 50 + "\n")
    
    for model_name, forecast in forecasts.items():
        var_idx = int(model_name.split('_')[1]) - 1
        var_name = variables[var_idx]
        actual = df[var_name].values
        
        me = ME(actual, forecast)
        rmse = RMSE(actual, forecast)
        mae = MAE(actual, forecast)
        mpe = MPE(actual, forecast)
        mape = MAPE(actual, forecast)
        theil_u = TheilU(actual, forecast)
        mse_decomp = MSE_decomposition(actual, forecast)
        
        results.append({
            'Model': model_name,
            'ME': me,
            'RMSE': rmse,
            'MAE': mae,
            'MPE': mpe,
            'MAPE': mape,
            'Theil_U': theil_u,
            'MSE': mse_decomp['MSE'],
            'UM': mse_decomp['UM'],
            'UR': mse_decomp['UR'],
            'UD': mse_decomp['UD']
        })
    
    results_df = pd.DataFrame(results)
    print(results_df.to_string(index=False))
    print()
    
    results_path = "output/results/forecast_evaluation.csv"
    results_df.to_csv(results_path, index=False)
    print(f"✅ Results saved to: {results_path}\n")
    
    print("=" * 50)
    print("INTERPRETATION GUIDE")
    print("=" * 50 + "\n")
    print("Lower values = Better forecast accuracy\n")
    print("• ME (Mean Error): Measures bias (closer to 0 = better)")
    print("• RMSE: Penalizes large errors, good overall measure")
    print("• MAE: Average error magnitude")
    print("• MAPE: Percentage error (easy to interpret)")
    print("• Theil's U: Normalized accuracy (< 1 = better than naive forecast)\n")
    print("MSE Decomposition:")
    print("• UM: Bias proportion (systematic over/under prediction)")
    print("• UR: Regression proportion (different variation)")
    print("• UD: Disturbance proportion (unexplained randomness)\n")
    
    print("=" * 50)
    print("SUMMARY")
    print("=" * 50 + "\n")
    
    for var in variables:
        print(f"{var.upper()}:")
        var_idx = variables.index(var) + 1
        
        trend_rmse = results_df[results_df['Model'] == f"TREND_{var_idx}"]['RMSE'].values
        ma_rmse = results_df[results_df['Model'] == f"MA_{var_idx}"]['RMSE'].values
        
        if len(trend_rmse) > 0 and len(ma_rmse) > 0:
            if not np.isnan(trend_rmse[0]) and not np.isnan(ma_rmse[0]):
                if trend_rmse[0] < ma_rmse[0]:
                    print("  → Linear Trend performs better (lower RMSE)")
                else:
                    print("  → Moving Average performs better (lower RMSE)")
            else:
                print("  → Cannot compare (missing RMSE values)")
        print()
    
    print("=" * 50)
    print("ANALYSIS COMPLETE! 🎉")
    print("=" * 50)
    print()
    print("📁 Check your output folder:")
    print("   output/plots/     - All visualizations")
    print("   output/results/   - Forecast evaluation CSV")
    print()
    print("✨ You're ready for your exam!")


if __name__ == "__main__":
    os.makedirs("output/plots", exist_ok=True)
    os.makedirs("output/results", exist_ok=True)
    
    main()
