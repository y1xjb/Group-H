# MTH6134 Group Project: Midland Premier League 2023/24

Shared workspace for our MTH6134 Statistical Modelling II group project. All code, outputs, notes and reports live here.

## Group members

| Name | GitHub username |
|------|-----------------|
|   Jabir   |        y1xjb         |
|      |                 |
|   Alex   |         made-in-july        |
|      |                 |
|Aaron|solio6|

## Folder structure

| Folder     | Contents |
|------------|----------|
| `code/`    | All R code, including rough exploratory work. Do not delete scripts that did not make the report. |
| `data/`    | `league_players.csv` and `ashford_matches.csv` |
| `outputs/` | Plots and outputs produced along the way, including ones not used |
| `notes/`   | `decision-notes.md` and `who-did-what.md` |
| `reports/` | Final group report and each member's individual report |

## Data

- `league_players.csv`: 620 players across 24 clubs, one row per player (team, position, age, minutes_played, training_load, prev_injuries, bmi, injured).
- `ashford_matches.csv`: all 46 league fixtures of Ashford United (home_away, goals_scored, goals_conceded, opponent_rank).

All data are simulated.

## How to run

1. Open `mth6134-group-project.Rproj` in RStudio. This sets the working directory to the repo root, so every path in the code is relative (e.g. `data/league_players.csv`).
2. Run `code/00_setup.R` once to install and load packages.
3. Run the numbered scripts in `code/` in order.

## Working rules

- Set your own `git config user.name` and `user.email` so commits show who did what.
- Pull before you push. Commit small and often, with a clear message.
- Never use absolute file paths (nothing like `C:/Users/...`).
- Log every analytical decision in `notes/decision-notes.md` (what, when, why).
- Keep `notes/who-did-what.md` accurate and up to date.
- Name scripts `NN_description_initials.R` if several people work on the same topic, so nothing is overwritten.

## Deadlines and check-ins

- Submit the workspace link on QM+ by the **end of week 5**.
- The module lead checks the workspace in **weeks 5, 8 and 11**.
- Week 12: group decides which three analyses to present and plans the report.
- Final submission deadline: TBC (update here when announced).
