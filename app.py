import joblib
import numpy as np
from flask import Flask, jsonify, request

model = joblib.load("./models/housing_model.pkl")

app = Flask(__name__)


@app.route('/predict', methods=['POST'])
def predict():
    input_data = request.get_json()
    features = np.array(input_data['features']).reshape(1, -1)
    prediction = model.predict(features)[0]
    return jsonify({"prediction": prediction})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001)
