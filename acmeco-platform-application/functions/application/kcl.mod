[package]
name = "application"
version = "0.0.1"

[dependencies]
models = { path = "./model" }
kube = { oci = "oci://xpkg.upbound.io/upbound/kcl-modules_kube", tag = "1.31.2", package = "kcl-modules_kube", version = "1.31.2" }
strategic_merge_patch = "0.1.1"
