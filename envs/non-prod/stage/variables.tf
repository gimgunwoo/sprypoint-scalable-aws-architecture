variable "env" {
  description = "The environment"
  type = string
  default = "stage"
}

variable "aws-region" {
	type        = string
	description = "AWS Region"
	default     = "ca-central-1"
}

variable "default_tags" {
	type = map(any)
	default = {
		"iac:created-with" = "terraform"
		"iac:repo"         = "sprypoint-scalable-architecture"
	}
}

variable "password" {
  type = string
  description = "Master DB instance password"
  default     = null
}

variable "replicate_source_db" {
  type        = string
  description = "Specifies that this resource is a Replicate database, and to use this value as the source database"
  default     = null
}

variable "stage_namespace" {
  type = string
  description = "CloudMap service discovery namespace"
  default = "thisisjustastage"
}