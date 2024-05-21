from flask import Flask
from .config import Config
from flask_session import Session
from firebase_admin import credentials, auth, initialize_app


def create_app():
  app = Flask(__name__)
  app.config.from_object(Config)

  # Initialize Firebase Admin SDK
  initialize_app()
  Session(app)

  from .routes import users
  app.register_blueprint(users.bp)

  return app
