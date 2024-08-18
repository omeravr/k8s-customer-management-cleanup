variable "region" {
  description = "AWS region"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = ""
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "VPC ID for the EKS cluster"
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "Subnets for the EKS cluster"
  type        = list(string)
  default     = []
}

variable "instance_types" {
  description = "Instance types for the EKS node group"
  type        = list(string)
  default     = []
}

variable "lb_subnet_ids" {
  description = "Subnets for the Load Balancer"
  type        = list(string)
}

variable "lb_internal" {
  description = "Whether the Load Balancer should be internal"
  type        = bool
  default     = false
}

