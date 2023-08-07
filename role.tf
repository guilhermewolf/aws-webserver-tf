resource "aws_iam_role_policy" "ec2_default_role" {
  name   = "${var.name}-ec2DefaultRole"
  role   = module.asg.iam_role_name		
  policy = data.template_file.aws_iam_role_policy_tpl.rendered
}

resource "aws_iam_role_policy" "ec2_instance_ssm_management" {
  name = "ec2SsmManagement"
  role = module.asg.iam_role_name		

  policy = data.template_file.ssm_policy.rendered
}
