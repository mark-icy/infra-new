variable "github_token" {
  sensitive = true
  type      = string
}

variable "github_org" {
  type = string
  default = "mark-icy"
}

variable "github_repository" {
  type = string
  default = "infra-new"
}
