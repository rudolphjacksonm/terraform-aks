resource "kubernetes_secret" "mysql" {
  metadata {
    name = "mysqlfqdn"
  }

  data {
    "mysql_fqdn" = "${var.mysql_fqdn}"
  }

  type = "kubernetes.io/opaque"
}
