resource "aws_launch_template" "mylt" {
  name                   = "terraform-lt"
  description            = "v1"
  image_id               = "ami-0ca9fb66e076a6e32"
  instance_type          = "t2.micro"
  key_name               = "ec2"
  vpc_security_group_ids = [aws_security_group.mysg.id]
  placement {
    availability_zone = "us-east-1"
  }
}
resource "aws_elb" "myelb" {
  name            = "terraform-lb"
  subnets         = [aws_subnet.mysubnet1.id, aws_subnet.mysubnet2.id]
  security_groups = [aws_security_group.mysg.id]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}
resource "aws_autoscaling_group" "myasg" {
  name                = "terraform-asg"
  min_size            = 2
  max_size            = 6
  desired_capacity    = 2
  health_check_type   = "EC2"
  load_balancers      = [aws_elb.myelb.name]
  vpc_zone_identifier = [aws_subnet.mysubnet1.id, aws_subnet.mysubnet2.id]
  launch_template {
    id = aws_launch_template.mylt.id
  }
}








