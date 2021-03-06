resource "aws_elb" "app1-external" {
  name = "app1-external"

  listener = {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400
  internal = false

  security_groups = ["${aws_security_group.elb1.id}"]
  subnets = ["${aws_subnet.elb1.0.id}"]
  instances = ["${aws_instance.varnish_001.id}"]
}

resource "aws_elb" "app1-internal" {
  name = "app1-internal"

  listener = {
    instance_port = 8001
    instance_protocol = "http"
    lb_port = 8001
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/health-check"
    interval = 30
  }

  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400
  internal = true

  security_groups = ["${aws_security_group.app-internal-elb.id}"]
  subnets = ["${aws_subnet.elb1.1.id}"]
  instances = ["${aws_instance.wordpress_001.id}","${aws_instance.wordpress_002.id}"]
}
