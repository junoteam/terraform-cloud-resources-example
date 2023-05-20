## Cost 

```bash
infracost breakdown --path terraform/

Evaluating Terraform directory at terraform/
  ✔ Downloading Terraform modules
  ✔ Evaluating Terraform directory
  ✔ Retrieving cloud prices to calculate costs

Project: junoteam/terraform-example-ec2/terraform

 Name                                                 Monthly Qty  Unit   Monthly Cost

 module.ec2_complete.aws_instance.this[0]
 ├─ Instance usage (Linux/UNIX, on-demand, t2.micro)          730  hours         $9.20
 └─ root_block_device
    └─ Storage (general purpose SSD, gp3)                      50  GB            $4.40

 OVERALL TOTAL                                                                  $13.60
──────────────────────────────────
25 cloud resources were detected:
∙ 1 was estimated, it includes usage-based costs, see https://infracost.io/usage-file
∙ 24 were free, rerun with --show-skipped to see details
```

## Pre-commit hooks

```bash
pre-commit run -a

check for added large files..............................................Passed
fix end of files.........................................................Passed
Terraform fmt............................................................Passed
Terraform docs...........................................................Passed
Terraform validate with tflint...........................................Passed
Infracost breakdown......................................................Passed
- hook id: infracost_breakdown
- duration: 2.71s

Evaluating Terraform directory at terraform/
  ✔ Downloading Terraform modules
  ✔ Evaluating Terraform directory
  ✔ Retrieving cloud prices to calculate costs


Running in "terraform"

Summary: {
  "totalDetectedResources": 25,
  "totalSupportedResources": 1,
  "totalUnsupportedResources": 0,
  "totalUsageBasedResources": 1,
  "totalNoPriceResources": 24,
  "unsupportedResourceCounts": {},
  "noPriceResourceCounts": {
    "aws_default_network_acl": 1,
    "aws_default_route_table": 1,
    "aws_default_security_group": 1,
    "aws_egress_only_internet_gateway": 1,
    "aws_internet_gateway": 1,
    "aws_network_acl": 2,
    "aws_network_acl_rule": 4,
    "aws_route": 2,
    "aws_route_table": 2,
    "aws_route_table_association": 2,
    "aws_security_group": 1,
    "aws_security_group_rule": 3,
    "aws_subnet": 2,
    "aws_vpc": 1
  }
}

Total Monthly Cost:        13.598 USD
Total Monthly Cost (diff): 0 USD
```

