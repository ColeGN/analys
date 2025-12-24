import xml.etree.ElementTree as ET
import pandas as pd
import os
from datetime import datetime, timedelta

def convert_gretl_to_csv(gdt_file, output_csv):
    print("=" * 50)
    print("  GRETL TO CSV CONVERTER")
    print("=" * 50)
    print()
    
    print(f"📂 Reading Gretl file: {gdt_file}")
    
    try:
        tree = ET.parse(gdt_file)
        root = tree.getroot()
        
        variables_node = root.find('variables')
        var_names = [var.get('name') for var in variables_node.findall('variable')]
        print(f"   Variables found: {', '.join(var_names)}")
        
        obs_node = root.find('observations')
        obs_list = obs_node.findall('obs')
        
        data_list = []
        for obs in obs_list:
            values = obs.text.strip().split()
            data_list.append([float(v) for v in values if v])
        
        df = pd.DataFrame(data_list, columns=var_names)
        
        n_obs = len(df)
        start_date = datetime(1948, 1, 1)
        dates = pd.date_range(start=start_date, periods=n_obs, freq='MS')
        df.insert(0, 'date', dates)
        
        df.to_csv(output_csv, index=False)
        
        print("✅ SUCCESS!")
        print(f"   Observations: {n_obs}")
        print(f"   Saved to: {output_csv}")
        print()
        
        print("First 5 rows:")
        print(df.head())
        print()
        
        return df
        
    except Exception as e:
        print(f"❌ ERROR: {str(e)}")
        print("\nTroubleshooting:")
        print("  1. Make sure EconomicsUSA.gdt is in the 'data/' folder")
        print("  2. Check if the file path is correct")
        print("  3. Ensure xml.etree.ElementTree is available (built-in)")
        return None


if __name__ == "__main__":
    gdt_file = "data/EconomicsUSA.gdt"
    output_csv = "data/EconomicsUSA.csv"
    
    os.makedirs("data", exist_ok=True)
    os.makedirs("output/plots", exist_ok=True)
    os.makedirs("output/results", exist_ok=True)
    
    print("Starting conversion...\n")
    df = convert_gretl_to_csv(gdt_file, output_csv)
    
    if df is not None:
        print("=" * 50)
        print("🎉 Data ready for analysis!")
        print("Next step: Run detrend_analysis.py")
        print("=" * 50)
    else:
        print("=" * 50)
        print("Conversion failed. Please check the error messages above.")
        print("=" * 50)
