dependencies {
  paths = ["../1_rke", "../3_install_rancher"]
}
retryable_errors = [
  "(?s).*Rancher is not ready.*",
  "(?s).*Connecting with user/pass: Bad response statusCode [403].*"
]
