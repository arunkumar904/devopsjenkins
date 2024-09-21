from flask import Flask, send_from_directory, jsonify
import os

app = Flask(__name__, static_folder='frontend/build')

# Serve the main frontend page
@app.route('/')
def serve_frontend():
    return send_from_directory(app.static_folder, 'index.html')

# Serve static files (e.g., JS, CSS) from the build directory
@app.route('/<path:path>')
def serve_static(path):
    return send_from_directory(app.static_folder, path)

# Example API endpoint
@app.route('/api/health', methods=['GET'])
def health_check():
    return jsonify({"status": "healthy"}), 200

# Handle 404 errors
@app.errorhandler(404)
def not_found(e):
    return jsonify({"error": "Not found"}), 404

# Run the application
if __name__ == "__main__":
    port = int(os.environ.get("PORT", 80))
    app.run(host="0.0.0.0", port=port)
