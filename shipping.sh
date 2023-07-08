script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

echo -e "\e[36m>>>>>>>>>>>>>>Install Maven<<<<<<<<<<<<<<<<\e[0m"
yum install maven -y

echo -e "\e[36m>>>>>>>>>>>>>>Add app userid<<<<<<<<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[36m>>>>>>>>>>>>>>create app directory<<<<<<<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>>>>>>>Dowload the app content<<<<<<<<<<<<<<<<\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip

echo -e "\e[36m>>>>>>>>>>>>>>Extract the app content<<<<<<<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/shipping.zip

echo -e "\e[36m>>>>>>>>>>>>>>Download Maven dependencies<<<<<<<<<<<<<<<<\e[0m"
mvn clean package
mv target/shipping-1.0.jar shipping.jar

echo -e "\e[36m>>>>>>>>>>>>>>Install my sql<<<<<<<<<<<<<<<<\e[0m"
yum install mysql -y

echo -e "\e[36m>>>>>>>>>>>>>>Load schema<<<<<<<<<<<<<<<<\e[0m"
mysql -h mysql-dev.sreenivasulareddydevops.online -uroot -pRoboShop@1 < /app/schema/shipping.sql

echo -e "\e[36m>>>>>>>>>>>>>>Setup systemd service<<<<<<<<<<<<<<<<\e[0m"
cp ${script_path}/shipping.service /etc/systemd/system/shipping.service

echo -e "\e[36m>>>>>>>>>>>>>>Restart service<<<<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable shipping
systemctl restart shipping