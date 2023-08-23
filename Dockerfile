FROM alpine AS trivy

ENV TRIVY_VERSION=0.44.1

RUN apk update && \
    apk add coreutils wget && \
    wget "https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz" && \
    tar -xvf trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz

# Kaniko
FROM gcr.io/kaniko-project/executor:v1.12.1-debug AS kaniko

# Install bash and git on alpine
# Coreutils required: https://github.com/bats-core/bats-core/issues/83
FROM alpine
RUN apk update
RUN apk add bash git coreutils nodejs curl

# Deploy kaniko
COPY --from=kaniko /kaniko /kaniko
COPY --from=trivy /trivy /kaniko/trivy

# Set env variables for kaniko
ENV HOME /root
ENV USER /root
ENV PATH $PATH:/kaniko
ENV SSL_CERT_DIR /kaniko/ssl/certs
ENV DOCKER_CONFIG /kaniko/.docker/
ENV DOCKER_CREDENTIAL_GCR_CONFIG /kaniko/.config/gcloud/docker_credential_gcr_config.json

# Set the default shell to bash
SHELL ["/bin/bash", "-c"]
