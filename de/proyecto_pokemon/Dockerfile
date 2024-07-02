FROM apache/airflow:2.3.3-python3.8

# Configurar variables de entorno Airflow
ENV AIRFLOW_HOME /airflow

# Copiar la carpeta dags al contenedor
COPY dags/ /opt/airflow/dags/

# Exponer el puerto 8080 para la interfaz web de Airflow
EXPOSE 8080

# Comando para iniciar Airflow
CMD ["airflow", "webserver", "--host", "0.0.0.0", "--port", "8080"]