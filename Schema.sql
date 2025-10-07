-- MLB Database Schema

-- Teams table
CREATE TABLE IF NOT EXISTS Teams (
    team_id INTEGER PRIMARY KEY,
    team_name TEXT NOT NULL,
    city TEXT NOT NULL,
    state TEXT,
    division TEXT NOT NULL,
    league TEXT NOT NULL
);

-- Players table
CREATE TABLE IF NOT EXISTS Players (
    player_id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    birth_date TEXT,
    position TEXT NOT NULL,
    team_id INTEGER,
    jersey_number INTEGER,
    FOREIGN KEY (team_id) REFERENCES Teams(team_id)
);

-- Stadiums table
CREATE TABLE IF NOT EXISTS Stadiums (
    stadium_id INTEGER PRIMARY KEY,
    stadium_name TEXT NOT NULL,
    city TEXT NOT NULL,
    state TEXT,
    capacity INTEGER,
    opened_year INTEGER,
    team_id INTEGER,
    FOREIGN KEY (team_id) REFERENCES Teams(team_id)
);

-- Games table
CREATE TABLE IF NOT EXISTS Games (
    game_id INTEGER PRIMARY KEY,
    game_date TEXT NOT NULL,
    home_team_id INTEGER NOT NULL,
    away_team_id INTEGER NOT NULL,
    stadium_id INTEGER NOT NULL,
    season_year INTEGER NOT NULL,
    attendance INTEGER,
    duration_minutes INTEGER,
    FOREIGN KEY (home_team_id) REFERENCES Teams(team_id),
    FOREIGN KEY (away_team_id) REFERENCES Teams(team_id),
    FOREIGN KEY (stadium_id) REFERENCES Stadiums(stadium_id)
);

-- Game Results table
CREATE TABLE IF NOT EXISTS GameResults (
    result_id INTEGER PRIMARY KEY,
    game_id INTEGER NOT NULL,
    home_team_runs INTEGER NOT NULL,
    away_team_runs INTEGER NOT NULL,
    home_team_hits INTEGER NOT NULL,
    away_team_hits INTEGER NOT NULL,
    home_team_errors INTEGER NOT NULL,
    away_team_errors INTEGER NOT NULL,
    winning_pitcher_id INTEGER,
    losing_pitcher_id INTEGER,
    save_pitcher_id INTEGER,
    FOREIGN KEY (game_id) REFERENCES Games(game_id),
    FOREIGN KEY (winning_pitcher_id) REFERENCES Players(player_id),
    FOREIGN KEY (losing_pitcher_id) REFERENCES Players(player_id),
    FOREIGN KEY (save_pitcher_id) REFERENCES Players(player_id)
);

-- Player Game Stats table
CREATE TABLE IF NOT EXISTS PlayerGameStats (
    stat_id INTEGER PRIMARY KEY,
    game_id INTEGER NOT NULL,
    player_id INTEGER NOT NULL,
    at_bats INTEGER DEFAULT 0,
    hits INTEGER DEFAULT 0,
    runs INTEGER DEFAULT 0,
    rbi INTEGER DEFAULT 0,
    home_runs INTEGER DEFAULT 0,
    stolen_bases INTEGER DEFAULT 0,
    innings_pitched REAL DEFAULT 0,
    strikeouts INTEGER DEFAULT 0,
    walks_allowed INTEGER DEFAULT 0,
    earned_runs INTEGER DEFAULT 0,
    FOREIGN KEY (game_id) REFERENCES Games(game_id),
    FOREIGN KEY (player_id) REFERENCES Players(player_id)
);
