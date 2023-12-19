#!/usr/bin/env bash

set -euo pipefail

if [ "${#}" -lt 1 ]; then
    echo "Usage: run.sh INSTANCE_TYPE"
    exit 1
fi

INSTANCE_TYPE=$1

echo "### Setting SSH keys for cloning from GitHub started"
echo "github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl" >> ~/.ssh/known_hosts
echo "github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=" >> ~/.ssh/known_hosts
echo "github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==" >> ~/.ssh/known_hosts
echo "### Setting SSH keys for cloning from GitHub finished"

echo "### Installing packages started"
export DEBIAN_FRONTEND=noninteractive
# removing the needrestart package to prevent service restart prompts during installation
sudo apt purge -y needrestart
sudo apt update
sudo apt install -y tmux vim nmon bmon python3-pip zip silversearcher-ag parallel awscli s4cmd git g++ cmake ninja-build fzf
echo "### Installing packages finished"

pip3 install pybind11
pip3 install duckdb

aws s3 cp s3://duckdb-blobs/data/tpch-sf100.db .

python3 run.py ${1}
cat out.csv
