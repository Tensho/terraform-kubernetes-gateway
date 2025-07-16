resource "google_compute_global_address" "default" {
  name = "test"
}

resource "google_certificate_manager_certificate_map" "default" {
  name = "test"
}

resource "google_compute_ssl_policy" "default" {
  name = "test"
}