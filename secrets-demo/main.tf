# Starts leaky on purpose: sensitive hides the value on screen,
# but the saved plan still contains it.

variable "db_password" {
  type      = string
  sensitive = true
}

resource "terraform_data" "db" {
  input = var.db_password
}
