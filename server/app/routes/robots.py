from app.routes import bp
from app.services import cloud_sql as db
from app.services import socketio
from app.utils import rb

from flask import request, jsonify
from flask_socketio import send

def robot_request():
    data = request.json
    code = data.get('code')
    if code:
        rb.add_to_queue(code)
        return jsonify({"message": "Code added to the queue"}), 200
    else:
        return jsonify({"message": "Code is required"}), 400


#@bp.route('/')
def index():
    return render_template('index.html')


@socketio.on('message')
def handle_message(msg):
    send(msg, broadcast=True)
