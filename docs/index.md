#Overview

Welcome to our project! This is a monorepo for managing infrastructure using modern DevOps principles and technologies. We've adopted a GitOps approach, which means all changes to our infrastructure are made via git commits.

## Technologies Used

- Terraform: Used for provisioning our cloud resources.
- Kubernetes: Our applications are containerized and managed using Kubernetes.
- Flux: Our GitOps tool of choice. It ensures our Kubernetes cluster state matches the state defined in this repository.
- Jenkins: Used for continuous deployment of our applications.
- MetalLB: Implemented as the load balancer for our Kubernetes cluster.
- Cert-Manager: Used for managing Let's Encrypt SSL certificates. 
- Cloudflare Tunnels: Used to host apps directly from our local server (jenkins.markguiang.dev and shop.markguiang.dev)

## Infrastructure as Code (IaC)
The entire system is written as Infrastructure as Code (IaC) for easy reproducibility, management, and deployment. This approach allows us to automate the process of infrastructure setup, reducing the possibility of human error, and ensuring consistency across different environments.

## Project Layout
Our project is organized into several directories:

    apps/: Contains application deployments.
    clusters/dev/: Contains FluxCD bootstrap configurations and kustomizations.
    docs/: Contains our project documentation.
    infrastructure/: Contains infrastructure-related deployments and configurations, including the Jenkins setup.
    scripts/: Contains helper scripts, mainly for creating sealed secrets.
    secrets/: Contains sealed secrets and public keys.