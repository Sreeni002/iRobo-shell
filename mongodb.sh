script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

print_head "Copy mongo repo file"
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
func_status_check $?

print_head "Install MongoDB client"
yum install mongodb-org -y &>>$log_file
func_status_check $?

print_head "Update MongoDB listen address to 0.0.0.0"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf &>>$log_file
func_status_check $?

print_head "enable and restart service"
systemctl enable mongod &>>$log_file
systemctl restart mongod &>>$log_file
func_status_check $?

