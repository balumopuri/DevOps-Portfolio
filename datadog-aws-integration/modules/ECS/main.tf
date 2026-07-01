module "ecs_cluster" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-ecs.git//modules/cluster?ref=v1.0.0"

  cluster_name = "my-ecs-cluster"

  cluster_setting = [
    {
      name  = "containerInsights"
      value = "enabled"
    }
  ]
}
