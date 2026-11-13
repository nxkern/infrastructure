.PHONY: plan apply fmt validate 

plan:
	terraform plan $(PARALLEL) -var-file="variables.tfvars" -out plan.out

apply:
	terraform apply $(PARALLEL) "plan.out"

fmt: 
	terraform fmt --recursive

validate:
	terraform validate

