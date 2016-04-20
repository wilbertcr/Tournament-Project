-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

DROP DATABASE IF EXISTS tournament;
CREATE DATABASE tournament;
\connect tournament;

DROP TABLE IF EXISTS players CASCADE;
DROP TABLE IF EXISTS matches CASCADE;
DROP TABLE IF EXISTS tournaments CASCADE;
DROP TABLE IF EXISTS tournament_registration CASCADE;

CREATE TABLE players (
    id serial PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE tournaments (
    tournament_id SERIAL PRIMARY KEY,
    name TEXT
);

CREATE TABLE tournament_registration(
    tournament_id INTEGER REFERENCES tournaments(tournament_id),
    player_id INTEGER REFERENCES players(id) ON DELETE CASCADE,
    -- A player can only be registered once for a given tournament at a given point in time.
    UNIQUE(tournament_id,player_id)
);

-- As safety, I am declaring the table such that
-- it won't allow matches among the same players
-- to be registered for the same tournament.
CREATE TABLE matches (
    match_id SERIAL PRIMARY KEY,
    tournament_id INTEGER REFERENCES tournaments(tournament_id) ON DELETE CASCADE,
    winner integer REFERENCES players(id) ON DELETE CASCADE,
    loser integer,
    draw integer DEFAULT 0,
    -- The same two players cannot play more than once
    -- during the same tournament.
    UNIQUE(winner,loser,tournament_id),
    UNIQUE(loser,winner,tournament_id)
);

CREATE VIEW standings AS
    SELECT
        tournament_registration.tournament_id as tournament_id,
        tournament_registration.player_id as id,
        (SELECT name FROM players WHERE id = tournament_registration.player_id) as name,
        (SELECT COALESCE(count(*)) AS wins FROM matches WHERE tournament_registration.player_id = winner),
        (SELECT COALESCE(count(*)) AS matches FROM matches WHERE tournament_registration.player_id = winner OR tournament_registration.player_id = loser)
    FROM tournament_registration
    GROUP BY tournament_registration.player_id, tournament_registration.tournament_id, name
    ORDER BY wins DESC;

-- This could be a subquery also, but did it this way for clarity.
CREATE VIEW omw_table_raw AS
    SELECT *
    FROM
        (SELECT standings.tournament_id, winner as player_id, loser as opponent, wins as opponent_wins
        FROM standings,matches
        WHERE
            -- Make sure we get the wins from the opponent(loser in this case).
            loser = standings.id AND
            -- Make sure the match wasn't a draw.
            draw = 0) AS opponents_count
        UNION
        (SELECT standings.tournament_id, loser as player_id, winner as opponent, wins as opponent_wins
        FROM standings,matches
        WHERE
            -- Make sure we get the wins from the opponent(winner in this case)
            winner = standings.id AND
            -- Make sure the match wasn't a draw.
            draw = 0);


-- Note how omw_table is ordered by wins first and then by opponent wins.
-- That means pairings fulfill the requirement that:
    -- When two players have the same number of wins, rank them according to
    -- OMW (Opponent Match Wins), the total number of wins by players they have played against.
CREATE VIEW omw_table AS
    SELECT standings.tournament_id,standings.id as id, name, wins,  SUM(COALESCE(opponent_wins,0)) AS opponents_wins
    FROM standings LEFT OUTER JOIN omw_table_raw ON standings.id = omw_table_raw.player_id
    GROUP BY standings.tournament_id, standings.id, name, wins
    ORDER BY wins DESC,opponents_wins DESC;


CREATE VIEW pairings AS
    SELECT omw_table1.row_number, tournament_id1, id1,name1,id2,name2 FROM
    ( SELECT
        ROW_NUMBER() OVER () AS row_number,tournament_id as tournament_id1, id as id1, name as name1
      FROM omw_table
    ) omw_table1,
    ( SELECT
        ROW_NUMBER() OVER () AS row_number,tournament_id as tournament_id2, id as id2,name as name2
      FROM omw_table
    ) omw_table2
    WHERE omw_table1.row_number % 2 = 1 AND omw_table1.row_number+1=omw_table2.row_number;
