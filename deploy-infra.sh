cd infra
echo "Running OpenTofu tests..."
./run-tofu-tests.sh

echo "Applying OpenTofu configuration..."
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
    -n infrastructure