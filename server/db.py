import psycopg2
from main import app
from flask import jsonify



# Replace the values with your connection string
DB_USER = 'your_db_user'
DB_PASSWORD = 'your_db_password'
DB_NAME = 'your_db_name'
DB_HOST = 'your_db_host'

def connect_to_database():
  conn = psycopg2.connect(
      dbname=DB_NAME,
      user=DB_USER,
      password=DB_PASSWORD,
      host=DB_HOST
  )
  return conn
