# Terraform Homelab K8s

Terraform repo to setup a local k8s cluster to homelab with

K8s provider: `kind`

TODO: Will Include `ArgoCD`!

# Bugs

Currently can't get the ArgoCD terraform provider to sucessfully bring the helm release of ArgoCD into its own management. The error feels networky but the setup is so simple that I don't know where it's going wrong.

```
argocd_application.argocd: Creating...
╷
│ Error: failed to create new API client
│ 
│   with argocd_application.argocd,
│   on main.tf line 117, in resource "argocd_application" "argocd":
│  117: resource "argocd_application" "argocd" {
│ 
│ cannot find pod with selector: [app.kubernetes.io/name=argocd-server] - use the --{component}-name flag in this command or set the environmental variable (Refer to
│ https://argo-cd.readthedocs.io/en/stable/user-guide/environment-variables), to change the Argo CD component name in the CLI
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
