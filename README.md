# MTH6134 Group Project: Midland Premier League 2023/24

Shared workspace for our MTH6134 Statistical Modelling II group project. All code, outputs, notes and reports live here.

## Group members

| Name | GitHub username |
|------|-----------------|
|   Jabir   |        y1xjb         |
|      |                 |
|   James   |         made-in-july        |
|      |                 |
|Aaron|solio6|

## Folder structure

| Folder     | Contents |
|------------|----------|
| `code/`    | All R code, including rough exploratory work.|
| `data/`    | `league_players.csv` and `ashford_matches.csv` |
| `outputs/` | Plots and outputs produced |
| `notes/`   | `decision-notes.md` and `who-did-what.md` |
| `reports/` | Final group report and each member's individual report |

## Data

- `league_players.csv`: 620 players across 24 clubs, one row per player (team, position, age, minutes_played, training_load, prev_injuries, bmi, injured).
- `ashford_matches.csv`: all 46 league fixtures of Ashford United (home_away, goals_scored, goals_conceded, opponent_rank).


## How to run

1. Open `mth6134-group-project.Rproj` in RStudio. This sets the working directory to the repo root, so every path in the code is relative (e.g. `data/league_players.csv`).
2. Run `code/00_setup.R` once to install and load packages.
3. Run the numbered scripts in `code/` in order.

## Deadlines and check-ins

- Submit the workspace link on QM+ by the **end of week 5**.
- The module lead checks the workspace in **weeks 5, 8 and 11**.
- Week 12: group decides which three analyses to present and plans the report.
- Final submission deadline: TBC.
