# Подключаем провайдер Google Cloud
# Здесь указываем путь к JSON-ключу сервисного аккаунта, который имеет права создавать проекты
provider "google" {
  credentials = file("C:/Users/D/Desktop/GCP/secrets/terraform-sa.json")
}

# Создаём новый проект в GCP
resource "google_project" "demo_project" {
  # Человекочитаемое имя проекта
  name            = "Demo Data Engineering Project"
  
  # Уникальный идентификатор проекта (используется в API и ресурсах)
  project_id      = var.project_id
  
  # ID организации, внутри которой создаётся проект
  org_id          = var.org_id
  
  # ID биллингового аккаунта, чтобы проект мог использовать платные ресурсы
  billing_account = var.billing_account
}

# Назначаем владельца (админа) проекта
resource "google_project_iam_member" "owner" {
  # Привязываем IAM-политику к созданному проекту
  project = google_project.demo_project.project_id
  
  # Роль "roles/owner" даёт полный доступ к управлению проектом
  role    = "roles/owner"
  
  # Указываем пользователя или сервисный аккаунт, который будет владельцем
  member  = "user:dmitry@example.com"
}
# Включаем API BigQuery
resource "google_project_service" "bigquery_api" {
  project = var.project_id
  service = "bigquery.googleapis.com"
}

# Включаем API Cloud Storage
resource "google_project_service" "storage_api" {
  project = var.project_id
  service = "storage.googleapis.com"
}
# Создаём dataset для экспорта данных из Google Analytics 4
resource "google_bigquery_dataset" "ga4_export" {
  dataset_id                 = "ga4_export"       # имя датасета
  location                   = var.region         # регион, например europe-west1
  project                    = var.project_id     # проект, куда создаётся датасет
  delete_contents_on_destroy = true               # при удалении датасета удаляются все таблицы

  # Зависимость: сначала включаем BigQuery API
  depends_on = [google_project_service.bigquery_api]
}
# Создаём bucket для хранения данных
resource "google_storage_bucket" "raw_data" {
  name     = "\-raw-data"   # имя bucket формируется из project_id
  location = var.region                      # регион, например europe-west1
  uniform_bucket_level_access = true         # единый уровень доступа
  depends_on = [google_project_service.storage_api] # сначала включаем API
}

# Загружаем файл в bucket
resource "google_storage_bucket_object" "sample_file" {
  name   = "sample.txt"                                # имя файла в bucket
  bucket = google_storage_bucket.raw_data.name         # bucket куда кладём
  source = "C:/Users/D/Desktop/GCP/files/sample.txt"   # путь к локальному файлу
}
