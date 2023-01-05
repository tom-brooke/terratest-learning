resource "aws_s3_bucket" "terratest" {
  bucket = "tom-test-bucket-12341234-${var.env}"
  versioning {
    enabled = false
  }
}

# resource "aws_s3_bucket_versioning" "terratest" {
#   bucket = aws_s3_bucket.terratest.id
#   versioning_configuration {
#     status = "Disabled"
#   }
# }

resource "aws_s3_bucket_acl" "terratest" {
  bucket = aws_s3_bucket.terratest.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "terratest" {
  bucket = aws_s3_bucket.terratest.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "terratest" {
  bucket = aws_s3_bucket.terratest.id
  policy = data.aws_iam_policy_document.deny_non_secure_transport.json
}

data "aws_iam_policy_document" "deny_non_secure_transport" {
  statement {
    sid    = "DenyNonSecureTransport"
    effect = "Deny"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = ["s3:*"]
    resources = [
      "${aws_s3_bucket.terratest.arn}/*",
      "${aws_s3_bucket.terratest.arn}"
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}
