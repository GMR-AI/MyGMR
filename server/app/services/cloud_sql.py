from app.utils import connect_with_connector
from sqlalchemy.sql import text

def execute_query(query, response=True):
    pool = connect_with_connector()
    try:
        with pool.connect() as conn:
            if isinstance(query, str):
                result = conn.execute(text(query))
            else:
                result = conn.execute(query)
            if response: # If we expect a response
                return result.mappings().all()
            else:
                conn.commit()
    finally:
        pool.dispose()