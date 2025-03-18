terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = "langgraph-031825"
  region  = "us-east5"
}

# Enable required APIs
resource "google_project_service" "vertex_ai" {
  project = "langgraph-031825"
  service = "aiplatform.googleapis.com"
}

resource "google_project_service" "iam" {
  project = "langgraph-031825"
  service = "iam.googleapis.com"
}

# Create service account
resource "google_service_account" "langgraph_service_account" {
  account_id   = "langgraph-service-account"
  display_name = "LangGraph Service Account"
  project      = "langgraph-031825"
}

# Grant necessary roles
resource "google_project_iam_member" "vertex_ai_user" {
  project = "langgraph-031825"
  role    = "roles/aiplatform.user"
  member  = "serviceAccount:${google_service_account.langgraph_service_account.email}"
}

resource "google_project_iam_member" "service_account_user" {
  project = "langgraph-031825"
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.langgraph_service_account.email}"
}

# Create and download service account key
resource "google_service_account_key" "langgraph_key" {
  service_account_id = google_service_account.langgraph_service_account.name
}

# Save the key to a file
resource "local_file" "service_account_key" {
  content  = base64decode(google_service_account_key.langgraph_key.private_key)
  filename = "${path.module}/service-account-key.json"
} 