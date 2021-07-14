#!/bin/bash

# switch builder for multi platform support
# docker buildx create --name mybuilder --use
# build docker images
# docker build --platform linux/amd64,linux/arm64 -t aelkikhia/multi-client:latest -t aelkikhia/multi-client:"$SHA" -f ./client/Dockerfile ./client 
# docker build --platform linux/amd64,linux/arm64 -t aelkikhia/multi-server:latest -t aelkikhia/multi-server:"$SHA" -f ./server/Dockerfile ./server 
# docker build --platform linux/amd64,linux/arm64 -t aelkikhia/multi-worker:latest -t aelkikhia/multi-worker:"$SHA" -f ./worker/Dockerfile ./worker 

docker build  -t aelkikhia/multi-client:latest -t aelkikhia/multi-client:"$SHA" -f ./client/Dockerfile ./client
docker build  -t aelkikhia/multi-server:latest -t aelkikhia/multi-server:"$SHA" -f ./server/Dockerfile ./server
docker build  -t aelkikhia/multi-worker:latest -t aelkikhia/multi-worker:"$SHA" -f ./worker/Dockerfile ./worker

# publish to dockerhub
docker push aelkikhia/multi-client:latest
docker push aelkikhia/multi-client:"$SHA"
docker push aelkikhia/multi-server:latest
docker push aelkikhia/multi-server:"$SHA"
docker push aelkikhia/multi-worker:latest
docker push aelkikhia/multi-worker:"$SHA"

# apply k8s configs
kubectl apply -f k8s

# apply updated images
kubectl set image deployments/client-deployment client=aelkikhia/multi-client:"$SHA"
kubectl set image deployments/server-deployment server=aelkikhia/multi-server:"$SHA"
kubectl set image deployments/worker-deployment worker=aelkikhia/multi-worker:"$SHA"