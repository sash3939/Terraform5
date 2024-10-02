terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=0.13"
  backend "s3" {
 endpoint = "storage.yandexcloud.net"
 bucket = "tfstate-my"
 region = "ru-central1"
 key = "terraform.tfstate"
 
 skip_region_validation = true
 skip_credentials_validation = true

  dynamodb_endpoint = "https://docapi.serverless.yandexcloud.net/ru-central1/b1gus312hmbm3drr7i2s/etnfg5p16khh6mtv56rv"
 dynamodb_table = "tfstate-dev"
 }
}

provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.default_zone
}

#enable module
module "vpc_dev" {
  source       = "./vpc"
  zone = "ru-central1-a"
  cidr = "10.0.1.0/24"
  env_name = "develop"
}

module "test-vm" {
  source          = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name        = "develop"
  network_id      = module.vpc_dev.network_id
  subnet_zones    = ["ru-central1-a"]
  subnet_ids      = [module.vpc_dev.subnet_id]
  instance_name   = "web"
  instance_count  = 2
  image_family    = "ubuntu-2004-lts"
  public_ip       = true
  
  metadata = {
      user-data          = data.template_file.cloudinit.rendered #Для демонстрации №3
      serial-port-enable = 1
  }

}

#Пример передачи cloud-config в ВМ для демонстрации №3
data "template_file" "cloudinit" {
 template = file("./cloud-init.yml")
 vars     = {
    ssh-authorized-keys = file(var.ssh-authorized-keys[0])
  }
}

