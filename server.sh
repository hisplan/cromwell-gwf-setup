#!/bin/bash

# update according to your environment setup
instance_id="i-0ca914341b4913d6c"
keypair="~/dpeerlab-chunj.pem"

usage()
{
cat << EOF
USAGE: `basename $0` [options]
    -u  bring up the server instance
    -d  bring down the server instance
EOF
}

server_up()
{
    aws ec2 start-instances \
        --instance-ids ${instance_id}

    aws ec2 wait instance-status-ok \
        --instance-ids ${instance_id}

    # get public DNS name
    addr=`aws ec2 describe-instances --instance-ids ${instance_id} --query "Reservations[0].Instances[0].{Instance:PublicDnsName}" --output text`

    echo "Cromwell server address: ${addr}"

    ssh -i ${keypair} ec2-user@${addr} ./startup.sh

    # send ready message to Slack
    python3 notify_slack.py \
        --hook-key="${slack_hook_key}" \
        --message="Cromwell/Job Manager is available at http://${addr}:4200"

    echo "Cromwell/Job Manager is available at http://${addr}:4200"
}

server_down()
{
    aws ec2 stop-instances \
        --instance-ids ${instance_id}

    aws ec2 wait instance-stopped \
        --instance-ids ${instance_id}

    # send ready message to Slack
    python3 notify_slack.py \
        --hook-key="${slack_hook_key}" \
        --message="Cromwell/Job Manager is stopped."

    echo "Cromwell/Job Manager is stopped."
}

while getopts "udh" OPTION
do
    case $OPTION in
        u) action="up" ;;
        d) action="down" ;;
        h) usage; exit 1 ;;
        *) usage; exit 1 ;;
    esac
done

# get slack hook key
slack_hook_key=`aws ssm get-parameters --name="scata-slack-noti-dev" --query="Parameters[0].Value" | sed 's/"//g'`

if [ "$action" == 'up' ]
then
    server_up
    exit 0
fi

if [ "$action" == 'down' ]
then
    server_down
    exit 0
fi

usage
