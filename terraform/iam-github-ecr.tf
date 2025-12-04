resource "aws_iam_user" "github_ecr_user" {
  name = "github-ecr-retail-store"
  tags = {
    Purpose = "GitHubActionsECR"
  }
}


data "aws_iam_policy_document" "github_ecr_policy_doc" {
  statement {
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage",
      "ecr:CreateRepository",
      "ecr:DescribeRepositories"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_user_policy" "github_ecr_policy" {
  name   = "github-ecr-access"
  user   = aws_iam_user.github_ecr_user.name
  policy = data.aws_iam_policy_document.github_ecr_policy_doc.json
}


resource "aws_iam_access_key" "github_ecr_key" {
  user = aws_iam_user.github_ecr_user.name
}

output "github_ecr_access_key_id" {
  value       = aws_iam_access_key.github_ecr_key.id
  description = "GitHub ECR user access key ID"
}


output "github_ecr_secret_access_key" {
  value       = aws_iam_access_key.github_ecr_key.secret
  description = "GitHub ECR user secret access key"
  sensitive   = true
}