from app.routes import bp
from app.services import cloud_sql as db
from app.services.cloud_bucket import image_folder
from app.utils import rb
import os
from app.utils.active_robots_manager import active_rm, j_status
from flask import request, jsonify, session, make_response

## USER REQUESTS

@bp.route('/robot_request', methods=['POST'])
def robot_request():
    data = request.json
    code = int(data.get('code'))

    #code = request.args.get('code')

    if db.get_robot_by_code(code):
        return jsonify({"message": "Robot already exists"}), 410
    req = rb.remove_from_queue(code)
    if not req:
        return jsonify({"message": "Request not found"}), 404
    
    if not session.get('db_id'):
        return jsonify({"message": "Session error restart the app"}), 401
    
    # Check model and get default name and image
    mod = db.get_model_by_id(req['model'])
    if not mod:
        return jsonify({"message": "Robot model not found, contact our team"}), 404
    
    CLOUD_BUCKET_BASE_URL = os.getenv('CLOUD_BUCKET_BASE_URL')
    model = f"{CLOUD_BUCKET_BASE_URL}/{image_folder.bucket_name}/{code}_gmr.glb"
    image = f"{CLOUD_BUCKET_BASE_URL}/{image_folder.bucket_name}/{mod['image_path']}"
    db.add_new_robot(code, mod['name'], image, session['db_id'], req['model'], model)

    # Once added, get robots
    return jsonify({}), 200

@bp.route('/get_robots', methods=['POST'])
def get_robots():
    if not session.get('db_id'):
        return jsonify({"message": "Session error restart the app"}), 401
    
    robots = db.get_user_robots(session.get('db_id'))
    if not robots:
        return jsonify({"message": "No robots found"}), 404
    
    # Update their status
    for robot in robots:
        robot['status'] = active_rm.exists_in_queue(robot['id_connect'])

    return jsonify({'message': 'Robot request was successful', 'robots': robots}), 200

@bp.route('/get_robot_info', methods=['POST'])
def get_robot_info():
    data = request.json
    code = int(data.get('code'))

    if not session.get('db_id'):
        return jsonify({"message": "Session error restart the app"}), 401
    
    model = db.get_model_by_id(code);
    if not model:
        return jsonify({"message": "No robots found"}), 404

    return jsonify(model), 200

@bp.route('/delete_robot', methods=['POST'])
def delete_robot():
    data = request.json
    robot_id = data.get('robot_id')
    code = data.get('code')

    if robot_id is None:
        return jsonify({"message": "robot_id is required"}), 400
    
    active_rm.remove_from_queue(code)

    # Eliminar el robot de la base de datos
    db.delete_robot(robot_id)

    return jsonify({"message": "Robot deleted successfully"}), 200

## ROBOT REQUESTS

@bp.route('/ping', methods=['POST'])
def go_online():
    data = request.json
    code = int(data.get('code'))

    # Check if its an online robot check (most frequent case)
    if active_rm.exists_in_queue(code):
        # Health check (check inbox)
        message = active_rm.ping(code)
        message = message if message else "Pong"
        
        return jsonify({'message': f'{message}'}), 200   


    # Check robot on the database
    robot_data = db.get_robot_by_code(code)

    if not robot_data: # If it doesn't exists
        return jsonify({"message": "Robot does not exists, make a request"}), 201
        
    
    # Check if theres missing data
    print(robot_data)
  
    # Robot goes online
    active_rm.add_to_queue(code)
    return jsonify({'message': f'Robot {code} has joined the room'}), 200

@bp.route('/new_request', methods=['POST'])
def new_request():
        data = request.json
        code = int(data.get('code'))
        model = int(data.get('model'))
        # Add the robot to the request queue
        if rb.add_to_queue(code, model):
            return jsonify({"message": "Robot added to the queue"}), 201
        else:
            return jsonify({"message": "Robot was already queued"}), 201

@bp.route('/check_request', methods=['POST'])
def check_request():
    data = request.json
    code = int(data.get('code'))
    if rb.exists_in_queue(code):
        return jsonify({}), 304
    else:
        return jsonify({}), 200

@bp.route('/active_job', methods=['POST'])
def active_job():
    data = request.json
    code = int(data.get('code'))
    # Check if robot is online
    if not active_rm.exists_in_queue(code):
        return jsonify({'job_status': j_status.NONE.name}), 404
    
    status = active_rm.get_queue()[code]['job_status']
    #active_rm.update_job(code, j_status.NONE)

    job_data=[]
    if status == j_status.START_JOB:
        # Check if the job has been set up
        job_data=db.get_active_job_code(code)        
        if not job_data:
            return jsonify({'job_status': j_status.NONE.name, 'job_data': job_data}), 404
        
    return jsonify({'job_status': status.name, 'job_data': job_data}), 200

@bp.route('/job_finished', methods=['POST'])
def job_finished():
    data = request.json
    code = int(data.get('code'))
    # Check if robot is online
    if not active_rm.exists_in_queue(code):
        return jsonify({'job_status': j_status.NONE.name}), 404
    # TODO: Actualizar el end_time
    active_rm.update_job(code, j_status.NONE)

    return jsonify({'status': 'done'}), 200

############## Debugging functions (comment this functions before deploying) ##############

@bp.route('/view_requests')
def view_requests():
    return jsonify({'success': True, 'requests': f'{rb.get_queue()}'})

@bp.route('/view_online')
def view_oneline():
    return jsonify({'success': True, 'online_robots': f'{active_rm.get_queue()}'})

@bp.route('/emit_message')
def emit_message():
    code = int(request.args.get('code'))
    message = request.args.get('message')

    if code is None or message is None:
        return jsonify({'error': 'Both code and message parameters are required.'}), 400
    code = int(code)
    if code in active_rm.get_queue():
        active_rm.exists_in_queue(code)
        return jsonify({'success': True, 'message': f'Message sent to room {code}.'})

    return jsonify({'error': f'Room with code {code} does not exist.'}), 404
