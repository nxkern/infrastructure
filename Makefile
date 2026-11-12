.PHONY: plan apply

plan:
	terraform plan -var-file="variables.tfvars" -out plan.out

apply:
	terraform apply "plan.out"

