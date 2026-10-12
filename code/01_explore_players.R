# 01_explore_players.R
# Week 2 style exploration of league_players.csv.
# Run 00_setup.R first.

source("code/00_setup.R")

# ---- Structure and variable types -------------------------------------
glimpse(players)
summary(players)
colSums(is.na(players))          # missing values?

# Variable types (fill in / check as a group):
#   team            nominal (24 levels)
#   position        nominal (GK, DEF, MID, FWD)
#   age             discrete numeric (years)
#   minutes_played  discrete numeric
#   training_load   ordinal (1-5)
#   prev_injuries   count
#   bmi             continuous
#   injured         binary (0/1)

# ---- Summary tables ----------------------------------------------------
players %>%
  summarise(across(c(age, minutes_played, training_load, prev_injuries, bmi),
                   list(mean = mean, sd = sd, min = min, max = max),
                   .names = "{.col}_{.fn}")) %>%
  pivot_longer(everything(), names_to = c("variable", "stat"),
               names_pattern = "(.*)_(mean|sd|min|max)") %>%
  pivot_wider(names_from = stat, values_from = value)

table(players$position)
table(players$injured)
prop.table(table(players$injured))

# Injury rate by position and by training load
players %>% group_by(position) %>%
  summarise(n = n(), injury_rate = mean(injured))
players %>% group_by(training_load) %>%
  summarise(n = n(), injury_rate = mean(injured))
players %>% group_by(prev_injuries) %>%
  summarise(n = n(), injury_rate = mean(injured))

# Injury rate varies by team? (relevant to the mixed model week)
players %>% group_by(team) %>%
  summarise(n = n(), injury_rate = mean(injured)) %>%
  arrange(desc(injury_rate))

# ---- Plots (saved to outputs/) -----------------------------------------
p1 <- ggplot(players, aes(minutes_played)) +
  geom_histogram(bins = 30) +
  labs(x = "Minutes played", y = "Number of players")
ggsave("outputs/players_minutes_hist.png", p1, width = 6, height = 4)

p2 <- ggplot(players, aes(factor(injured), minutes_played)) +
  geom_boxplot() +
  labs(x = "Injured (0 = no, 1 = yes)", y = "Minutes played")
ggsave("outputs/players_minutes_by_injured.png", p2, width = 6, height = 4)

p3 <- players %>%
  group_by(prev_injuries) %>%
  summarise(rate = mean(injured), n = n()) %>%
  ggplot(aes(prev_injuries, rate)) +
  geom_point(aes(size = n)) +
  geom_line() +
  labs(x = "Previous injuries (3 seasons)", y = "Proportion injured")
ggsave("outputs/players_injury_rate_by_previnj.png", p3, width = 6, height = 4)

p4 <- ggplot(players, aes(bmi)) +
  geom_histogram(bins = 30) +
  labs(x = "BMI", y = "Number of players")
ggsave("outputs/players_bmi_hist.png", p4, width = 6, height = 4)

# ---- First linear model (week 2): continuous outcome -------------------
# Example only: does BMI vary with age and position?
m_bmi <- lm(bmi ~ age + position, data = players)
summary(m_bmi)
confint(m_bmi)
par(mfrow = c(2, 2)); plot(m_bmi); par(mfrow = c(1, 1))

# ---- Ideas for later weeks (log decisions in notes/decision-notes.md) --
# Wk 4  binomial: injured ~ age + position + training_load + prev_injuries
#                 + bmi (+ minutes_played?)
# Wk 6  poisson:  prev_injuries as a count outcome
# Wk 8-9 contingency tables: position x injured, training_load x injured
# Wk 11 GLMM:     injured ~ ... + (1 | team)
