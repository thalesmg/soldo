let kubernetes = ./Kubernetes.dhall

let IntOrString = kubernetes.IntOrString

let registry = env:DOCKER_REGISTRY as Text ? "ghcr.io"

let username = env:DOCKER_USERNAME as Text ? "thalesmg"

let tag = env:DOCKER_TAG as Text ? "latest"

let image = "soldo:${tag}"

let labels = Some (toMap { soldo = "true" })

let metadata = kubernetes.ObjectMeta::{ name = "soldo", labels }

let deployment =
      kubernetes.Deployment::{
      , metadata
      , spec = Some kubernetes.DeploymentSpec::{
        , selector = kubernetes.LabelSelector::{ matchLabels = labels }
        , replicas = Some 1
        , template = kubernetes.PodTemplateSpec::{
          , metadata
          , spec = Some kubernetes.PodSpec::{
            , imagePullSecrets = Some
              [ kubernetes.LocalObjectReference::{ name = Some "ghcr-thalesmg" }
              ]
            , containers =
              [ kubernetes.Container::{
                , name = "soldo"
                , image = Some "${registry}/${username}/${image}"
                , ports = Some
                  [ kubernetes.ContainerPort::{ containerPort = 3000 } ]
                , resources = Some kubernetes.ResourceRequirements::{
                  , limits = Some (toMap { memory = "64Mi", cpu = "100m" })
                  , requests = Some (toMap { memory = "64Mi", cpu = "100m" })
                  }
                }
              ]
            }
          }
        }
      }

let service =
      kubernetes.Service::{
      , metadata =
          metadata
        with annotations = Some
            (toMap { `dev.okteto.com/auto-ingress` = "true" })
      , spec = Some kubernetes.ServiceSpec::{
        , selector = labels
        , ports = Some
          [ kubernetes.ServicePort::{
            , port = 80
            , targetPort = Some (IntOrString.Int 3000)
            }
          ]
        }
      }

in  { deployment, service }
