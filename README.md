# kaniko-alpine
Kaniko based on Alpine with Bash and Git included

## Deploying

- `docker login`
- `docker build -t kaniko-trivy-alpine .`
- `docker image tag kaniko-trivy-alpine $USER/kaniko-trivy-alpine:$TAG`
- `docker image push $USER/kaniko-trivy-alpine:$TAG`
