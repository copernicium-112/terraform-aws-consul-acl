# ---------------------------------------------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  # This module is now only being tested with Terraform 1.0.x. However, to make upgrading easier, we are setting
  # 0.12.26 as the minimum version, as that version added support for required_providers with source URLs, making it
  # forwards compatible with 1.0.x code.
  required_version = ">= 0.12.26"
}

# ---------------------------------------------------------------------------------------------------------------------
# ATTACH AN IAM POLICY THAT ALLOWS THE CONSUL NODES TO AUTOMATICALLY DISCOVER EACH OTHER AND FORM A CLUSTER
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_role_policy" "auto_discover_cluster" {
  count  = var.enabled ? 1 : 0
  name   = "auto-discover-cluster"
  role   = var.iam_role_id
  policy = data.aws_iam_policy_document.auto_discover_cluster.json
}

data "aws_iam_policy_document" "auto_discover_cluster" {
  statement {
    effect = "Allow"

    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeTags",
      "autoscaling:DescribeAutoScalingGroups",
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "acl_token_cluster_ssm" {

  count = var.acl_store_type == "ssm" ? 1 : 0

  statement {
    effect = "Allow"

    actions = [ "ssm:PutParameter", "ssm:GetParameters" ]

    resources = [ "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.cluster_tag_value}/*" ]
  }
}

resource "aws_iam_role_policy" "ssm" {
  count  = var.acl_store_type == "ssm" ? 1 : 0
  name   = "ssm-cluster"
  role   = var.iam_role_id
  policy = data.aws_iam_policy_document.acl_token_cluster_ssm[0].json
}

data "aws_caller_identity" "current" {

}

data "aws_region" "current" {

}

