import os
# Importa las bibliotecas necesarias
from datetime import datetime, timedelta
from email import message
from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from airflow.operators.dummy_operator import DummyOperator  # Importa DummyOperator

# Importa la función desde el otro DAG
from scripts.conexion_carga_datos_tabla import cargar_datos_pokemon_to_redshift


# Obtener la ruta del directorio actual
current_dir = os.path.dirname(os.path.abspath(__file__))

default_args_pokemon = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2023, 1, 1),
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

dag_pokemon = DAG(
    'pokemon_dag',
    default_args=default_args_pokemon,
    description='DAG para obtener y cargar datos de Pokémon en Redshift',
    schedule_interval=timedelta(days=1),
)

# Definir tarea para obtener datos de Pokémon
task_obtener_datos = PythonOperator(
    task_id='obtener_datos_pokemon',
    python_callable=cargar_datos_pokemon_to_redshift,
    provide_context=True,
    op_args=[],
    dag=dag_pokemon,
)
# Usar DummyOperator como punto de conexión entre ambos DAGs
dummy_operator = DummyOperator(
    task_id='dummy_operator',
    dag=dag_pokemon,
)

# Establecer la relación de dependencia entre las tareas
task_obtener_datos >> dummy_operator