app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

print_head() {
echo -e "\e[36m>>>>>>>>>>>>>>$1<<<<<<<<<<<<<<<<\e[0m"
}

schema_setup() {
  echo -e "\e[36m>>>>>>>>>>>>>>Copy mongo repo file <<<<<<<<<<<<<<<<\e[0m"
  cp $script_path/mongo.repo /etc/yum.repos.d/mongo.repo

  echo -e "\e[36m>>>>>>>>>>>>>>Install mongo client<<<<<<<<<<<<<<<<\e[0m"
  yum install mongodb-org-shell -y

  echo -e "\e[36m>>>>>>>>>>>>>>Load schema<<<<<<<<<<<<<<<<\e[0m"
  mongo --host mongodb-dev.sreenivasulareddydevops.online </app/schema/${component}.js
}

function_nodejs() {
print_head "Configuring nodeJS repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

print_head "Inastall nodejs"
yum install nodejs -y

print_head "Add app user"
useradd ${app_user}

print_head "Create app Dir"
rm -rf /app
mkdir /app

print_head "Download app content"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
cd /app

print_head "Extract the content"
unzip /tmp/${component}.zip

print_head "Install npm repos"
npm install

print_head "Copy cart service file"
cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

print_head "Restart the cart service"
systemctl daemon-reload
systemctl enable ${component}
systemctl restart ${component}
schema_setup
}