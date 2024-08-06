variable "namespace_aks" {
  type = list(string)
  default = [ "ingress-nginx","keycloak","dev" ]
}

variable "keycloak_db_user_secret" {
  description = "Keycloak DB username and password"
  type = map(string)
  default = {
    "username" = "KEYCLOAKUSERNAME"
    "password" = "KEYCLOAKPASSWORD"
  }
}