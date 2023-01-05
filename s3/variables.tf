variable "env" {
  type        = string
  description = "The environment to deploy resources to"
  default = "terratest"
}

variable "region" {
  type        = string
  description = "The AWS region to deploy resources to"
  default = "eu-west-2"
}

variable "role_arn" {
  type        = string
  description = "The deployment role to deploy with"
  default = "arn:aws:iam::637180932514:role/orion/orion-admin-user"
}
