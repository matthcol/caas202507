# Orchestraion with Kubernetes

## Minikube
Install minikube: https://minikube.sigs.k8s.io/docs/start

### Start minikube
```
minikube start
minikube start --driver=docker

minikube status
minikube start
minikube stop
```

### Management
```
kubectl get pods
kubectl get pods -A
kubectl get pod -A
kubectl get po -A

# or kubectl downloaded inside minikube
minikube kubectl -- get pods -A
```

NB: minikube is using dind
```
docker exec -it minikube docker ps -a
```

Shortcuts dind (follow instructions):
```
minikube docker-env
```

### Deployment
```
kubectl apply -f nginx.deployment.yml
kubectl get pod
kubectl get deployment
kubectl get replicaset

kubectl get po,rs,deployment,svc
```

Apply changes in the deployment:
- from file:
```
kubectl apply -f nginx.deployment.yml
```
- cli:
```
kubectl scale --replicas=10 deployment/front
kubectl scale --replicas=2 deployment/front
```

Deployment with CLI:
```
kubectl create deployment echos --image=kicbase/echo-server:1.0 --replicas=3
```

### Pod without deployment
```
kubectl run echosolo --image=kicbase/echo-server:1.0
```

### Dashboard
```
 minikube dashboard
```

### Management with labels
```
kubectl get po,rs,deployment,svc --show-labels

kubectl get po,rs,deployment,svc -l app=echos
kubectl get deployment -l app=echos
kubectl scale deployment -l app=echos --replicas=4

# stop:
kubectl scale deployment -l app=echos --replicas=0

# start
kubectl scale deployment -l app=echos --replicas=3

# delete
kubectl delete deployment -l app=echos
kubectl delete pod -l run=echosolo
```

NB: delete deployment => delete deployment, replicaset and pods

Add labels:
- yaml config + apply
- cli:

```
kubectl label deployment -l app=front country=fr
kubectl get deployment -l country=fr,buisness=selling

kubectl create deployment echos --image=kicbase/echo-server:1.0 --replicas=3
kubectl label deployment -l app=echos country=fr buisness=music

kubectl get deployment -l country=fr
kubectl get deployment -l country=fr,buisness=selling

kubectl label deployment -l country=fr,buisness=selling tva=20
```

Update label:
- edit yaml config + apply
- cli:

```
kubectl label --overwrite deployment -l app=echos buisness=sound
```

Delete
- edit yaml config + apply
- cli:

```
kubectl label deployment -l app=front tva-
```

### Services

Yaml: nginx.service.yml
```
kubectl apply -f nginx.service.yml
kubectl get svc 
```

Result:
NAME            TYPE           CLUSTER-IP    EXTERNAL-IP   PORT(S)        AGE
front-service   LoadBalancer   10.111.4.54   <pending>     85:30482/TCP   7m14s

Locally in minikube (`docker exec -it minikube bash`):
```
curl -G 10.111.4.54:85 
```

Externally with tunnel (minikube tunnel):
```
curl -G 127.0.0.1:85 
```

Service type NodePort

cli (expose pod or expose deployment): 
```
kubectl expose pod echosolo --type=NodePort --port 8080
kubectl expose pod echosolo --type=NodePort --port 8081 --target-port 8080 --name echosolo-service
```

NB: pour choisir le nodePort, uniquement en Yaml

Expose service externally (Minikube)
```
minikube service echosolo-service --url
```

### ConfigMap
- CLI from litteral:
```
kubectl create configmap db-env --from-literal=POSTGRES_USER=movie --from-literal=POSTGRES_DB=dbmovie
kubectl get configmap
kubectl get cm
kubectl get cm db-env -o json
kubectl get cm db-env -o jsonpath='{.data}'
kubectl describe cm db-env
kubectl delete cm db-env

kubectl create configmap db-env --from-literal=POSTGRES_DB=dbmovie -n mdb
kubectl get cm -n mdb
kubectl delete cm db-env -n mdb
```

- CLI from environnement file
```
kubectl create configmap db-env --from-env-file=.envdb -n mdb
kubectl get cm db-env -n mdb -o jsonpath='{.data}'
kubectl delete cm db-env -n mdb
```

- Yaml file + apply

- CLI from file (binary data):
```
kubectl create cm db-init -n mdb --from-file=sql
kubectl get cm db-init -n mdb -o jsonpath='{.data}'
kubectl describe cm db-init -n mdb 
```

### Secrets
CLI or Yaml, multiple crypto algorithms (generic, ...):

```
kubectl create secret generic db-secret -n mdb --from-literal=POSTGRES_USER=movie '--from-literal=POSTGRES_PASSWORD=aR@$~*%!!!aDxGU|**#'
kubectl get secret db-secret -n mdb -o jsonpath='{.data}'
```

## Project MDB

### Namespaces
```
kubectl get namespaces
kubectl get ns
kubectl create ns mdb
```

### DB deployment
```
kubectl get po,cm,secret,deployment -n mdb
kubectl apply -f .\dbmovie.deployment.yml 
kubectl exec -n mdb -it pod/dbmovie-7c76ff74b9-4dn4f -- bash
```

NB: init data
- SQL scripts in a config map mounted to  /docker-entrypoint-initdb.d
- post install k8s: initContainer
- post install manuallly: cp + exec

## Data Persistence 

```
kubectl apply -f dbmovie.volume.yml
kubectl get pvc -n mdb
kubectl apply -f dbmovie.deployment.yml
kubectl get po -n mdb
```

Test:
```
kubectl exec -n mdb -it pod/dbmovie-895ddfc94-gd6js -- psql -U movie -d dbmovie
insert into person (name) values ('Clint Eastwood');
\q
kubectl scale deployment -n mdb -l app=dbmovie --replicas=0
kubectl scale deployment -n mdb -l app=dbmovie --replicas=1  
kubectl exec -n mdb -it pod/dbmovie-895ddfc94-fgcpb -- psql -U movie -d dbmovie
select * from person; -- Clint still here ?
delete from person; -- cleanup
```

Inject data with Copy + Exec:
```
kubectl cp -n mdb ../composition/sql/02-data-persons.sql.gz dbmovie-895ddfc94-fgcpb:/tmp
kubectl exec -n mdb -it pod/dbmovie-895ddfc94-fgcpb -- ls -l /tmp
kubectl exec -n mdb -it pod/dbmovie-895ddfc94-fgcpb -- bash -c 'gunzip -c /tmp/02-data-persons.sql.gz | psql -U movie -d dbmovie'
kubectl exec -n mdb -it pod/dbmovie-895ddfc94-fgcpb -- rm /tmp/02-data-persons.sql.gz
kubectl exec -n mdb -it pod/dbmovie-895ddfc94-fgcpb -- ls -l /tmp
kubectl exec -n mdb -it pod/dbmovie-895ddfc94-fgcpb -- psql -U movie -d dbmovie -f /docker-entrypoint-initdb.d/06-realign-seq.sql
```

## Summary
File `deploy.sh`

To redo all, suppress namespace before: `kubectl delete namespace mdb`

Nb: keyword all references pod, replica set, deployment and services
```
kubectl get all -n mdb
kubectl delete all -n mdb
```













