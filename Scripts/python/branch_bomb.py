import threading
import argparse
import subprocess as sp
import random
import string
import time


def git_clone(clone_link):
    sp.check_output(['git', 'clone', clone_link])
    print("[Branch Bombing] Git Clone Repo: [" + clone_link + "]")


def create_branch(branch_name):
    sp.check_output(['git', 'checkout', '-b', branch_name])
    print("[Branch Bombing] Created Branch [" + branch_name + "]")


def push_local_branch_to_remote(branch_name):
    # This may require authentication via ssh key or username/password
    sp.check_output(['git', 'push', '-u', 'origin', branch_name])
    print("[Branch Bombing] Branch [" + branch_name + "] : Pushed to Remote")


def generate_unique_branch_name(num_chars):
    return (''.join(
        random.SystemRandom().choice(string.ascii_uppercase + string.ascii_lowercase + string.digits) for _ in
        range(num_chars)))


def execute_branch_bombing(clone_link, name_size, thread_index, reset_branch_name):
    if reset_branch_name is not None:
        unique_branch_name = generate_unique_branch_name(name_size)
        git_clone(clone_link)
        create_branch(unique_branch_name)
        push_local_branch_to_remote(unique_branch_name)
        reset_to_branch(reset_branch_name)
        delete_branch(unique_branch_name)
        print("[Branch Bombing] Thread " + str(
            thread_index) + " : Created Branch [" + unique_branch_name + "] & Pushed to Origin")
    else:
        unique_branch_name = generate_unique_branch_name(name_size)
        create_branch(unique_branch_name)
        push_local_branch_to_remote(unique_branch_name)
        reset_to_branch(reset_branch_name)
        delete_branch(unique_branch_name)
        print("[Branch Bombing] Thread " + str(
            thread_index) + " : Created Branch [" + unique_branch_name + "] & Pushed to Origin")


def reset_to_branch(branch_name):
    sp.check_output(['git', 'checkout', branch_name])
    print("[Branch Bombing] Reset to Branch [" + branch_name + "]")


def delete_branch(branch_name):
    sp.check_output(['git', 'branch', '-d', branch_name])
    print("[Branch Bombing] Deleted Branch [" + branch_name + "]")


def main():
    parser = argparse.ArgumentParser(description='Run branch bombing on a specific Git repo.')
    parser.add_argument('-t', '--Threads', help='Number of threads', required=False)
    parser.add_argument('-ib', '--Initial_Branch', help='Initial branch used to start creating branches from.',
                        required=False)
    parser.add_argument('-rb', '--Reset_Branch', help='Reset branch after the bombing.', required=False)
    parser.add_argument('-n', '--Size_Of_Branch_Name', help='Number of characters for each unique branch generated.',
                        required=False)
    parser.add_argument('-c', '--Git_Clone_Repo', help='The SSH link for Git cloning the repo.', required=False)

    args = vars(parser.parse_args())
    num_of_threads = args['Threads']
    initial_branch = args['Initial_Branch']
    reset_branch_name = args['Reset_Branch']
    number_chars_for_branch_name = args['Size_Of_Branch_Name']
    git_clone_link = args['Git_Clone_Repo']

    print("[Branch Bombing] Starting Branch Bombing")

    if initial_branch is not None:
        sp.Popen(["git", "checkout " + initial_branch], stdin=sp.PIPE, stdout=sp.PIPE,
                 shell=True)
        print("[Branch Bombing] Git Checked Out to " + initial_branch)

    if num_of_threads is None:
        num_of_threads = 10

    if reset_branch_name is None:
        reset_branch_name = 'master'

    if number_chars_for_branch_name is None:
        number_chars_for_branch_name = 10

    for x in range(num_of_threads):
        print("[Branch Bombing] Thread " + str(x) + " : Executing the Branch Bombing")
        thread_start = threading.Thread(target=execute_branch_bombing,
                                        args=(git_clone_link, number_chars_for_branch_name, x, reset_branch_name))
        thread_start.start()
        time.sleep(.9)


if __name__ == "__main__":
    main()
