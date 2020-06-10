resource "aws_instance" "${var.instance_name}" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  vpc_security_group_ids = "${var.vpc_security_group_ids}" 
