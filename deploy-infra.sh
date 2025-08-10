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
    --docker-password=<token> \
    --docker-email=deividfranciscosantos@hotmail.com \
    -n infrastructure