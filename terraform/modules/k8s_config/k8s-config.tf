resource "kubernetes_secret" "mysql" {
  metadata {
    name = "mysqldsn"
  }

  data {
    "DSN" = "${var.mysql_dsn}"
  }

  type = "kubernetes.io/opaque"
}