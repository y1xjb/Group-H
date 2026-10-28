# Week 6: Poisson regression
# Question: Do home advantage and opponent rank explain
# the number of goals scored by Ashford United?

matches <- read.csv("data/ashford_matches.csv")

head(matches)
dim(matches)  # Should show 46 rows and 4 columns
summary(matches)
colSums(is.na(matches))

# Check the variables used in the model.
stopifnot(
  all(complete.cases(
    matches[c("goals_scored", "home_away", "opponent_rank")]
  )),
  all(matches$goals_scored >= 0),
  all(matches$goals_scored == floor(matches$goals_scored)),
  all(matches$home_away %in% c("Away", "Home"))
)

# Set Away as the reference category.
matches$home_away <- factor(
  matches$home_away,
  levels = c("Away", "Home")
)

# 2. Summary statistics ------------------------------------------

table(matches$goals_scored)

c(
  mean_goals = mean(matches$goals_scored),
  variance_goals = var(matches$goals_scored)
)

aggregate(
  goals_scored ~ home_away,
  data = matches,
  FUN = mean
)

# 3. Exploratory plots -------------------------------------------

barplot(
  table(matches$goals_scored),
  main = "Ashford United: goals scored per match",
  xlab = "Goals scored",
  ylab = "Number of matches",
  col = "steelblue"
)

boxplot(
  goals_scored ~ home_away,
  data = matches,
  main = "Goals scored at home and away",
  xlab = "Match location",
  ylab = "Goals scored",
  col = c("lightgrey", "lightblue")
)

# 4. Fit a Poisson regression ------------------------------------
#
# Response: goals_scored
# Predictors: home_away and opponent_rank
# Link function: log
#
# Larger opponent_rank values mean lower-finishing opponents.
# Rank is treated as numeric, assuming a linear relationship
# with log expected goals.
# Each observation is one full match, so no offset is used.

model <- glm(
  goals_scored ~ home_away + opponent_rank,
  family = poisson(link = "log"),
  data = matches
)

summary(model)
model$converged  # Should return TRUE

# Test each predictor while retaining the other predictor.
drop1(model, test = "Chisq")

# 5. Expected count ratios and 95% confidence intervals ------------
#
# Home ratio: expected goals at Home divided by those Away,
# holding opponent rank constant.
#
# Rank ratio: multiplier for each one-place increase in rank,
# holding match location constant.
#
# Ratio > 1: higher expected goals.
# Ratio < 1: lower expected goals.

beta <- coef(model)
se <- sqrt(diag(vcov(model)))

results <- data.frame(
  term = names(beta),
  log_coefficient = unname(beta),
  count_ratio = unname(exp(beta)),
  lower_95 = unname(exp(beta - qnorm(0.975) * se)),
  upper_95 = unname(exp(beta + qnorm(0.975) * se))
)

print(results, digits = 3)

# These are approximate Wald confidence intervals.
# The exponentiated intercept refers to Away at rank 0,
# which is outside the observed data.

# 6. Check dispersion and influential observations ----------------
#
# Poisson assumes variance equals the mean CONDITIONAL on
# the predictors. Comparing the overall raw mean and variance
# alone does not check this assumption.

pearson_res <- residuals(model, type = "pearson")

dispersion <- sum(pearson_res^2) / df.residual(model)
print(dispersion)

# Around 1: broadly consistent with Poisson dispersion.
# Appreciably above 1: possible overdispersion.
# This is a rough diagnostic, not a definitive test.

old_par <- par(mfrow = c(1, 2))

plot(
  fitted(model), pearson_res,
  main = "Residuals against fitted values",
  xlab = "Fitted expected goals",
  ylab = "Pearson residuals",
  pch = 19
)
abline(h = 0, col = "red", lty = 2)

plot(
  cooks.distance(model),
  type = "h",
  main = "Influential matches",
  xlab = "Row in dataset",
  ylab = "Cook's distance"
)

par(old_par)

# Inspect the three most influential observations.
influential_rows <- order(
  cooks.distance(model),
  decreasing = TRUE
)[1:3]

matches[influential_rows, ]

# The dataset includes an eight-goal match.
# Investigate influential observations; do not automatically
# remove them just because they are unusual.

# 7. Predict expected goals --------------------------------------

new_matches <- expand.grid(
  home_away = c("Away", "Home"),
  opponent_rank = c(5, 12, 20)
)

new_matches$home_away <- factor(
  new_matches$home_away,
  levels = levels(matches$home_away)
)

pred <- predict(
  model,
  newdata = new_matches,
  type = "link",
  se.fit = TRUE
)

new_matches$expected_goals <- exp(pred$fit)
new_matches$lower_95 <- exp(
  pred$fit - qnorm(0.975) * pred$se.fit
)
new_matches$upper_95 <- exp(
  pred$fit + qnorm(0.975) * pred$se.fit
)

print(new_matches, digits = 3)

# These are confidence intervals for the expected mean goals,
# not prediction intervals for an individual match.

# 8. Optional: sensitivity check for overdispersion ----------------

model_quasi <- glm(
  goals_scored ~ home_away + opponent_rank,
  family = quasipoisson(link = "log"),
  data = matches
)

summary(model_quasi)

# Quasi-Poisson retains the coefficient estimates but adjusts
# standard errors using the estimated dispersion.

# 9. Save results to the group's outputs folder -------------------

dir.create("outputs", showWarnings = FALSE)

write.csv(
  results,
  "outputs/week6_poisson_coefficients.csv",
  row.names = FALSE
)

write.csv(
  new_matches,
  "outputs/week6_poisson_predictions.csv",
  row.names = FALSE
)

capture.output(
  summary(model),
  file = "outputs/week6_poisson_summary.txt"
)

# Save diagnostic plots as a PDF.
pdf("outputs/week6_poisson_diagnostics.pdf", width = 9, height = 4.5)

par(mfrow = c(1, 2))

plot(
  fitted(model), pearson_res,
  main = "Residuals against fitted values",
  xlab = "Fitted expected goals",
  ylab = "Pearson residuals",
  pch = 19
)
abline(h = 0, col = "red", lty = 2)

plot(
  cooks.distance(model),
  type = "h",
  main = "Influential matches",
  xlab = "Row in dataset",
  ylab = "Cook's distance"
)

dev.off()

# Discussion notes:
# - Interpret home advantage while holding rank constant.
# - Interpret rank while holding home/away constant.
# - Discuss dispersion and influential observations.
# - Each opponent appears twice, so independence is an assumption
#   to revisit when studying grouped data.
# - Results describe associations, not causal effects.