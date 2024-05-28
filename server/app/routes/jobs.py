from app.routes import bp
from app.services import cloud_sql as db
from app.utils import rb

from flask import request, jsonify, session
from flask_socketio import emit, join_room, leave_room

from firebase_admin import auth

from datetime import datetime

@bp.route('/add_new_job', methods=['POST'])
def add_new_job():
    data = request.json

    cutting_height = data.get('cutting_height')
    area = data.get('area')
    model = data.get('model')
    state = data.get('state')
    start_time = data.get('start_time')
    end_time = data.get('end_time')
    id_robot = data.get('id_robot')

    if not all([cutting_height, area, model, state, start_time, end_time, id_robot]):
        return jsonify({"message": "Missing data"}), 400

    try:
        start_time = datetime.fromisoformat(start_time)
        end_time = datetime.fromisoformat(end_time)
    except ValueError:
        return jsonify({"message": "Invalid date format"}), 400

    queue = rb.get_queue()

    if (cutting_height, area, model, state, start_time, end_time, id_robot) not in queue:
        return jsonify({"message": "Job was not requested"}), 404

    queue.remove((cutting_height, area, model, state, start_time, end_time, id_robot))

    job_id = db.add_new_job(cutting_height, area, model, state, start_time, end_time, id_robot)
    
    if job_id:
        # Actualizar el campo id_actual_job en la tabla robots
        db.add_active_job(job_id, id_robot)
        return jsonify({"message": "Job added successfully", "job_id": job_id}), 200
    else:
        return jsonify({"message": "Failed to add job"}), 500


@bp.route('/delete_jobs', methods=['POST'])
def delete_jobs():
    data = request.json
    rid = data.get('rid')
    queue = rb.get_queue()
    if rid not in queue:
        return jsonify({"message": "Robot was not requested"}), 404
    
    queue.remove(rid)
    if db.delete_jobs(rid):
        return jsonify({"message": "All jobs already deleted"}), 200
    else:
        return jsonify({"message": "OK"}), 200


@bp.route('/get_all_jobs', methods=['POST'])
def get_all_jobs():
    data = request.json
    rid = data.get('rid')
    queue = rb.get_queue()
    if rid not in queue:
        return jsonify({"message": "Robot was not requested"}), 404
    
    queue.remove(rid)
    jobs = db.get_all_jobs(rid)
    if jobs:
        return jsonify({"message": "All jobs getted", "jobs": jobs}), 200
    else:
        return jsonify({"message": "No jobs available for the specified robot"}), 404
    

@bp.route('/get_active_job/<int:robot_id>', methods=['GET'])
def get_active_job(robot_id):
    query = "SELECT * FROM jobs WHERE id = (SELECT id_actual_job FROM robots WHERE id = :robot_id)"
    row = execute_query(query, response=True, param_values={'robot_id': robot_id})
    
    if row:
        job = dict(row[0])
        return jsonify({"message": "Active job found", "job": job}), 200
    else:
        return jsonify({"message": "No active job found"}), 404
    

@bp.route('/finish_active_job/<int:robot_id>', methods=['PUT'])
def finish_active_job(robot_id):
    # Obtener el ID del trabajo activo del robot
    query = "SELECT id_actual_job FROM robots WHERE id = :robot_id"
    row = execute_query(query, response=True, param_values={'robot_id': robot_id})
    
    if not row:
        return jsonify({"message": "No active job found for the specified robot"}), 404
    
    active_job_id = row[0]['id_actual_job']
    
    # Actualizar el estado del trabajo a "finished"
    query_update_job = "UPDATE jobs SET state = 'finished' WHERE id = :job_id"
    execute_query(query_update_job, response=False, param_values={'job_id': active_job_id})
    
    # Limpiar el campo id_actual_job del robot
    query_clear_robot = "UPDATE robots SET id_actual_job = NULL WHERE id = :robot_id"
    execute_query(query_clear_robot, response=False, param_values={'robot_id': robot_id})
    
    return jsonify({"message": "Active job finished successfully"}), 200
