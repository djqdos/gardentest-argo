check "health_check" {
  data "http" "terraform_io" {
    url = "https://web.gardentest.dev"
  }

  assert {
    condition     = data.http.terraform_io.status_code == 200
    error_message = "${data.http.terraform_io.url} returned an unhealthy status code"
  }
}
