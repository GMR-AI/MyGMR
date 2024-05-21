# Singelton class which handles new pending requests

class robot_queue:
    _instance = None
    _queue = []

    def __new__(cls, *args, **kwargs):
        if not cls._instance:
            cls._instance = super(robot_queue, cls).__new__(cls, *args, **kwargs)
        return cls._instance

    def add_to_queue(self, code):
        self._queue.append(code)

    def remove_from_queue(self, code):
        if code in self._queue:
            self._queue.remove(code)
            return True
        return False

    def get_queue(self):
        return self._queue
