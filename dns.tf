resource "aws_route53_zone" "primary" {
  name="${var.aws_dns_zone}"
}

resource "aws_route53_record" "www" {
  zone_id = "${aws_route53_zone.primary.zone_id}"
  name="www.${var.aws_dns_zone}"
  type="CNAME"
  ttl="300"
  records=["${aws_elb.app-external.dns_name}"]
}

resource "aws_route53_record" "admin" {
  zone_id = "${aws_route53_zone.primary.zone_id}"
  name="admin.${var.aws_dns_zone}"
  type="CNAME"
  ttl="300"
  records=["${aws_instance.app_admin_001.private_ip}"]
}
