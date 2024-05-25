# Singelton class which handles active room robots

class robot_manager:
    _instance = None
    _queue = {}

    def __new__(cls, *args, **kwargs):
        if not cls._instance:
            cls._instance = super(robot_manager, cls).__new__(cls, *args, **kwargs)
        return cls._instance

    def exists_in_queue(self, room, sid):
        return room in self._queue or sid in self._queue.values()
    
    def add_to_queue(self,room, sid):
        self._queue[room]=sid


    def remove_from_queue(self, code):
        if code in self._queue:
                del self._queue[code]
                return True
        return False

    def get_queue(self):
        return self._queue

active_rm = robot_manager()