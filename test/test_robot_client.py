import socketio
from dotenv import load_dotenv
import os

# Create a Socket.IO client
sio = socketio.Client()

@sio.event
def connect():
    print('Connected to server')
    sio.emit('ping')
    handle_user_input()

@sio.event
def disconnect():
    sio.emit('disconnect')
    print('Disconnected from server')

@sio.event
def message(data):
    print(f'Server says: {data}')

@sio.event
def status(data):
    print(data['message'])

def handle_user_input():
    while True:
        action = input("Enter 'join' to join a room, 'leave' to leave a room, or 'exit' to quit: ").strip().lower()
        print(action)
        if action == 'join':
            code = input("Enter the room code to join: ").strip()
            sio.emit('join', {'code': code})
        elif action == 'leave':
            code = input("Enter the room code to leave: ").strip()
            sio.emit('leave', {'code': code})
        elif action == 'ping':
            print("Ping...")
            sio.emit('ping')
        elif action == 'exit':
            print("Exiting...")
            sio.disconnect()
            break
        else:
            print("Invalid action. Please enter 'join', 'leave', or 'exit'.")


if __name__ == '__main__':
    load_dotenv()
    # Connect to the Flask SocketIO server
    sio.connect(os.environ.get("SERVER_URL"))
    sio.wait()
