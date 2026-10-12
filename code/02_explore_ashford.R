# 02_explore_ashford.R
# Exploration of ashford_matches.csv (46 fixtures).
# Run 00_setup.R first.

source("code/00_setup.R")

# ---- Structure ---------------------------------------------------------
glimpse(matches)
summary(matches)
colSums(is.na(matches))

# Variable types:
#   home_away        binary categorical (Home / Away)
#   goals_scored     count
#   goals_conceded   count
#   opponent_rank    ordinal / discrete numeric (1-24)

# ---- Derived variables -------------------------------------------------
matches <- matches %>%
  mutate(
    result = case_when(
      goals_scored >  goals_conceded ~ "Win",
      goals_scored == goals_conceded ~ "Draw",
      TRUE                           ~ "Loss"
    ),
    result = factor(result, levels = c("Loss", "Draw", "Win")),
    win = as.integer(result == "Win")
  )

# ---- Summaries ---------------------------------------------------------
table(matches$home_away, matches$result)

matches %>% group_by(home_away) %>%
  summarise(n = n(),
            mean_scored   = mean(goals_scored),
            var_scored    = var(goals_scored),    # compare to mean (Poisson?)
            mean_conceded = mean(goals_conceded),
            var_conceded  = var(goals_conceded),
            win_rate      = mean(win))

# Unusual observation: check the biggest result
matches %>% arrange(desc(goals_scored)) %>% head(3)

# ---- Plots -------------------------------------------------------------
p1 <- ggplot(matches, aes(goals_scored)) +
  geom_bar() + facet_wrap(~ home_away) +
  labs(x = "Goals scored", y = "Number of matches")
ggsave("outputs/ashford_goals_scored_bar.png", p1, width = 6, height = 4)

p2 <- ggplot(matches, aes(opponent_rank, goals_scored, colour = home_away)) +
  geom_jitter(width = 0.2, height = 0.1) +
  labs(x = "Opponent final rank", y = "Goals scored", colour = "Venue")
ggsave("outputs/ashford_scored_vs_rank.png", p2, width = 6, height = 4)

p3 <- ggplot(matches, aes(opponent_rank, goals_conceded, colour = home_away)) +
  geom_jitter(width = 0.2, height = 0.1) +
  labs(x = "Opponent final rank", y = "Goals conceded", colour = "Venue")
ggsave("outputs/ashford_conceded_vs_rank.png", p3, width = 6, height = 4)

# ---- Starter models (revisit in weeks 4-6) -----------------------------
# Poisson: goals scored
m_pois <- glm(goals_scored ~ home_away + opponent_rank,
              family = poisson, data = matches)
summary(m_pois)
confint(m_pois)

# Binomial: win vs not win
m_win <- glm(win ~ home_away + opponent_rank,
             family = binomial, data = matches)
summary(m_win)

# TODO as a group: check the 8-goal match (influence, residuals) and
# record how we handle it in notes/decision-notes.md
