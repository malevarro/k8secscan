#!/bin/bash
export TRIVYCACHE="/tmp/trivy_cache"
export DOCKLERCACHE="/tmp/dockler_cache"
export ARTIFACT_FOLDER="./json"

# installing all necessary stuff
echo "[+] Installing required packages"
yum update
yum install -y wget git python3 python3-pip unzip

# preparing directory structure
echo "[+] Preparing necessary directories"
mkdir /docker_tools
cd /docker_tools
mkdir $TRIVYCACHE
mkdir $DOCKLERCACHE
mkdir $ARTIFACT_FOLDER

# Trivy
echo "[+] Fetching Trivy"
export TRIVYVERSION=$(git ls-remote --refs --sort="version:refname" --tags https://github.com/aquasecurity/trivy | cut -d/ -f3-|tail -n1 | sed -e 's/^.//')
echo "[+] Trivy Version:" ${TRIVYVERSION}
wget -nv --no-cache https://github.com/aquasecurity/trivy/releases/download/v${TRIVYVERSION}/trivy_${TRIVYVERSION}_Linux-64bit.rpm
echo "[+] Installing Trivy"
rpm -i trivy_${TRIVYVERSION}_Linux-64bit.rpm
echo "[+] Trivy Installed "${TRIVYVERSION}

# Dockle
echo "[+] Fetching Dockle"
export DOCKLEVERSION=$(git ls-remote --refs --sort="version:refname" --tags https://github.com/goodwithtech/dockle | cut -d/ -f3-|tail -n1 | sed -e 's/^.//')
wget -nv --no-cache https://github.com/goodwithtech/dockle/releases/download/v${DOCKLEVERSION}/dockle_${DOCKLEVERSION}_Linux-64bit.rpm
rpm -i dockle_${DOCKLEVERSION}_Linux-64bit.rpm
echo "Dockle Installed "$DOCKLEVERSION

# Hadolint
echo "[+] Fetching Hadolint"
export HADOLINTVERSION=$(git ls-remote --refs --sort="version:refname" --tags https://github.com/hadolint/hadolint | cut -d/ -f3-|tail -n1 | sed -e 's/^.//')
echo "[+] Hadolint Version:" ${HADOLINTVERSION}
wget -nv --no-cache https://github.com/hadolint/hadolint/releases/download/v${HADOLINTVERSION}/hadolint-Linux-x86_64 && chmod +x hadolint-Linux-x86_64

# cleaning up
echo "[+] Removing left-overs"
rm *.rpm #LICENSE README.md 

# json converting script
echo "[+] Fetching json2HTML"
pip3 install json2html
wget -nv --no-cache -O convert_json_results.py https://raw.githubusercontent.com/Swordfish-Security/docker_cicd/master/convert_json_results.py

echo "[+] Image has been built"