# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "iam_role_id" {
  description = "The ID of the IAM Role to which these IAM policies should be attached"
  type        = string
}

variable "enabled" {
  description = "Give the option to disable this module if required"
  type        = bool
  default     = true
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "cluster_tag_value" {
  description = "The EC2 tag value used to identify cluster members. This is only required if you set 'acl_store_type' to 'ssm', so that the instances can write to / read from SSM parameters under the correct path."
  type        = string
  default  =  ""
}

variable "acl_store_type" {
  description = "The type of cloud store where the cluster will write / read ACL tokens. If left at the default then no related policies will be created."
  type        = string
  default     = ""
  validation {
    condition     = contains(["ssm",""],var.acl_store_type)
    error_message = "You must specify a supported store type for ACL tokens. Currently the only allowed value is 'ssm'."
  } 
} 

