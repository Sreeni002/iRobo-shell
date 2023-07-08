source common.sh
echo -e "\e[36m>>>>>>>>>>>>>>Install python3<<<<<<<<<<<<<<<<\e[0m"
yum install python36 gcc python3-devel -y

echo -e "\e[36m>>>>>>>>>>>>>>Add application user<<<<<<<<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[36m>>>>>>>>>>>>>>Create app Dir<<<<<<<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>>>>>>>Download app content<<<<<<<<<<<<<<<<\e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip

echo -e "\e[36m>>>>>>>>>>>>>>Extract the app content<<<<<<<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/payment.zip

echo -e "\e[36m>>>>>>>>>>>>>>Install pip dependencies<<<<<<<<<<<<<<<<\e[0m"
pip3.6 install -r requirements.txt

echo -e "\e[36m>>>>>>>>>>>>>>Copy the systemd service file <<<<<<<<<<<<<<<<\e[0m"
cp /home/centos/iRobo-shell/payment.service /etc/systemd/system/payment.service

echo -e "\e[36m>>>>>>>>>>>>>>Restart the payment service<<<<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable payment
systemctl restart payment
