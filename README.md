# K8SecScan

Image for Security Scan for Security Analysis on Containers Images

## Elementos

- En la ruta input_files es necesario dejar el archivo Dockerfile que se desea analizar con la herramienta.
- Se ejecuta por medio del siguiente comando

```bash
./entrypoint.sh $DOCKERIMAGE='imagen a analizar' 

#Ejemplo

./entrypoint.sh $DOCKERIMAGE='postgres:latest'
```
