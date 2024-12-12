import models.io.upbound.platform.v1 as platform
import models.io.upbound.aws.s3.v1beta2 as s3

app_deployment = platform.XAppDeployment{**option("params").oxr}.spec

_buckets = filter b in app_deployment.resources {
    b.type == "s3"
}

_items = [s3.Bucket{
    metadata.annotations = {                                                                    
        "krm.kcl.dev/composition-resource-name" = "bucket-{}".format(b.name)                            
        "crossplane.io/external-name" = b.s3.bucketName
    }
    spec.forProvider = {
        region = "eu-west-1"
    }
} for b in _buckets]

items = _items