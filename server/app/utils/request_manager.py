# Singelton class which handles new pending requests

from datetime import datetime, timedelta

class robot_queue:
    _instance = None
    _queue = {}

    def __new__(cls, *args, **kwargs):
        if not cls._instance:
            cls._instance = super(robot_queue, cls).__new__(cls, *args, **kwargs)
        return cls._instance

    def add_to_queue(self, code, model, expiration_minutes=5):
        if code in self._queue.keys():
            return False
        
        expiration_time = datetime.now() + timedelta(minutes=expiration_minutes)
        self._queue[code] = {'expires_at': expiration_time, 'model': model}
        return True

    def remove_from_queue(self, code):
        for c in self._queue.keys():
            if c == code:
                return self._queue.pop(c)
        return None

    def get_queue(self):
        self._cleanup_expired()
        return self._queue
    
    def exists_in_queue(self, code):
        self._cleanup_expired()
        return code in self._queue.keys()


    def _cleanup_expired(self):
        current_time = datetime.now()
        delete_keys=[]
        for c, item in self._queue.items():
            if item['expires_at'] < current_time:
                delete_keys.append(c)
        for c in delete_keys:
            del self._queue[c]

