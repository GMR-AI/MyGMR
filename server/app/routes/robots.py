from app.routes import bp
from app.services import cloud_sql as db
from app.services.cloud_bucket import image_folder
from app.utils import rb
from app.utils.active_robots_manager import active_rm
from flask import request, jsonify, session

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
    
    db.add_new_robot(code, mod['name'], mod['image_path'], session['db_id'], req['model'])

    # Once added, get robots
    return get_robots()

@bp.route('/get_robots', methods=['POST'])
def get_robots():
    if not session.get('db_id'):
        return jsonify({"message": "Session error restart the app"}), 401
    
    robots = db.get_user_robots(session.get('db_id'))
    if not robots:
        return jsonify({"message": "No robots found"}), 404
    
    for robot in robots:
        robot['status'] = active_rm.exists_in_queue(robot['id_connect'])

    return jsonify(robots), 200


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
    # TODO: Add to de db so the user can know when
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
        return 304
    else:
        return 200

@bp.route('/active_job', methods=['POST'])
def active_job():
    return jsonify({'active_job': "Upload teapot.obj"}), 200

@bp.route('/upload_file', methods=['POST'])
def upload_file():
    if 'file' not in request.files:
        return jsonify({"error": "No file part"}), 400
    
    file = request.files['file']
    if file.filename == '':
        return jsonify({"error": "No selected file"}), 400
    
    if file:
        try:
            # Upload file to GCS
            image_folder.upload_file(file, file.filename, file.content_type)
            return jsonify({"message": "File uploaded successfully"}), 200
        except Exception as e:
            return jsonify({"error": str(e)}), 500

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
