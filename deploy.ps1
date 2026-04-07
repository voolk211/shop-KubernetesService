Write-Host "Enabling ingress addon..."
minikube addons enable ingress

Write-Host "Step 1: Deploying databases..."
kubectl apply -f userservice/postgres/statefulset.yaml
kubectl apply -f userservice/postgres/service.yaml
kubectl apply -f userservice/redis/statefulset.yaml
kubectl apply -f userservice/redis/service.yaml
kubectl apply -f authservice/postgres/statefulset.yaml
kubectl apply -f authservice/postgres/service.yaml
kubectl apply -f orderservice/postgres/statefulset.yaml
kubectl apply -f orderservice/postgres/service.yaml
kubectl apply -f paymentservice/mongodb/statefulset.yaml
kubectl apply -f paymentservice/mongodb/service.yaml
kubectl apply -f apigatewayservice/redis/statefulset.yaml
kubectl apply -f apigatewayservice/redis/service.yaml

Write-Host "Waiting 30s for databases to initialize..."
Start-Sleep -Seconds 30

Write-Host "Step 2: Deploying Kafka..."
kubectl apply -f kafka/zookeeper/statefulset.yaml
kubectl apply -f kafka/zookeeper/service.yaml

Write-Host "Waiting 60s for Zookeeper..."
Start-Sleep -Seconds 60

kubectl apply -f kafka/broker/statefulset.yaml
kubectl apply -f kafka/broker/service.yaml

Write-Host "Waiting 90s for Kafka..."
Start-Sleep -Seconds 90

Write-Host "Step 3: Deploying ConfigMaps and Secrets..."
kubectl apply -f userservice/configmap.yaml
kubectl apply -f userservice/secret.yaml
kubectl apply -f authservice/configmap.yaml
kubectl apply -f authservice/secret.yaml
kubectl apply -f orderservice/configmap.yaml
kubectl apply -f orderservice/secret.yaml
kubectl apply -f paymentservice/configmap.yaml
kubectl apply -f paymentservice/secret.yaml
kubectl apply -f apigatewayservice/configmap.yaml
kubectl apply -f apigatewayservice/secret.yaml

Write-Host "Step 4: Deploying Services..."
kubectl apply -f userservice/service.yaml
kubectl apply -f authservice/service.yaml
kubectl apply -f orderservice/service.yaml
kubectl apply -f paymentservice/service.yaml
kubectl apply -f apigatewayservice/service.yaml

Start-Sleep -Seconds 10

Write-Host "Step 5: Deploying applications..."
kubectl apply -f userservice/deployment.yaml
kubectl apply -f authservice/deployment.yaml
kubectl apply -f orderservice/deployment.yaml
kubectl apply -f paymentservice/deployment.yaml

Write-Host "Waiting 60s for core services..."
Start-Sleep -Seconds 60

kubectl apply -f apigatewayservice/deployment.yaml

Write-Host "Waiting 60s for ApiGateway..."
Start-Sleep -Seconds 60

Write-Host "Step 6: Deploying Ingress..."
kubectl apply -f ingress.yaml

Write-Host "Done! Checking pods..."
kubectl get pods
kubectl get ingress