resource "aws_db_instance" "app-db" {
  identifier = "app-rds"
  allocated_storage = 10
  engine = "mysql"
  engine_version = "5.6.22"
  instance_class = "db.m3.medium"
  parameter_group_name = "default.mysql5.6"
  storage_type = "gp2"
  backup_retention_period = 30
  multi_az = true
  publicly_accessible = false
  storage_encrypted = true
  vpc_security_group_ids = ["${aws_security_group.data1.id}"]
  db_subnet_group_name = "app"
  name = "${lookup(var.db, "name")}"
  username = "${lookup(var.db, "username")}"
  password = "${lookup(var.db, "password")}"
}
