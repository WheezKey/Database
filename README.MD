# MLB Database Project

This project converts Major League Baseball game statistics from CSV format into a normalized SQLite database for efficient querying and analysis.

## Project Structure

- `data/` - Contains the raw CSV data files
- `scripts/` - Contains Python scripts for data processing and migration
- `database/` - Contains the SQLite database file
- `queries/` - Contains example SQL queries for analysis

## Getting Started

1. Run `create_database.py` to create the SQLite database and tables
2. Run `import_data.py` to import data from CSV files into the database
3. Run example queries from the `queries/` directory

## Database Schema

The database follows a normalized schema with the following tables:

- Teams
- Players
- Games
- GameStats
- Stadiums
- Seasons

See the schema documentation for detailed information on table relationships and fields.
