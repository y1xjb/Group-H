# Week 2: linear models

players <- read.csv("data/league_players.csv")
matches <- read.csv("data/ashford_matches.csv")

# 1. Players: minutes played
plot(players$training_load, players$minutes_played)

players_fit <- lm(minutes_played ~ as.factor(position) + training_load, data = players)
summary(players_fit)

plot(players_fit$fitted, rstudent(players_fit),
     xlab = "Fitted values", ylab = "Studentised residuals")
abline(h = 0, lwd = 2)

qqnorm(rstudent(players_fit), main = NULL)
qqline(rstudent(players_fit), lwd = 2)

plot(players_fit, 4)
abline(h = 8/(620 - 2*5), lty = 2)

# 2. Ashford: goal difference
matches$goal_diff <- matches$goals_scored - matches$goals_conceded

plot(matches$opponent_rank, matches$goal_diff)

matches_fit <- lm(goal_diff ~ as.factor(home_away) + opponent_rank, data = matches)
summary(matches_fit)

plot(matches_fit$fitted, rstudent(matches_fit),
     xlab = "Fitted values", ylab = "Studentised residuals")
abline(h = 0, lwd = 2)

qqnorm(rstudent(matches_fit), main = NULL)
qqline(rstudent(matches_fit), lwd = 2)

plot(matches_fit, 4)
abline(h = 8/(46 - 2*3), lty = 2)
