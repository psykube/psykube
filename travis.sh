#!/usr/bin/env bash
set -e

# Install Kubectl
curl -fsSLO https://storage.googleapis.com/kubernetes-release/release/$(curl -fsSL https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

get-release(){
  PSYKUBE_VERSION=${PSYKUBE_VERSION-latest}
  PSYKUBE_RELEASES_URL="https://api.github.com/repos/psykube/psykube/releases/${PSYKUBE_VERSION}"
  if [ -n "${GITHUB_API_TOKEN}" ] ; then
    curl -fsSL -H "Authorization: token ${GITHUB_API_TOKEN}" ${PSYKUBE_RELEASES_URL}
  else
    curl -fsSL ${PSYKUBE_RELEASES_URL}
  fi
}

get-download-url(){
  jq -r '.assets[] | select(.name | contains("linux")).browser_download_url'
}

# Install Psykube
curl -fsSL `get-release | get-download-url` | sudo tar -xzC /usr/local/bin
