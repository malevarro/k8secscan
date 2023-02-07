# K8SecScan

Image for Security Scan for Security Analysis on Containers Images

## Elementos

- En la ruta input_files es necesario dejar el archivo Dockerfile que se desea analizar con la herramienta.
- Los pasos para la ejecución son los siguientes
  - Se realiza la construcción de la image docker con el siguiente comando

      ```bash
            docker build -t k8sec . #k8sec es el nombre que le vamos a dar a la imagen del contenedor
    ```

  - Verificar que la imagen haya quedado en el repositorio local de docker
  
      ```bash
            docker images
    ```

  - Ejecutar el docker
