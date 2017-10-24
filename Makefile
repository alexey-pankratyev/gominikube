# Enter what type of hypiphyper you want to use ( virtualbox or kvm )
hypervisor = virtualbox

.PHONY: deploy install_chef run_minikube create_libvirt create_vbox destroy \
	      destroy_libvirt destroy_vbox run stop_vm start_vm delete_vm  use_context helm_init


	@#@
	@#@ ----------------- LAUNCH OPERATIOS -----------------

deploy: install_chef create run_minikube use_context helm_init
	@#@ This work is to install and run a minicube and everything you need for it.

install_chef:
	@#@ Install chef
	sudo curl -L https://www.opscode.com/chef/install.sh | sudo bash

create:
	@#@ Run the hypervisor,  kubectl, minikube, helm installation
	if [ $(hypervisor) == "virtualbox" ]  ;	then $(MAKE) create_vbox ; fi
	if [ $(hypervisor) == "kvm" ]  ;	then $(MAKE) create_libvirt ; fi

create_libvirt:
	@#@ Run the libvirt,  kubectl, minikube, helm installation
	echo "{\"run_list\":[\"recipe[gominikube::create_libvirt]\", \"recipe[gominikube::default]\"],\"user_dir\":\"$(HOME)\/.minikube\"}" > $(shell pwd)/chef_solo/minikube_create.json
	sudo chef-solo -c $(shell pwd)/chef_solo/solo.rb -j $(shell pwd)/chef_solo/minikube_create.json

create_vbox:
	@#@ Run the virtualbox,  kubectl, minikube, helm installation
	echo "{\"run_list\":[\"recipe[virtualbox::default]\",\"recipe[gominikube::default]\"],\"user_dir\":\"$(HOME)\/.minikube\"}" > $(shell pwd)/chef_solo/minikube_create.json
	sudo chef-solo -c $(shell pwd)/chef_solo/solo.rb -j $(shell pwd)/chef_solo/minikube_create.json

run_minikube:
	@#@ Run minikube
	if [ $(hypervisor) == "virtualbox" ]  ;	then minikube start ; fi
	if [ $(hypervisor) == "kvm" ]  ;	then minikube start --vm-driver $(hypervisor) ; fi

use_context:
	@#@ Set context minikube
	kubectl config use-context minikube

helm_init:
	@#@ Initialization helm
	helm init


	@#@
	@#@ ----------------- OPERATING DESTRUCTION -----------------

destroy:
	@#@ Destroy the hypervisor,  kubectl, minikube, helm installation
	if [ $(hypervisor) == "virtualbox" ]  ;	then $(MAKE) destroy_vbox ; fi
	if [ $(hypervisor) == "kvm" ]  ;	then $(MAKE) destroy_libvirt ; fi

destroy_libvirt:
	@#@ Start removing the libvirt, kubectl, minikube, helm
	minikube delete || echo "continue"
	echo "{\"run_list\":[\"recipe[destroykube::default], recipe[destroykube::destroylibvirt]\"],\"user_dir\":\"$(HOME)\/.minikube\"}" > $(shell pwd)/chef_solo/minikube_destroy.json
	sudo chef-solo -c $(shell pwd)/chef_solo/solo.rb -j $(shell pwd)/chef_solo/minikube_destroy.json

destroy_vbox:
	@#@ Start removing the virtualbox, kubectl, minikube, helm
	minikube delete || echo "continue"
	echo "{\"run_list\":[\"recipe[destroykube::default]\", \"recipe[virtualbox::destroyvbox]\"],\"user_dir\":\"$(HOME)\/.minikube\"}" > $(shell pwd)/chef_solo/minikube_destroy.json
	sudo chef-solo -c $(shell pwd)/chef_solo/solo.rb -j $(shell pwd)/chef_solo/minikube_destroy.json


	@#@
	@#@ ---------------- OPERATING WITH VIRTUAL MACHINES ----------------

run: run_minikube use_context helm_init
	@#@ Launching minikube, context definition and helmet installation

stop_vm:
	@#@ Stop virtual minikube  machine
	minikube stop

start_vm: start_minikube
	@#@ Start virtual minikube  machine
	minikube start

delete_vm:
	@#@ Delete virtual minikube  machine
	minikube delete

help:
	$(info What type of hyprovisor do you want to install? \
	       Enter the top in the variable of "hypervisor" - ( virtualbox or kvm ))
	@grep -P "\t@#@" $(CURDIR)/Makefile -B 2 | \
	grep -P "^([\w$$]+|\t)" | \
	awk '{if ($$1 ~ /^@?#/) {$$1="\t\t";print;} else print "\033[1;37m" $$1 "\033[0m "}'
