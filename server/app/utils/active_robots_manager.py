# Singelton class which handles active room robots
from datetime import datetime, timedelta
from enum import Enum

# Ordenes que el usuario puede enviar directamente al robot (estas se resetean a NONE una vez el robot reciba la orden)
class j_status(Enum):
    NONE = 0 # No updates
    NEW_JOB = 1 # User requested 3D model and top image
    START_JOB = 2 # User has uploaded the new job
    UPDATE_JOB = 3 # User recalls any update in the actual job?
    CANCEL_JOB = 4 # User has canceled the job

class robot_manager:
    _instance = None
    _queue = {}
    _update_time=5

    def __new__(cls, *args, **kwargs):
        if not cls._instance:
            cls._instance = super(robot_manager, cls).__new__(cls, *args, **kwargs)
        return cls._instance

    def add_to_queue(self, code, expiration_minutes=_update_time):
        self._cleanup_expired()
        if code in self._queue.keys():
            return False
        
        expiration_time = datetime.now() + timedelta(minutes=expiration_minutes)
        self._queue[code]={'message': None, 'expires_at': expiration_time, 'job_status': j_status.NONE}
        
        return True

    def remove_from_queue(self, code):
        if code in self._queue:
            print("Robot ", self._queue[code], " disconnected")
            # TODO: Update state in the db if necessary
            del self._queue[code]
            return True
        return False

    def get_queue(self):
        self._cleanup_expired()
        return self._queue
    
    def update_job(self, code, status):
        self._cleanup_expired()
        if code in self._queue.keys() and status in j_status:
            self._queue[code]['job_status'] = status
        else:
            print("Either didn't get the code: ", code, " in ", self._queue.keys())
            print("Or status: ", status, "is not a j_status")


    def exists_in_queue(self, code):
        self._cleanup_expired()
        return code in self._queue.keys()

    def ping(self, code): # Update, return message, reset message
        if self.exists_in_queue(code):
            self._queue[code]['expires_at'] = datetime.now() + timedelta(minutes=self._update_time)
            ret = self._queue[code]['message'] 
            self._queue[code]['message'] = None
            return ret
        
        return None
        
    def _cleanup_expired(self):
        current_time = datetime.now()
        keys_to_delete=[]
        for c, item in self._queue.items():
            if item['expires_at'] < current_time:
                keys_to_delete.append(c)
        for c in keys_to_delete:
            del self._queue[c]

active_rm = robot_manager()