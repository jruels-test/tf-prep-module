variable "team" {
  type = string
}

output "tags" {
  value = {
    team       = var.team
    managed_by = "terraform"
  }
}
