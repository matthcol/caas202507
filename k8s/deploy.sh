kubectl create namespace mdb
# DB
kubectl apply -f dbmovie.env.configmap.yml
kubectl create secret generic db-secret -n mdb --from-literal=POSTGRES_USER=movie '--from-literal=POSTGRES_PASSWORD=aR€$~*%!!!aDxGU|**#'
kubectl create cm db-init -n mdb --from-file=sql
kubectl apply -f dbmovie.volume.yml 
kubectl apply -f dbmovie.deployment.yml 
kubectl apply -f dbmovie.service.yml 
# API
kubectl apply -f movieapi.deployment.yml 
