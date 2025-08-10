cd infra
tofu init
tofu validate
# tofu plan
tofu apply -auto-approve
echo "Infrastructure deployment completed"
tofu output

kubectl create secret docker-registry regcred \
    --docker-server=https://index.docker.io/v1/ \
    --docker-username=deividsantos \
    --docker-password=<docker> \
    -n infrastructure

kubectl port-forward -n infrastructure svc/jenkins 8080:8080
# kubectl port-forward -n infrastructure svc/prometheus-grafana 8090:80 -n infrastructure   