#!/usr/bin/env bash

# Bash script to delete all branches except master and the requested branch
# Input: branch name
# Output: 1. Checkouts to designated branch
#         2. Deletes all branches execept for master and the designated branch
# Ex. sh delete_all_branches.sh dev

echo "Deleting all local branches except master & $1"

# Move to the branch that is not to be deleted
git checkout $1

# Deleting all branches except for the requested one
git branch | egrep -v "(^\*|master|$1)" | xargs git branch -d
