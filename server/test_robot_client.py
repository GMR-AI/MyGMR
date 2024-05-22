import requests
import websocket
import json

def send_code_to_queue(code):
    url = "http://127.0.0.1:8080/robot_request"
    payload = {"code": code}
    response = requests.post(url, json=payload)
    return response.json()

def on_message(ws, message):
    data = json.loads(message)
    if 'code' in data and data['code'] == code:
        print(f"Received message for {code}: {data['message']}")

def on_error(ws, error):
    print(f"Error: {error}")

def on_close(ws):
    print("### closed ###")

def on_open(ws):
    def run(*args):
        ws.send(json.dumps({'code': code, 'action': 'join'}))
    run()

if __name__ == "__main__":
    code = "unique_code_123"
    send_response = send_code_to_queue(code)
    print(send_response)
    
    websocket_url = "ws://127.0.0.1:8080/socket.io/?EIO=4&transport=websocket"
    ws = websocket.WebSocketApp(websocket_url,
                                on_message=on_message,
                                on_error=on_error,
                                on_close=on_close)
    ws.on_open = on_open
    ws.run_forever()
