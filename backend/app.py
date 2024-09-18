from flask import Flask, jsonify, send_from_directory
import os

app = Flask(__name__)

@app.route('/')
def serve_frontend():
    return send_from_directory('frontend/build', 'index.html')

# Set the port from environment variable or default to 8080
if __name__ == '__main__':
    port = int(os.environ.get('PORT', 8080))
    app.run(host='0.0.0.0', port=port)
