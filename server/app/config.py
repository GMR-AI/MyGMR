import os
from dotenv import load_dotenv


load_dotenv()
class Config:
  GOOGLE_APPLICATION_CREDENTIALS = os.environ.get("GOOGLE_APPLICATION_CREDENTIALS")
  SQLALCHEMY_TRACK_MODIFICATIONS = False