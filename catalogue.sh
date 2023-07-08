source common.sh
echo -e "\e[36m>>>>>>>>>>>>>>Configuring nodejs repos<<<<<<<<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[36m>>>>>>>>>>>>>>Install nodejs<<<<<<<<<<<<<<<<\e[0m"
yum install nodejs -y

echo -e "\e[36m>>>>>>>>>>>>>>Add application user<<<<<<<<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[36m>>>>>>>>>>>>>>Create application dir<<<<<<<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>>>>>>>Download application content<<<<<<<<<<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app

echo -e "\e[36m>>>>>>>>>>>>>>Unzip App content <<<<<<<<<<<<<<<<\e[0m"
unzip /tmp/catalogue.zip

echo -e "\e[36m>>>>>>>>>>>>>>Install nodejs dependencies<<<<<<<<<<<<<<<<\e[0m"
npm install

echo -e "\e[36m>>>>>>>>>>>>>>Copy catalogue systemd file<<<<<<<<<<<<<<<<\e[0m"
cp /home/centos/iRobo-shell/catalogue.service /etc/systemd/system/catalogue.service

echo -e "\e[36m>>>>>>>>>>>>>>Start catalogue service<<<<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue

echo -e "\e[36m>>>>>>>>>>>>>>Copy mongo repo<<<<<<<<<<<<<<<<\e[0m"
cp /home/centos/iRobo-shell/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m>>>>>>>>>>>>>>Install mongodb client<<<<<<<<<<<<<<<<\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[36m>>>>>>>>>>>>>>Load mongodb schema<<<<<<<<<<<<<<<<\e[0m"
mongo --host mongodb-dev.sreenivasulareddydevops.online </app/schema/catalogue.js