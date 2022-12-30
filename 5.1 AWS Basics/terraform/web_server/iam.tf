resource "aws_iam_role" "role" {
  name               = "s3-role-${var.project}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": ["ec2.amazonaws.com"]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

}

resource "aws_iam_policy" "policy" {
  name        = "s3_access_policy"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid" : "AllowS3CRUDAccess",
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        "Resource" : [
        for s in local.bucket_list_mod_merged: s
        ]
      },
      {
        "Sid" : "AllowS3ListAndGetAllBuckets",
        "Effect" : "Allow",
        "Action" : [
          "s3:ListAllMyBuckets",
          "s3:GetBucketLocation"
        ],
        "Resource" : [
          "arn:aws:s3:::*"
        ]
      }
    ]
  })

}

resource "aws_iam_policy_attachment" "attach" {
  name       = "attach-role-s3-${var.project}"
  roles      = [aws_iam_role.role.name]
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_instance_profile" "profile" {
  name = "instance-profile-${var.project}"
  role = aws_iam_role.role.name
}
