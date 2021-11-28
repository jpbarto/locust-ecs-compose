FROM locustio/locust

COPY start-locust-from-s3.sh /home/locust/start-locust-from-s3.sh

ENTRYPOINT ["/home/locust/start-locust-from-s3.sh"]
