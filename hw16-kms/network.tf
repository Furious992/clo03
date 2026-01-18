resource "yandex_vpc_network" "vpc" {
  name = "clo02-vpc"
}

resource "yandex_vpc_subnet" "public" {
  name           = "clo02-public"
  zone           = var.yc_zone
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = [var.vpc_cidr_public]
}

resource "yandex_vpc_security_group" "web_sg" {
  name       = "clo02-web-sg"
  network_id = yandex_vpc_network.vpc.id

  # входящий HTTP
  ingress {
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # входящий SSH (для проверки, если нужно)
  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # healthcheck ICMP (не обязательно, но удобно)
  ingress {
    protocol       = "ICMP"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # исходящий доступ в интернет
  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
