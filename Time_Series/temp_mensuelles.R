install.packages(c("forecast", "tseries", "boot"))

library(forecast)
library(tseries)
library(boot)

getwd()
setwd("Data path")
temperature_data <- read.csv("Data/Sao_Paulo.csv")

# Convert the data into a time series
temperature_ts <- ts(temperature_data$temperature, start = c(1948, 1), frequency = 12)



# Plot the time series
plot(temperature_ts, main = "Monthly Average Temperatures in São Paulo", 
     ylab = "Temperature", xlab = "Years")


# Plot autocorrelations
acf(temperature_ts, main = "Temperature ACF")
pacf(temperature_ts, main = "Temperature PACF")

# Test stationarity with Augmented Dickey-Fuller test
adf_test <- adf.test(temperature_ts)
print(adf_test)

# Differencing if necessary
temperature_diff <- diff(temperature_ts)
plot(temperature_diff, main = "Differenced Temperatures", 
     ylab = "Difference", xlab = "Years")

# Check after differencing
acf(temperature_diff, main = "ACF of Differenced Temperatures")
pacf(temperature_diff, main = "PACF of Differenced Temperatures")

# Split the data into training and test sets
temperature_train <- window(temperature_ts, end = c(1959, 12))
temperature_test <- window(temperature_ts, start = c(1960, 1))

# Fit multiple SARIMA models
sarima_models <- list(
  model1 = auto.arima(temperature_train, seasonal = TRUE),
  model2 = Arima(temperature_train, order = c(1, 0, 0), seasonal = c(0, 1, 1)),
  model3 = Arima(temperature_train, order = c(2, 1, 0), seasonal = c(1, 1, 1))
)

# Diagnostics for each model
lapply(sarima_models, function(model) {
  print(summary(model))
  checkresiduals(model)
})


# Compare models with AIC and BIC
sapply(sarima_models, function(model) c(AIC = AIC(model), BIC = BIC(model)))

# Choose the best model
best_model <- sarima_models$model1


# Forecast on the test data
forecast_values <- forecast(best_model, h = length(temperature_test))

# Plot the forecasts
plot(forecast_values, main = "SARIMA Forecasts", ylab = "Temperature", xlab = "Years")
lines(temperature_test, col = "red")
legend("topright", legend = c("Forecast", "Actual Data"), 
       col = c("blue", "red"), lty = 1)

# Non-parametric bootstrap
residuals <- residuals(best_model)

# Bootstrap function
bootstrap_function <- function(residuals, indices) {
  resampled_residuals <- residuals[indices]
  boot_forecast <- fitted(best_model) + resampled_residuals
  return(mean(boot_forecast))
}

boot_results <- boot(residuals, bootstrap_function, R = 500)
print(boot_results)

# Bootstrap confidence intervals
ci <- boot.ci(boot_results, type = "perc")
print(ci)


# Calculate the errors between forecasts and actual data
errors_sarima <- temperature_test - forecast_values$mean

# The errors
print(errors_sarima)

