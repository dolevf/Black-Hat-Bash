.DEFAULT_GOAL := help

MAKEFLAGS += --no-print-directory

deploy:
	@./run.sh deploy

teardown:
	@./run.sh teardown

cleanup:
	@./run.sh cleanup

rebuild:
	@./run.sh rebuild

status:
	@./run.sh status

init:
	@./init.sh

help:
	@echo "Usage: make deploy | teardown | cleanup | rebuild | status | init"
	@echo 
	@echo "deploy   | build images and start containers"
	@echo "teardown | stop containers"
	@echo "rebuild  | rebuilds the lab from scratch"
	@echo "cleanup  | stop containers and delete containers and images"
	@echo "status   | check the status of the lab"
