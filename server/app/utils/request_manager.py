# Singelton class which handles new pending requests

from datetime import datetime, timedelta

class robot_queue:
    _instance = None
    _queue = []

    def __new__(cls, *args, **kwargs):
        if not cls._instance:
            cls._instance = super(robot_queue, cls).__new__(cls, *args, **kwargs)
        return cls._instance

    def add_to_queue(self, code, expiration_minutes=5):
        expiration_time = datetime.now() + timedelta(minutes=expiration_minutes)
        self._queue.append({'code': code, 'expires_at': expiration_time})

    def remove_from_queue(self, code):
        for item in self._queue:
            if item['code'] == code:
                self._queue.remove(item)
                return True
        return False

    def get_queue(self):
        self._cleanup_expired()
        return self._queue

    def _cleanup_expired(self):
        current_time = datetime.now()
        self._queue = [item for item in self._queue if item['expires_at'] > current_time]

