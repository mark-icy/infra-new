#Jenkins

##Use
[jenkins.markguiang.dev](https://jenkins.markguiang.dev) points to our cluster Jenkins instance.

[mark-icy/ci-jobs](https://github.com/mark-icy/ci-jobs) contains all the jenkins jobs on the instance as code using JobDSL. One job example is the [shop-frontend-onPush job](), it automatically builds and pushes the docker image of the [shop-app](https://shop.markguiang.dev) whenever the [repository](https://github.com/mark-icy/shop-frontend) sends a preconfigured webhook on push.

##Configuration
Jenkins is configured as Infrastructure as Code (IaC) using a combination of Kubernetes resources, Helm, and Jenkins Configuration as Code (JCasC). The code is located in [infrastructure/controllers/jenkins](https://github.com/mark-icy/infra-new/tree/main/infrastructure/controllers/jenkins)

The Jenkins instance is deployed using a Helm chart, as defined in the jenkins.yaml file. The Helm chart is configured using a ConfigMap named jenkins-values, which contains the values for the Helm chart.

```
apiVersion: v1
kind: Namespace
metadata:
  name: jenkins 
---
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: jenkins
  namespace: jenkins
spec:
  interval: 24h 
  url: https://charts.jenkins.io
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: jenkins
  namespace: jenkins
spec:
  interval: 10m0s
  chart:
    spec:
      chart: jenkins
      version: '4.5.0'
      sourceRef:
        kind: HelmRepository
        name: jenkins
        namespace: jenkins
  install:
    remediation:
      retries: -1
  valuesFrom:
    - kind: ConfigMap
      name: jenkins-values
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: jenkins
  namespace: jenkins
spec:
  ingressClassName: nginx
  tls:
    - hosts:
      - jenkins.markguiang.dev
      secretName: letsencrypt-prod
  rules:
  - host: jenkins.markguiang.dev
    http:
      paths:
      - path: /
        pathType: ImplementationSpecific
        backend:
          service:
            name: jenkins
            port:
              number: 8080
```
###JCasC and the Seed Job
The Jenkins instance is describe completely as code (JCasC). The JCasC configuration includes a seed job, which is a Jenkins job that creates other Jenkins jobs. The seed job is defined in a script within the JCasC configuration. The seed job clones a [Git repository](https://github.com/mark-icy/ci-jobs) and executes a Jenkinsfile from that repository that spawns all other jenkins jobs.

The Jenkins instance also uses a set of plugins, which are specified in the installPlugins section of the jenkins-values ConfigMap.
```
apiVersion: v1
kind: ConfigMap
metadata:
  name: jenkins-values
  namespace: jenkins
data:
  values.yaml: |-
    controller:
      jenkinsUrl: https://jenkins.markguiang.dev
      installPlugins:
        - kubernetes:3985.vd26d77b_2a_48a_
        - workflow-aggregator(...redacted...)
        - git:5.2.0
        - configuration(...redacted...)
        - github:1.37.3
        - job-dsl:1.84
        - javax-mail-api:1.6.2-9
        - pipeline-utility-steps:2.16.0
        - generic-webhook-trigger:1.87.0
        - docker-workflow(...redacted...)
      additionalExistingSecrets:
        - name: jenkins-credentials-icy
          keyName: username
        - name: jenkins-credentials-icy
          keyName: password
      JCasC:
        configScripts:
          seed-jobs: |
            security:
              globalJobDslSecurityConfiguration:
                useScriptSecurity: false
            jobs:
              # - script: >
              #     job('seed-job') {
              #       scm {
              #         github('mark-icy/ci-jobs')
              #       }
              #       steps {
              #         dsl {
              #           external('hello.groovy')
              #           removeAction('DELETE')
              #         }
              #       }
              #     }
              - script: >
                  pipelineJob(...redacted...) {
                    definition {
                      cpsScm {
                        scm {
                          git {
                            remote {
                              url('https://github.com/mark-icy/ci-jobs.git')
                            }
                            branch('main')
                          }
                        }
                        scriptPath('./seed-job/Jenkinsfile')
                      }
                    }
                  }
        securityRealm: |-
          local:
            users:
              - id: "${chart-admin-username}"
                name: "Jenkins Admin"
                password: "${chart-admin-password}"
              - id: "${jenkins-credentials-icy-username}"
                name: "${jenkins-credentials-icy-username} account"
```

Credentials for Jenkins are stored as a SealedSecret, which is a Kubernetes Secret that has been encrypted using a public key. The SealedSecret is decrypted in the cluster using a corresponding private key.
```
{
  "kind": "SealedSecret",
  "apiVersion": "bitnami.com/v1alpha1",
  "metadata": {
    "name": "jenkins-credentials-icy",
    "namespace": "jenkins",
    "creationTimestamp": null
  },
  "spec": {
    "template": {
      "metadata": {
        "name": "jenkins-credentials-icy",
        "namespace": "jenkins",
        "creationTimestamp": null
      }
    },
    "encryptedData": {
      "username": "AgAyaItznN6gyeh/fKjcenELl9xb4/(...redacted...)/(...redacted...)/(...redacted...)/(...redacted...)/2Hai0jVW1GZILC/(...redacted...)/3joeqX2/(...redacted...)/(...redacted...)/4SR2a1pQ/(...redacted...)=",
      "password": (...redacted...)/(...redacted...)/(...redacted...)/(...redacted...)/(...redacted...)/(...redacted...)/(...redacted...)/(...redacted...)/(...redacted...)licesm(...redacted...)/hEY(...redacted...)/0Ytw/(...redacted...)/y7NgA="
    }
  }
}
```
