bitnamy/wordpress discards to work on M1 Silicon chip without any workarounds. 
so, eksctl apply -f cluster.yaml

kubectl create namespace argocd
kubectl create namespace wordpress
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl patch svc argocd-server -n argocd --type='json' -p '[{"op":"replace","path":"/spec/type","value":"NodePort"},{"op":"replace","path":"/spec/ports/0/nodePort","value":31433}]'

pass
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
psvcUBTdTQwodbgh

install argocd cli
brew  install argocd

argocd login 16.170.224.39:31433 --insecure
argocd cluster list
```
SERVER                          NAME        VERSION  STATUS      MESSAGE  PROJECT
https://kubernetes.default.svc  in-cluster  1.23+    Successful  
```

---misc -- creation service account and csi driver
eksctl utils associate-iam-oidc-provider --region=eu-north-1 --cluster=argocd-cluster --approve

eksctl create iamserviceaccount \
--name ebs-csi-controller-sa \
--namespace kube-system \
--cluster argocd-cluster \
--attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy \
--approve \
--role-only \
--role-name AmazonEKS_EBS_CSI_DriverRole \
--override-existing-serviceaccounts

kubectl annotate serviceaccount ebs-csi-controller-sa \
-n kube-system \
eks.amazonaws.com/role-arn=arn:aws-cn:iam::111122223333:role/AmazonEKS_EBS_CSI_DriverRole

kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-1.13"



```bash
argocd app create wordpress --repo https://github.com/imakeeva1qa/helm-charts.git --path bitnami/wordpress \
       --dest-server https://kubernetes.default.svc --dest-namespace wordpress 
```
argocd app sync wordpress

argocd app set wordpress --sync-policy automated

-- users

kubectl apply -f argocd-cm.yml
argocd account list
```
iharmakeyeu@Ihars-MacBook-Air 3.2 ArgoCD % argocd account list
NAME    ENABLED  CAPABILITIES
admin   true     login
deploy  true     apiKey, login

```
argocd account can-i sync applications '*/*'
argocd account can-i sync applications 'wordpress/wordpress'
argocd account can-i create applications '*/*'

-- tg
Basic command installs v1.0.2 --# kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/notifications_catalog/install.yaml
however it is not going to work with telegram, so do upgrade it explicitly :
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj-labs/argocd-notifications/v1.2.1/manifests/install.yaml
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj-labs/argocd-notifications/v1.2.1/catalog/install.yaml
kubectl apply -f tg_secret.yaml

adding context and subscription
kubectl patch cm argocd-notifications-cm -n argocd --type merge -p '{"data":{"context": "argocdUrl: https://16.170.224.39:31433","service.telegram": "token: $telegram-token"}}'
kubectl patch app wordpress -n argocd -p '{"metadata": {"annotations": {"notifications.argoproj.io/subscribe.on-deployed.telegram": "-1001814261230","notifications.argoproj.io/subscribe.on-sync-failed.telegram": "-1001814261230","notifications.argoproj.io/subscribe.on-sync-running.telegram": "-1001814261230","notifications.argoproj.io/subscribe.on-sync-succeeded.telegram": "-1001814261230"}}}' --type merge



junk/
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"},"ports": [{"port":8080,"protocol":"TCP","targetPort":8080,"nodePort":31433}]}'
kubectl expose --type=NodePort deployment nginx-deployment --port 80 --name nginx-service  --overrides '{ "apiVersion": "v1","spec":{"ports": [{"port":80,"protocol
":"TCP","targetPort":80,"nodePort":31433}]}}'
kubectl port-forward svc/argocd-server -n argocd 8080:443