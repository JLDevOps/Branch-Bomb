# Branch Bomb

#### *:(){ :|: & };: for Git Branches*
***

**Bash Script Edition**

## Usage
Here are the following arguments to use with the branch_bomb script:

1. Branch to checkout from (-i)
2. Clone a Git Repo (-c)
3. Number of Characters For the Branch Name (-n)
4. Execute "Dangerous" version of Branch Bombing where the script generates a file for each branch and pushes it to the remote.


### Sample Run

Executing a branch bomb with:
1. A branch to checkout from
2. Git Repo to clone from
3. 10 character name for each branch
4. Execute the "Dangerous" version of Branch Bombing

```bash
    sh branch_bomb.sh -i master -c git@github.com:JLDevOps/Branch-Bomb.git -n 10 -t
```

Executing a branch bomb with *Default Settings*:
```bash
    sh branch_bomb.sh
```
