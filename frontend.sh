script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

print_head "Install nginx"
yum install nginx -y &>>$log_file
func_status_check

print_head "Copy Roboshop config file"
cp roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$log_file
func_status_check

print_head "Remove the existing content"
rm -rf /usr/share/nginx/html/* &>>$log_file
func_status_check

print_head "Download the application content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$log_file
func_status_check

print_head "Extract the App content"
cd /usr/share/nginx/html &>>$log_file
unzip /tmp/frontend.zip &>>$log_file
func_status_check

print_head "Enable and restart the service"
systemctl restart nginx &>>$log_file
systemctl enable nginx &>>$log_file
func_status_check