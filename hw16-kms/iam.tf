resource "yandex_iam_service_account" "sa" {
  name        = "clo02-sa"
  description = "Service account for instance group + load balancer + object storage"
}

# Для instance group + интеграции с NLB нужны compute.editor и load-balancer.editor :contentReference[oaicite:3]{index=3}
resource "yandex_resourcemanager_folder_iam_member" "sa_compute_editor" {
  folder_id = var.yc_folder_id
  role      = "compute.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "sa_lb_editor" {
  folder_id = var.yc_folder_id
  role      = "load-balancer.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

# Для бакета/объектов
resource "yandex_resourcemanager_folder_iam_member" "sa_storage_editor" {
  folder_id = var.yc_folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

# Статические ключи (Access/Secret) для Object Storage :contentReference[oaicite:4]{index=4}
resource "yandex_iam_service_account_static_access_key" "sa_s3_key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "Static access key for Object Storage"
}

resource "yandex_resourcemanager_folder_iam_member" "sa_rm_viewer" {
  folder_id = var.yc_folder_id
  role      = "resource-manager.viewer"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "sa_vpc_user" {
  folder_id = var.yc_folder_id
  role      = "vpc.user"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "sa_rm_editor" {
  folder_id = var.yc_folder_id
  role      = "resource-manager.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "sa_editor" {
  folder_id = var.yc_folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "sa_kms_use" {
  folder_id = var.yc_folder_id
  role      = "kms.keys.encrypterDecrypter"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}
