from app.routes import bp
from app.services import cloud_sql as db

@bp.route('/insert')
def insert_user():
    query = f"INSERT INTO users (name, mail) VALUES ('user1', 'user1@example.com')"
    db.execute_query(query, response=False)
    return 'insert was succesful!'


@bp.route('/view')
def view_users():
    query = "SELECT * FROM users"
    rows = db.execute_query(query)
    users = [dict(row.items()) for row in rows]
    return users

@bp.route('/delete')
def delete_user_by_mail():
    query = f"DELETE FROM users WHERE mail = 'user1@example.com'"
    db.execute_query(query, response=False)
    return 'delete was succesful!'


"""
from google.auth.transport import requests
from google.oauth2 import id_token

CLIENT_ID = "YOUR_GOOGLE_CLIENT_ID"

@app.route("/login/google", methods=["POST"])
def google_login():
    token = request.json.get("token")
    try:
        # Verify the token
        idinfo = id_token.verify_oauth2_token(token, requests.Request(), CLIENT_ID)

        if idinfo['iss'] not in ['accounts.google.com', 'https://accounts.google.com']:
            raise ValueError('Wrong issuer.')

        # Extract user info
        user_id = idinfo['sub']
        email = idinfo['email']
        name = idinfo['name']

        # Here, you can check if the user exists in your database.
        # If not, create a new user.

        # Return user info
        return jsonify({"user_id": user_id, "email": email, "name": name})

    except ValueError:
        return jsonify({"error": "Invalid token"}), 401
"""