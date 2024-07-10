from flask import Flask, request, jsonify, send_file
from flask_cors import CORS  # Import CORS
import os
import uuid
from PIL import Image
from io import BytesIO

app = Flask(__name__)
CORS(app)  # Enable CORS for the app

UPLOAD_FOLDER = 'uploads'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

@app.route('/upload', methods=['POST'])
def upload_images():
    project_name = request.form.get('project_name')
    images = []
    for i in range(1, 3):
        image_file = request.files.get(f'image{i}')
        if image_file:
            images.append(image_file)

    if not images:
        return jsonify({'error': 'No images provided'}), 400

    saved_filenames = []
    for image in images:
        filename = f"{uuid.uuid4().hex}.jpg"
        filepath = os.path.join(UPLOAD_FOLDER, filename)
        image.save(filepath)
        saved_filenames.append(filename)

    grayscale_filenames = []
    for filename in saved_filenames:
        image_path = os.path.join(UPLOAD_FOLDER, filename)
        grayscale_image = Image.open(image_path).convert('L')
        grayscale_filename = f"grayscale_{filename}"
        grayscale_path = os.path.join(UPLOAD_FOLDER, grayscale_filename)
        grayscale_image.save(grayscale_path)
        grayscale_filenames.append(grayscale_filename)

    return jsonify({'filenames': grayscale_filenames}), 200

@app.route('/image/<filename>', methods=['GET'])
def get_image(filename):
    return send_file(os.path.join(UPLOAD_FOLDER, filename), mimetype='image/jpeg')

if __name__ == '__main__':
    app.run(port=4000, debug=True)
