output "bucket_name" {
  value = google_storage_bucket.raw_data.name
}

output "dataset_id" {
  value = google_bigquery_dataset.analytics.dataset_id
}

output "pubsub_topic" {
  value = google_pubsub_topic.etl_trigger.name
}
# Выводим статус включённых API
output "bigquery_api_enabled" {
  value = google_project_service.bigquery_api.service
}

output "storage_api_enabled" {
  value = google_project_service.storage_api.service
}
# Выводим имя датасета GA4 после создания
output "ga4_dataset_id" {
  value = google_bigquery_dataset.ga4_export.dataset_id
}
# Выводим имя bucket
output "bucket_name" {
  value = google_storage_bucket.raw_data.name
}

# Выводим имя файла в bucket
output "uploaded_file" {
  value = google_storage_bucket_object.sample_file.name
}
