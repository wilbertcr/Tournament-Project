# Tournament Project

I believe there is enough information about the project so I will not explain it again. I will limit this file to an explanation on how to run the program.
=======
I believe there is enough information about the project so I will not explain it again. I will limit this file to an explanation on how to run the program and what you should expect to find as a result of that.

Steps:

```sh
$ git clone fullstack-nanodegree-vm
$ cd fullstack-nanodegree-vm
$ cd /vagrant
$ vagrant up
$ vagrant ssh
$ cd tournament
```
- Create the database and run the test.
![alt text](https://github.com/wilbertcr/fullstack-nanodegree-vm/blob/master/vagrant/tournament/CreateDBAndRunTest.png)
=======
- Create the database
![alt text](https://github.com/wilbertcr/fullstack-nanodegree-vm/blob/ExtraCredit/vagrant/tournament/CreateDB.png)

- Escape out of the psql console
```sh
CTRL+D
```

- Run Test
![alt text](https://github.com/wilbertcr/fullstack-nanodegree-vm/blob/ExtraCredit/vagrant/tournament/run_test.png)


You should see several pairings# files in the tournament folder. Each file contains a round of matches, as prescribed
by swissPairings(tournament_id). The outcomes of each match are semi-randomly chosen but equally likely in probability and
includes draws.
