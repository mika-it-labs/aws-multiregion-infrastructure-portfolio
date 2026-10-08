# AWS Multi-Region Infrastructure Portfolio

A personal AWS infrastructure project exploring private networking, containerised applications, operational access, event-driven processing and connectivity between the Osaka and Tokyo regions.

I built and tested the environment using the AWS Management Console and AWS CLI, then documented major resources in Terraform. This repository demonstrates hands-on learning and infrastructure design decisions; it does not represent a client production deployment.

**Terraform scope:** `terraform init` and `terraform validate` were completed for the configuration. Import planning was undertaken for existing resources. Import execution, a completed migration into Terraform state, and provisioning from scratch with `terraform apply` are outside the demonstrated scope.

## Architecture

![AWS architecture](diagrams/architecture.png)

```text
Internet
   |
   v
Application Load Balancer :80
   |
   v
Web EC2 :3000 — Docker / Node.js — Private subnet
   |
   v
API EC2 :3001 — Docker / Node.js — Private subnet
   |
   +--> Amazon S3
   |
   +--> Inter-Region VPC Peering --> Tokyo Minutes Analytics API

Test client --> OpenVPN Access Server on EC2 --> Private resources
Administrator --> Systems Manager Session Manager --> Private EC2
                  (EC2 connectivity through VPC endpoints)

S3 JSON upload --> Lambda --> CloudWatch Logs
EventBridge Scheduler --> Lambda --> CloudWatch Logs
CloudTrail --> CloudWatch Logs --> Metric filter --> CloudWatch Alarm
```

The primary application environment runs in Osaka (`ap-northeast-3`). It connects to a separate Minutes Analytics API in Tokyo (`ap-northeast-1`) using private IP addresses over VPC peering.

This is a cross-region connectivity demonstration. It does not demonstrate automated regional failover or a disaster recovery solution.

## Network Design

| Location | Network | Purpose |
|---|---|---|
| Osaka | `10.10.0.0/16` | Primary application VPC |
| Osaka | `10.10.0.0/20`, `10.10.16.0/20` | Public subnets |
| Osaka | `10.10.128.0/20`, `10.10.144.0/20` | Private subnets |
| Tokyo | `10.0.0.0/24` | Minutes Analytics VPC |

The Osaka public and private subnets span two Availability Zones. Web and API EC2 instances are placed in private subnets, with external web traffic entering through the Application Load Balancer.

Non-overlapping VPC CIDRs, routes on both sides and security group rules support cross-region communication. Subnets across two Availability Zones alone do not establish application high availability; this project does not claim tested automatic application failover.

## Containerised Web and API Services

- Node.js web and API applications run in Docker containers on EC2.
- Separate Amazon ECR repositories hold the web and API images.
- The ALB forwards HTTP requests to the web service on port `3000`.
- The web service communicates with the API on port `3001`.
- The API accesses S3 and the Tokyo Minutes Analytics API.

Security groups control the intended traffic paths: ALB to web, and web to API. The application instances are not directly exposed to the internet.

## Private AWS Service Access

Private EC2 instances use the following VPC endpoints:

| Service | Endpoint type |
|---|---|
| Systems Manager (`ssm`) | Interface |
| Systems Manager Messages (`ssmmessages`) | Interface |
| ECR API (`ecr.api`) | Interface |
| ECR Docker Registry (`ecr.dkr`) | Interface |
| S3 | Gateway |

These endpoints provide private access to the AWS services used by the environment. They do not provide general internet access for arbitrary package repositories or external APIs.

A NAT Gateway was used temporarily during software installation and removed after the required endpoint paths were established. This removed the ongoing NAT Gateway dependency for those paths. No measured net cost reduction is claimed; interface endpoints also incur charges.

## Operational Access and Security

I used Systems Manager Session Manager to administer EC2 without exposing SSH port `22` to the internet. Instance IAM roles and the required VPC endpoints support this access.

OpenVPN Access Server on EC2 provides a separate test-client access path to private resources. I tested access to the private web and API services after connecting to the VPN. This models internal-user access rather than an actual employee deployment.

Security measures documented for this project include:

- Private subnet placement for web and API instances.
- Security group rules based on required communication paths.
- IAM roles for AWS service access.
- S3 Block Public Access and EC2 IMDSv2.
- CloudTrail for AWS API activity auditing.
- A dedicated assumed-role profile for Terraform, rather than root-account credentials.

The current documented ALB listener uses HTTP on port `80`. HTTPS with AWS Certificate Manager and further IAM least-privilege refinement are planned improvements.

## Event-Driven Processing

I built and tested two Lambda invocation paths:

1. A JSON file upload to S3 triggers Lambda, with execution logs in CloudWatch Logs.
2. EventBridge Scheduler invokes Lambda on a schedule, with execution logs in CloudWatch Logs.

I also tested an Osaka Lambda function accessing the Tokyo Minutes Analytics API through VPC peering.

## Monitoring and Audit

CloudWatch provides logs and alarms, while CloudTrail records AWS API activity. The project includes monitoring for security group changes through the following path:

```text
AWS API operation
  --> CloudTrail
  --> CloudWatch Logs
  --> Metric filter
  --> CloudWatch Alarm
```

This demonstrates an audit and monitoring workflow. It does not claim production incident response coverage or a service-level agreement.

## Terraform: Completed Work and Boundaries

The live environment was built with the AWS Console and CLI before the Terraform configuration was written.

Terraform configuration covers major resources such as VPCs, subnets, route tables, security groups, VPC endpoints, the ALB and target group, S3, ECR and VPC peering. These definitions should not be treated as proof of a fully reproducible deployment. EC2, Lambda and EventBridge Scheduler were built and tested using the AWS Console and CLI; their Terraform resource definitions are not included in the published configuration.

| Activity | Demonstrated scope |
|---|---|
| Build and test the AWS environment using Console/CLI | Completed as a personal project |
| Define major resources in Terraform | Completed |
| `terraform init` | Completed, as recorded in the original project documentation |
| `terraform validate` | Completed, as recorded in the original project documentation |
| Plan import of existing resources | Design stage only |
| Execute imports and migrate resources into Terraform state | Not demonstrated |
| Verify a no-change plan against the live environment | Not demonstrated |
| Provision a fresh environment with `terraform apply` | Not demonstrated |

`terraform validate` checks configuration validity; it does not prove that an apply will succeed or that the configuration matches deployed resources. These validation results describe the original project work and were not rerun for this English documentation update.

Import planning remains a design activity rather than a completed migration. Executable import mappings are not included in the published configuration.

Next steps are to document resource-to-address mappings, review an import plan, perform controlled imports and inspect the resulting plan for unintended changes. A separate future project will demonstrate provisioning from scratch.

## Cost Awareness

This is a learning and validation environment. I removed the temporary NAT Gateway and stop EC2 instances when they are not needed for testing.

Stopping EC2 does not eliminate all costs: EBS volumes, ALBs, interface endpoints and other retained resources can continue to incur charges. The project does not publish a quantified savings figure.

## Repository Guide

```text
aws-multiregion-infrastructure-portfolio/
├── README.md
├── .gitignore
├── diagrams/
│   └── architecture.png
└── terraform/
    ├── .terraform.lock.hcl
    ├── alb.tf
    ├── ecr.tf
    ├── endpoints.tf
    ├── network.tf
    ├── peering.tf
    ├── providers.tf
    ├── s3.tf
    ├── security_groups.tf
    ├── variables.tf
    └── versions.tf
```

Terraform state, credentials, private keys and VPN profiles are excluded from version control. The Terraform configuration refers to an environment-specific AWS profile and existing resources; it is not a ready-to-apply deployment template.

## Skills Practised

- VPC addressing, subnet separation, routing and security groups.
- ALB integration with private EC2 application services.
- Docker, Node.js and ECR image management.
- SSM administration and private AWS service access.
- Inter-Region VPC peering and VPN connectivity.
- S3 events, Lambda and EventBridge Scheduler.
- CloudWatch logging and CloudTrail auditing.
- Terraform configuration, initialisation, validation and import planning.
- GitHub feature branches, pull requests and merges.

## Planned Improvements

- HTTPS with AWS Certificate Manager and DNS with Route 53.
- CI/CD using GitHub Actions.
- A Terraform remote state backend.
- Further IAM least-privilege refinement.
- Controlled import of existing infrastructure into Terraform state.
- A separate infrastructure project provisioned from scratch with Terraform.

## Project Purpose

I created this portfolio to develop practical AWS infrastructure skills and explain the reasoning behind networking, access, operations and automation decisions. I am interested in discussing AWS infrastructure and cloud support opportunities with Australian and international remote teams.

[View the GitHub repository](https://github.com/mika-it-labs/aws-multiregion-infrastructure-portfolio)
