resource "aws_db_instance" "app-db" {
  identifier = "app-rds"
  allocated_storage = 1024
  engine = "mysql"
  engine_version = "5.6.22"
  instance_class = "db.m3.xlarge"
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
  backup_window = "07:00-07:30"
  maintenance_window = "Tue:07:30-Tue:08:00"
  apply_immediately = true
}

resource "aws_db_instance" "app-db-read" {
  identifier = "app-rds-read"
  allocated_storage = "${aws_db_instance.app-db.allocated_storage}"
  engine = "mysql"
  engine_version = "5.6.22"
  instance_class = "db.m3.medium"
  parameter_group_name = "default.mysql5.6"
  storage_type = "gp2"
  publicly_accessible = false
  storage_encrypted = true
  vpc_security_group_ids = ["${aws_security_group.data1.id}"]
  db_subnet_group_name = "app"
  name = "${lookup(var.db, "name")}"
  username = "${lookup(var.db, "username")}"
  password = "${lookup(var.db, "password")}"
  replicate_source_db = "${aws_db_instance.app-db.id}"
  maintenance_window = "Mon:07:00-Mon:07:30"
  backup_window = "07:30-08:00"
}
