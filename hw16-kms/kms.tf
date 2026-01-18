resource "yandex_kms_symmetric_key" "bucket_key" {
  name              = "clo03-bucket-key"
  description       = "Key for encrypting Object Storage bucket"
  default_algorithm = "AES_256"
  rotation_period   = "8760h" # 1 год
}
