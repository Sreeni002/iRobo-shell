script_path=$(dirname $0)
source ${script_path}/common.sh

component=catalogue

function_nodejs

echo -e "\e[36m>>>>>>>>>>>>>>Copy mongo repo<<<<<<<<<<<<<<<<\e[0m"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m>>>>>>>>>>>>>>Install mongodb client<<<<<<<<<<<<<<<<\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[36m>>>>>>>>>>>>>>Load mongodb schema<<<<<<<<<<<<<<<<\e[0m"
mongo --host mongodb-dev.sreenivasulareddydevops.online </app/schema/${component}.js