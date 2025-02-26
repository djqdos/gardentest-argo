resource "helm_release" "argocd" {
	name = "argocd"

  repository = "https://argoproj.github.io/argo-helm"
  chart = "argo-cd"
  namespace = "argocd"
  create_namespace = true
  version = "7.7.12"

  values = [file("./modules/argocd/argocd-values.yml")]
}
