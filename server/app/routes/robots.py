from app.routes import bp
from app.services import cloud_sql as db
from app.utils import robot_queue as rb

from flask import Flask, request, jsonify, session
from firebase_admin import auth

@bp.route('/request_robot')