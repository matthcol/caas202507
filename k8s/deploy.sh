kubectl create namespace mdb
kubectl apply -f dbmovie.env.configmap.yml
kubectl create secret generic db-secret -n mdb --from-literal=POSTGRES_USER=movie '--from-literal=POSTGRES_PASSWORD=aR@$~*%!!!aDxGU|**#'
kubectl apply -f dbmovie.volume.yml 
kubectl apply -f dbmovie.deployment.yml 
