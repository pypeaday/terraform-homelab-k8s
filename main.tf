module "kind" {
  source = "./kind"

  traefik_external_ips = ["192.168.1.143"]

}
