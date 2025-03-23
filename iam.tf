resource "google_project_iam_member" "container_admin" {
  project = var.project
  role    = "roles/container.admin"
  member  = "user:${var.service_account_email}"
}

resource "google_project_iam_member" "network_admin" {
  project = var.project
  role    = "roles/compute.networkAdmin"
  member  = "user:${var.service_account_email}"
}

resource "google_project_iam_member" "sa_user" {
  project = var.project
  role    = "roles/iam.serviceAccountUser"
  member  = "user:${var.service_account_email}"
}
