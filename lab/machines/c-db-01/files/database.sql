CREATE DATABASE IF NOT EXISTS adminer_db;
CREATE USER IF NOT EXISTS 'adminer_user'@'localhost' IDENTIFIED BY 'P@ssword321';
GRANT ALL ON *.* TO 'adminer_user'@'localhost';
