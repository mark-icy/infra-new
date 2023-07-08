variable "github_token" {
  sensitive = true
  type      = string
}

variable "github_org" {
  type = string
}

variable "github_repository" {
  type = string
  default = "github.com/mark-icy/infra-new"
	
}
