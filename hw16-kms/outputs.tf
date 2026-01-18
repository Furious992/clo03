output "bucket_name" {
  value = yandex_storage_bucket.bucket.bucket
}

output "picture_url" {
  value = "https://storage.yandexcloud.net/${yandex_storage_bucket.bucket.bucket}/${yandex_storage_object.picture.key}"
}

# listener/external_address_spec = set → вытаскиваем адрес через for/flatten
output "nlb_public_ip" {
  value = one(flatten([
    for l in yandex_lb_network_load_balancer.nlb.listener : [
      for e in l.external_address_spec : e.address
    ]
  ]))
}
