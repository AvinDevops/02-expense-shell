#!/bin/bash

#creating/declaring user variables
USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPTNAME=$(echo $0 | cut -d "." f1)
LOGFILE=/tmp/$SCRIPTNAME-$TIMESTAMP.log

#creating colors user variables
R="\e[31m"
G="\e[32m"
N="\e[0m"

#creating CHECKSTATUS function
CHECKSTATUS(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2...is $R Failed $N"
        exit 1
    else
        echo -e "$2...is $G Success $N"
    fi
}

#checking whether user is root or not
if [ $USERID -ne 0 ]
then
    echo "Please access with root user access"
    exit 1
else
    echo "you have root access, please procced"
fi

#Main code
dnf install mysql-server -y &>> $LOGFILE
CHECKSTATUS $? "Installing mysql-server"

systemctl enable mysqld &>> $LOGFILE
CHECKSTATUS $? "Enabling mysql-server"

systemctl start mysqld &>> $LOGFILE
CHECKSTATUS $? "Starting mysql-server"

mysql_secure_installation --set-root-pass ExpenseApp@1 &>> $LOGFILE
CHECKSTATUS $? "Setting root password for mysql-server"