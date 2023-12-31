app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")
log_file=/tmp/roboshop.log
# the below command will delete the exisiting file and it will create new when the script runs every time
# rm -rf $log_file

print_head() {
echo -e "\e[36m>>>>>>>>>>>>>>$1<<<<<<<<<<<<<<<<\e[0m"
echo -e "\e[36m>>>>>>>>>>>>>>$1<<<<<<<<<<<<<<<<\e[0m" &>>$log_file
}

func_status_check() {
    if [ $1 -eq 0 ]; then
      echo -e "\e[32m SUCCESS\e[0m"
    else
      echo -e "\e[32m FAILURE\e[0m"
      echo "Refer the log file /tmp/roboshop.log for more info"
      exit 1
    fi
}
schema_setup() {
  if [ "$schema_setup" == "mongo" ]; then
    print_head "Copy mongo repo file"
    cp $script_path/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
    func_status_check $?

    print_head "Install mongo client"
    yum install mongodb-org-shell -y &>>$log_file
    func_status_check $?

    print_head "Load schema"
    mongo --host mongodb-dev.sreenivasulareddydevops.online </app/schema/${component}.js &>>$log_file
    func_status_check $?
  fi
  if [ "${schema_setup}" == "mysql" ]; then
    print_head "Install my sql"
    yum install mysql -y &>>$log_file
    func_status_check $?

    print_head "Load schema"
    mysql -h mysql-dev.sreenivasulareddydevops.online -uroot -p${mysql_root_password} < /app/schema/shipping.sql &>>$log_file
    func_status_check $?
  fi
}

func_app_prereq() {
  print_head "Add app userid"
  id ${app_user} &>>/tmp/roboshop.log
  if [ $? -ne 0 ]; then
    useradd ${app_user} &>>/tmp/roboshop.log
  fi
  func_status_check $?

  print_head "create app directory"
  rm -rf /app &>>$log_file
  mkdir /app &>>$log_file
  func_status_check $?

  print_head "Dowload the app content"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>$log_file
  func_status_check $?

  print_head "Extract the app content"
  cd /app
  unzip /tmp/${component}.zip &>>$log_file
  func_status_check $?
}

func_systemd_setup() {
  print_head "Setup systemd service"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service &>>$log_file
  func_status_check $?

  print_head "Restart ${component} service"
  systemctl daemon-reload
  systemctl enable ${component} &>>$log_file
  systemctl restart ${component} &>>$log_file
  func_status_check $?
}

function_nodejs() {
  print_head "Configuring nodeJS repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$log_file
  func_status_check $?

print_head "Inastall nodejs"
  yum install nodejs -y &>>$log_file
  func_status_check $?

  func_app_prereq

  print_head "Install nodejs repos"
  npm install &>>$log_file
  func_status_check $?

  schema_setup
  func_systemd_setup
}

func_java() {
  print_head "Install Maven"
  yum install maven -y &>>$log_file
  func_status_check $?

  func_app_prereq

print_head "Download Maven dependencies"
  mvn clean package &>>$log_file

  func_status_check $?

  mv target/${component}-1.0.jar ${component}.jar &>>$log_file
  schema_setup
  func_systemd_setup
}

func_python() {

print_head "Install python3"
yum install python36 gcc python3-devel -y  &>>$log_file
func_status_check $?

func_app_prereq

print_head "Install pip dependencies"
pip3.6 install -r requirements.txt  &>>$log_file
func_status_check $?

print_head "Update password in system service file"
sed -i -e "s|rabbitmq_appuser_password|${rabbitmq_appuser_password}|" ${script_path}/payment.service  &>>$log_file
func_status_check $?
func_systemd_setup
}