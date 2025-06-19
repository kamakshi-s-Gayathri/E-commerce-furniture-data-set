# Load necessary packages
library(tidyverse)
library(ggplot2)
library(readr)
library(caret)
library(randomForest)
library(corrplot)

# Load cleaned dataset
furniture = read_csv("C:\\Users\\intel\\OneDrive\\Desktop\\unified mentor\\E-commerce furniture Dataset\\Furniture_Cleaned.csv")
furniture <- read_csv("C:\\Users\\intel\\OneDrive\\Desktop\\unified mentor\\E-commerce furniture Dataset\\Furniture_Cleaned.csv", col_names = FALSE)

# Manually set the column names
colnames(furniture) <- c("productTitle", "originalPrice", "price", "sold", "tagText", "discount_percentage")


# View structure
glimpse(furniture)

##EDA
# Summary statistics
summary(furniture)

# Check for NA values
colSums(is.na(furniture))

# Distribution of sold values
ggplot(furniture, aes(x = sold)) +
  geom_histogram(fill = "#2c3e50", bins = 30, color = "white") +
  labs(title = "Distribution of Furniture Items Sold", x = "Units Sold", y = "Count")

##Analyse discount impact
# Scatter plot: Discount vs. Sold
ggplot(furniture, aes(x = discount_percentage, y = sold)) +
  geom_point(color = "#e74c3c", alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE, color = "blue") +
  labs(title = "Discount % vs. Items Sold", x = "Discount Percentage", y = "Units Sold")


# Boxplot: Shipping Type vs. Sold
ggplot(furniture, aes(x = tagText, y = sold, fill = tagText)) +
  geom_boxplot() +
  labs(title = "Items Sold by Shipping Tag", x = "Shipping Tag", y = "Units Sold") +
  theme_minimal()

# Correlation matrix for numeric features
numeric_data <- furniture %>% select(price, originalPrice, discount_percentage, sold)
cor_matrix <- cor(numeric_data, use = "complete.obs")
corrplot(cor_matrix, method = "circle", type = "lower", tl.cex = 0.8)





