import azure.functions as func
import json
import logging
import os
import random
import time
from datetime import datetime

# Configuration de logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Création de l'application Function
app = func.FunctionApp()

def generate_point(batch_id: str) -> dict:
    """Génère un point aléatoire pour Monte Carlo"""
    return {
        "x": random.uniform(0, 1),
        "y": random.uniform(0, 1),
        "batch_id": batch_id,
        "timestamp": datetime.utcnow().isoformat()
    }

@app.function_name(name="StartProducer")
@app.route(route="start", methods=["POST"])
def start_producer(req: func.HttpRequest) -> func.HttpResponse:
    """
    Démarre la production de points Monte Carlo
    
    Parameters (optionnels via POST JSON):
    - duration: durée en minutes (default: 5)
    - override_rate: override du rate (default: env var)
    - override_batch_size: override du batch_size (default: env var)
    """
    logger.info("Producer start requested")
    
    try:
        # Configuration depuis environment variables
        producer_id = os.environ.get("PRODUCER_ID", "prod01")
        default_rate = int(os.environ.get("RATE", "100"))
        default_batch_size = int(os.environ.get("BATCH_SIZE", "1000"))
        
        # Paramètres depuis la requête (optionnels)
        req_body = {}
        try:
            req_body = req.get_json() or {}
        except ValueError:
            pass
            
        duration_minutes = req_body.get("duration", 5)
        rate = req_body.get("override_rate", default_rate)
        batch_size = req_body.get("override_batch_size", default_batch_size)
        
        logger.info(f"Starting producer {producer_id}: rate={rate}, batch_size={batch_size}, duration={duration_minutes}min")
        
        # Génération du batch ID unique
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S_%f')
        batch_id = f"batch_{producer_id}_{timestamp}"
        
        # Simulation production (pour test sans Service Bus)
        total_points = 0
        start_time = time.time()
        end_time = start_time + (duration_minutes * 60)
        
        points_generated = []
        while time.time() < end_time and len(points_generated) < batch_size:
            # Génération d'un point
            point = generate_point(batch_id)
            points_generated.append(point)
            total_points += 1
            
            # Rate limiting - pause entre points
            if rate > 0:
                time.sleep(1.0 / rate)
            
            # Log progress
            if total_points % 100 == 0:
                logger.info(f"Generated {total_points} points...")
        
        duration_actual = time.time() - start_time
        actual_rate = total_points / duration_actual if duration_actual > 0 else 0
        
        result = {
            "status": "completed",
            "producer_id": producer_id,
            "batch_id": batch_id,
            "total_points_generated": total_points,
            "duration_seconds": round(duration_actual, 2),
            "actual_rate_points_per_second": round(actual_rate, 2),
            "target_rate": rate,
            "batch_size": batch_size,
            "sample_points": points_generated[:5] if points_generated else []  # First 5 for demo
        }
        
        logger.info(f"Production completed: {result}")
        
        return func.HttpResponse(
            json.dumps(result),
            status_code=200,
            mimetype="application/json"
        )
        
    except Exception as e:
        error_msg = f"Error in producer: {str(e)}"
        logger.error(error_msg)
        return func.HttpResponse(
            json.dumps({"status": "error", "message": error_msg}),
            status_code=500,
            mimetype="application/json"
        )

@app.function_name(name="ProducerStatus")
@app.route(route="status", methods=["GET"])
def producer_status(req: func.HttpRequest) -> func.HttpResponse:
    """Retourne le statut et la configuration du producer"""
    
    config = {
        "producer_id": os.environ.get("PRODUCER_ID", "prod01"),
        "rate": int(os.environ.get("RATE", "100")),
        "batch_size": int(os.environ.get("BATCH_SIZE", "1000")),
        "status": "ready",
        "version": "1.0.0-minimal"
    }
    
    return func.HttpResponse(
        json.dumps(config),
        status_code=200,
        mimetype="application/json"
    )

@app.function_name(name="HealthCheck")
@app.route(route="health", methods=["GET"])
def health_check(req: func.HttpRequest) -> func.HttpResponse:
    """Health check endpoint"""
    return func.HttpResponse(
        json.dumps({
            "status": "healthy", 
            "timestamp": datetime.utcnow().isoformat(),
            "version": "1.0.0-minimal"
        }),
        status_code=200,
        mimetype="application/json"
    )