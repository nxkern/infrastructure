.PHONY: init plan apply fmt validate 

init:
	terraform init -reconfigure -backend-config=backend.hcl

plan:
	terraform plan $(PARALLEL) -var-file="variables.tfvars" -out plan.out

apply:
	terraform apply $(PARALLEL) "plan.out"

fmt: 
	terraform fmt --recursive

validate:
	terraform validate

