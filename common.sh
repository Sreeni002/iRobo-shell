app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

print_head() {
echo -e "\e[36m>>>>>>>>>>>>>>$1<<<<<<<<<<<<<<<<\e[0m"
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
}