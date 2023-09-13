SHELL := /bin/bash
MAKEFLAGS += --no-print-directory

.DEFAULT_GOAL := help

deploy:
	@./run.sh deploy

teardown:
	@./run.sh teardown

clean:
	@./run.sh clean

rebuild:
	@./run.sh rebuild

status:
	@./run.sh status

test:
	@./run.sh status

init:
	@./init.sh

help:
	@echo "Usage: make deploy | teardown | clean | rebuild | status | init | help"
	@echo 
	@echo "deploy   | build images and start containers"
	@echo "teardown | stop containers (shutdown lab)"
	@echo "rebuild  | rebuilds the lab from scratch (clean and deploy)"
	@echo "clean    | stop and delete containers and images"
	@echo "status   | check the status of the lab"
	@echo "init     | build everything (containers and hacking tools)"
	@echo "help     | show this help message"
	
