#!/bin/bash
yum update -y
yum install -y amazon-cloudwatch-agent  #install cloudwatch-agent

cat <<EOF > /opt/aws/amazon-cloudwatch-agent/bin/config.json    #create cloudwatch agent config
{
  "metrics": {
    "metrics_collected": {
      "disk": {                             
        "measurement": ["used_percent"],
        "resources": ["*"],
        "drop_device": true
      }
    },
    "append_dimensions": {
      "InstanceId": "\${aws:InstanceId}"
    }
  }
}
EOF

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config \
  -m ec2 \
  -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json \
  -s
