import k8s.api.apps.v1 as apps
import k8s.api.core.v1 as core
import model.io.crossplane.kubernetes.v1alpha2 as provider_kubernetes
import model.io.upbound.platform.v1 as platform
import yaml
import strategic_merge_patch as s

app_deployment_spec = platform.XAppDeployment{**option("params").oxr}.spec
context = option("params").ctx 

app_name = app_deployment_spec.application?.name or "application"
target: str = context.target?.name or "default"

# Applications have a deployment and a service
labels = {
    app = app_name
}

_base_deployment: apps.Deployment = yaml.decode(_deployment_template)
_base_deployment.spec.template.spec.containers[0].name = app_name
_base_deployment.spec.template.spec.containers[0].image = app_deployment_spec.application.image
_base_deployment |= {
    metadata.name = app_name
    metadata.namespace = "default"
    spec: {
        replicas = 1
        revisionHistoryLimit = 3
        selector.matchLabels = labels
        template.metadata.labels = labels
    }
}

# Apply a strategic merge patch if one is provided
if app_deployment_spec.application.deploymentPatch:
    _deployment = s.merge(_base_deployment, yaml.decode(app_deployment_spec.application.deploymentPatch)) 
else:
    _deployment = _base_deployment

_service: core.Service = yaml.decode(_service_template)
_service |= {
    metadata.name = app_name
    metadata.namespace = "default"
    spec = {
        selector = labels
        ports = [{
            port = 80
            targetPort = 80
        }]
    }
}

_object = lambda key: str, manifest: any {
    provider_kubernetes.Object {                                                         
        metadata = {                                                                     
            annotations = {                                                              
                "krm.kcl.dev/composition-resource-name" = key                            
            }                                                                            
            name = "{}-{}".format(app_name, key)                                         
        }                                                                                
        spec.forProvider.manifest = manifest                                             
        spec.providerConfigRef.name = target                                             
    }                                                                                     
}    

_items = [
    _object("deployment", _deployment)
    _object("service", _service)
]
items = _items
