variable "api_id" {
  type = "string"
  description = "REST API id"
}

variable "parent_resource_id" {
  type = "string"
  description = "Parent resource id"
}

variable "path_part" {
  type = "string"
  description = "Resource path part value"
}

variable "api_key_required" {
  default = "false"
}

variable "methods" {
  type = "list"
  description = "List of resource methods"
}

variable "origin" {
  type = "string"
  description = "Allowed CORS origin"
  default = "*"
}
