resource "aws_efs_file_system" "mongo-db" {
  throughput_mode = "elastic"

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  lifecycle_policy {
    transition_to_archive = "AFTER_90_DAYS"
  }

  tags = {
    Name = "mongo-db"
  }
}

resource "aws_efs_mount_target" "mongo-db-mt-1" {
  file_system_id  = aws_efs_file_system.mongo-db.id
  subnet_id       = aws_subnet.private-subnet-1.id
  security_groups = [aws_security_group.efs-sg.id]
}

resource "aws_efs_mount_target" "mongo-db-mt-2" {
  file_system_id  = aws_efs_file_system.mongo-db.id
  subnet_id       = aws_subnet.private-subnet-2.id
  security_groups = [aws_security_group.efs-sg.id]
}