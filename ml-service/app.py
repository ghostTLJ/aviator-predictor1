from flask import Flask, request, jsonify
from flask_cors import CORS
import os

app = Flask(__name__)
CORS(app)

PORT = int(os.getenv('PORT', 5001))

@app.route('/health', methods=['GET'])
def health():
    return jsonify({'status': 'OK', 'service': 'ML Service'}), 200

@app.route('/api/predict', methods=['POST'])
def predict():
    return jsonify({
        'prediction': 2.45,
        'confidence': 0.78,
        'model': 'random_forest'
    }), 200

@app.route('/api/models', methods=['GET'])
def get_models():
    return jsonify({
        'models': [
            {'id': 'rf_classifier', 'name': 'Random Forest Classifier', 'accuracy': 0.82},
            {'id': 'linear_regression', 'name': 'Linear Regression', 'accuracy': 0.75}
        ]
    }), 200

if __name__ == '__main__':
    print(f'🚀 ML Service running on port {PORT}')
    app.run(host='0.0.0.0', port=PORT)