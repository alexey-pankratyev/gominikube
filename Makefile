.PHONY: install_chef run_chefcookbooks_gominikube deploy run_minikube use_context helm_init

deploy: install_chef run_chefcookbooks_gominikube
	@#@ This work is to install and run a minicube and everything you need for it.

install_chef:
	@#@ install chef
	sudo curl -L https://www.opscode.com/chef/install.sh | bash

run_chefcookbooks_gominikube:
	@#@ Run chefcookbook
	sudo chef-solo -c $(shell pwd)/chef_solo/solo.rb -j $(shell pwd)/chef_solo/node.json

run_minikube:
	@#@ Run minikube
	minikube start --vm-driver kvm

use_context:
	@#@ Set context minikube
	kubectl config use-context minikube

helm_init:
	@#@ initialization helm
	helm init

help:
	@grep -P "\t@#@" $(CURDIR)/Makefile -B 2 | \
	grep -P "^([\w$$]+|\t)" | \
	awk '{if ($$1 ~ /^@?#/) {$$1="\t\t";print;} else print "\033[1;37m" $$1 "\033[0m "}'
