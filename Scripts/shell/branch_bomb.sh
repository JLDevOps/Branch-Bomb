#!/usr/bin/env bash

# Bash script to generate multiple branches and push them to origin
# Input: branch name
# Output: 1. Checkouts to designated branch
#         2. Deletes all branches except for master and the designated branch
# Ex. sh delete_all_branches.sh dev

usage() { echo "Usage: $0 [-i <Branch Name to Checkout From>] [-c <Repo Clone URL (SSH | HTTP)>] [-n <Number of Characters for the Branch Name>]" 1>&2; exit 1; }

while getopts ":i:c:n:" o; do
    case "${o}" in
        i)
            i=${OPTARG}
            ;;
        c)
            c=${OPTARG}
            ;;
        n)
            n=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))



git_checkout()
{
    echo "[Branch Bombing] Git Checked Out to [$1]"
    git checkout $1
}

git_clone()
{
    echo "[Branch Bombing] Git Clone Repo: [$1]"
    git clone $1
}

create_branch()
{
    echo "[Branch Bombing] Created Branch [$1]"
    git checkout -b $1
}

push_branch_to_remote()
{
    echo "[Branch Bombing] Created Branch [$1]"
    git push -u origin $1
}

git_status()
{
    echo "[Branch Bombing] Git Status Checks [${1}]"
    git status $1
}

delete_all_local_branches()
{
    echo "[Branch Bombing] Deleting all local branches except [$1]"
    git branch | egrep -v "(^\*|master|$1)" | xargs git branch -d
}

execute_branch_bomb()
{
    while true
    do
        echo 'Branch Bombing: Started'
        if [ "${n}" ]; then
            unique_branch_name=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${n} | head -n 1)
            echo "[Branch Bombing] Unique Branch Name [${unique_branch_name}]"
        else
            unique_branch_name=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)
            echo "[Branch Bombing] Unique Branch Name [${unique_branch_name}]"
        fi

        if [ "${c}" ]; then
            git_clone ${c}
        fi

        create_branch ${unique_branch_name}
        push_branch_to_remote ${unique_branch_name}

        if [ "${i}" ]; then
            git_checkout ${i}
        fi

        delete_all_local_branches $1
    done
}


if [ "${i}" ] &&  [ "${c}" ] &&  [ "${n}" ]; then
    echo 'Branch Bombing: Started'
    execute_branch_bomb ${i} ${c} ${n}
elif [ -z "${i}" ] &&  [ "${c}" ] &&  [ "${n}" ]; then
    echo 'Branch Bombing: Started'
    execute_branch_bomb ${c} ${n}
elif [ -z "${i}" ] &&  [ -z "${c}" ] &&  [ "${n}" ]; then
    echo 'Branch Bombing: Started'
    execute_branch_bomb ${n}
else
    execute_branch_bomb
fi
