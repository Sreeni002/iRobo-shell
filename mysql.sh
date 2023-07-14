script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "$mysql_root_password" ]; then
  echo Input mysql_root_password is missing
  exit 1
fi

print_head "Disable mysql version 8"
dnf module disable mysql -y &>>$log_file
func_status_check $?

print_head "Copy mysql repo file"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo &>>$log_file
func_status_check $?

print_head "Install mysql"
yum install mysql-community-server -y &>>$log_file
func_status_check $?

print_head "start mysql service"
systemctl enable mysqld &>>$log_file
systemctl restart mysqld &>>$log_file
func_status_check $?

print_head "reset user id for mysql"
mysql_secure_installation --set-root-pass $mysql_root_password &>>$log_file
func_status_check $?
