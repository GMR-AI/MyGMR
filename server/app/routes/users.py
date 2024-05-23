from app.routes import bp
from app.services import cloud_sql as db
from app.utils import rb

from flask import request, jsonify, session
from flask_socketio import emit, join_room, leave_room

from firebase_admin import auth

@bp.route('/g_auth', methods=['POST'])
def continue_with_google():
    data = request.get_json()
    id_token = data.get('idToken')

    try:
        # Verify the ID token
        decoded_token = auth.verify_id_token(id_token)
        uid = decoded_token['uid']

        # Check if user exists
        id = db.get_user_id(uid)
        if not id: # User does not exist (create user)
            # Get user data
            email = decoded_token.get('email')
            name = decoded_token.get('name')
            # Create user
            id = db.insert_user(name, email, uid)

        # Start session (store uid which will used to access user data)
        session['db_id'] = id

        # Get robots
        robots = db.get_user_robots(id)
        # Return Robots
        return jsonify({'message': 'User authenticated', 'uid': uid, 'robots': robots}), 200

    except ValueError as e:
        # Token is invalid
        return jsonify({'error': str(e)}), 400

@bp.route('/check_session', methods=['POST'])
def check_session():
    data = request.get_json()
    id_token = data.get('idToken')

    try:
        # Verify the ID token
        decoded_token = auth.verify_id_token(id_token)
        uid = decoded_token['uid']

        # Check if session is valid
        if 'db_id' in session and db.get_user_id(uid) == session['db_id']:
            # Get robots
            robots = db.get_user_robots(session['db_id'])
            return jsonify({'status': 'active', 'robots': robots}), 200
        else:
            # Invalid session, clear it
            session.pop('db_id', None)
            return jsonify({'status': 'inactive'}), 200

    except ValueError as e:
        # Token is invalid
        session.pop('db_id', None)
        return jsonify({'status': 'inactive', 'error': str(e)}), 400


@bp.route('/add_user_robot', methods=['POST'])
def add_user_robot():
    data = request.json
    code = data.get('code')
    queue = rb.get_queue()
    if code not in queue:
        return jsonify({"message": "Robot was not requested"}), 404
    
    queue.remove(code)
    if db.get_robot_by_code(code):
        return jsonify({"message": "Robot already registered"}), 412
    
    db.add_user_robot()
    return jsonify({"message": "Code matched and removed from queue"}), 200

        



# View funciton for testing purposes
@bp.route('/view')
def view_users():
    query = "SELECT * FROM users"
    rows = db.execute_query(query)
    users = [dict(row.items()) for row in rows]
    return jsonify(users)

