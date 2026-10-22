#Week 4: Binomial Regression

players <- read.csv("league_players.csv")
str(players)
players$position <- factor(players$position, levels = c("DEF", "GK", "MID", "FWD"))
table(players$injured)
prop.table(table(players$injured))

players$any_prev <- as.integer(players$prev_injuries > 0)
tab <- table(any_prev = players$any_prev, injured = players$injured)
tab

inj.glm <- glm(injured ~ any_prev, family = binomial, data = players)
summary(inj.glm)
exp(coef(inj.glm)[2])

confint.default(inj.glm)
confint(inj.glm)
exp(confint(inj.glm))

inj2.data <- data.frame( 
  injured = c(tab["0", "1"], tab["1", "1"]),
  notinjured = c(tab["0", "0"], tab["1", "0"]),
  any_prev = c(0,1))

inj3.data <-aggregate(injured ~ prev_injuries, data = players, FUN = function(x) c(inj = sum(x), n = length(x)))
inj3.data <- data.frame(prev_injuries = inj3.data$prev_injuries,
                        injured = inj3.data$injured[, "inj"],
                        notinjured = inj3.data$injured[, "n"] - inj3.data$injured[, "inj"],
                        n = inj3.data$injured[, "n"])

inj3.glm <- glm(cbind(injured, notinjured) ~ prev_injuries,
                family = binomial, data = inj3.data)
summary(inj3.glm)
coef(glm(injured ~ prev_injuries, family = binomial, data = players))


model_full <- glm(injured ~ age + minutes_played + training_load + prev_injuries + bmi + position,
                  family = binomial, data = players)

summary(model_full)$coefficients

drop1(model_full, test = "Chisq")
model_reduced <- glm(injured ~ age + training_load + prev_injuries,
                     family = binomial, data = players)

anova(model_reduced, model_full, test = "Chisq")
AIC(model_full, model_reduced)

lambda <- model_reduced$null.deviance - model_reduced$deviance
lrt_df <- model_reduced$df.null - model_reduced$df.residual
pchisq(lambda, lrt_df, lower.tail = FALSE)

model_cat <- glm(injured ~ age + factor(training_load) + prev_injuries,
                 family = binomial, data = players)
anova(model_reduced, model_cat, test = "Chisq")

exp(cbind(OR = coef(model_reduced), confint(model_reduced)))
change_in_x <- 5
exp(change_in_x * coef(model_reduced)["age"])
exp(change_in_x * confint(model_reduced)["age", ])

coef(model_reduced)["prev_injuries"] / coef(model_reduced)["age"]

example_players <- data.frame(age = c(22, 22, 30, 30),
                              training_load = c(2, 5, 2, 5),
                              prev_injuries = c(0, 0, 2, 2))

example_players$p_hat <- predict(model_reduced, example_players, type = "response")
example_players