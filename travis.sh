#!/usr/bin/env bash
set -e

PSYKUBE_VERSION=${PSYKUBE_VERSION-latest}

# Install Kubectl
curl -fsSLO https://storage.googleapis.com/kubernetes-release/release/$(curl -fsSL https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

# Install Psykube
PSYKUBE_RELEASES_URL=https://api.github.com/repos/psykube/psykube/releases/${PSYKUBE_VERSION}
echo $PSYKUBE_RELEASES_URL
PSYKUBE_RELEASE_RESULTS=`curl -fsSL -H "Authorization: token ${GITHUB_API_TOKEN}" ${PSYKUBE_RELEASES_URL} || curl -fsSL ${PSYKUBE_RELEASES_URL}`
PSYKUBE_DOWNLOAD_URL=`echo $PSYKUBE_RELEASE_RESULTS | jq -r '.assets[] | select(.name | contains("linux")).browser_download_url'`
curl -fsSL ${PSYKUBE_DOWNLOAD_URL} | sudo tar -xzC /usr/local/bin
