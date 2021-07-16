#!/bin/bash

usage()
{
cat << EOF
USAGE: `basename $0` [options]
    -u  bring up the server instance
    -d  bring down the server instance
    -i  Cromwell server instance ID
    -k  path to your EC2 keypair for SSH login
    -r  AWS region
EOF
}

server_up()
{
    aws ec2 start-instances \
        --instance-ids ${instance_id} \
        --region ${region}

    aws ec2 wait instance-status-ok \
        --instance-ids ${instance_id} \
        --region ${region}

    # get public DNS name
    addr=`aws ec2 describe-instances --instance-ids ${instance_id} --region ${region} --query "Reservations[0].Instances[0].{Instance:PublicDnsName}" --output text`

    echo "Cromwell server address: ${addr}"

    ssh -i ${keypair} ec2-user@${addr} ./startup.sh

    # send ready message to Slack
    if [ "$slack_hook_key" != "null" ]
    then
        python3 notify_slack.py \
            --hook-key="${slack_hook_key}" \
            --message="Cromwell/Job Manager is available at http://${addr}:4200"
    fi
    echo "Cromwell/Job Manager is available at http://${addr}:4200"
}

server_down()
{
    aws ec2 stop-instances \
        --instance-ids ${instance_id} \
        --region ${region}

    aws ec2 wait instance-stopped \
        --instance-ids ${instance_id} \
        --region ${region}

    # send ready message to Slack
    if [ "$slack_hook_key" != "null" ]
    then
        python3 notify_slack.py \
            --hook-key="${slack_hook_key}" \
            --message="Cromwell/Job Manager is stopped."
    fi
    echo "Cromwell/Job Manager is stopped."
}

while getopts "udi:k:r:h" OPTION
do
    case $OPTION in
        u) action="up" ;;
        d) action="down" ;;
        i) instance_id=$OPTARG ;;
        k) keypair=$OPTARG ;;
        r) region=$OPTARG ;;
        h) usage; exit 1 ;;
        *) usage; exit 1 ;;
    esac
done

if [ -z "$instance_id" ] || [ -z "$keypair" ] || [ -z "$region" ]
then
    usage
    exit 1
fi

# get slack hook key
slack_hook_key=`aws ssm get-parameters --name="scata-slack-noti-dev" --query="Parameters[0].Value" --region ${region} | sed 's/"//g'`

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
