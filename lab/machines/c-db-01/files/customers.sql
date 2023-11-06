CREATE DATABASE IF NOT EXISTS customers;

use customers;

CREATE TABLE acme_hyper_branding(
   id INT AUTO_INCREMENT,
   first_name VARCHAR(100),
   last_name VARCHAR(100),
   designation VARCHAR(100),
   email VARCHAR(50),
   password VARCHAR(20),
   PRIMARY KEY(id)
);

CREATE TABLE acme_impact_alliance(id INT AUTO_INCREMENT,
   first_name VARCHAR(100),
   last_name VARCHAR(100),
   designation VARCHAR(100),
   email VARCHAR(50),
   password VARCHAR(20),
   PRIMARY KEY(id)
);

INSERT INTO acme_hyper_branding (`first_name`, `last_name`, `designation`, `email`, `password`) VALUES ("Jacob", "Taylor", "Founder", "jtaylor@acme-hyper-branding.com", "carmen");
INSERT INTO acme_hyper_branding (`first_name`, `last_name`, `designation`, `email`, `password`) VALUES ("Sarah", "Lewish", "Executive Assistant", "slewis@acme-hyper-branding.com", "cachepot");
INSERT INTO acme_hyper_branding (`first_name`, `last_name`, `designation`, `email`, `password`) VALUES ("Nicholas", "Young", "Influencer", "nyoung@acme-hyper-branding.com", "spring2023");
INSERT INTO acme_hyper_branding (`first_name`, `last_name`, `designation`, `email`, `password`) VALUES ("Lauren", "Scott", "Influencer", "lscott@acme-hyper-branding.com", "gaga");
INSERT INTO acme_hyper_branding (`first_name`, `last_name`, `designation`, `email`, `password`) VALUES ("Aaron", "Peres", "Marketing Lead", "aperes@acme-hyper-branding.com", "aperes123");
INSERT INTO acme_hyper_branding (`first_name`, `last_name`, `designation`, `email`, `password`) VALUES ("Melissa", "Rogers", "Software Engineer", "mrogers@acme-hyper-branding.com", "melissa2go");

INSERT INTO acme_impact_alliance (`first_name`, `last_name`, `designation`, `email`, `password`) VALUES ("Jane", "Torres", "Owner", "jtorres@acme-impact-alliance.com", "asfim2ne7asd7");
INSERT INTO acme_impact_alliance (`first_name`, `last_name`, `designation`, `email`, `password`) VALUES ("Anthony", "Johnson", "Executive Assistant", "ajohnson@acme-impact-alliance.com", "3kemas8dh23");
INSERT INTO acme_impact_alliance (`first_name`, `last_name`, `designation`, `email`, `password`) VALUES ("David", "Carter", "Cat Rescuer", "dcarter@acme-impact-alliance.com", "asdij28ehasds");
INSERT INTO acme_impact_alliance (`first_name`, `last_name`, `designation`, `email`, `password`) VALUES ("Benjamin", "Mitchell", "Cat Rescuer", "bmitchell@acme-impact-alliance.com", "2rnausdiuwhd");
INSERT INTO acme_impact_alliance (`first_name`, `last_name`, `designation`, `email`, `password`) VALUES ("Karen", "Cook", "Cat Rescuer", "kcook@acme-impact-alliance.com", "wdnausdb723bs");
INSERT INTO acme_impact_alliance (`first_name`, `last_name`, `designation`, `email`, `password`) VALUES ("Kevin", "Peterson", "Software Engineer", "kpeterson@acme-impact-alliance.com", "wudhasdg72ws");

