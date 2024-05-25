from app.routes import bp
from app.services import cloud_sql as db
from app.services import socketio
from app.utils import rb
from app.utils.active_robots_manager import active_rm

from flask import request, jsonify, session
from flask_socketio import join_room, leave_room, emit



@bp.route('/robot_request', methods=['POST'])
def robot_request():
    data = request.json
    code = data.get('code')

    #code = request.args.get('code')

    if db.get_robot_by_code(code):
        return jsonify({"message": "Robot already exists"}), 410
    req = rb.remove_from_queue(code)
    if not req:
        return jsonify({"message": "Request not found"}), 404
    
    if not session.get('db_id'):
        return jsonify({"message": "Session error restart the app"}), 401
    
    db.add_new_robot(code, session['db_id'])
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
    if active_rm.exists_in_queue(code, request.sid):
        socketio.emit('status', {'message': f'Code {code} or socket already in use'}, to=request.sid)
        return
    active_rm.add_to_queue(code,  request.sid)
    join_room(code, sid=request.sid)
    print(f'Robot {request.sid} joined the room {code}')
    socketio.emit('status', {'message': f'Robot {code} has joined the room'}, room=code)

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

@socketio.event
def connect():
    print("Robot ", request.sid, " connected")

@socketio.event
def disconnect():
    rooms_to_remove=[]
    for r, s in active_rm.get_queue().items():
        if s == request.sid:
            print("Client: ", request.sid, "leaving room ", r)
            rooms_to_remove.append(r)
            leave_room(r)
    # This is to avoid active_rms queue to change size during iteration
    for r in rooms_to_remove:
        active_rm.remove_from_queue(r)
    print("Robot ", request.sid, " disconnected")


############## Debugging functions (comment this functions before deploying) ##############

# @bp.route('/view_requests')
# def view_requests():
#     return jsonify({'success': True, 'requests': f'{rb.get_queue()}'})

# @bp.route('/view_online')
# def view_oneline():
#     return jsonify({'success': True, 'online_robots': f'{active_rm.get_queue()}'})

# @bp.route('/emit_message')
# def emit_message():
#     code = request.args.get('code')
#     message = request.args.get('message')

#     if code is None or message is None:
#         return jsonify({'error': 'Both code and message parameters are required.'}), 400
#     code = int(code)
#     if code in active_rm.get_queue():
#         socketio.emit('message', message, room=code)
#         return jsonify({'success': True, 'message': f'Message sent to room {code}.'})

#     return jsonify({'error': f'Room with code {code} does not exist.'}), 404
