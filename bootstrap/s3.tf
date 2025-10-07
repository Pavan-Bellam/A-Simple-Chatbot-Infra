resource "aws_s3_bucket" "bucket" {
    bucket = "a-simple-chatbot-terraform-state-bucket"
}

resource "aws_s3_bucket_versioning" "versioning" {
    bucket = aws_s3_bucket.bucket.id
    versioning_configuration {
        status = "Enabled"
    }
}