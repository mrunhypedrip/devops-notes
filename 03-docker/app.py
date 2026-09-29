from flask import Flask, jsonify
import redis
import os

app = Flask(__name__)
r = redis.Redis(host=os.getenv('REDIS_HOST', 'localhost'), port=6379, db=0)

@app.route('/health')
def health():
    return jsonify({"status": "healthy", "service": "python-api"}), 200

@app.route('/api/v1/hits')
def hits():
    count = r.incr('hits')
    return jsonify({"message": "Production Microservice Active", "visitor_count": count}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
