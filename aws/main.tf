resource "aws_instance" "jackson" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  vpc_security_group_ids = ["${var.vpc_security_group_ids}"]
}
