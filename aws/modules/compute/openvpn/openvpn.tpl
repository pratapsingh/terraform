#!/bin/bash
yum install -y wget curl aws-cli
jenkins_url='https://ci.production.com'
username='devops'
ENV=${env}
PROJECT_NAME=${project}
HOSTNAME=${hostname}
if [ -n "$HOSTNAME" ]
then
    hostname $HOSTNAME
    unalias cp
    cp -f /etc/sysconfig/network /etc/sysconfig/network.bak
    sed -ie 's/^\(HOSTNAME\)=.*$/\1='$HOSTNAME'/' /etc/sysconfig/network
else
  echo "No hostname passed."
fi
SERVER=`curl wgetip.com`
token='ff2945ccab09483d5cc326702f261a'
CRUMB=$(curl -k --user $username:$token $jenkins_url/crumbIssuer/api/xml?xpath=concat\(//crumbRequestField,%22:%22,//crumb\))
#curl -kv -XPOST --user $username:$token -H "$CRUMB" $jenkins_url/job/devops_serversetup/buildWithParameters?ENV=$TYPE
curl -kv -X POST -H "$CRUMB" $jenkins_url/job/devops_serversetup/build \
  --user $username:$token \
  --data-urlencode json='{"parameter": [{"name":"ENV", "value":"'"$ENV"'"}, {"name":"PROJECT_NAME", "value":"'"$PROJECT_NAME"'"}, {"name":"HOSTNAME", "value":"'"$SERVER"'" }]}'
