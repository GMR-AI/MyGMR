from flask import Flask
import os
from google.cloud.sql.connector import Connector, IPTypes
import pg8000
import sqlalchemy
from sqlalchemy.sql import text
from dotenv import load_dotenv

app = Flask(__name__)

# Load environment variables from .env file
load_dotenv()

def connect_with_connector() -> sqlalchemy.engine.base.Engine:
    """
    Initializes a connection pool for a Cloud SQL instance of Postgres.

    Uses the Cloud SQL Python Connector package.
    """
    # Note: Saving credentials in environment variables is convenient, but not
    # secure - consider a more secure solution such as
    # Cloud Secret Manager (https://cloud.google.com/secret-manager) to help
    # keep secrets safe.

    instance_connection_name = os.environ[
        "INSTANCE_CONNECTION_NAME"
    ]  # e.g. 'project:region:instance'
    db_user = os.environ["DB_USER"]  # e.g. 'my-db-user'
    db_pass = os.environ["DB_PASS"]  # e.g. 'my-db-password'
    db_name = os.environ["DB_NAME"]  # e.g. 'my-database'

    ip_type = IPTypes.PRIVATE if os.environ.get("PRIVATE_IP") else IPTypes.PUBLIC

    # initialize Cloud SQL Python Connector object
    connector = Connector()

    def getconn() -> pg8000.dbapi.Connection:
        conn: pg8000.dbapi.Connection = connector.connect(
            instance_connection_name,
            "pg8000",
            user=db_user,
            password=db_pass,
            db=db_name,
            ip_type=ip_type,
        )
        return conn

    # The Cloud SQL Python Connector can be used with SQLAlchemy
    # using the 'creator' argument to 'create_engine'
    pool = sqlalchemy.create_engine(
        "postgresql+pg8000://",
        creator=getconn,
        # [START_EXCLUDE]
        # Pool size is the maximum number of permanent connections to keep.
        pool_size=5,
        # Temporarily exceeds the set pool_size if no connections are available.
        max_overflow=2,
        # The total number of concurrent connections for your application will be
        # a total of pool_size and max_overflow.
        # 'pool_timeout' is the maximum number of seconds to wait when retrieving a
        # new connection from the pool. After the specified amount of time, an
        # exception will be thrown.
        pool_timeout=30,  # 30 seconds
        # 'pool_recycle' is the maximum number of seconds a connection can persist.
        # Connections that live longer than the specified amount of time will be
        # re-established
        pool_recycle=1800,  # 30 minutes
        # [END_EXCLUDE]
    )
    return pool

def execute_select_query(query):
    pool = connect_with_connector()
    try:
        with pool.connect() as conn:
            if isinstance(query, str):
                result = conn.execute(text(query))
            else:
                result = conn.execute(query)
            return result.mappings().all()
    finally:
        pool.dispose()

def execute_non_select_query(query):
    pool = connect_with_connector()
    try:
        with pool.connect() as conn:
            if isinstance(query, str):
                conn.execute(text(query))
            else:
                conn.execute(query)
            conn.commit()
    finally:
        pool.dispose()

@app.route('/insert')
def insert_user():
    query = f"INSERT INTO users (name, mail) VALUES ('user1', 'user1@example.com')"
    execute_non_select_query(query)
    return 'insert was succesful!'


@app.route('/view')
def view_users():
    query = "SELECT * FROM users"
    rows = execute_select_query(query)
    users = [dict(row.items()) for row in rows]
    return users

@app.route('/delete')
def delete_user_by_mail():
    query = f"DELETE FROM users WHERE mail = 'user1@example.com'"
    execute_non_select_query(query)
    return 'delete was succesful!'

@app.route('/')
def hello():
    return "hello world!"

if __name__ == "__main__":
    # This is used when running locally only. When deploying to Google App
    # Engine, a webserver process such as Gunicorn will serve the app.
    app.run(host="127.0.0.1", port=8080, debug=True)