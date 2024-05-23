from flask import Flask
from flask_cors import CORS
from .config import Config
from flask_session import Session
from firebase_admin import initialize_app
from app.services import socketio

def create_app():
  app = Flask(__name__)
  app.config.from_object(Config)

  # Initialize Firebase Admin SDK
  initialize_app()
  Session(app)

  app = Flask(__name__)
  CORS(app, resources={r"/*":{"origins":"*"}})

  socketio.init_app(app)

  from app.routes import bp
  app.register_blueprint(bp)

  return app
