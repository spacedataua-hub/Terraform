# Уникальный идентификатор проекта
variable "project_id" {
  type = string
}

# ID организации, внутри которой создаётся проект
variable "org_id" {
  type = string
}

# ID биллингового аккаунта, чтобы проект мог использовать платные ресурсы
variable "billing_account" {
  type = string
}
