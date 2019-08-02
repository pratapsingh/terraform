You need to mv state.tf file else where if you are running the terraform init and plan for the first time.

Export the aws profile first as below

export AWS_PROFILE=default

mv state.tf ../

terraform init

terraform plan

terraform apply

Created all necessary buckets first

mv ../state.tf .

terraform init

terraform plan

terraform apply

Now stored all the global resources state in state files in s3
