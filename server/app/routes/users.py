from app.routes import bp
import app.routes.robots as robot
from app.services import cloud_sql as db
from app.utils import rb
import io
from app.services.cloud_bucket import image_folder
from flask import request, jsonify, session, make_response
import requests
import os

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
        user = db.get_user_id(uid)
        if not user: # User does not exist (create user)
            # Get user data
            email = decoded_token.get('email')
            name = decoded_token.get('name')
            CLOUD_BUCKET_BASE_URL = os.getenv('CLOUD_BUCKET_BASE_URL')
            image_path = f"{CLOUD_BUCKET_BASE_URL}/{image_folder.bucket_name}/default.png"
            picture_url = decoded_token.get('picture')
            if picture_url:
                response = requests.get(picture_url)
                if response.status_code == 200:
                    filename = f"{uid}_pfp.png"
                    file_stream = io.BytesIO(response.content)
                    image_folder.upload_file(file_stream, filename, 'image/png')
                    image_path = f"{CLOUD_BUCKET_BASE_URL}/{image_folder.bucket_name}/{filename}"

            user = db.insert_user(name, email, uid, image_path)
        session['db_id'] = user['id']
        # Return Robots
        return jsonify(user), 200

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

@bp.route('/get_image', methods=['POST'])
def get_robot_image():
    data = request.get_json()
    image_name = data.get('image_name')

    if not image_name:
        return jsonify({"message": "Image name is required"}), 400

    # Retrieve the cloud storage bucket base URL from the environment variable
    CLOUD_BUCKET_BASE_URL = os.getenv('CLOUD_BUCKET_BASE_URL')
    if not CLOUD_BUCKET_BASE_URL:
        return jsonify({"message": "Cloud bucket base URL is not configured"}), 500

    image_url = f"{CLOUD_BUCKET_BASE_URL}/{image_folder.bucket_name}/{image_name}"

    return jsonify({"image_url": image_url}), 200

# View funciton for testing purposes
@bp.route('/view')
def view_users():
    query = "SELECT * FROM users"
    rows = db.execute_query(query)
    users = [dict(row.items()) for row in rows]
    return jsonify(users)

