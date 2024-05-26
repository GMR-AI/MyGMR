from dotenv import load_dotenv
import json
import os
from enum import Enum
import keyboard
import argparse

class State(Enum):
    IDLE = 0
    REQUESTING = 1
    WORKING = 2
    FINISHING = 3

class CON_STATUS(Enum):
    OFFLINE = 0
    ONLINE = 1

import requests
import time

class RobotClient:
    def __init__(self, server_url, data, debug=False):
        self.server_url = server_url
        self.code = data['matricula']
        self.active_job = None
        self.robot_state = State.IDLE
        self.connection = CON_STATUS.OFFLINE
        self.debug = debug

    def ping(self):
        try:
            response = requests.post(f"{self.server_url}/ping", json={'code': self.code})
            # Check for any logs
            data = response.json()
            log = data.get("message")

            if log: 
                print("Server says: ", log)
            if response.status_code == 200:

                if self.connection == CON_STATUS.OFFLINE:
                    print("Robot is online.")
                    self.connection = CON_STATUS.ONLINE
                                
            elif response.status_code == 201:
                print("Requesting...")
                self.robot_state = State.REQUESTING
            else:
                print("Failed to go online:", response.status_code)
                self.connection = CON_STATUS.OFFLINE

        except requests.RequestException as e:
            self.connection = CON_STATUS.OFFLINE
            print("Error in connection, maybe server is offline")
            if self.debug:
                print("Error:", e)


    def get_active_job(self):
        try:
            response = requests.post(f"{self.server_url}/active_job", json={'code': self.code})
            if response.status_code == 200:
                data = response.json()
                return data.get('active_job')
            else:
                print("Failed to retrieve active job:", response.status_code)
        except requests.RequestException as e:
            print("Error:", e)
        return None
    
    def check_request(self):
        try:
            response = requests.post(f"{self.server_url}/check_request", json={'code': self.code})
            if response.status_code == 200:
                # If everything is correct return to default state
                self.robot_state = State.IDLE
        except requests.RequestException as e:
            print("Error:", e)

    def do_task(self, task):
        print("Doing task:", task)
        if task == "Upload teapot.obj":
            self.upload_file("teapot.obj")

    def upload_file(self, file_path):
        try:
            with open(file_path, 'rb') as file:
                files = {'file': (file_path, file)}
                response = requests.post(f"{self.server_url}/upload_file", files=files)
                if response.status_code == 200:
                    print("File uploaded successfully.")
                else:
                    print("Failed to upload file:", response.status_code, response.json())
        except Exception as e:
            print("Error:", e)

    def run(self):
        while True:
            time.sleep(3)
            self.ping()

            # No online, no new activities
            if self.connection == CON_STATUS.OFFLINE:
                continue
            
            if self.robot_state == State.IDLE: # Unemployed, get a job
                new_active_job = self.get_active_job()
                if new_active_job != self.active_job:
                    if new_active_job is not None:
                        self.do_task(new_active_job)
                    self.active_job = new_active_job

            elif self.robot_state == State.REQUESTING: # Check for the request
                self.check_request()

            # Either working or finishing a job on a different thread, simply do a health check (ping next iteration)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Robot Client")
    parser.add_argument('--debug', action='store_true', help='Enable debug mode')
    args = parser.parse_args()


    load_dotenv()
    with open("robot_data.json", 'r') as file:
        data = json.load(file)
    # gcloud test
    #server_url = os.environ.get("SERVER_URL")
    # local test
    server_url = "http://localhost:8080"
    client = RobotClient(server_url, data, args.debug)
    client.run()