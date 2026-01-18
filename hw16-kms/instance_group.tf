data "local_file" "ssh_key" {
  filename = pathexpand(var.ssh_pubkey_path)
}

locals {
  # Публичная ссылка на объект в Object Storage (будет открываться из браузера)
  picture_url = "https://storage.yandexcloud.net/${yandex_storage_bucket.bucket.bucket}/${yandex_storage_object.picture.key}"

  user_data = <<-EOF
  #cloud-config
  runcmd:
    - bash -lc 'cat > /var/www/html/index.html <<HTML
      <html>
      <head><title>CLO02 LAMP IG</title></head>
      <body>
        <h1>Instance Group работает</h1>
        <p>Картинка из Object Storage:</p>
        <img src="${local.picture_url}" width="600" />
      </body>
      </html>
      HTML'
  EOF
}

resource "yandex_compute_instance_group" "ig" {
  name               = "clo02-ig"
  service_account_id = yandex_iam_service_account.sa.id

  instance_template {
    platform_id = "standard-v1"

    resources {
      cores  = 2
      memory = 2
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = var.lamp_image_id
        size     = 10
      }
    }

    network_interface {
      network_id         = yandex_vpc_network.vpc.id
      subnet_ids         = [yandex_vpc_subnet.public.id]
      security_group_ids = [yandex_vpc_security_group.web_sg.id]
      nat                = true
    }

    metadata = {
      ssh-keys  = "${var.ssh_user}:${trimspace(data.local_file.ssh_key.content)}"
      user-data = local.user_data
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = [var.yc_zone]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }

  # Интеграция с NLB: IG создаст target group сам :contentReference[oaicite:8]{index=8}
  load_balancer {
    target_group_name        = "clo02-tg"
    target_group_description = "Target group for NLB"
  }
}
