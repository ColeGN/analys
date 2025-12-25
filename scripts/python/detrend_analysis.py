import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from scipy import stats
from sklearn.linear_model import LinearRegression
from sklearn.metrics import r2_score, mean_squared_error
import os
import warnings
warnings.filterwarnings('ignore')

try:
    import seaborn as sns
    HAS_SEABORN = True
except ImportError:
    HAS_SEABORN = False
    print("Note: seaborn not available, using matplotlib for heatmap\n")
def load_data(file_path):
    """
    Load cross-sectional dataset
    Examples: housing.csv, students.csv, companies.csv, etc.
    """
    print("="*70)
    print(" CROSS-SECTIONAL DATA ANALYSIS ".center(70))
    print("="*70)
    print("\n📂 Loading data from:", file_path)
    
    try:
        df = pd.read_csv(file_path)
        print(f"✅ Loaded {len(df)} observations\n")
        return df
    except FileNotFoundError:
        print("❌ File not found! Creating sample dataset...\n")
        return create_sample_data()


def create_sample_data():
    """
    Create sample cross-sectional data if you don't have a dataset yet
    Example: Student performance data
    """
    np.random.seed(42)
    n = 200
    
    df = pd.DataFrame({
        'student_id': range(1, n+1),
        'study_hours': np.random.uniform(1, 10, n),
        'previous_grade': np.random.uniform(50, 95, n),
        'attendance': np.random.uniform(60, 100, n),
        'sleep_hours': np.random.uniform(4, 9, n),
        'final_grade': None  # We'll calculate this
    })
    
    df['final_grade'] = (
        40 + 
        2.5 * df['study_hours'] + 
        0.3 * df['previous_grade'] + 
        0.2 * df['attendance'] + 
        np.random.normal(0, 5, n)
    )
    df['final_grade'] = df['final_grade'].clip(0, 100)
    
    print("✅ Created sample student performance dataset")
    print("   Variables: study_hours, previous_grade, attendance, sleep_hours, final_grade\n")
    
    return df


def descriptive_analysis(df, output_dir):
    """
    Calculate and display descriptive statistics
    """
    print("\n" + "="*70)
    print(" DESCRIPTIVE STATISTICS ".center(70))
    print("="*70 + "\n")
    
    numeric_cols = df.select_dtypes(include=[np.number]).columns
    numeric_cols = [col for col in numeric_cols if 'id' not in col.lower()]
    
    stats_df = pd.DataFrame({
        'Mean': df[numeric_cols].mean(),
        'Median': df[numeric_cols].median(),
        'Std Dev': df[numeric_cols].std(),
        'Min': df[numeric_cols].min(),
        'Max': df[numeric_cols].max(),
        'Skewness': df[numeric_cols].skew(),
        'Kurtosis': df[numeric_cols].kurtosis()
    })
    
    print(stats_df.round(3))
    print("\n✅ Descriptive statistics calculated\n")
    
    stats_path = os.path.join(output_dir, 'results', 'descriptive_statistics.csv')
    stats_df.to_csv(stats_path)
    print(f"📁 Saved to: {stats_path}\n")
    
    return stats_df

def correlation_analysis(df, output_dir):
    print("="*70)
    print(" CORRELATION ANALYSIS ".center(70))
    print("="*70 + "\n")
    
    numeric_cols = df.select_dtypes(include=[np.number]).columns
    numeric_cols = [col for col in numeric_cols if 'id' not in col.lower()]
    
    corr_matrix = df[numeric_cols].corr()
    
    print("Correlation Matrix:")
    print(corr_matrix.round(3))
    print()
    
    corr_pairs = []
    for i in range(len(corr_matrix.columns)):
        for j in range(i+1, len(corr_matrix.columns)):
            corr_pairs.append({
                'Variable 1': corr_matrix.columns[i],
                'Variable 2': corr_matrix.columns[j],
                'Correlation': corr_matrix.iloc[i, j]
            })
    
    corr_pairs_df = pd.DataFrame(corr_pairs)
    corr_pairs_df = corr_pairs_df.sort_values('Correlation', 
                                                key=abs, 
                                                ascending=False)
    
    print("\nStrongest Correlations:")
    print(corr_pairs_df.head(5).to_string(index=False))
    print()
    
    plt.figure(figsize=(10, 8))
    if HAS_SEABORN:
        sns.heatmap(corr_matrix, annot=True, cmap='coolwarm', center=0,
                    square=True, linewidths=1, fmt='.2f')
    else:
        im = plt.imshow(corr_matrix, cmap='coolwarm', aspect='auto', vmin=-1, vmax=1)
        plt.colorbar(im)
        plt.xticks(range(len(corr_matrix.columns)), corr_matrix.columns, rotation=45, ha='right')
        plt.yticks(range(len(corr_matrix.columns)), corr_matrix.columns)
        for i in range(len(corr_matrix.columns)):
            for j in range(len(corr_matrix.columns)):
                plt.text(j, i, f'{corr_matrix.iloc[i, j]:.2f}', 
                        ha='center', va='center', color='black')
    plt.title('Correlation Matrix Heatmap', fontsize=16, fontweight='bold')
    plt.tight_layout()
    plot_path = os.path.join(output_dir, 'plots', 'correlation_matrix.png')
    plt.savefig(plot_path, dpi=300, bbox_inches='tight')
    print(f"✅ Saved: {plot_path}\n")
    plt.close()
    
    return corr_matrix


def regression_analysis(df, dependent_var, independent_vars, output_dir):
    print("="*70)
    print(" MULTIPLE REGRESSION ANALYSIS ".center(70))
    print("="*70 + "\n")
    
    print(f"Dependent Variable: {dependent_var}")
    print(f"Independent Variables: {', '.join(independent_vars)}\n")
    
    X = df[independent_vars].values
    y = df[dependent_var].values
    
    mask = ~np.isnan(X).any(axis=1) & ~np.isnan(y)
    X = X[mask]
    y = y[mask]
    
    model = LinearRegression()
    model.fit(X, y)
    
    y_pred = model.predict(X)
    
    r2 = r2_score(y, y_pred)
    rmse = np.sqrt(mean_squared_error(y, y_pred))
    adj_r2 = 1 - (1 - r2) * (len(y) - 1) / (len(y) - len(independent_vars) - 1)
    
    print("REGRESSION EQUATION:")
    equation = f"{dependent_var} = {model.intercept_:.4f}"
    for i, var in enumerate(independent_vars):
        sign = "+" if model.coef_[i] >= 0 else ""
        equation += f" {sign} {model.coef_[i]:.4f}*{var}"
    print(equation)
    print()
    
    print("COEFFICIENTS:")
    coef_df = pd.DataFrame({
        'Variable': independent_vars,
        'Coefficient': model.coef_,
        'Abs_Coefficient': np.abs(model.coef_)
    }).sort_values('Abs_Coefficient', ascending=False)
    print(coef_df[['Variable', 'Coefficient']].to_string(index=False))
    print()
    
    print("MODEL FIT STATISTICS:")
    print(f"  R-squared:          {r2:.4f}")
    print(f"  Adjusted R-squared: {adj_r2:.4f}")
    print(f"  RMSE:               {rmse:.4f}")
    print()
    
    print("INTERPRETATION:")
    strongest_var = coef_df.iloc[0]
    print(f"  • {strongest_var['Variable']} has the strongest effect")
    print(f"  • A 1-unit increase in {strongest_var['Variable']} leads to")
    print(f"    {strongest_var['Coefficient']:.4f} change in {dependent_var}")
    print(f"  • The model explains {r2*100:.1f}% of the variance\n")
    
    plt.figure(figsize=(10, 6))
    plt.scatter(y, y_pred, alpha=0.5)
    plt.plot([y.min(), y.max()], [y.min(), y.max()], 'r--', lw=2)
    plt.xlabel(f'Actual {dependent_var}')
    plt.ylabel(f'Predicted {dependent_var}')
    plt.title(f'Actual vs Predicted {dependent_var}\n(R² = {r2:.3f})')
    plt.grid(True, alpha=0.3)
    plt.tight_layout()
    plot_path = os.path.join(output_dir, 'plots', 'regression_fit.png')
    plt.savefig(plot_path, dpi=300, bbox_inches='tight')
    print(f"✅ Saved: {plot_path}\n")
    plt.close()
    
    residuals = y - y_pred
    plt.figure(figsize=(10, 6))
    plt.scatter(y_pred, residuals, alpha=0.5)
    plt.axhline(y=0, color='r', linestyle='--', lw=2)
    plt.xlabel(f'Predicted {dependent_var}')
    plt.ylabel('Residuals')
    plt.title('Residual Plot')
    plt.grid(True, alpha=0.3)
    plt.tight_layout()
    plot_path = os.path.join(output_dir, 'plots', 'residuals.png')
    plt.savefig(plot_path, dpi=300, bbox_inches='tight')
    print(f"✅ Saved: {plot_path}\n")
    plt.close()
    
    results_df = pd.DataFrame({
        'Metric': ['R-squared', 'Adjusted R-squared', 'RMSE', 'Intercept'],
        'Value': [r2, adj_r2, rmse, model.intercept_]
    })
    coef_results = coef_df[['Variable', 'Coefficient']].rename(
        columns={'Variable': 'Metric', 'Coefficient': 'Value'}
    )
    results_df = pd.concat([results_df, coef_results], ignore_index=True)
    results_path = os.path.join(output_dir, 'results', 'regression_results.csv')
    results_df.to_csv(results_path, index=False)
    print(f"✅ Saved: {results_path}\n")
    
    return model, results_df


def hypothesis_testing(df, group_var, test_var, output_dir):
    print("="*70)
    print(" HYPOTHESIS TESTING ".center(70))
    print("="*70 + "\n")
    
    df_test = df.copy()
    if df_test[group_var].dtype in [np.float64, np.int64]:
        median_val = df_test[group_var].median()
        df_test['group'] = df_test[group_var].apply(
            lambda x: 'High' if x > median_val else 'Low'
        )
        group_var_used = 'group'
        print(f"Created groups based on median split of original variable\n")
    else:
        group_var_used = group_var
    
    groups = df_test[group_var_used].unique()
    
    if len(groups) == 2:
        group1 = df_test[df_test[group_var_used] == groups[0]][test_var].dropna()
        group2 = df_test[df_test[group_var_used] == groups[1]][test_var].dropna()
        
        t_stat, p_value = stats.ttest_ind(group1, group2)
        
        print("TWO-SAMPLE T-TEST")
        print(f"Testing: {test_var} across {group_var_used} groups\n")
        print(f"Group 1 ({groups[0]}): Mean = {group1.mean():.3f}, SD = {group1.std():.3f}, N = {len(group1)}")
        print(f"Group 2 ({groups[1]}): Mean = {group2.mean():.3f}, SD = {group2.std():.3f}, N = {len(group2)}\n")
        print(f"T-statistic: {t_stat:.4f}")
        print(f"P-value:     {p_value:.4f}\n")
        
        if p_value < 0.05:
            print(f"✅ SIGNIFICANT: {test_var} differs significantly between groups (p < 0.05)")
        else:
            print(f"❌ NOT SIGNIFICANT: No significant difference between groups (p ≥ 0.05)")
        
        plt.figure(figsize=(10, 6))
        df_test.boxplot(column=test_var, by=group_var_used)
        plt.suptitle('')
        plt.title(f'{test_var} by {group_var_used}\n(p-value = {p_value:.4f})')
        plt.ylabel(test_var)
        plt.tight_layout()
        plot_path = os.path.join(output_dir, 'plots', 'hypothesis_test.png')
        plt.savefig(plot_path, dpi=300, bbox_inches='tight')
        print(f"\n✅ Saved: {plot_path}\n")
        plt.close()
        
    else:
        group_data = [df_test[df_test[group_var_used] == g][test_var].dropna() for g in groups]
        f_stat, p_value = stats.f_oneway(*group_data)
        
        print("ONE-WAY ANOVA")
        print(f"Testing: {test_var} across {group_var_used} groups\n")
        for g, data in zip(groups, group_data):
            print(f"{g}: Mean = {data.mean():.3f}, SD = {data.std():.3f}, N = {len(data)}")
        print(f"\nF-statistic: {f_stat:.4f}")
        print(f"P-value:     {p_value:.4f}\n")
        
        if p_value < 0.05:
            print(f"✅ SIGNIFICANT: {test_var} differs significantly across groups (p < 0.05)")
        else:
            print(f"❌ NOT SIGNIFICANT: No significant difference across groups (p ≥ 0.05)")

def main():
    project_root = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    
    output_dir = os.path.join(project_root, 'output', 'python')
    os.makedirs(os.path.join(output_dir, 'plots'), exist_ok=True)
    os.makedirs(os.path.join(output_dir, 'results'), exist_ok=True)
    
    data_path = os.path.join(project_root, 'data', 'cross_sectional_data.csv')
    df = load_data(data_path)  
    
    if not os.path.exists(data_path):
        os.makedirs(os.path.join(project_root, 'data'), exist_ok=True)
        df.to_csv(data_path, index=False)
        print(f"💾 Sample data saved to: {data_path}")
        print("   You can replace this with your own cross-sectional dataset!\n")
    
    print("Dataset Preview:")
    print(df.head())
    print()
    
    desc_stats = descriptive_analysis(df, output_dir)
    
    corr_matrix = correlation_analysis(df, output_dir)
    
    numeric_cols = df.select_dtypes(include=[np.number]).columns.tolist()
    numeric_cols = [col for col in numeric_cols if 'id' not in col.lower()]
    
    if 'final_grade' in df.columns:
        dependent = 'final_grade'
        independent = [col for col in ['study_hours', 'previous_grade', 'attendance'] 
                      if col in df.columns and col != dependent]
    else:
        dependent = numeric_cols[0] if len(numeric_cols) > 0 else None
        independent = numeric_cols[1:4] if len(numeric_cols) > 1 else []
    
    if dependent and len(independent) > 0:
        model, results = regression_analysis(df, dependent, independent, output_dir)
        
        if len(independent) > 0:
            hypothesis_testing(df, independent[0], dependent, output_dir)
    
    print("\n" + "="*70)
    print(" ANALYSIS COMPLETE! 🎉 ".center(70))
    print("="*70)
    print(f"\n📁 Generated files in: {output_dir}/")
    print("   • plots/correlation_matrix.png")
    print("   • plots/regression_fit.png")
    print("   • plots/residuals.png")
    print("   • plots/hypothesis_test.png")
    print("   • results/descriptive_statistics.csv")
    print("   • results/regression_results.csv")
    print("\n✨ Ready for your exam!\n")


if __name__ == "__main__":
    main()
