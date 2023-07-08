echo -e "\e[36m>>>>>>>>>>>>>>setup erlang repos<<<<<<<<<<<<<<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash

echo -e "\e[36m>>>>>>>>>>>>>>setup rabbitmq repos<<<<<<<<<<<<<<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

echo -e "\e[36m>>>>>>>>>>>>>>Install erlang and rabbitmq<<<<<<<<<<<<<<<<\e[0m"
yum install erlang rabbitmq-server -y

echo -e "\e[36m>>>>>>>>>>>>>>Restart rabbitmq server<<<<<<<<<<<<<<<\e[0m"
systemctl enable rabbitmq-server
systemctl restart rabbitmq-server

echo -e "\e[36m>>>>>>>>>>>>>>Add application user in rabbitmq <<<<<<<<<<<<<<<<\e[0m"
rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
