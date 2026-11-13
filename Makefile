.PHONY: plan apply 

plan:
	terraform plan $(PARALLEL) -var-file="variables.tfvars" -out plan.out

apply:
	terraform apply $(PARALLEL) "plan.out"



