from app.routes import bp
from app.services import cloud_sql as db
from app.services import socketio
from app.utils import rb

from flask import request, jsonify, session
from flask_socketio import join_room, leave_room, emit



@bp.route('/robot_request')
def robot_request():
    #data = request.json
    #code = data.get('code')

    code = request.args.get('code')

    if db.get_robot_by_code(code):
        return jsonify({"message": "Robot already exists"}), 410
    req = rb.remove_from_queue(code)
    if not req:
        return jsonify({"message": "Request not found"}), 404
    
    if not session.get['db_id']:
        return jsonify({"message": "Session error restart the app"}), 500
    
    db.add_new_robot(code, 21)#session['db_id'])
    socketio.emit('request_successful', to=req['sid'])

    return jsonify({"message": "Robot added succesfully"}), 200

@socketio.event
def go_online(data):
    code = data['code']
    # Check robot on the database
    robot_data = db.get_robot_by_code(code)
    if not robot_data: # If it doesn't exists
        # Add the robot to the request queue
        if rb.add_to_queue(code, request.sid):
            socketio.emit('requesting')
        else:
            socketio.emit('error', {'message': 'Robot already at queue'})
        return
    
    # Check if theres missing data
    print(robot_data)
    # If it was update the status    
    #join_room(code)
    #emit('status', {'message': f'Robot {code} has joined the room'}, room=code)

@socketio.on('leave')
def on_leave(data):
    code = data['code']
    leave_room(code)
    emit('status', {'message': f'Robot {code} has left the room'}, room=code)

@socketio.event
def ping():
    emit('status', {'message': "pong"})


############## Debugging functions
@bp.route('/view_requests')
def view_requests():
    return jsonify({'success': True, 'requests': f'{rb.get_queue()}'})

@socketio.event
def connect():
    print("Robot ", request.sid, " connected")

@socketio.event
def disconnect():
    print("Robot ", request.sid, " disconnected")