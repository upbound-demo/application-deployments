[package]
name = "application"
version = "0.0.1"

[dependencies]
models = { path = "./model" }
kube = { package = "k8s", version = "1.32.4" }
strategic_merge_patch = "0.1.1"
