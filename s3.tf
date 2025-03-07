resource "aws_s3_bucket" "my_public_bucket" {
    bucket_prefix = "my-tf-test-bucket"
    tags = {
        Name = "public-documents"
    }
}

resource "aws_s3_object" "test_object" {
    bucket = aws_s3_bucket.my_public_bucket.id
    key = "test.txt"
    content = "Just a test file"
}

resource "aws_s3_bucket_ownership_controls" "public_access" {
  bucket = aws_s3_bucket.my_public_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
    bucket = aws_s3_bucket.my_public_bucket.id

    block_public_acls       = false
    block_public_policy     = false
    ignore_public_acls      = false
    restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "public-read-write" {
    depends_on = [
        aws_s3_bucket_ownership_controls.public_access,
        aws_s3_bucket_public_access_block.public_access,
    ]

    bucket = aws_s3_bucket.my_public_bucket.id
    acl    = "public-read-write"
}

resource "aws_s3_bucket_policy" "allow_all" {
  bucket = aws_s3_bucket.my_public_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          "${aws_s3_bucket.my_public_bucket.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_s3_bucket_cors_configuration" "cors-test" {
  bucket = aws_s3_bucket.my_public_bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST","HEAD","DELETE"]
    allowed_origins = [""]
    expose_headers  = []
    max_age_seconds = 3000
  }

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }
}