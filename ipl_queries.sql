-- Create matches Database
CREATE TABLE
    matches (
        id serial PRIMARY KEY,
        season integer,
        city text,
        date date,
        team1 text,
        team2 text,
        toss_winner text,
        toss_decision text,
        result text,
        dl_applied boolean,
        winner text,
        win_by_runs integer,
        win_by_wickets integer,
        player_of_match text,
        venue text,
        umpire1 text,
        umpire2 text,
        umpire3 text
    );

-- copy data to matches.csv into matches table
copy matches
FROM '/var/lib/postgresql/matches.csv' DELIMITER ',' CSV HEADER;

-- Create deliveries Database
CREATE TABLE
    deliveries (
        match_id INT,
        inning INT,
        batting_team text,
        bowling_team text,
        over DECIMAL(5, 2),
        ball INT,
        batsman text,
        non_striker text,
        bowler text,
        is_super_over int,
        wide_runs INT,
        bye_runs INT,
        legbye_runs INT,
        noball_runs INT,
        penalty_runs INT,
        batsman_runs INT,
        extra_runs INT,
        total_runs INT,
        player_dismissed text,
        dismissal_kind text,
        fielder text,
    );

-- copy data to deliveries.csv into matches table
copy deliveries
FROM '/var/lib/postgresql/deliveries.csv' DELIMITER ',' CSV HEADER;



-- IPL-DATASET-QUERIES


-- 01: Counting the number of matches per season
SELECT season, COUNT(season) FROM matches
GROUP BY season
ORDER BY season;


-- 02: Counting the number of wins per team in each season
SELECT season, winner, COUNT(winner) AS win_count FROM matches 
WHERE winner IS NOT NULL
GROUP BY season, winner 
ORDER BY season, win_count;


-- 03: Total extra runs conceded by bowling teams in the 2016 season
SELECT bowling_team, SUM(extra_runs) as extra_runs FROM matches
LEFT JOIN deliveries on matches.id=deliveries.match_id
WHERE season = 2016
GROUP BY bowling_team
ORDER BY extra_runs;


-- 04: Top 10 bowlers with the best economy rate in the 2015 season
SELECT bowler, round(((SUM(total_runs) - SUM(bye_runs) - SUM(legbye_runs) - SUM(penalty_runs)) * 6.00) / SUM(CASE WHEN wide_runs = 0 AND noball_runs = 0 THEN 1 ELSE 0 END), 2) as economy FROM matches m
LEFT JOIN deliveries d ON m.id = d.match_id
WHERE season = 2015
GROUP BY bowler
ORDER BY economy
LIMIT 10;


-- 05: Teams with the most wins when they win the toss
SELECT winner, COUNT(winner) FROM matches m
WHERE toss_winner = winner
GROUP BY winner
ORDER BY count DESC;


-- 06: Player of the match with the highest count for each season
-- Handled edge cases(Where two players have same score)
SELECT season, player_of_match, times FROM
(SELECT season, player_of_match, COUNT(player_of_match) AS times,
RANK() OVER (PARTITION BY season ORDER BY COUNT(player_of_match) DESC) AS row_number FROM matches
GROUP BY season, player_of_match
ORDER BY season, times DESC) AS subquery
WHERE row_number = 1;


-- 07: MS Dhoni's strike rate per season
SELECT season, round(SUM(batsman_runs) * 100.00 / SUM(CASE WHEN wide_runs = 0 THEN 1 ELSE 0 END), 2) AS strike_rate FROM matches m
LEFT JOIN deliveries d ON m.id = d.match_id 
WHERE batsman = 'MS Dhoni' GROUP BY season
ORDER BY season;


-- 08: Bowler with the most dismissals (except run-outs)
-- Handled edge cases(Where two players have same score)
SELECT player_dismissed, bowler, dismiss_count FROM
(SELECT player_dismissed, bowler, COUNT(bowler) AS dismiss_count, RANK() OVER (ORDER BY COUNT(bowler) DESC) AS rank FROM deliveries d
WHERE player_dismissed IS NOT NULL
and dismissal_kind <> 'run out'
GROUP BY player_dismissed, bowler) AS subquery
WHERE rank = 1;


-- 09: Bowler with the best economy in Super Overs
-- Handled edge cases(Where two players have same score)
WITH SuperOverEconomyData AS (
	SELECT bowler, round((SUM(total_runs) - SUM(bye_runs) - SUM(legbye_runs) - SUM(penalty_runs)) * 6.00 / (SUM(CASE WHEN  wide_runs = 0 AND noball_runs = 0 THEN 1 ELSE 0 END)), 2) AS economy FROM deliveries
	WHERE is_super_over = 1 
	GROUP BY bowler
)
SELECT * FROM(
	SELECT *, RANK() OVER (ORDER BY economy ASC) AS rank FROM SuperOverEconomyData
) AS subquery
WHERE rank = 1;
