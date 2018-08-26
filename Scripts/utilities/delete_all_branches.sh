#!/bin/bash

# Bash script to delete all branches except master and the requested branch
# Input: branch name
# Output: 1. Checkouts to designated branch
#         2. Deletes all branches except for master and the designated branch
# Ex. sh delete_all_branches.sh dev

# Move to the branch that is not to be deleted
git checkout $1

# Deleting all branches except for the requested one
if ["$1"];then
    echo "Deleting all local branches except master & $1"
    git branch | egrep -v "(master|$1)" | xargs git branch -d
else
    echo "Deleting all local branches except master"
    git branch | egrep -v "(master)" | xargs git branch -d
fi

