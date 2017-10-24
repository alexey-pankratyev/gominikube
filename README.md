# Go Minikube

A simple cookbook for turning the Minikube and all the necessary packages for it.

## How deploy Minikube?

Everything is very simple, In the project directory, simply call the command ``make help``

* That would install a __hypervisor__, __minikube__, __kubectl__, __helm__. You need to register the variable "__hypervisor__" parameter "**virtualbox**" or "**kvm**" in the __Make__ file. Than launch command ```make deploy```.

* That would remove everything installed, just run command ```make destroy```
