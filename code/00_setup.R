# 00_setup.R
# Install (if missing) and load packages, and read both datasets with
# relative paths. Open mth6134-group-project.Rproj first so the working
# directory is the repo root.

pkgs <- c("tidyverse", "broom", "MASS", "lme4", "knitr")
to_install <- setdiff(pkgs, rownames(installed.packages()))
if (length(to_install) > 0) install.packages(to_install)

library(tidyverse)
library(broom)
library(lme4)
library(knitr)
# MASS is NOT attached: it masks dplyr::select. Call MASS:: explicitly.

# Check we are in the repo root
if (!file.exists("data/league_players.csv")) {
  stop("Cannot find data/league_players.csv. Open the .Rproj file so the ",
       "working directory is the repo root.")
}

players <- read_csv("data/league_players.csv", show_col_types = FALSE)
matches <- read_csv("data/ashford_matches.csv", show_col_types = FALSE)

# Sensible types: categorical variables as factors
players <- players %>%
  mutate(
    team     = factor(team),
    position = factor(position, levels = c("GK", "DEF", "MID", "FWD")),
    injured  = as.integer(injured)
  )

matches <- matches %>%
  mutate(home_away = factor(home_away, levels = c("Home", "Away")))

# Create the outputs folder if it is missing
dir.create("outputs", showWarnings = FALSE)
