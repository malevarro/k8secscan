# K8SecScan

Image for Security Scan for Security Analysis on Containers Images

## Elementos

- Se debe realizar la creación de las siguientes carpetas en el servidor Linux

    ```bash
        mkdir /workdir
        mkdir /workdir/input_files
        mkdir /workdir/results
    ```

- En la ruta /workdir/input_files es necesario dejar el archivo Dockerfile que se desea analizar con la herramienta.
- ir a la ruta /workdir y realizar la copia del proyecto de Github

    ```bash
        sudo git clone https://github.com/malevarro/k8secscan.git
    ```

## Ejecución de análisis

- Los pasos para la ejecución son los siguientes
  - Ir a la carpeta donde esta el proyecto descargado

    ```bash
        cd /workdir/k8secscan/
    ```

  - Se realiza la construcción de la image docker con el siguiente comando

      ```bash
            docker build -t k8sec . #k8sec es el nombre que le vamos a dar a la imagen del contenedor
      ```

  - Verificar que la imagen haya quedado en el repositorio local de docker
  
      ```bash
            docker images
      ```

  - Se obtiene una salida como la siguiente:

    | REPOSITORY | TAG | IMAGE ID | CREATED | SIZE |
    |---|---|---|---|---|
    | k8sec | latest | 5d927b944b74 | 16 minutes ago | 777MB |

  - Se deben tener en cuenta las siguientes variables para la ejecución del análisis:
  
    -**DOCKERIMAGE** -> Corresponde a la imagen de contenedor que se desea analizar con las herramientas.

    -**DOCKERFILE** -> Corresponde al archivo de definición del contenedor que se desea analizar con las herramientas.

  - Ejecutar el docker, el siguientes es un ejemplo de ejecución con las variables indicadas.

      ```bash
          docker run --env DOCKERIMAGE='debian:latest' --env DOCKERFILE='Dockerfile' -v '/workdir/results:/results' -v '/workdir/input_files:/input_files' k8sec
      ```

  - En la ruta /workdir/results quedan todos los archivos de resultados del análisis de seguridad.
  
      ```bash
          hkuser@ubuntudocker:/workdir/results$ ls -hal
          total 772K
          drwxr-xr-x 2 root root 4.0K Feb  8 11:43 .
          drwxr-xr-x 5 root root 4.0K Feb  8 11:39 ..
          -rw-r--r-- 1 root root 1.6K Feb  8 11:42 dockle_results.json
          -rw-r--r-- 1 root root  990 Feb  8 11:42 dockle_results.txt
          -rw-r--r-- 1 root root  209 Feb  8 11:42 hadolint_results.json
          -rw-r--r-- 1 root root  162 Feb  8 11:42 hadolint_results.txt
          -rw-r--r-- 1 root root 213K Feb  8 11:43 results.html
          -rw-r--r-- 1 root root 1.7K Feb  8 11:43 trivy_compliance_results.json
          -rw-r--r-- 1 root root 2.8K Feb  8 11:43 trivy_compliance_results.txt
          -rw-r--r-- 1 root root 190K Feb  8 11:43 trivy_results.json
          -rw-r--r-- 1 root root  68K Feb  8 11:43 trivy_results.txt
          -rw-r--r-- 1 root root 262K Feb  8 11:43 trivy_sbom_results.json
      ```
