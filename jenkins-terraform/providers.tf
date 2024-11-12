terraform {
    backend "s3" {
        bucket         = "yasmin-jenkins-terraform-state"
        key            = "checkpoint-home-exam/terraform.tfstate"
        region         = "us-east-1"
        dynamodb_table = "yasmin-jenkins-terraform-state-lock"
        encrypt        = true
    }

    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
        }
    }
}

provider "aws" {
    region = var.region
    default_tags {
        tags = var.tags
    }
}