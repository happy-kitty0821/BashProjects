#!/bin/bash

#making this script executable
# chmod +x PasswordGenerator.sh
# ./PasswordGenerator.sh 
clear
#simple password generator using bash language

echo "[<>]password generator v0.0.1[<>]"
sleep 1 #delay of 1 sec
echo "[~] Enter the length of your password:"

read -r passwordLength

echo "[!] Your password length is $passwordLength"
sleep 0.5 #delay of 500
echo "[!]how many paswords u want to make???"

read -r passwordNumber
#generate different passwords according to the user's choice
for _ in $(seq "$passwordNumber"); do
    openssl rand -base64 "$((passwordLength * 3 / 4))" | tr -d '\n'
    echo  #add a newline after each password
    sleep 0.75 #delay of 750ms 
done
