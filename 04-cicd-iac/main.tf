terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }
}

resource "local_file" "devops_config" {
  content  = "environment = production\nregion = ap-southeast-1\n"
  filename = "${path.module}/env_config.txt"
}
