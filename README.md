## Infra run 

```bash
cd terraform/
terraform init
terraform plan 
terraform apply
terraform destroy
```

## InfraCost 

```bash
terraform plan -out tfplan.binary
terraform show -json tfplan.binary > plan.json
infracost breakdown --path plan.json --show-skipped
```

## InfraCost breakdown

```bash
Detected Terraform plan JSON file at plan.json
  ✔ Extracting only cost-related params from terraform
  ✔ Retrieving cloud prices to calculate costs

Project: junoteam/terraform-cloud-resources-example/terraform/plan.json

 Name                                                 Monthly Qty  Unit   Monthly Cost

 aws_eip.this
 └─ IP address (if unused)                                    730  hours         $3.65

 module.ec2_complete.aws_instance.this[0]
 ├─ Instance usage (Linux/UNIX, on-demand, t2.micro)          730  hours         $8.47
 └─ root_block_device
    └─ Storage (general purpose SSD, gp3)                      50  GB            $4.00

 OVERALL TOTAL                                                                  $16.12
──────────────────────────────────
28 cloud resources were detected:
∙ 2 were estimated, 1 of which usage-based costs, see https://infracost.io/usage-file
∙ 26 were free:
  ∙ 6 x aws_route_table_association
  ∙ 6 x aws_subnet
  ∙ 4 x aws_route_table
  ∙ 3 x aws_security_group_rule
  ∙ 1 x aws_default_network_acl
  ∙ 1 x aws_default_route_table
  ∙ 1 x aws_default_security_group
  ∙ 1 x aws_internet_gateway
  ∙ 1 x aws_route
  ∙ 1 x aws_security_group
  ∙ 1 x aws_vpc
```

## Build custom Jenkins Docker

```bash
docker build -t jenkins/jenkins:lts-local .
```

## Run Jenkins 

```bash
docker run --restart=always -d -p 8080:8080 -p 50000:50000 --name jenkins -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts-local
```


## Screenshot of Pipeline in Jenkins

![Alt Text](https://github.com/junoteam/terraform-cloud-resources-example/blob/main/pipeline_example.png?raw=true)