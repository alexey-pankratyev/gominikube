.PHONY: deploy install_chef run_minikube create destroy run stop_vm start_vm delete_vm  use_context helm_init


	@#@
	@#@ ----------------- LAUNCH OPERATIOS -----------------

deploy: install_chef create run_minikube use_context helm_init
	@#@ This work is to install and run a minicube and everything you need for it.

install_chef:
	@#@ Install chef
	sudo curl -L https://www.opscode.com/chef/install.sh | sudo bash

create:
	@#@ Run the hypervisor,  kubectl, minikube, helm installation
	echo "{\"run_list\":[\"recipe[gominikube]\"],\"user_dir\":\"$(HOME)\/.minikube\"}" > $(shell pwd)/chef_solo/minikube_create.json
	sudo chef-solo -c $(shell pwd)/chef_solo/solo.rb -j $(shell pwd)/chef_solo/minikube_create.json

run_minikube:
	@#@ Run minikube
	minikube start --vm-driver kvm

use_context:
	@#@ Set context minikube
	kubectl config use-context minikube

helm_init:
	@#@ Initialization helm
	helm init


	@#@
	@#@ ----------------- OPERATING DESTRUCTION -----------------

destroy:
	@#@ Start removing the hypervisor, kubectl, minikube, helm
	echo "{\"run_list\":[\"recipe[destroykube]\"],\"user_dir\":\"$(HOME)\/.minikube\"}" > $(shell pwd)/chef_solo/minikube_destroy.json
	sudo chef-solo -c $(shell pwd)/chef_solo/solo.rb -j $(shell pwd)/chef_solo/minikube_destroy.json


	@#@
	@#@ ----------------- OPERATING WITH VIRTUAL MACHINES -----------------

run: run_minikube use_context helm_init
	@#@ Launching minikube, context definition and helmet installation

stop_vm:
	@#@ Stop virtual minikube  machine
	minikube stop

start_vm: start_minikube
	@#@ Start virtual minikube  machine
	minikube start

delete_vm: delete_minikube
	@#@ Delete virtual minikube  machine
	minikube delete

help:
	@grep -P "\t@#@" $(CURDIR)/Makefile -B 2 | \
	grep -P "^([\w$$]+|\t)" | \
	awk '{if ($$1 ~ /^@?#/) {$$1="\t\t";print;} else print "\033[1;37m" $$1 "\033[0m "}'
