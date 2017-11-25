resource "aws_instance" "monitored-instance" {
  ami = "${var.ec2_cloudwatch_ami}"
  instance_type = "${var.ec2_cloudwatch_instance_size}"
  key_name = "${var.ssh_key_name}"
  vpc_security_group_ids = ["${aws_security_group.monitored-instance.id}"]
  subnet_id = "${module.vpc.public_subnets[0]}"
  user_data = "${file("files/ec2-cloudwatch.sh")}"
  iam_instance_profile = "${aws_iam_instance_profile.ec2-cloudwatch-test-profile.id}"
  associate_public_ip_address = true
  source_dest_check = false
  #lifecycle {
  #  ignore_changes = ["user_data"]
  #}

    tags {
        Name = "EC2 cloudwatch test"
        "Terraform" = "true"
        "Environment" = "${var.environment}" 
    }
}

module "cloudwatch" {
  source = "./modules/cloudwatch/"
  cpu_utilization_check = "${module.aws_cloudwatch_metric_alarm.cpu_utilization_check}"
}


 resource "aws_security_group" "monitored_instance_test" {
   name   = "${var.cluster_name}-monitored_instance-test-SG"
   vpc_id = "${module.vpc.vpc_id}"
   tags = {
     "Terraform" = "true"
     "Role" = "Ops Utility security group"
     "Environment" = "${var.cluster_name}"
     "Name" = "${var.cluster_name}-monitored_instance-test-SG"
   }
   lifecycle {
     create_before_destroy = true
   }
 }

 resource "aws_security_group_rule" "allow_server_monitored_instance_inbound" {
   type              = "ingress"
   security_group_id = "${aws_security_group.monitored_instance_test.id}"

   from_port   = 22
   to_port     = 22
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }

 resource "aws_security_group_rule" "allow_server_monitored_instance_outbound" {
   type              = "egress"
   security_group_id = "${aws_security_group.monitored_instance_test.id}"

   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
