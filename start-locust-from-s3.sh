#!/bin/sh

set -e

if [ -z "$S3LOCUSTFILE" ]; then
    cat >/home/locust/locustfile.py <<EOF
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
        print("Locust agent {} is running...".format(AUID))
EOF
else
    aws s3 cp ${S3LOCUSTFILE} /home/locust/locustfile.py
fi

locust -f /home/locust/locustfile.py $@
