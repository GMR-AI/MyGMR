from dotenv import load_dotenv
import json
import os
from enum import Enum
import argparse
from google.cloud import storage
from ply2jpg import run_convertion

import trimesh
import os

def convert_obj_to_glb(file_path):
    # Load the OBJ file
    mesh = trimesh.load(file_path)

    # Change the file extension to .glb
    glb_file_path = os.path.splitext(file_path)[0] + '.glb'

    # Export the mesh to GLB format
    mesh.export(glb_file_path, file_type='glb')

    print(f"Converted {file_path} to {glb_file_path}")

def upload_to_gcs(file_path, destination_blob_name):
    # Initialize a storage client
    storage_client = storage.Client()
    bucket = storage_client.bucket(os.environ.get("BUCKET_NAME"))
    blob = bucket.blob(destination_blob_name)

    # Upload the file
    blob.upload_from_filename(file_path)
    blob.make_public()

    print(f"File {file_path} uploaded to {destination_blob_name}.")



# Ordenes que el usuario puede enviar directamente al robot (estas se resetean a NONE una vez el robot reciba la orden)
class j_status(Enum):
    NONE = 0 # No updates
    NEW_JOB = 1 # User requested 3D model and top image
    START_JOB = 2 # User has uploaded the new job
    UPDATE_JOB = 3 # User recalls any update in the actual job?
    CANCEL_JOB = 4 # User has canceled the job


class State(Enum):
    IDLE = 0
    REQUESTING = 1
    WORKING = 2
    FINISHING = 3

class CON_STATUS(Enum):
    OFFLINE = 0
    ONLINE = 1

class Job:
    def __init__(self, server_url, data, debug=False):
        self.server_url = server_url
        self.code = data['matricula']
        self.model = data['model_id']
        self.active_job = None
        self.robot_state = State.IDLE
        self.connection = CON_STATUS.OFFLINE
        self.debug = debug

import requests
import time

class RobotClient:

################# ATRIBUTES ######################


    def __init__(self, server_url, data, debug=False):
        self.server_url = server_url
        self.code = data['matricula']
        self.model = data['model_id']
        self.active_job = None
        self.robot_state = State.IDLE
        self.connection = CON_STATUS.OFFLINE
        self.debug = debug

################# HEALTH CHECKS #################

    def log_message(self, response):
            # Check for any logs
            data = response.json()
            log = data.get("message")

            if log: 
                print("Server says: ", log)

    def ping(self):
        try:
            response = requests.post(f"{self.server_url}/ping", json={'code': self.code})
            if response.status_code == 200:
                self.log_message(response)
                if self.connection == CON_STATUS.OFFLINE:
                    print("Robot is online.")
                    self.connection = CON_STATUS.ONLINE
                    # Reanudate status
                    self.reanudate_status()
                                
            elif response.status_code == 201:
                if self.robot_state != State.REQUESTING:
                    print("Requesting...")
                    self.send_request()
            else:
                print("Failed to go online:", response.status_code)
                self.connection = CON_STATUS.OFFLINE

        except requests.RequestException as e:
            self.connection = CON_STATUS.OFFLINE
            print("Error in connection, maybe server is offline")
            if self.debug:
                print("Error:", e)

    def reanudate_status(self):
        try:
            response = requests.post(f"{self.server_url}/active_job", json={'code': self.code})
            data = response.json()
            if data:
                self.parse_job_status(data)
        except requests.RequestException as e:
            print("Error:", e)
        return None

################# REQUESTING #################

    def send_request(self):
        try:
            response = requests.post(f"{self.server_url}/new_request", json={'code': self.code, 'model': self.model})
            if response.status_code == 201:
                # If everything is correct return to default state
                self.robot_state = State.REQUESTING
                self.log_message(response)
        except requests.RequestException as e:
            print("Error:", e)

    def check_request(self):
        try:
            response = requests.post(f"{self.server_url}/check_request", json={'code': self.code})
            if response.status_code == 200:
                # If everything is correct return to default state
                self.robot_state = State.IDLE
        except requests.RequestException as e:
            print("Error:", e)

################# IDLE #################

    def check_job_updates(self):
        try:
            response = requests.post(f"{self.server_url}/active_job", json={'code': self.code})
            if response.status_code == 200:
                data = response.json()
                self.parse_job_status(data)
            else:
                print("Failed to retrieve active job:", response.status_code)
        except requests.RequestException as e:
            print("Error:", e)
        return None
    
    def parse_job_status(self, data):
        job_status_str =  data.get('job_status')
        job_status = j_status[job_status_str]

        if job_status == j_status.NONE:
            return
        elif job_status == j_status.NEW_JOB:
           if job_status == State.WORKING and self.active_job != None:
                print("Cancelling current job...")
                self.cancel_task()

           self.new_job()
        elif job_status == j_status.START_JOB:
            job_data = data.get('job_data')
            if not job_data:
                print("Error: Job data was not given, cancelling...")
                return
            self.robot_state = State.WORKING

            if job_status == State.WORKING and self.active_job != None:
                if self.active_job.id == job_data['id']:
                    print("Already doing the job")
                    return

                print("Cancelling current job...")
                self.cancel_task()
            else:
                job_status = State.WORKING

            # Llamada a la funcion ROS legendaria 1
            return
        elif job_status == j_status.CANCEL_JOB:
            print("Canceling...")
            self.cancel_task()
            self.robot_state=State.IDLE
            return
        elif job_status == j_status.UPDATE_JOB:
            # Enviar datos del job
            return

################# JOBS #################

    def do_task(self):
        print("Planning the task...")
        # Funcion del path planner
        time.sleep(5)
        print("Plan was sent to ROS2")
        # Enviar tasca al nodo de ROS 2
        return

    def cancel_task(self):
        time.sleep(10)
        self.send_finished()
        return
    
    def new_job(self):
        print('Making a reconstruction...')
        # Funcion de reconstruccion

        convert_obj_to_glb('obj_dataset/gmr.obj')

        print('Making the top image...')
        #run_convertion('ply_dataset', 'image_dataset')

        print('Sending data')
        upload_to_gcs('obj_dataset/gmr.glb', f'{self.code}_gmr.glb')
        upload_to_gcs('image_dataset/gmr.jpg', f'{self.code}_gmr.jpg')
        self.send_finished()

    def send_finished(self):
        try:
            data = {'code': self.code}
            response = requests.post(f"{self.server_url}/job_finished", json={'code': self.code})
            if response.status_code == 200:
                print("Task finished successfully.")
            else:
                print("Failed to notify the finished task:", response.status_code, response.json())
        except Exception as e:
            print("Error:", e)

################# MAIN LOOP #################

    def run(self):
        while True:
            time.sleep(3)
            self.ping()
            print("State: ", self.robot_state)
            # No online, no new activities
            if self.connection == CON_STATUS.OFFLINE:
                continue
            elif self.robot_state == State.REQUESTING: # Check for the request
                self.check_request()
            else: # Unemployed, get a job
                self.check_job_updates()

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Robot Client")
    parser.add_argument('--debug', action='store_true', help='Enable debug mode')
    args = parser.parse_args()


    load_dotenv()
    with open("robot_data.json", 'r') as file:
        data = json.load(file)
    # gcloud test
    server_url = os.environ.get("SERVER_URL")
    # local test
    #server_url = "http://localhost:8080"
    client = RobotClient(server_url, data, args.debug)
    client.run()