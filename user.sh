echo -e "\e[36m>>>>>>>>>>>>>>Configuring nodeJS repos <<<<<<<<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[36m>>>>>>>>>>>>>>Inastall nodejs<<<<<<<<<<<<<<<<\e[0m"
yum install nodejs -y

echo -e "\e[36m>>>>>>>>>>>>>>Add app user<<<<<<<<<<<<<<<<\e[0m"
useradd roboshop

echo -e "\e[36m>>>>>>>>>>>>>>Create app Dir<<<<<<<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>>>>>>>Download app content<<<<<<<<<<<<<<<<\e[0m"
curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip

echo -e "\e[36m>>>>>>>>>>>>>>Extract the content<<<<<<<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/user.zip

echo -e "\e[36m>>>>>>>>>>>>>>Install npm repos<<<<<<<<<<<<<<<<\e[0m"
npm install

echo -e "\e[36m>>>>>>>>>>>>>>Copy user service file <<<<<<<<<<<<<<<<\e[0m"
cp /home/centos/iRobo-shell/user.service /etc/systemd/system/user.service

echo -e "\e[36m>>>>>>>>>>>>>>Restart the user service<<<<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable user
systemctl restart user

echo -e "\e[36m>>>>>>>>>>>>>>Copy mongo repo file <<<<<<<<<<<<<<<<\e[0m"
cp /home/centos/iRobo-shell/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m>>>>>>>>>>>>>>Install mongo client<<<<<<<<<<<<<<<<\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[36m>>>>>>>>>>>>>>Load schema<<<<<<<<<<<<<<<<\e[0m"
mongo --host mongodb-dev.sreenivasulareddydevops.online </app/schema/user.js

