CREATE DATABASE adminer_db;
CREATE USER 'adminer_user'@'localhost' IDENTIFIED BY 'P@ssword321';
GRANT ALL ON adminer_db.* TO 'adminer_user'@'localhost';
