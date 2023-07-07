cp mongo.repo /etc/yum.repos.d/mongo.repo
yum install mongodb-org -y
sed -i -e 's|127.0.0.1|0.0.0.0' /etc/mongod.conf
systemctl enable mongod
systemctl restart mongod

#We need to update the mongodb port no to 0.0.0.0
