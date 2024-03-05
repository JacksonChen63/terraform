resource "kubernetes_cluster_role" "this" {
  metadata {
    name = "${var.service_account}-cluster-role"
  }

  rule {
    api_groups = ["*"]
    resources  = ["deployments", "pods/*", "services", "secrets", "networkpolicies.networking.k8s.io", "pods", "horizontalpodautoscalers", "ingresses", "replicasets"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "apply", "delete"]
  }
}

resource "kubernetes_service_account_v1" "this" {
  metadata {
    name = "${var.service_account}-sa"
  }
  secret {
    name = "${var.service_account}-secret"
  }
}

resource "kubernetes_secret_v1" "this" {
  metadata {
    name = "${kubernetes_service_account_v1.this.metadata[0].name}-secret"
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account_v1.this.metadata[0].name
    }
    generate_name = "${kubernetes_service_account_v1.this.metadata[0].name}-secret"

  }
  type = "kubernetes.io/service-account-token"

  wait_for_service_account_token = true
}

resource "kubernetes_cluster_role_binding" "this" {
  metadata {
    name = "${var.service_account}-cluster-role-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.this.metadata.0.name
  }
  subject {
    kind      = "User"
    name      = "admin"
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.this.metadata.0.name
    namespace = kubernetes_service_account_v1.this.metadata.0.namespace
  }
  subject {
    kind      = "Group"
    name      = "system:masters"
    api_group = "rbac.authorization.k8s.io"
  }
}

