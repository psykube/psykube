#!/usr/bin/env bash
set -e

PSYKUBE_VERSION=${PSYKUBE_VERSION-latest}

# Install latest docker
sudo apt-get update
sudo apt-get install docker-ce

# Install Psykube
PSYKUBE_RELEASES_URL=https://api.github.com/repos/psykube/psykube/releases/tags/${PSYKUBE_VERSION}
PSYKUBE_RELEASE_RESULTS=`curl -sSL -H "Authorization: token ${GITHUB_API_TOKEN}" ${PSYKUBE_RELEASES_URL}`
PSYKUBE_DOWNLOAD_URL=`echo $PSYKUBE_RELEASE_RESULTS | jq -r '.assets[] | select(.name | contains("linux")).browser_download_url'`
curl -sSL ${PSYKUBE_DOWNLOAD_URL} | sudo tar -xzC /usr/local/bin

# Install Kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
