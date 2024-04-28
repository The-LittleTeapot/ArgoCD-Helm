## Create user in ArgoCD

### Get the configmap from the cluster and edit it
`kubectl get configmap argocd-cm -n argocd -o yaml > argocd-cm.yml`

### Add data field in the yaml like below:
```
data:
  accounts.<new-username>: apiKey, login 
  admin.enabled: "false" ##This will disable the admin user, use it only if required
```

Example file:
```
apiVersion: v1
kind: ConfigMap
data:
  accounts.anusha: apiKey, login
  admin.enabled: "false"
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"v1","data":{"accounts.anusha":"apiKey, login"},"kind":"ConfigMap","metadata":{"annotations":{},"creationTimestamp":"2023-04-17T18:46:18Z","labels":{"app.kubernetes.io/name":"argocd-cm","app.kubernetes.io/part-of":"argocd"},"name":"argocd-cm","namespace":"argocd","resourceVersion":"9963","uid":"28c5472d-5a71-45c2-bfd4-9087b0268728"}}
  creationTimestamp: "2023-04-17T18:46:18Z"
  labels:
    app.kubernetes.io/name: argocd-cm
    app.kubernetes.io/part-of: argocd
  name: argocd-cm
  namespace: argocd
  resourceVersion: "12296"
  uid: 28c5472d-5a71-45c2-bfd4-9087b0268728
```
### Apply the above edited file
`kubectl apply -f argocd-cm.yml`

### Exec into the argocd server-api

`kubectl exec -it -n argocd <argocd-server-name>`

### Command to update credentials for new user
```
argocd login --username admin --password <ADMIN PASSWORD> argocd-server --loglevel debug
argocd account list
argocd account update-password --account <new-username> --new-password <new-password>
```
### Get the admin password
`kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo`