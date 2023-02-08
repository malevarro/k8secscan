#!/bin/bash
echo "[+] Setting environment variables"
export SHOWSTOPPER_PRIORITY="HIGH,CRITICAL"
export TRIVYCACHE="/tmp/trivy_cache"
export DOCKLERCACHE="/tmp/dockler_cache"
export ARTIFACT_FOLDER="./json"
export TRIVY_USERNAME=${USERNAME}
export TRIVY_PASSWORD=${PASSWORD}
export DOCKLE_USERNAME=${USERNAME}
export DOCKLE_PASSWORD=${PASSWORD}

#Variables
echo "[+]Verificando las variables"
echo DockerImage=$DOCKERIMAGE
echo Username=$TRIVY_USERNAME
echo Password=$TRIVY_PASSWORD
echo Dockerfile=${DOCKERFILE}

#Inicializando Carpetas
cd /docker_tools
mkdir $ARTIFACT_FOLDER

# Hadolint
echo "[+] Running Hadolint"
# writing finding into files
echo "[+] Writing Hadolint JSON File" 
./hadolint-Linux-x86_64 -f json /input_files/${DOCKERFILE} > $ARTIFACT_FOLDER/hadolint_results.json
echo "[+] Writing Hadolint Text File" 
./hadolint-Linux-x86_64 /input_files/${DOCKERFILE} > /results/hadolint_results.txt

# Dockle
echo "[+] Running Dockle"
# writing finding into files
echo "[+] Writing Dockle JSON File" 
dockle --cache-dir $DOCKLERCACHE --exit-code 1 -f json --output $ARTIFACT_FOLDER/dockle_results.json $DOCKERIMAGE
echo "[+] Writing Dockle Text File" 
dockle --cache-dir $DOCKLERCACHE --exit-code 1 $DOCKERIMAGE > /results/dockle_results.txt

# Trivy
echo "[+] Running Trivy"
#clean Vuln Database
trivy --cache-dir $TRIVYCACHE image --clear-cache
trivy --cache-dir $TRIVYCACHE image --download-db-only
# writing finding into files
echo "***Vulneability Assesment***"
echo "[+] Writing Trivy JSON File" 
trivy --cache-dir $TRIVYCACHE image --skip-db-update -f json -o $ARTIFACT_FOLDER/trivy_results.json --exit-code 0 $DOCKERIMAGE
echo "[+] Writing Trivy Text File" 
trivy --cache-dir $TRIVYCACHE image --skip-db-update -f table --exit-code 0 $DOCKERIMAGE > /results/trivy_results.txt
echo "***SBOM Analysis***"
echo "[+] Writing Trivy SBOM JSON File" 
trivy --cache-dir $TRIVYCACHE image --scanners vuln --format cyclonedx --output $ARTIFACT_FOLDER/trivy_sbom_results.json --exit-code 0 $DOCKERIMAGE
echo "***Docker Compliance Analysis***"
echo "[+] Writing Trivy Docker Compliance File" 
trivy --cache-dir $TRIVYCACHE image --compliance docker-cis $DOCKERIMAGE > /results/trivy_compliance_results.txt
echo "[+] Writing Trivy Docker Compliance JSON File" 
trivy --cache-dir $TRIVYCACHE image --compliance docker-cis --format json --output $ARTIFACT_FOLDER/trivy_compliance_results.json $DOCKERIMAGE

# fail build if there is at least 1 vulnerability of the defined severity
#echo "[+] Trivy High and Critical Vulnerabilities"
#trivy -d --cache-dir $TRIVYCACHE --exit-code 1 --severity $SHOWSTOPPER_PRIORITY --quiet $DOCKERIMAGE

# HTML results from all tools outputs
echo "[+] Making the output look pretty"
python3 ./convert_json_results.py
mv $ARTIFACT_FOLDER/*.json /results
mv results.html /results

# Collect the results in docker_tools/results.html
echo "[+] Everything is done. Find the resulting HTML report in results.html"