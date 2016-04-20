# Full Stack Web Developer Nanodegree

# Project 2: Tournament Planner

**Project Description: **

In this project, I wrote a Python module that uses the PostgreSQL database to keep track of players and matches in a game tournament.

The game tournament uses the Swiss system for pairing up players in each round: players are not eliminated, and each player should be paired with another player with the same number of wins, or as close as possible.

This project has two parts: Defining the database schema (SQL table definitions), and writing the code that will use it.

**Functions in tournament.py**

registerPlayer(name)

Adds a player to the tournament by putting an entry in the database. The database should assign an ID number to the player. Different players may have the same names but will receive different ID numbers.

countPlayers()

Returns the number of currently registered players. This function should not use the Python len() function; it should have the database count the players.

deletePlayers()

Clear out all the player records from the database.

reportMatch(winner, loser)

Stores the outcome of a single match between two players in the database.

deleteMatches()

Clear out all the match records from the database.

playerStandings()

Returns a list of (id, name, wins, matches) for each player, sorted by the number of wins each player has.

swissPairings()

Given the existing set of registered players and the matches they have played, generates and returns a list of pairings according to the Swiss system. Each pairing is a tuple (id1, name1, id2, name2), giving the ID and name of the paired players. For instance, if there are eight registered players, this function should return four pairings. This function should use playerStandings to find the ranking of players.

Extra credit:

- [x] Prevent rematches between players.
- [x] Don’t assume an even number of players. 
- [x] If there is an odd number of players, assign one player a “bye” (skipped round). A bye counts as a free win. A player should not receive more than one bye in a tournament.
- [x] Support games where a draw (tied game) is possible. This will require changing the arguments to reportMatch.
- [x] When two players have the same number of wins, rank them according to OMW (Opponent Match Wins), the total number of wins by players they have played against.
- [x] Support more than one tournament in the database, so matches do not have to be deleted between tournaments. This will require distinguishing between “a registered player” and “a player who has entered in tournament #123”, so it will require changes to the database schema.

# Installation
============================================
Steps:

```sh
$ git clone fullstack-nanodegree-vm
$ cd fullstack-nanodegree-vm
$ cd /vagrant
$ vagrant up
$ vagrant ssh
$ cd tournament
```

# Running the program
- Create the database and run the test.

![alt text](https://raw.githubusercontent.com/wilbertcr/Tournament-Project/master/CreateDBAndRunTest.png)


=======
- Create the database

![alt text](https://raw.githubusercontent.com/wilbertcr/Tournament-Project/master/CreateDB.png)

- Escape out of the psql console
```sh
CTRL+D
```

- Run Test

![alt text](https://raw.githubusercontent.com/wilbertcr/Tournament-Project/master/run_test.png)

You should see several pairings# files in the tournament folder. Each file contains a round of matches, as prescribed
by swissPairings(tournament_id). The outcomes of each match are semi-randomly chosen but equally likely in probability and
includes draws.