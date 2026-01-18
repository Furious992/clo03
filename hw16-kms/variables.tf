variable "yc_token" {
  type      = string
  sensitive = true
}

variable "yc_cloud_id" {
  type = string
}

variable "yc_folder_id" {
  type = string
}

variable "yc_zone" {
  type    = string
  default = "ru-central1-a"
}

variable "vpc_cidr_public" {
  type    = string
  default = "192.168.10.0/24"
}

variable "lamp_image_id" {
  type    = string
  default = "fd827b91d99psvq5fjit"
}

variable "ssh_user" {
  type    = string
  default = "ubuntu"
}

variable "ssh_pubkey_path" {
  type    = string
  default = "~/.ssh/id_ed25519.pub"
}

variable "bucket_name" {
  type        = string
  description = "Object Storage bucket name (must be globally unique)"
}
