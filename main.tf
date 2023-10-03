terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "mod_jk_load_balancing_issues_in_apache_http" {
  source    = "./modules/mod_jk_load_balancing_issues_in_apache_http"

  providers = {
    shoreline = shoreline
  }
}