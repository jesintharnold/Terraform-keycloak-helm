provider "azurerm" {
  features {}
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
#create a namespaces required
resource "kubernetes_namespace" "Ingress-namespace" {
  count = length(var.namespace_aks)
  metadata {
    name = element(var.namespace_aks,count.index)
  }
}

#create and install certficates in specific namespaces

resource "kubernetes_secret" "keycloak-certs" {
  metadata {
    name = "keycloak-tls"
    namespace = element(var.namespace_aks,1)
  }

    data = {
      tls.crt = file("${path.module}/certs/keycloak/tls.crt")
      tls.key = file("${path.module}/certs/keycloak/tls.key")
    }

  type = "kubernetes.io/tls"
}


resource "kubernetes_secret" "keycloak-generic-ssl" {
  metadata {
    name = "ssl"
    namespace = element(var.namespace_aks,1)
  }

    data = {
      tls.crt = file("${path.module}/certs/keycloak/tls.crt")
      tls.key = file("${path.module}/certs/keycloak/tls.key")
    }
    
  type = "Opaque"
}

resource "kubernetes_secret" "keycloak-sql-secret" {
  metadata {
    name = "kc-mssql-user"
    namespace = element(var.namespace_aks,1)
  }

    data = {
      mssql-username = var.keycloak_db_user_secret["username"]
      mssql-password = var.keycloak_db_user_secret["password"]
    }
    
  type = "Opaque"
}

# Now Install Ingress-controller