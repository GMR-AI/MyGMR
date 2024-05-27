import os
from dotenv import load_dotenv


load_dotenv()
class Config:
  GOOGLE_APPLICATION_CREDENTIALS = os.environ.get("GOOGLE_APPLICATION_CREDENTIALS")
  SQLALCHEMY_TRACK_MODIFICATIONS = False
  # Configure session to use filesystem (server-side sessions)
  SESSION_TYPE = 'filesystem'
  SESSION_PERMANENT=False
  SECRET_KEY = os.environ.get("FLASK_SECRET_KEY")
