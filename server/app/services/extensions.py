# extensions.py
from flask_socketio import SocketIO

socketio = SocketIO(cors_allowed_origins="*", ping_timeout=300)
