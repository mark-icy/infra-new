# Infrastructure as Code
The whole system is written as Infrastructure as Code (IaC) for easy reproducibility, management, and deployment.

## Terraform
I used Terraform to describe and deploy the cluster and the resources it needs. This includes:

* Local Kubernetes in Docker (Kind) cluster 
    * 1 control-plane node
    * 1 worker node
* Cloudflare tunnels
* FluxCD  bootstrapping

