data "aws_ami" "ubuntu_latest" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20220308"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

data "aws_ami" "linux_ami" {
  most_recent = "true"
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.????????.?-x86_64-gp2"]
  }
}

data "template_file" "cloud_init" {
  template = file("templates/cloud_init.tpl")
  vars = {
    additional_user_data = join("\n", [data.template_file.ssm_tunnel_instance.rendered, data.template_file.webserver.rendered])
    name                 = var.name
  }
}

data "template_file" "ssm_policy" {
  template = file("templates/ssm_policy.tpl")
}

data "template_file" "ssm_tunnel_instance" {
  template = file("templates/ssm_tunnel.tpl")
}

data "template_file" "aws_iam_role_policy_tpl" {
  template = file("templates/aws_iam_role_policy.tpl")
}

data "template_file" "webserver" {
  template = file("templates/webserver.tpl")
  vars = {
    REGION = var.region
  }
}

