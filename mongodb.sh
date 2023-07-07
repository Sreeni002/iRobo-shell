cp mongo.repo /etc/yum.repos.d/mongo.repo
yum install mongodb-org -y
systemctl enable mongod
systemctl start mongod

#We need to update the mongodb port no to 0.0.0.0
systemctl restart mongod