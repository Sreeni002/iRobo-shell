echo -e "\e[36m>>>>>>>>>>>>>>Disable mysql version 8 <<<<<<<<<<<<<<<<\e[0m"
yum module disable mysql -y

echo -e "\e[36m>>>>>>>>>>>>>>Copy mysql repo file <<<<<<<<<<<<<<<<\e[0m"
cp /home/centos/iRobo-shell/mysql.repo /etc/systemd/system/mysql.repo

echo -e "\e[36m>>>>>>>>>>>>>>Install mysql<<<<<<<<<<<<<<<<\e[0m"
yum install mysql-community-server -y

echo -e "\e[36m>>>>>>>>>>>>>>start<<<<<<<<<<<<<<<<\e[0m"
systemctl enable mysqld
systemctl restart mysqld

echo -e "\e[36m>>>>>>>>>>>>>>reset user id for mysql<<<<<<<<<<<<<<<<\e[0m"
mysql_secure_installation --set-root-pass RoboShop@1
