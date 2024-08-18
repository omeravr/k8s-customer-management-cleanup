provider "aws" {
  region = var.region
}

module "eks_al2" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  enable_cluster_creator_admin_permissions = true

  # EKS Addons
  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  vpc_id    = var.vpc_id
  subnet_ids = var.subnet_ids

  eks_managed_node_groups = {
    example = {
      ami_type       = "AL2_x86_64"
      instance_types = var.instance_types
      min_size       = 2
      max_size       = 5
      desired_size   = 2
    }
  }

  tags = {
    Example    = "ex-eks-mng"
    GithubRepo = "terraform-aws-eks"
    GithubOrg  = "terraform-aws-modules"
  }
}

resource "aws_security_group_rule" "allow_all_inbound" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.eks_al2.cluster_security_group_id
}

resource "aws_security_group_rule" "node_sg_allow_all_traffic" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.eks_al2.node_security_group_id
}

resource "aws_security_group_rule" "node_sg_allow_tcp_all" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.eks_al2.node_security_group_id
}

resource "aws_lb" "network_lb" {
  name               = "eks-nlb"
  internal           = var.lb_internal
  load_balancer_type = "network"
  subnets            = var.subnet_ids

  tags = {
    Name = "eks-nlb"
  }
}

resource "aws_lb_target_group" "nlb_target_group" {
  name        = "eks-nlb-tg"
  port        = 80
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    protocol            = "TCP"
  }

  tags = {
    Name = "eks-nlb-tg"
  }
}

resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.network_lb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_target_group.arn
  }
}

