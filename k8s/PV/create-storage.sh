#/bin/sh
aws ec2 create-volume --region us-west-2 --availability-zone us-west-2a --size 50 --volume-type gp2 --tag-specifications 'ResourceType=volume,Tags=[{Key=Name,Value=jackson-chen}]'
