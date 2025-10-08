-- Verification Queries for MLB Database

-- 1. Count records in each table to verify data was imported
SELECT 'Teams' AS Table_Name, COUNT(*) AS Record_Count FROM Teams
UNION ALL
SELECT 'Players' AS Table_Name, COUNT(*) AS Record_Count FROM Players
UNION ALL
SELECT 'Stadiums' AS Table_Name, COUNT(*) AS Record_Count FROM Stadiums
UNION ALL
SELECT 'Games' AS Table_Name, COUNT(*) AS Record_Count FROM Games
UNION ALL
SELECT 'GameResults' AS Table_Name, COUNT(*) AS Record_Count FROM GameResults
UNION ALL
SELECT 'PlayerGameStats' AS Table_Name, COUNT(*) AS Record_Count FROM PlayerGameStats;

-- 2. Check for referential integrity between Teams and Players
SELECT p.player_id, p.first_name, p.last_name, p.team_id, t.team_name
FROM Players p
LEFT JOIN Teams t ON p.team_id = t.team_id
WHERE t.team_id IS NULL AND p.team_id IS NOT NULL;

-- 3. Check for referential integrity between Teams and Stadiums
SELECT s.stadium_id, s.stadium_name, s.team_id, t.team_name
FROM Stadiums s
LEFT JOIN Teams t ON s.team_id = t.team_id
WHERE t.team_id IS NULL AND s.team_id IS NOT NULL;

-- 4. Check for referential integrity in Games table
SELECT g.game_id, g.home_team_id, ht.team_name AS home_team, 
       g.away_team_id, at.team_name AS away_team,
       g.stadium_id, s.stadium_name
FROM Games g
LEFT JOIN Teams ht ON g.home_team_id = ht.team_id
LEFT JOIN Teams at ON g.away_team_id = at.team_id
LEFT JOIN Stadiums s ON g.stadium_id = s.stadium_id
WHERE ht.team_id IS NULL OR at.team_id IS NULL OR s.stadium_id IS NULL;

-- 5. Check for referential integrity in GameResults table
SELECT gr.result_id, gr.game_id, g.game_date,
       gr.winning_pitcher_id, wp.first_name || ' ' || wp.last_name AS winning_pitcher,
       gr.losing_pitcher_id, lp.first_name || ' ' || lp.last_name AS losing_pitcher
FROM GameResults gr
LEFT JOIN Games g ON gr.game_id = g.game_id
LEFT JOIN Players wp ON gr.winning_pitcher_id = wp.player_id
LEFT JOIN Players lp ON gr.losing_pitcher_id = lp.player_id
WHERE g.game_id IS NULL 
   OR (gr.winning_pitcher_id IS NOT NULL AND wp.player_id IS NULL)
   OR (gr.losing_pitcher_id IS NOT NULL AND lp.player_id IS NULL);

-- 6. Check for referential integrity in PlayerGameStats table
SELECT pgs.stat_id, pgs.game_id, g.game_date, 
       pgs.player_id, p.first_name || ' ' || p.last_name AS player_name
FROM PlayerGameStats pgs
LEFT JOIN Games g ON pgs.game_id = g.game_id
LEFT JOIN Players p ON pgs.player_id = p.player_id
WHERE g.game_id IS NULL OR p.player_id IS NULL;
