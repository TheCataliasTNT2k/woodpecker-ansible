#!/bin/bash

if [[ -z ${SSH_KEY} ]]; then
  echo "Please configure ssh_key as woodpecker ci secret!"
  exit 1
fi

# first we are going to save the contents of SSH_KEY as valid ssh key
mkdir -p /home/worker/.ssh/
echo -n "${SSH_KEY}" > /home/worker/.ssh/id_ed25519
chown worker:worker /home/worker/.ssh/id_ed25519
chmod 400 /home/worker/.ssh/id_ed25519

# make git cli useable
git config --global --add safe.directory $(pwd)

if [[ -f /home/worker/jobs.sh ]]; then
    # check which files have been changed in the last commit,
    #  if changes have been made to a specific site it will be added to the hosts list
    #  if changes have been made to all sites, all sites will be returned
    export HOSTS=$(python3 /home/worker/check_changes.py $(git diff --name-only HEAD HEAD~1 | xargs))

    if [ -z "${HOSTS}" ]; then
        echo "No relevant changes detected, exiting..."
        exit 0
    fi

    /bin/bash /home/worker/jobs.sh
else
    echo "File /home/worker/jobs.sh could not be found, spawning shell..."
    /bin/bash
fi
