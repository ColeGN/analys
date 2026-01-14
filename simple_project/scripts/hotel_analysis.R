library(dplyr)
library(ggplot2)
library(tidyr)

# data gaa unshih
data = read.csv("data/hotelbookingdata.csv")

# datagaa filterdeh 
data = filter(data, accommodationtype == "_ACCOM_TYPE@Hotel")
data = filter(data, s_city == "Vienna")
data = filter(data, year == 2017)
data = filter(data, month == 11)
data = filter(data, weekend == 0)
data = filter(data, starrating == 3 | starrating == 4)

# columnaa songoh
data = select(data, center1distance, price, guestreviewsrating , holiday)

# text number blgh ghimu 
# distance "4.5" "string" number =4,5  '4.5' 
data = separate(data, center1distance, into = c("distance", "miles"), sep = " ")
# 6.5 
data$distance = as.numeric(data$distance)
# 6.5 number blg avad 
data = select(data, -miles)

# text number blgh ghimu 
data = rename(data, rating = guestreviewsrating)
data = separate(data, rating, into = c("rating", "garbage"), sep = " ")
data$rating = as.numeric(data$rating)
data = select(data, -garbage)

# bhq bga data rowg ustganaa 
# distance not number not given c umu 
data = na.omit(data)
data = filter(data, price < 300, distance < 10)

# plots resultsaa uusgeneee 
dir.create("output/plots", showWarnings = FALSE, recursive = TRUE)
dir.create("output/results", showWarnings = FALSE, recursive = TRUE)

# mean median sd min max aaa grgj bga ghiimu exact number ognoo 
desc_stats = data.frame(
  Variable = c("price", "distance", "rating"),
  Mean = c(mean(data$price), mean(data$distance), mean(data$rating)),
  Median = c(median(data$price), median(data$distance), median(data$rating)),
  SD = c(sd(data$price), sd(data$distance), sd(data$rating)),
  Min = c(min(data$price), min(data$distance), min(data$rating)),
  Max = c(max(data$price), max(data$distance), max(data$rating))
)
write.csv(desc_stats, "output/results/descriptive_statistics.csv", row.names = FALSE)

# -1 ees 1 iin hoorond erembeljiga 4n hotel bhin -1 1 iin hoorond unelgee maygin -0.65 1 0.65
corr_matrix = cor(data)
write.csv(corr_matrix, "output/results/correlation_matrix.csv")

#end jinhene utgaaa olnoo odoo jisheeni 2 miliin zaid neg iim ratingtaa hotel bnaa gejign uniig rating holiin zainaas tootsoloh c ghimu zuerr taamaglana 
model = lm(price ~ distance + rating, data = data)

coef_df = data.frame(
  Variable = names(coef(model)),
  Coefficient = as.numeric(coef(model)),
  Std_Error = summary(model)$coefficients[, "Std. Error"],
  t_value = summary(model)$coefficients[, "t value"],
  p_value = summary(model)$coefficients[, "Pr(>|t|)"]
)
write.csv(coef_df, "output/results/regression_results.csv", row.names = FALSE)

# hamgin lagaas hmgin sugiig haritsulnaaa 
data$rating_group = ifelse(data$rating >= 4, "High Rating", "Low Rating")
t_test = t.test(price ~ rating_group, data = data)

# 1. Price histogram
png("output/plots/price_histogram.png", width = 800, height = 600, res = 100)
ggplot(data, aes(x = price)) +
  geom_histogram(bins = 30, fill = "skyblue", color = "white") +
  labs(title = "Distribution of Hotel Prices", x = "Price (EUR)", y = "Count") +
  theme_minimal()
dev.off()

# 2. Distance histogram
png("output/plots/distance_histogram.png", width = 800, height = 600, res = 100)
ggplot(data, aes(x = distance)) +
  geom_histogram(binwidth = 0.5, fill = "green", color = "black") +
  labs(title = "Distance from City Center", x = "Distance (miles)", y = "Count") +
  theme_minimal()
dev.off()

# 3. Price vs Distance scatter plot
png("output/plots/price_vs_distance.png", width = 800, height = 600, res = 100)
ggplot(data, aes(x = distance, y = price)) +
  geom_point(color = "darkblue", alpha = 0.6) +
  geom_smooth(method = "lm", color = "red", se = TRUE) +
  labs(title = "Price vs Distance", x = "Distance (miles)", y = "Price (EUR)") +
  theme_minimal()
dev.off()

# 4. Price by rating group boxplot
png("output/plots/price_by_rating.png", width = 800, height = 600, res = 100)
boxplot(price ~ rating_group, data = data, 
        col = c("lightcoral", "lightblue"),
        main = "Price by Rating Group", 
        xlab = "Rating Group", 
        ylab = "Price (EUR)")
dev.off()

# 5. Regression fit plot
png("output/plots/regression_fit.png", width = 800, height = 600, res = 100)
plot(data$price, fitted(model), 
     xlab = "Actual Price", 
     ylab = "Predicted Price",
     main = sprintf("Regression Fit (R² = %.3f)", summary(model)$r.squared),
     pch = 19, 
     col = rgb(0, 0, 1, 0.5))
abline(a = 0, b = 1, col = "red", lwd = 2, lty = 2)
grid()
dev.off()
