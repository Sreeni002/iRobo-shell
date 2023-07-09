app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

print_head() {
echo -e "\e[36m>>>>>>>>>>>>>>$1<<<<<<<<<<<<<<<<\e[0m"
}

schema_setup() {
  if [ "$schema_setup" == "mongo" ]; then
    print_head "Copy mongo repo file"
    cp $script_path/mongo.repo /etc/yum.repos.d/mongo.repo

    print_head "Install mongo client"
    yum install mongodb-org-shell -y

    print_head "Load schema"
    mongo --host mongodb-dev.sreenivasulareddydevops.online </app/schema/${component}.js
  fi
  if [ "${schema_setup}" == "mysql" ]; then
    print_head "Install my sql"
    yum install mysql -y

    print_head "Load schema"
    mysql -h mysql-dev.sreenivasulareddydevops.online -uroot -p${mysql_root_password} < /app/schema/shipping.sql
  fi
}

func_app_prereq() {
  print_head "Add app userid"
  useradd ${app_user}

  print_head "create app directory"
  rm -rf /app
  mkdir /app

  print_head "Dowload the app content"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip

  print_head "Extract the app content"
  cd /app
  unzip /tmp/${component}.zip
}

func_systemd_setup() {
  print_head "Setup systemd service"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

  print_head "Restart ${component} service"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}
}

function_nodejs() {
print_head "Configuring nodeJS repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

print_head "Inastall nodejs"
yum install nodejs -y

func_app_prereq

print_head "Install npm repos"
npm install

schema_setup
func_systemd_setup
}

func_java() {
print_head "Install Maven"
yum install maven -y
if [ $? -eq 0 ]; then
  echo -e "\e[32m SUCCESS\e[0m"
else
  echo -e "\e[32m FAILURE\e[0m"
fi

func_app_prereq

print_head "Download Maven dependencies"
  mvn clean package
  if [ $? -eq 0 ]; then
    echo -e "\e[32m SUCCESS\e[0m"
  else
    echo -e "\e[32m FAILURE\e[0m"
  fi
  mv target/${component}-1.0.jar ${component}.jar

  schema_setup
  func_systemd_setup
}