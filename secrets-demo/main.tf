# Fixed: ephemeral keeps the value out of plan and state.

variable "db_password" {
  type      = string
  ephemeral = true
}

resource "terraform_data" "db" {
  provisioner "local-exec" {
    command = "echo \"password received\""
    environment = {
      DB_PASSWORD = var.db_password
    }
  }
}
