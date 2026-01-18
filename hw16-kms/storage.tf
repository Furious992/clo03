resource "yandex_storage_bucket" "bucket" {
  bucket = var.bucket_name
  folder_id = var.yc_folder_id

  # Публичный доступ только на чтение объекта (листинг запрещён)
  anonymous_access_flags {
    read        = true
    list        = false
    config_read = false
  }

  # Шифрование бакета ключом KMS
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.bucket_key.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "yandex_storage_object" "picture" {
  bucket = yandex_storage_bucket.bucket.bucket
  key    = "pic.png"
  source = "${path.module}/files/pic.png"
}
