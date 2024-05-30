from google.cloud import storage
import os

class CloudBucket:
    def __init__(self, bucket_name, credentials_path):
        self.bucket_name = bucket_name
        self.storage_client = storage.Client.from_service_account_json(credentials_path)
        self.bucket = self.storage_client.bucket(bucket_name)

    def upload_file(self, local_file_path, remote_file_name, content_type):
        blob = self.bucket.blob(remote_file_name)
        blob.upload_from_file(local_file_path, content_type=content_type)
        blob.make_public()

    def download_file(self, remote_file_name, local_file_path):
        blob = self.bucket.blob(remote_file_name)
        blob.download_to_filename(local_file_path)

    def delete_file(self, remote_file_name):
        blob = self.bucket.blob(remote_file_name)
        blob.delete()

    def get_file_url(self, remote_file_name):
        blob = self.bucket.blob(remote_file_name)
        return blob.public_url
    
image_folder = CloudBucket(os.environ.get("CLOUD_IMAGE_FOLDER"), os.environ.get('GOOGLE_APPLICATION_CREDENTIALS'))
