from app.routes import bp
from app.services import cloud_sql as db
from app.utils import rb

from flask import request, jsonify, session
from flask_socketio import emit, join_room, leave_room

from firebase_admin import auth

# pregunta: las funciones aqui se pueden llamar igual que las funciones del cloud.sql?
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

    queue = rb.get_queue()
    if cutting_height and area and model and state and start_time and end_time and id_robot not in queue:
        return jsonify({"message": "Job was not requested"}), 404
    
    queue.remove(cutting_height)
    queue.remove(area)
    queue.remove(model)
    queue.remove(state)
    queue.remove(start_time)
    queue.remove(end_time)
    queue.remove(id_robot)
    
    if db.add_new_job(cutting_height, area, model, state, start_time, end_time, id_robot):
        return jsonify({"message": "Job already registered"}), 412
    
    return jsonify({"message": "OK"}), 200
    

@bp.route('/delete_jobs', methods=['POST'])
def delete_jobs():
    data = request.json
    rid = data.get('rid')
    queue = rb.get_queue()
    if rid not in queue:
        return jsonify({"message": "Robot was not requested"}), 404
    
    queue.remove(rid)
    if db.delete_jobs(rid):
        return jsonify({"message": "All jobs already deleted"}), 412
    
    return jsonify({"message": "OK"}), 200

@bp.route('/get_all_jobs', methods=['POST'])
def get_all_jobs():
    data = request.json
    rid = data.get('rid')
    queue = rb.get_queue()
    if rid not in queue:
        return jsonify({"message": "Robot was not requested"}), 404
    
    queue.remove(rid)
    if db.get_all_jobs(rid):
        return jsonify({"message": "All jobs geted"}), 412
    
    return jsonify({"message": "OK"}), 200