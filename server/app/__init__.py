from flask import Flask
from .config import Config
from flask_session import Session
from firebase_admin import initialize_app
from app.utils import extensions as e

def create_app():
  app = Flask(__name__)
  app.config.from_object(Config)

  # Initialize Firebase Admin SDK
  initialize_app()
  Session(app)

  e.socketio.init_app(app)

  from app.routes import users, robots
  app.register_blueprint(users.bp)
  #app.register_blueprint(robots.bp)

  return app
