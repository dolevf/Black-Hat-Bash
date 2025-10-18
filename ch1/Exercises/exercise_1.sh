#Recording you name and date 
#!/usr/bin/bash

read -r first_name 
read -r last_name 
touch output.txt
date -d -s "+%d-%m-%Y" > output.txt

echo "${first_name} ${last_name}" >> output.txt

cp output.txt backup.txt

cat output.txt
