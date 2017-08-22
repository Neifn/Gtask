# Creating lauch configuration resource in aws to configure our instance
resource "aws_launch_configuration" "web_server" {
  name                        = "web_server"
  image_id                    = "${var.web_server_ami}"
  instance_type               = "${var.web_server_instance_type}"
  security_groups             = ["${aws_security_group.web_server_security.id}"]
  key_name                    = "${var.web_server_key_name}"
  associate_public_ip_address = true
#  user_data                   = "${data.template_file.userdata_web_server.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

# Creating ELB for autoscaling group
resource "aws_elb" "web_server_elb" {
  subnets             = ["${aws_subnet.eu-west-1a-public.id}"]
  security_groups     = ["${aws_security_group.elb_security.id}"]
  idle_timeout        = 300
  listener {
    instance_port     = 80
    instance_protocol = "tcp"
    lb_port           = 80
    lb_protocol       = "tcp"
  }
  health_check {
    healthy_threshold   = 4
    unhealthy_threshold = 4
    timeout             = 5
    target              = "tcp:80"
    interval            = 30
  }
}

# Creating autoscaling policy 
resource "aws_autoscaling_policy" "cpu_scaling" {
  name                   = "simple_scaling_policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.web_server_scaling.name}"
}

# Creating alarm for autoscaling policy
resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "web_server_alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Maximum"
  threshold           = "80"
  alarm_actions       = ["${aws_autoscaling_policy.cpu_scaling.arn}"]
}

# Creating autoscalling group resource in aws which will use our launch configuration and create specified instance
resource "aws_autoscaling_group" "web_server_scaling" {
  name                      = "web_server_scaling"
  launch_configuration      = "${aws_launch_configuration.web_server.name}"
  min_size                  = "${var.web_server_scaling_min_capacity}"
  max_size                  = "${var.web_server_scaling_max_capacity}"
  vpc_zone_identifier       = ["${aws_subnet.eu-west-1a-public.id}"]
  load_balancers            = ["${aws_elb.web_server_elb.name}"]
  health_check_grace_period = 300
  health_check_type         = "ELB"
  tags = [ 
    {
      key                 = "Name"
      value               = "web_server"
      propagate_at_launch = true
    },
  ]

  lifecycle {
    create_before_destroy = true
  }
}
