import time
from locust import HttpUser, task, between
import uuid

AUID = uuid.uuid4()

class QuickstartUser(HttpUser):
    wait_time = between(1, 2)

    @task
    def hello_world(self):
        self.client.get("/")

    def on_start(self):
        print ("Locust agent {} is running...".format (AUID})
