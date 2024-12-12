_deployment_template = """\
apiVersion: apps/v1
kind: Deployment
spec:
  selector: {}
  template:
    spec:
      containers:
      - name: default
        ports:
        - name: http
          protocol: TCP
          containerPort: 80
"""

_service_template = """\
apiVersion: v1
kind: Service
spec:
  ports:
  - name: http
    protocol: TCP
    port: 80
    targetPort: http
"""