from flask import Flask
from .config import Config

def create_app():
  app = Flask(__name__)
  app.config.from_object(Config)

  from .routes import users
  app.register_blueprint(users.bp)

  return app
