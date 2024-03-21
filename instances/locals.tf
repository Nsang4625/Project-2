locals {
  web_servers = {
    server_1 = {
      machine_type = "t3.micro"
      subnet_id    = var.first_web_subnet_id
    }
    server_2 = {
      machine_type = "t3.micro"
      subnet_id    = var.second_web_subnet_id
    }
  }
}
