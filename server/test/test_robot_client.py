import socketio
from dotenv import load_dotenv
import json
import os
from enum import Enum
import keyboard  

# Create a Socket.IO client
sio = socketio.Client()

class State(Enum):
    IDLE = 0
    REQUESTING = 1

robot_state = State.IDLE


@sio.event
def connect():
    print('Connected to server')
    go_online()

def go_online():
    print("going online...")
    sio.emit('go_online', {'code': data['matricula']})

@sio.event
def disconnect():
    sio.emit('disconnect')
    print('Disconnected from server')

@sio.event
def requesting():
    robot_state = State.REQUESTING
    print("Requesting for new user...")

@sio.event
def request_successful():
    if robot_state is State.REQUESTING:
        print("Request was succesful!")
        robot_state = State.IDLE

# Logging
@sio.event
def error(data):
    mes=data['message']
    print(f'ERROR: {mes}')

@sio.event
def message(data):
    print(f'Server says: {data}')

@sio.event
def status(data):
    print(data['message'])

if __name__ == '__main__':
    load_dotenv()
    with open("robot_data.json", 'r') as file:
        data = json.load(file)
    # gcloud test
    sio.connect(os.environ.get("SERVER_URL"))
    #Local test
    #sio.connect('http://localhost:8080')

    #Input
    # Listen for key presses in a separate thread
    # def check_key_presses():
    #     while True:
    #         if keyboard.is_pressed('enter'):  # You can specify a specific key if needed
    #             go_online()
    #             while keyboard.is_pressed('enter'):  # Wait until the key is released to avoid multiple calls
    #                 pass

    # import threading
    # key_listener_thread = threading.Thread(target=check_key_presses, daemon=True)
    # key_listener_thread.start()


    sio.wait()
