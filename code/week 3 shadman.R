# Week 3: Introduction to GLMs
# Which variables are responses, which are explanatory, and what type is each response?

players <- read.csv("data/league_players.csv")
matches <- read.csv("data/ashford_matches.csv")

str(players)
str(matches)

# 1. Possible responses
# injured        - binary (0/1)        -> binomial GLM, logit link
# goals_scored   - count (0, 1, 2, ...) -> Poisson GLM, log link
# goals_conceded - count (0, 1, 2, ...) -> Poisson GLM, log link
# Everything else (position, age, minutes_played, training_load, prev_injuries,
# bmi, home_away, opponent_rank) is explanatory. team is a grouping variable.

# 2. Injured: binary response
table(players$injured)
prop.table(table(players$injured))
tapply(players$injured, players$training_load, mean)
tapply(players$injured, players$position, mean)

# 3. Goals: count responses
table(matches$goals_scored)
table(matches$goals_conceded)
c(mean = mean(matches$goals_scored), var = var(matches$goals_scored))
c(mean = mean(matches$goals_conceded), var = var(matches$goals_conceded))
# Poisson assumes mean = variance, so these should be roughly equal

par(mfrow = c(1, 2))
barplot(table(matches$goals_scored), main = "Goals scored", xlab = "Goals")
barplot(table(matches$goals_conceded), main = "Goals conceded", xlab = "Goals")
par(mfrow = c(1, 1))

# 4. Why not a normal linear model?
# A linear model for injured can give fitted "probabilities" outside [0, 1]
lm_inj <- lm(injured ~ age + training_load + prev_injuries, data = players)
range(fitted(lm_inj))

# A linear model for goals can give negative fitted counts
lm_goals <- lm(goals_scored ~ as.factor(home_away) + opponent_rank, data = matches)
range(fitted(lm_goals))

# Residuals from lm on a 0/1 response fall in two bands, so normality fails
plot(fitted(lm_inj), rstudent(lm_inj),
     xlab = "Fitted values", ylab = "Studentised residuals")
abline(h = 0, lwd = 2)