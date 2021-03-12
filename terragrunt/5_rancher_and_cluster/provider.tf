terraform {
  required_providers {
    rancher2 = {
      source = "rancher/rancher2"
      version = "1.12.0"
    }
  }
}

terraform {
  required_providers {
    time = {
      source = "hashicorp/time"
      version = "0.7.0"
    }
  }
}

provider "time" {
  # Configuration options
}
