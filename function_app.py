import os
import time
import json
from datetime import datetime
import azure.functions as func
from azure.storage.queue import QueueClient
from random import random

def generate_point():
    return {
        "x": random(),
        "y": random(),
        "timestamp": datetime.utcnow().isoformat()
    }

def main(req: func.HttpRequest) -> func.HttpResponse:
    queue_conn_str = os.environ["AzureWebJobsStorage"]
    queue_name = os.environ.get("QUEUE_NAME", "queue-montecarlo")
    queue_client = QueueClient.from_connection_string(queue_conn_str, queue_name)

    duration_seconds = 300  # 5 minutes
    messages_per_second = 1000
    start_time = time.time()
    sent = 0

    while time.time() - start_time < duration_seconds:
        batch = [generate_point() for _ in range(messages_per_second)]
        for msg in batch:
            queue_client.send_message(json.dumps(msg))
        sent += messages_per_second
        time.sleep(1)  # Attendre 1 seconde

    return func.HttpResponse(f"Sent {sent} messages in {duration_seconds} seconds.", status_code=200)