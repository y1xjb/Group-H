# Decision notes

Record every analytical decision here: what we decided, when, and why. Include alternatives we considered and rejected. Newest entries at the bottom.

Examples of things to log: which model we chose and what else we tried, how we handled an unusual observation, why a variable was included or dropped, which criterion we used for model selection.

---

## Template (copy for each decision)

**Date:**
**Who was involved:**
**Analysis / dataset:**
**Decision:**
**Alternatives considered:**
**Why:**
**Evidence (script / output file):**

---

## Log

### 2026-10-12: Initial data observations (starter entry)
**Analysis / dataset:** Both datasets, first look
**Decision:** Flag for the group to investigate, nothing decided yet.
**Notes:**
- `ashford_matches.csv` contains one very large result (Home, 8 goals scored, 0 conceded, opponent rank 24). Check its influence in any model for goals scored before deciding how to handle it.
- `league_players.csv` has a few players with very low minutes played (e.g. under 600) and several aged 17. Check whether `minutes_played` should be treated as exposure for injury analyses.
- Players are grouped within 24 teams, so independence across rows may not hold (relevant to the week 11 mixed model material).
**Evidence:** code/01_explore_players.R, code/02_explore_ashford.R
