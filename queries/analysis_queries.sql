-- Analysis Queries for MLB Database

-- 1. Team Win-Loss Records
SELECT 
    t.team_name,
    SUM(CASE WHEN (g.home_team_id = t.team_id AND gr.home_team_runs > gr.away_team_runs) OR 
                  (g.away_team_id = t.team_id AND gr.away_team_runs > gr.home_team_runs) THEN 1 ELSE 0 END) AS wins,
    SUM(CASE WHEN (g.home_team_id = t.team_id AND gr.home_team_runs < gr.away_team_runs) OR 
                  (g.away_team_id = t.team_id AND gr.away_team_runs < gr.home_team_runs) THEN 1 ELSE 0 END) AS losses,
    ROUND(SUM(CASE WHEN (g.home_team_id = t.team_id AND gr.home_team_runs > gr.away_team_runs) OR 
                       (g.away_team_id = t.team_id AND gr.away_team_runs > gr.home_team_runs) THEN 1 ELSE 0 END) * 1.0 / 
          COUNT(*), 3) AS win_percentage
FROM 
    Teams t
LEFT JOIN 
    Games g ON t.team_id = g.home_team_id OR t.team_id = g.away_team_id
LEFT JOIN 
    GameResults gr ON g.game_id = gr.game_id
GROUP BY 
    t.team_id, t.team_name
ORDER BY 
    win_percentage DESC;

-- 2. Top 10 Players by Batting Average (minimum 10 at-bats)
SELECT 
    p.first_name || ' ' || p.last_name AS player_name,
    t.team_name,
    SUM(pgs.hits) AS total_hits,
    SUM(pgs.at_bats) AS total_at_bats,
    ROUND(SUM(pgs.hits) * 1.0 / SUM(pgs.at_bats), 3) AS batting_average
FROM 
    Players p
JOIN 
    PlayerGameStats pgs ON p.player_id = pgs.player_id
JOIN 
    Teams t ON p.team_id = t.team_id
GROUP BY 
    p.player_id, player_name, t.team_name
HAVING 
    SUM(pgs.at_bats) >= 10
ORDER BY 
    5 DESC
FETCH FIRST 10 ROWS ONLY;

-- 3. Top 5 Pitchers by ERA (minimum 10 innings pitched)
SELECT 
    p.first_name || ' ' || p.last_name AS pitcher_name,
    t.team_name,
    SUM(pgs.innings_pitched) AS total_innings,
    SUM(pgs.earned_runs) AS total_earned_runs,
    ROUND(SUM(pgs.earned_runs) * 9.0 / SUM(pgs.innings_pitched), 2) AS ERA
FROM 
    Players p
JOIN 
    PlayerGameStats pgs ON p.player_id = pgs.player_id
JOIN 
    Teams t ON p.team_id = t.team_id
WHERE 
    p.position = 'P'
GROUP BY 
    p.player_id, pitcher_name, t.team_name
HAVING 
    SUM(pgs.innings_pitched) >= 10
ORDER BY 
    ERA ASC
FETCH FIRST 5 ROWS ONLY;

-- 4. Home Field Advantage Analysis
SELECT 
    s.stadium_name,
    t.team_name AS home_team,
    COUNT(g.game_id) AS total_home_games,
    SUM(CASE WHEN gr.home_team_runs > gr.away_team_runs THEN 1 ELSE 0 END) AS home_wins,
    ROUND(SUM(CASE WHEN gr.home_team_runs > gr.away_team_runs THEN 1 ELSE 0 END) * 100.0 / 
          COUNT(g.game_id), 1) AS home_win_percentage
FROM 
    Stadiums s
JOIN 
    Teams t ON s.team_id = t.team_id
JOIN 
    Games g ON s.stadium_id = g.stadium_id AND t.team_id = g.home_team_id
JOIN 
    GameResults gr ON g.game_id = gr.game_id
GROUP BY 
    s.stadium_id, s.stadium_name, t.team_name
ORDER BY 
    home_win_percentage DESC;

-- 5. League Comparison (American vs National)
SELECT 
    t.league,
    COUNT(DISTINCT g.game_id) AS total_games,
    SUM(gr.home_team_runs + gr.away_team_runs) AS total_runs,
    ROUND(SUM(gr.home_team_runs + gr.away_team_runs) * 1.0 / COUNT(DISTINCT g.game_id), 2) AS avg_runs_per_game,
    SUM(gr.home_team_hits + gr.away_team_hits) AS total_hits,
    ROUND(SUM(gr.home_team_hits + gr.away_team_hits) * 1.0 / COUNT(DISTINCT g.game_id), 2) AS avg_hits_per_game
FROM 
    Teams t
JOIN 
    Games g ON t.team_id = g.home_team_id
JOIN 
    GameResults gr ON g.game_id = gr.game_id
GROUP BY 
    t.league;