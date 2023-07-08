script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "$mysql_root_password" ]; then
  echo Input mysql_root_password is missing
  exit
fi

echo -e "\e[36m>>>>>>>>>>>>>>Disable mysql version 8 <<<<<<<<<<<<<<<<\e[0m"
dnf module disable mysql -y

echo -e "\e[36m>>>>>>>>>>>>>>Copy mysql repo file <<<<<<<<<<<<<<<<\e[0m"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo

echo -e "\e[36m>>>>>>>>>>>>>>Install mysql<<<<<<<<<<<<<<<<\e[0m"
yum install mysql-community-server -y

echo -e "\e[36m>>>>>>>>>>>>>>start<<<<<<<<<<<<<<<<\e[0m"
systemctl enable mysqld
systemctl restart mysqld

echo -e "\e[36m>>>>>>>>>>>>>>reset user id for mysql<<<<<<<<<<<<<<<<\e[0m"
mysql_secure_installation --set-root-pass $mysql_root_password
