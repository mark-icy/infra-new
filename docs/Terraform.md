# Terraform
We used Terraform to describe and deploy the cluster and the resources it needs. ```$ terraform apply``` initializes the whole system, it includes:

* Local Kubernetes in Docker (Kind) cluster 
    * 1 control-plane node
    * 1 worker node
* Cloudflare tunnels
* FluxCD  bootstrapping
    * Flux brings up all infrastructure controllers and apps using kustomization.yaml files

