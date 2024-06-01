from app.utils import connect_with_connector
from sqlalchemy.sql import text

def execute_query(query, response=True, param_values={}):
    pool = connect_with_connector()
    try:
        with pool.connect() as conn:
            if isinstance(query, str):
                result = conn.execute(text(query), param_values)
            else:
                result = conn.execute(query, param_values)

            conn.commit()
            if response: # If we expect a response
                return result.mappings().all()

    finally:
        pool.dispose()

## USERS

def get_user_id(uid):
    query = "SELECT * FROM users WHERE uid = :uid"
    rows = execute_query(query, response=True, param_values={'uid': uid})
    ids = [dict(row.items()) for row in rows]
    return ids[0] if ids else None

def insert_user(name, email, uid, path_image):
    query = "INSERT INTO users (name, mail, uid, path_image) VALUES (:name, :email, :uid, :pi) RETURNING *"
    param_values = {'name': name, 'email': email, 'uid': uid, 'pi': path_image}
    rows = execute_query(query, response=True, param_values=param_values)
    ids = [dict(row) for row in rows]
    return ids[0] if ids else None

def delete_user(uid):
    query = "DELETE FROM users WHERE uid = :uid"
    param_values = {'uid': uid}
    execute_query(query, response=False, param_values=param_values)

## MODELOS

def get_model_by_id(id):
    query = "SELECT * FROM models WHERE id = :c"
    rows = execute_query(query, response=True, param_values={'c': id})
    robs = [dict(row) for row in rows]
    return robs[0] if robs else None

## ROBOTS

def get_user_robots(user_id):
    query = "SELECT * FROM robots WHERE id_user = :user_id"
    rows = execute_query(query, response=True, param_values={'user_id': user_id})
    return [dict(row) for row in rows]

def get_robot_by_code(code):
    query = "SELECT * FROM robots WHERE id_connect = :c"
    rows = execute_query(query, response=True, param_values={'c': code})
    robs = [dict(row) for row in rows]
    return robs[0] if robs else None

def add_new_robot(code, name, img, usid, mid, model):
    query = "INSERT INTO robots (id_connect, name, img, id_user, id_model, reconstruction_path) VALUES (:idc, :n, :im, :idu, :idm, :m)"
    execute_query(query, response=False, param_values={'idc': code, 'n':name, 'im': img, 'idu': usid, 'idm': mid, 'm': model})

def delete_robot(robot_id):
    query_delete_robot = "DELETE FROM robots WHERE id = :robot_id"
    execute_query(query_delete_robot, response=False, param_values={'robot_id': robot_id})

## JOBS

def add_new_job(cutting_height, area, start_time, id_robot):
    query = "INSERT INTO jobs (cutting_height, area, start_time, id_robot) VALUES (:cutting_height, :area, :start_time, :id_robot) RETURNING id"
    row = execute_query(query, response=True, param_values = {
                                                            'cutting_height': cutting_height,
                                                            'area': area,
                                                            'start_time': start_time,
                                                            'id_robot': id_robot
                                                        })
    if row:
        return row[0]['id']
    else:
        return None
    
def delete_jobs(rid):
    query = "DELETE FROM jobs WHERE id_robot = :rid AND end_time IS NOT NULL"
    execute_query(query, response=False, param_values={'rid': rid})

def get_all_jobs(rid):
    query = "SELECT * FROM jobs WHERE id_robot = :rid AND end_time IS NOT NULL"
    rows = execute_query(query, response=True, param_values={'rid': rid})
    return [dict(row) for row in rows]

def add_active_job(job_id, id_robot):
    query = "UPDATE robots SET id_active_job = :job_id WHERE id = :id_robot"
    execute_query(query, response=False, param_values={'job_id': job_id, 'id_robot': id_robot})

def get_active_job(robot_id):
    query = "SELECT * FROM jobs WHERE id = (SELECT id_active_job FROM robots WHERE id = :robot_id)"
    row = execute_query(query, response=True, param_values={'robot_id': robot_id})
    return dict(row[0]) if row else None

def get_active_job_code(code):
    query = "SELECT * FROM jobs WHERE id = (SELECT id_active_job FROM robots WHERE id_connect = :code)"
    row = execute_query(query, response=True, param_values={'code': code})
    return dict(row[0]) if row else None

def get_id_active_job_from_robot(robot_id):
    query = "SELECT id_active_job FROM robots WHERE id = :robot_id"
    row = execute_query(query, response=True, param_values={'robot_id': robot_id})
    return row[0]['id_active_job'] if row else None

def delete_active_job_from_robot(robot_id):
    query = "UPDATE robots SET id_active_job = NULL WHERE id = :robot_id"
    execute_query(query, response=False, param_values={'robot_id': robot_id})

def add_end_time(job_id, end_time):
    query = "UPDATE jobs SET end_time = :end_time WHERE id = :jid"
    execute_query(query, response=False, param_values={'end_time': end_time, 'jid': job_id})