# ============================================================================
# HOTEL PRICE ANALYSIS - VIENNA
# ============================================================================
# What we're doing: Analyzing what affects hotel prices in Vienna
# Data: Hotel bookings from November 2017
# ============================================================================

# Import libraries (tools we need)
import pandas as pd                          # For working with data
import numpy as np                           # For math operations
import matplotlib.pyplot as plt              # For making graphs
from scipy import stats                      # For statistical tests
from sklearn.linear_model import LinearRegression  # For regression
import os                                    # For creating folders

# ============================================================================
# STEP 1: LOAD THE DATA
# ============================================================================
# Read the CSV file
data = pd.read_csv("data/hotelbookingdata.csv")

# ============================================================================
# STEP 2: FILTER THE DATA (keep only what we need)
# ============================================================================
# Keep only hotels in Vienna, November 2017, weekdays, 3-4 stars
data = data[data['accommodationtype'] == '_ACCOM_TYPE@Hotel']
data = data[data['s_city'] == 'Vienna']
data = data[data['year'] == 2017]
data = data[data['month'] == 11]
data = data[data['weekend'] == 0]
data = data[data['starrating'].isin([3, 4])]

# ============================================================================
# STEP 3: SELECT COLUMNS WE NEED
# ============================================================================
# We only need 3 columns: distance, price, rating
data = data[['center1distance', 'price', 'guestreviewsrating']].copy()

# ============================================================================
# STEP 4: CLEAN THE DATA
# ============================================================================
# Clean distance: "1.5 miles" -> 1.5
data[['distance', 'unit']] = data['center1distance'].str.split(' ', n=1, expand=True)
data['distance'] = pd.to_numeric(data['distance'], errors='coerce')

# Clean rating: "4.2 /5" -> 4.2
data[['rating', 'garbage']] = data['guestreviewsrating'].str.split(' ', n=1, expand=True)
data['rating'] = pd.to_numeric(data['rating'], errors='coerce')

# Keep only the columns we need
data = data[['price', 'distance', 'rating']]

# Remove rows with missing values
data = data.dropna()

# Remove outliers (very expensive or very far hotels)
data = data[data['price'] < 300]
data = data[data['distance'] < 10]

# ============================================================================
# STEP 5: CREATE OUTPUT FOLDERS
# ============================================================================
os.makedirs("output/plots", exist_ok=True)
os.makedirs("output/results", exist_ok=True)

# ============================================================================
# ANALYSIS 1: DESCRIPTIVE STATISTICS
# ============================================================================
# Calculate mean, median, etc. for each variable

desc_stats = pd.DataFrame({
    'Variable': ['price', 'distance', 'rating'],
    'Mean': [data['price'].mean(), data['distance'].mean(), data['rating'].mean()],
    'Median': [data['price'].median(), data['distance'].median(), data['rating'].median()],
    'SD': [data['price'].std(), data['distance'].std(), data['rating'].std()],
    'Min': [data['price'].min(), data['distance'].min(), data['rating'].min()],
    'Max': [data['price'].max(), data['distance'].max(), data['rating'].max()]
})

# Save to CSV file
desc_stats.to_csv("output/results/descriptive_statistics.csv", index=False)

# ============================================================================
# ANALYSIS 2: CORRELATION
# ============================================================================
# How are the variables related to each other?

corr_matrix = data.corr()

# Save to CSV file
corr_matrix.to_csv("output/results/correlation_matrix.csv")

# ============================================================================
# ANALYSIS 3: REGRESSION
# ============================================================================
# Question: How do distance and rating affect price?
# Model: price = intercept + (distance × β1) + (rating × β2)

# Prepare data
X = data[['distance', 'rating']].values  # Independent variables
y = data['price'].values                 # Dependent variable

# Create and fit the model
model = LinearRegression()
model.fit(X, y)

# Make predictions
y_pred = model.predict(X)

# Calculate R-squared (how good is the fit)
r2 = model.score(X, y)

# Save results
results_df = pd.DataFrame({
    'Variable': ['Intercept', 'distance', 'rating'],
    'Coefficient': [model.intercept_, model.coef_[0], model.coef_[1]]
})
results_df.to_csv("output/results/regression_results.csv", index=False)

# ============================================================================
# ANALYSIS 4: T-TEST
# ============================================================================
# Question: Do high-rated hotels cost more than low-rated hotels?

# Create groups: High Rating (>= 4) vs Low Rating (< 4)
data['rating_group'] = data['rating'].apply(lambda x: 'High Rating' if x >= 4 else 'Low Rating')

# Get prices for each group
high_rating = data[data['rating_group'] == 'High Rating']['price']
low_rating = data[data['rating_group'] == 'Low Rating']['price']

# Run t-test
t_stat, p_value = stats.ttest_ind(high_rating, low_rating)

# ============================================================================
# VISUALIZATION 1: PRICE HISTOGRAM
# ============================================================================
# Shows how prices are distributed

plt.figure(figsize=(8, 6))
plt.hist(data['price'], bins=30, color='skyblue', edgecolor='white')
plt.xlabel('Price (EUR)')
plt.ylabel('Count')
plt.title('Distribution of Hotel Prices')
plt.grid(alpha=0.3)
plt.savefig("output/plots/price_histogram.png", dpi=100, bbox_inches='tight')
plt.close()

# ============================================================================
# VISUALIZATION 2: DISTANCE HISTOGRAM
# ============================================================================
# Shows how far hotels are from city center

plt.figure(figsize=(8, 6))
plt.hist(data['distance'], bins=20, color='green', edgecolor='black')
plt.xlabel('Distance (miles)')
plt.ylabel('Count')
plt.title('Distance from City Center')
plt.grid(alpha=0.3)
plt.savefig("output/plots/distance_histogram.png", dpi=100, bbox_inches='tight')
plt.close()

# ============================================================================
# VISUALIZATION 3: PRICE VS DISTANCE
# ============================================================================
# Shows relationship between price and distance

plt.figure(figsize=(8, 6))
plt.scatter(data['distance'], data['price'], color='darkblue', alpha=0.6)

# Add trend line
z = np.polyfit(data['distance'], data['price'], 1)
p = np.poly1d(z)
plt.plot(data['distance'], p(data['distance']), "r--", linewidth=2)

plt.xlabel('Distance (miles)')
plt.ylabel('Price (EUR)')
plt.title('Price vs Distance')
plt.grid(alpha=0.3)
plt.savefig("output/plots/price_vs_distance.png", dpi=100, bbox_inches='tight')
plt.close()

# ============================================================================
# VISUALIZATION 4: PRICE BY RATING GROUP
# ============================================================================
# Compares prices between high and low rated hotels

plt.figure(figsize=(8, 6))
data.boxplot(column='price', by='rating_group', patch_artist=True)
plt.suptitle('')
plt.title('Price by Rating Group')
plt.xlabel('Rating Group')
plt.ylabel('Price (EUR)')
plt.savefig("output/plots/price_by_rating.png", dpi=100, bbox_inches='tight')
plt.close()

# ============================================================================
# VISUALIZATION 5: REGRESSION FIT
# ============================================================================
# Shows how well our model predicts prices

plt.figure(figsize=(8, 6))
plt.scatter(y, y_pred, alpha=0.5, color='blue')
plt.plot([y.min(), y.max()], [y.min(), y.max()], 'r--', lw=2)
plt.xlabel('Actual Price')
plt.ylabel('Predicted Price')
plt.title(f'Regression Fit (R² = {r2:.3f})')
plt.grid(alpha=0.3)
plt.savefig("output/plots/regression_fit.png", dpi=100, bbox_inches='tight')
plt.close()

# ============================================================================
# DONE!
# ============================================================================
print("Analysis complete. Results saved to output/")
