## creating EKS clusterwith mixed instances(on-demand and SPOT)
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = local.cluster_name
  cluster_version = "1.18"
  subnets         = module.vpc.public_subnets

  tags = {
    sre_candidate = "Ali Faraz Rizvi"
  }

  vpc_id = module.vpc.vpc_id

  workers_group_defaults = {
    root_volume_type = "gp2"
  }
  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "t2.small"
      subnets                       = module.vpc.public_subnets
      asg_max_size                  = 4
      asg_desired_capacity          = 2
      asg_min_size                  = 2
      on_demand_base_capacity       = 0
      on_demand_percentage_above_base_capacity = 25
      spot_price                    = "0.20"

    }
  ]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.9"
}
