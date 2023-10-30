<!-- @format -->

# IPL Dataset Project README

This README provides an overview of the IPL (Indian Premier League) dataset project using PostgreSQL. In this project, we create a PostgreSQL database, import IPL match and delivery data, and run SQL queries to extract meaningful insights from the dataset.

## Table of Contents

1. [Database Creation](#database-creation)
2. [Data Import](#data-import)
3. [Project Queries](#project-queries)
4. [Project Structure](#project-structure)
5. [Queries Overview](#queries-overview)

## Database Creation

### matches Table

- The `matches` table contains information about IPL matches. It includes details like match ID, season, city, date, team names, toss details, result, and more.

### deliveries Table

- The `deliveries` table contains detailed information about deliveries in each match, including batting and bowling details, runs scored, dismissals, and extras.

## Data Import

The data for the `matches` and `deliveries` tables is imported from CSV files using the PostgreSQL `COPY` command.

## Project Queries

The project includes various SQL queries to extract insights from the dataset. Here's a brief overview of the queries:

1. **Counting Matches per Season:** Counts the number of matches played in each IPL season.

2. **Counting Wins per Team in Each Season:** Counts the number of wins for each IPL team in each season.

3. **Total Extra Runs Conceded in 2016:** Calculates the total extra runs conceded by bowling teams in the 2016 season.

4. **Top 10 Bowlers with Best Economy Rate in 2015:** Lists the top 10 bowlers with the best economy rates in the 2015 season.

5. **Teams with Most Wins when Winning the Toss:** Identifies the teams with the most wins when they win the toss.

6. **Player of the Match with Highest Count per Season:** Identifies the player of the match with the highest count for each IPL season.

7. **MS Dhoni's Strike Rate per Season:** Calculates MS Dhoni's strike rate in each season.

8. **Bowler with Most Dismissals (Excluding Run-outs):** Identifies the bowler with the most dismissals (excluding run-outs).

9. **Bowler with Best Economy in Super Overs:** Identifies the bowler with the best economy rate in super overs.

## Project Structure

The project includes the following components:

- SQL script for table creation.
- SQL script for data import.
- SQL script for running the queries.
- This README.md file for project documentation.

## Queries Overview

The SQL queries in this project provide valuable insights into IPL match and delivery data. They cover a range of topics, including match counts, team performance, player statistics, and more. These queries can be a valuable resource for IPL enthusiasts, analysts, and fans who want to explore and understand the IPL dataset.

Feel free to explore and adapt the queries to your specific analysis needs or use them as a reference for similar database projects.
