from app.routes import bp
from app.services import cloud_sql as db
from app.services import socketio
from app.utils import rb

from flask import request, jsonify
from flask_socketio import join_room, leave_room, emit


@bp.route('/robot_request')
def robot_request():
    data = request.json
    code = data.get('code')
    if code:
        rb.add_to_queue(code)
        return jsonify({"message": "Code added to the queue"}), 200
    else:
        return jsonify({"message": "Code is required"}), 400


@socketio.on('join')
def on_join(data):
    code = data['code']
    join_room(code)
    emit('status', {'message': f'Robot {code} has joined the room'}, room=code)

@socketio.on('leave')
def on_leave(data):
    code = data['code']
    leave_room(code)
    emit('status', {'message': f'Robot {code} has left the room'}, room=code)

@socketio.event
def ping():
    emit('status', {'message': "pong"})