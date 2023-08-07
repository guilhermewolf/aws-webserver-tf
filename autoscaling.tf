module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 6.10.0"

  name = "${var.name}-scale-group"

  # Launch template
  launch_template_name = "${var.name}-webserver"

  image_id            = data.aws_ami.linux_ami.id
  instance_type       = var.instance_type
  security_groups     = [module.web_server_sg.security_group_id]
  user_data           = base64encode(data.template_file.cloud_init.rendered)
  metrics_granularity = "1Minute"
  enabled_metrics     = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupTotalInstances"]
  
  # ELB
  load_balancers = [module.elb.elb_id]
  
  # IAM role & instance profile
  create_iam_instance_profile = true
  iam_role_name               = "${var.name}-role"
  iam_role_path               = "/ec2/"
  iam_role_tags = {
    CustomIamRole = "Yes"
  }

  # Auto scaling group
  vpc_zone_identifier = module.vpc.private_subnets
  health_check_type   = "ELB"
  min_size            = 1
  max_size            = 3
  desired_capacity    = 1

  tags = {
    Name = "${var.name}-webserver0"
  }

}

resource "aws_autoscaling_policy" "autoscalingpolicy" {
  name                   = "${var.name}-autoscalepolicy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = module.asg.autoscaling_group_name
}

resource "aws_autoscaling_policy" "autoscalepolicy-down" {
  name                   = "${var.name}-autoscalepolicy-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = module.asg.autoscaling_group_name
}
