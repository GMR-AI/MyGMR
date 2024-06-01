from app.routes import bp
from app.services import cloud_sql as db
from app.services.cloud_bucket import image_folder
import os
from app.utils.active_robots_manager import active_rm, j_status

from flask import request, jsonify

from datetime import datetime

@bp.route('/add_new_job', methods=['POST'])
def add_new_job():
    data = request.json
    code = int(data.get('code'))
    cutting_height = data.get('cutting_height')
    area = data.get('area')
    start_time = data.get('start_time')
    id_robot = data.get('id_robot')

    if not all([cutting_height, area, start_time, id_robot]):
        return jsonify({"message": "Missing data"}), 400

    try:
        start_time = datetime.fromisoformat(start_time)
    except ValueError:
        return jsonify({"message": "Invalid date format"}), 400
    
    #TODO: Si esta en working, enviar señal de cancelar

    job_id = db.add_new_job(cutting_height, area, start_time, id_robot)
    
    if job_id:
        active_rm.update_job(code, j_status.START_JOB)
        # Actualizar el campo id_actual_job en la tabla robots
        db.add_active_job(job_id, id_robot)
        return jsonify({"message": "Job added successfully", "job_id": job_id}), 200
    else:
        return jsonify({"message": "Failed to add job"}), 500


@bp.route('/delete_jobs', methods=['POST'])
def delete_jobs():
    data = request.json
    rid = data.get('rid')
    
    if db.delete_jobs(rid):
        return jsonify({"message": "All jobs already deleted"}), 200
    else:
        return jsonify({"message": "OK"}), 200


@bp.route('/get_all_jobs', methods=['POST'])
def get_all_jobs():
    data = request.json
    rid = data.get('rid')
    
    jobs = db.get_all_jobs(rid)
    if jobs:
        return jsonify({"message": "All jobs getted", "jobs": jobs}), 200
    else:
        return jsonify({"message": "No jobs available for the specified robot"}), 404
    

@bp.route('/get_active_job', methods=['POST'])
def get_active_job():
    try:
        data = request.json
        robot_id = int(data.get('robot_id'))
        if robot_id is None:
            return jsonify({"message": "robot_id is required"}), 400
        
        job = db.get_active_job(robot_id)
        
        if job:
            return jsonify({"message": "Active job found", "job": job}), 200
        else:
            return jsonify({"message": "No active job found"}), 404
    except KeyError:
        return jsonify({"message": "Invalid JSON format"}), 400
    except Exception as e:
        # Catch any other unexpected exceptions
        return jsonify({"message": "An unexpected error occurred", "error": str(e)}), 500

    

@bp.route('/finish_active_job', methods=['POST'])
def finish_active_job():
    data = request.json
    robot_id = data.get('robot_id')
    code = int(data.get('code'))
    if robot_id is None:
        return jsonify({"message": "robot_id is required"}), 400
    
    if not code:
        return jsonify({"message": "code is required"}), 400

    # TODO: notificar al robot i poner el end_time
    # TODO: Poner en el cliente que si se ha cancelado y estava en estado NEW_JOB, no se ponga en none


    # Obtener el ID del trabajo activo del robot
    row = db.get_id_active_job_from_robot(robot_id)
    
    if not row:
        return jsonify({"message": "No active job found for the specified robot"}), 404
    
    # Limpiar el campo id_actual_job del robot
    db.delete_active_job_from_robot(robot_id)
    active_rm.update_job(code, j_status.CANCEL_JOB)

    return jsonify({"message": "Active job finished successfully"}), 200


@bp.route('/check_init', methods=['POST'])
def check_init():
    data = request.json
    code = int(data.get('code'))

    if not active_rm.exists_in_queue(code):
        return jsonify({'status':'Robot has not online'}), 404


    if active_rm.get_queue()[code]['job_status'] == j_status.NEW_JOB:
        return jsonify({'status':'Robot has not finished'}), 404
    
    
    CLOUD_BUCKET_BASE_URL = os.getenv('CLOUD_BUCKET_BASE_URL')
    glb_file = f"{CLOUD_BUCKET_BASE_URL}/{image_folder.bucket_name}/{code}_gmr.glb"
    top_image = f"{CLOUD_BUCKET_BASE_URL}/{image_folder.bucket_name}/{code}_gmr.jpg"
    return ({'glb': f'{glb_file}', 'top_image': f'{top_image}'}), 200

@bp.route('/request_new_job', methods=['POST'])
def request_new_job():
    data = request.json
    code = int(data.get('code'))
    if not code:
        print("Client did not send code")
        return ({'status': 'failed'}), 400
    
    if active_rm.exists_in_queue(code):
        return ({'status': 'Robot is offline'}), 404

    active_rm.update_job(code, j_status.NEW_JOB)
    return ({'status': 'done'}), 200