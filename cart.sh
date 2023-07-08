echo -e "\e[36m>>>>>>>>>>>>>>Configuring nodeJS repos<<<<<<<<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[36m>>>>>>>>>>>>>>Inastall nodejs<<<<<<<<<<<<<<<<\e[0m"
yum install nodejs -y

echo -e "\e[36m>>>>>>>>>>>>>>Add app user<<<<<<<<<<<<<<<<\e[0m"
useradd roboshop

echo -e "\e[36m>>>>>>>>>>>>>>Create app Dir<<<<<<<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>>>>>>>Download app content<<<<<<<<<<<<<<<<\e[0m"
curl -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
cd /app

echo -e "\e[36m>>>>>>>>>>>>>>Extract the content<<<<<<<<<<<<<<<<\e[0m"
unzip /tmp/cart.zip

echo -e "\e[36m>>>>>>>>>>>>>>Install npm repos<<<<<<<<<<<<<<<<\e[0m"
npm install

echo -e "\e[36m>>>>>>>>>>>>>>Copy cart service file <<<<<<<<<<<<<<<<\e[0m"
cp /home/centos/iRobo-shell/cart.service /etc/systemd/system/cart.service

echo -e "\e[36m>>>>>>>>>>>>>>Restart the cart service<<<<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable cart
systemctl restart cart