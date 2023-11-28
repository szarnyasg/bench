# bench

Create an EC2 instance with the following disk settings:

* capacity: 200GB
* type: gp3
* IOPS: 3000

1. Connect to the instance via SSH.
2. Start a `tmux` session.
3. Set the instance type, e.g.

    ```
    INSTANCE_TYPE=m6a.2xlarge
    ```

4. Run the benchmark:

    ```bash
    if [[ -z ${INSTANCE_TYPE} ]]; then
        echo Environment variable INSTANCE_TYPE must be set.
    else
        git clone https://github.com/szarnyasg/bench
        cd bench
        ./run.sh ${INSTANCE_TYPE}
    fi
    ```
