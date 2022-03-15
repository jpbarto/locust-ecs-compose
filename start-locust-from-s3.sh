#!/bin/sh

set -e

if [ -z "$S3LOCUSTFILE" ]; then
    cat >/home/locust/locustfile.py <<EOF
import time
from locust import HttpUser, task, between, constant_pacing
import uuid

AUID = uuid.uuid4()

class QuickstartUser(HttpUser):
    wait_time = constant_pacing(1)

    @task
    def hello_world(self):
        self.client.get("/")

    @task
    def hello_data(self):
        self.client.get("/data")

    def on_start(self):
        print("Locust agent {} is running...".format(AUID))
EOF
else
    aws s3 cp ${S3LOCUSTFILE} /home/locust/locustfile.py
fi

locust -f /home/locust/locustfile.py $@
