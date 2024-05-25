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
    query = "SELECT id FROM users WHERE uid = :uid"
    rows = execute_query(query, response=True, param_values={'uid': uid})
    ids = [dict(row.items()) for row in rows]
    return ids[0]['id'] if ids else None

def insert_user(name, email, uid):
    query = "INSERT INTO users (name, mail, uid) VALUES (:name, :email, :uid) RETURNING id"
    param_values = {'name': name, 'email': email, 'uid': uid}
    rows = execute_query(query, response=True, param_values=param_values)
    ids = [dict(row) for row in rows]
    return ids[0]['id'] if ids else None

def delete_user(uid):
    query = "DELETE FROM users WHERE uid = :uid"
    param_values = {'uid': uid}
    execute_query(query, response=False, param_values=param_values)

def edit_user(name, mail, img_path, uid):
    query = "UPDATE users SET name = :name, mail = :mail, img_path = :img_path WHERE id = :uid"
    param_values = {
        'name': name,
        'mail': mail,
        'img_path': img_path,
        'uid': uid
    }
    execute_query(query, param_values=param_values)


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

def add_new_robot(code, usid):
    query = "INSERT INTO robots (id_connect, id_user) VALUES (:idc, :idu)"
    execute_query(query, response=False, param_values={'idc': code, 'idu': usid})

def delete_robot(rid, uid):
    query = "DELETE FROM robots WHERE id = :rid AND id_user = :uid"
    execute_query(query, response=False, param_values={'rid': rid, 'uid': uid})

## JOBS

def add_new_job(cutting_height, area, model, state, start_time, end_time, id_robot):
    query = "INSERT INTO jobs (cutting_height, area, model, state, start_time, end_time, date, id_robot) VALUES (:cutting_height, :area, :model, :state, :start_time, :end_time, :date, :id_robot)"
    rows = execute_query(query, response=False, param_values = {
                                                            'cutting_height': cutting_height,
                                                            'area': area,
                                                            'model': model,
                                                            'state': state,
                                                            'start_time': start_time,
                                                            'end_time': end_time,
                                                            'id_robot': id_robot
                                                        })
    
def delete_jobs(rid):
    query = "DELETE FROM jobs WHERE id_robot = :rid"
    execute_query(query, response=False, param_values={'rid': rid})

def get_all_jobs(rid):
    query = "SELECT * FROM jobs WHERE id_robot = :rid"
    rows = execute_query(query, response=True, param_values={'rid': rid})
    return [dict(row) for row in rows]

