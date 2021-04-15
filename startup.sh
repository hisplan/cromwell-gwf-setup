#!/bin/bash -e

source versions.sh

# start docker
sudo service docker start

cd ${HOME}

# start redis
echo "Starting up Redis..."
screen -S redis -d -m docker run --rm -p 6379:6379 redis:${REDIS_VERSION}

sleep 5

# variables
sleep_seconds=5
cromwell_svr_log="$HOME/cromwell-server.log"

echo "Backing up Cromwell Server Log..."

if [ -r "$cromwell_svr_log" ]
then
  mv ${cromwell_svr_log} ${cromwell_svr_log}.bak
fi

# to avoid cat from complaining file not found
touch ${cromwell_svr_log}

echo "Starting up Cromwell Server..."

# 2019-11-14 10:48:00,386 - cwlogs.push.stream - WARNING - 2733 - Thread-1 - No file is found with given path '/tmp/cromwell-server.log'.
# hack:
# touch /tmp/cromwell-server.log

# start cromwell server (managed by supervisord)
supervisord
# start cromwell in a screen called "cromwell"
# screen -S cromwell -d -m ./start-cromwell.sh

# wait until cromwell is up and running
while ! cat ${cromwell_svr_log} | grep -F "service started on" > /dev/null
do
  echo "Waiting for Cromwell Server to be up and running..."
  sleep ${sleep_seconds}
done

# start Job Manager
echo "Starting up Job Manager..."
screen -S jm -d -m ${HOME}/jmui/bin/jmui_start.sh

sleep 5

# start cromsfer-poller
echo "Starting up Cromsfer Poller..."
screen -S poller -d -m ./start-cromsfer-poller.sh

sleep 5

# start cromsfer-transfer
echo "Starting up Cromsfer Transfer..."
screen -S transfer -d -m ./start-cromsfer-transfer.sh

sleep 5

# send ready message to Slack
slack_hook_key=`aws ssm get-parameters --name="scata-slack-noti-dev" --query="Parameters[0].Value" | sed 's/"//g'`
ip_addr=`curl --silent http://169.254.169.254/latest/meta-data/public-hostname`

python3 notify_slack.py \
  --hook-key="${slack_hook_key}" \
  --message="Cromwell/Job Manager is available at http://${ip_addr}:4200"

echo "DONE."
