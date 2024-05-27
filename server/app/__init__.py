from flask import Flask
from .config import Config
from flask_session import Session
from firebase_admin import initialize_app
import os

def create_app():
  app = Flask(__name__)
  app.config.from_object(Config)
  app.secret_key = os.environ.get('FLASK_SECRET_KEY')


  # Initialize Firebase Admin SDK
  initialize_app()
  Session(app)

  from app.routes import bp
  app.register_blueprint(bp)

  return app
