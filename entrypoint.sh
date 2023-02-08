#!/bin/bash
echo "[+] Setting environment variables"
export SHOWSTOPPER_PRIORITY="HIGH,CRITICAL"
export TRIVYCACHE="/.trivy_cache"
export DOCKLERCACHE="/.dockler_cache"
export ARTIFACT_FOLDER="./json"
export TRIVY_USERNAME=${USERNAME}
export TRIVY_PASSWORD=${PASSWORD}
export DOCKLE_USERNAME=${USERNAME}
export DOCKLE_PASSWORD=${PASSWORD}

#Validar Variables
echo "Verificando las variables"
echo DockerImage=$DOCKERIMAGE
echo Username=$TRIVY_USERNAME
echo Password=$TRIVY_PASSWORD
echo Dockerfile=${DOCKERFILE}

#Inicializando Carpetas
cd /docker_tools
mkdir $ARTIFACT_FOLDER

# Hadolint
echo "[+] Running Hadolint"
echo "[+] Writing Hadolint JSON File" 
echo "[+] Showing Hadolint Results" 
./hadolint-Linux-x86_64 -f json /input_files/${DOCKERFILE} > $ARTIFACT_FOLDER/hadolint_results.json

# show results
./hadolint-Linux-x86_64 /input_files/${DOCKERFILE}

# Dockle
echo "[+] Running Dockle"
# writing finding into files
echo "[+] Writing Dockle JSON File" 
dockle --cache-dir $DOCKLERCACHE --exit-code 1 -f json --output $ARTIFACT_FOLDER/dockle_results.json $DOCKERIMAGE
echo "[+] Writing Dockle Text File" 
dockle --cache-dir $DOCKLERCACHE --exit-code 1 $DOCKERIMAGE > /results/dockle_results.txt

# Trivy
echo "[+] Running Trivy"
#Updating Vuln Database
trivy image --clear-cache
#trivy image --download-db-only

# writing finding into files
echo "Vulneability Assesment"
echo "[+] Writing Trivy JSON File" 
trivy --cache-dir $TRIVYCACHE image -f json -o $ARTIFACT_FOLDER/trivy_results.json --exit-code 0 $DOCKERIMAGE
echo "[+] Writing Trivy Text File" 
trivy --cache-dir $TRIVYCACHE image -f table --exit-code 0 $DOCKERIMAGE > /results/trivy_results.txt

# writing finding into files
echo "SBOM Analysis"
echo "[+] Writing Trivy SBOM JSON File" 
trivy image --format cyclonedx --output $ARTIFACT_FOLDER/trivy_sbom_results.json --exit-code 0 $DOCKERIMAGE

# writing finding into files
echo "Docker Compliance Analysis"
echo "[+] Writing Trivy Docker Compliance File" 
trivy image --compliance docker-cis $DOCKERIMAGE > /results/trivy_compliance_results.txt

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