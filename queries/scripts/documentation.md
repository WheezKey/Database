# MLB Database Project Documentation

## Schema Design

The MLB database follows a normalized schema design with the following tables:

### Teams

- **Purpose**: Stores information about MLB teams
- **Primary Key**: team_id
- **Fields**: team_name, city, state, division, league

### Players

- **Purpose**: Stores information about MLB players
- **Primary Key**: player_id
- **Foreign Keys**: team_id references Teams(team_id)
- **Fields**: first_name, last_name, birth_date, position, jersey_number

### Stadiums

- **Purpose**: Stores information about MLB stadiums
- **Primary Key**: stadium_id
- **Foreign Keys**: team_id references Teams(team_id)
- **Fields**: stadium_name, city, state, capacity, opened_year

### Games

- **Purpose**: Stores information about MLB games
- **Primary Key**: game_id
- **Foreign Keys**:
  - home_team_id references Teams(team_id)
  - away_team_id references Teams(team_id)
  - stadium_id references Stadiums(stadium_id)
- **Fields**: game_date, season_year, attendance, duration_minutes

### GameResults

- **Purpose**: Stores the results of MLB games
- **Primary Key**: result_id
- **Foreign Keys**:
  - game_id references Games(game_id)
  - winning_pitcher_id references Players(player_id)
  - losing_pitcher_id references Players(player_id)
  - save_pitcher_id references Players(player_id)
- **Fields**: home_team_runs, away_team_runs, home_team_hits, away_team_hits, home_team_errors, away_team_errors

### PlayerGameStats

- **Purpose**: Stores individual player statistics for each game
- **Primary Key**: stat_id
- **Foreign Keys**:
  - game_id references Games(game_id)
  - player_id references Players(player_id)
- **Fields**: at_bats, hits, runs, rbi, home_runs, stolen_bases, innings_pitched, strikeouts, walks_allowed, earned_runs

## Normalization

The database schema follows these normalization principles:

1. **First Normal Form (1NF)**: All tables have a primary key, and all attributes contain atomic values.

2. **Second Normal Form (2NF)**: All non-key attributes are fully functionally dependent on the primary key.

3. **Third Normal Form (3NF)**: No transitive dependencies exist between non-key attributes.

## Data Migration Process

The data migration process involved the following steps:

1. **CSV Data Creation**: Sample MLB data was created in CSV format for each table in the schema.

2. **Database Creation**: A SQLite database was created with tables defined according to the schema design.

3. **Data Import**: Python scripts were used to read the CSV files and import the data into the corresponding SQLite tables.

4. **Data Verification**: SQL queries were executed to verify data integrity and referential constraints.

## Query Examples

The project includes two types of SQL queries:

1. **Verification Queries**: Used to check data integrity and referential constraints between tables.

2. **Analysis Queries**: Used to extract meaningful insights from the MLB data, including:
   - Team win-loss records
   - Player batting averages
   - Pitcher ERA statistics
   - Home field advantage analysis
   - League comparison statistics

## Project Structure

- `data/`: Contains CSV files with MLB data
- `database/`: Contains the SQLite database and schema definition
- `scripts/`: Contains Python scripts for database creation and data import
- `queries/`: Contains SQL queries for verification and analysis

## Usage Instructions

1. Run `create_database.py` to create the SQLite database and tables
2. Run `import_data.py` to import data from CSV files into the database
3. Execute queries from the `queries/` directory to analyze the data
