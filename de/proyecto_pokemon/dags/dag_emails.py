# Importa las bibliotecas necesarias
from datetime import datetime, timedelta
from email import message
from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from airflow.operators.dummy_operator import DummyOperator  # Importa DummyOperator

# Importa la función desde el otro DAG
from scripts.conexion_carga_datos_tabla import cargar_datos_pokemon_to_redshift


import smtplib

def enviar():
    try:
        x=smtplib.SMTP('smtp.gmail.com',587)
        x.starttls()
        x.login('marquezlucasa@gmail.com','puykjldwfxrqwikn')
        subject='Ganaste un premio'
        body_text='Has ganado un premio fantastico!!!!'
        message='Subject: {}\n\n{}'.format(subject,body_text)
        x.sendmail('marquezlucasa@gmail.com','marquezlucas1511@gmail.com',message)
        print('Exito')
    except Exception as exception:
        print(exception)
        print('Failure')

default_args_email={
    'owner': 'Tuki',
    'start_date': datetime(2023,12,24)
}

dag_email = DAG(
    'dag_smtp_email_automatico',
    default_args=default_args_email,
    schedule_interval='@daily',
)

# Definir tarea para enviar el correo
tarea_envio = PythonOperator(
    task_id='dag_envio',
    python_callable=enviar,
    dag=dag_email,
)

# Usar DummyOperator como punto de conexión entre ambos DAGs
dummy_operator = DummyOperator(
    task_id='dummy_operator',
    dag=dag_email,
)

# Establecer la relación de dependencia entre las tareas
dummy_operator >> tarea_envio