#!/bin/bash

# Bash script to generate multiple branches and push them to origin
# Input: branch name
# Output: 1. Checkouts to designated branch
#         2. Deletes all branches except for master and the designated branch
# Ex. sh delete_all_branches.sh dev

usage() { echo "Usage: $0 [-i <Branch Name to Checkout From>] [-c <Repo Clone URL (SSH | HTTP)>] [-n <Number of Characters for the Branch Name>] [-t <Execute Dangerous BB>]" 1>&2; exit 1; }

while getopts ":i:c:n:t:" o; do
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
        t)  t=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

git_add_commit()
{
    echo "[Branch Bombing] Git Add All Files"
    git add *
    git commit -m "Bombed"
}

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

delete_all_local_branches()
{
    if [ "$1" ]; then
        echo "[Branch Bombing] Deleting all local branches except [$1]"
        git branch | egrep -v "(master|$1)" | xargs git branch -d
    else
        echo "[Branch Bombing] Deleting all local branches except [master]"
        git branch | egrep -v "(master)" | xargs git branch -d
    fi
}

create_file()
{
    unique_name=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w $1 | head -n 1)
    echo "[Branch Bombing] File created [$unique_name]"
    touch ${unique_name}.txt
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

        if [ "${t}" ]; then
            create_file ${t}
            git_add_commit
        fi

        push_branch_to_remote ${unique_branch_name}

        if [ "${i}" ]; then
            git_checkout ${i}
        fi

        delete_all_local_branches $1
    done
}

if [ "${t}" ]; then
    if [ "${i}" ]; then
        if [ "${c}" ]; then
            if [ "${n}" ]; then
                echo 'Branch Bombing: Started'
                execute_branch_bomb ${i} ${c} ${n} ${t}
            else
                echo 'Branch Bombing: Started'
                execute_branch_bomb ${i} ${c} ${t}
            fi
        else
            echo 'Branch Bombing: Started'
            execute_branch_bomb ${i} ${t}
        fi
    else
        echo 'Branch Bombing: Started'
        execute_branch_bomb ${t}
    fi
else
    if [ "${i}" ]; then
        if [ "${c}" ]; then
            if [ "${n}" ]; then
                echo 'Branch Bombing: Started'
                execute_branch_bomb ${i} ${c} ${n}
            else
                echo 'Branch Bombing: Started'
                execute_branch_bomb ${i} ${c}
            fi
        else
            echo 'Branch Bombing: Started'
            execute_branch_bomb ${i}
        fi
    else
        echo 'Branch Bombing: Started'
        execute_branch_bomb
    fi
fi

