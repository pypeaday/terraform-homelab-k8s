# Terraform Homelab K8s

Terraform repo to setup a local k8s cluster to homelab with

K8s provider: `kind`

Includes ArgoCD as a helm release managed with terraform

Head over to my [homelab-argocd](https://www.github.com/pypeaday/homelab-argocd) repo to see  my app of apps deployment!


# Bugs

 I don't actually need this `data` resource, but I've not been able to use terraform to create `argocd_application`s meaning I haven't been able to configure the terraform provider appropriately. I'm not planning on using terraform to create argocd applications yet, will try to stick with manifests in homelab-argocd repo, but I need to understand this network issue nonetheless

```
data.kubernetes_secret.argocd_admin: Reading...
╷
│ Error: Get "http://localhost/api/v1/namespaces/argocd/secrets/argocd-initial-admin-secret": dial tcp [::1]:80: connect: connection refused
│ 
│   with data.kubernetes_secret.argocd_admin,
│   on main.tf line 95, in data "kubernetes_secret" "argocd_admin":
│   95: data "kubernetes_secret" "argocd_admin" {
│ 
╵
```

## Usage

```bash
terraform init
terraform apply -auto-approve
```
A kube config called `foo-tf-config` will be created and then `export KUBECONFIG=$PWD/foo-tf-config` and you can use `kubectl` or `k9s` to interact with your cluster.

When you're done just tear it down

```bash
terraform destroy -auto-approve
```
