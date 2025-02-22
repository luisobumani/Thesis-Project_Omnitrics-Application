from flask import Flask, request, send_file, jsonify
from flask_cors import CORS
import numpy as np
import cv2
import io

app = Flask(__name__)
CORS(app)  # Enable CORS if your Flutter app is on a different domain/port

# ---------------------------------------------------------------
# Color Conversion Functions (sRGB <-> Linear)
# ---------------------------------------------------------------
def srgb_to_linear(img):
    threshold = 0.04045
    return np.where(img <= threshold, img / 12.92, ((img + 0.055) / 1.055) ** 2.4)

def linear_to_srgb(linear):
    return np.where(linear <= 0.0031308, 12.92 * linear, 1.055 * (linear ** (1/2.4)) - 0.055)

# ---------------------------------------------------------------
# LMS Conversion Matrices (using Bradford transform)
# ---------------------------------------------------------------
M_sRGB_to_XYZ = np.array([
    [0.4124564, 0.3575761,  0.1804375],
    [0.2126729, 0.7151522,  0.0721750],
    [0.0193339, 0.1191920,  0.9503041]
])
M_Bradford = np.array([
    [ 0.8951,  0.2664, -0.1614],
    [-0.7502,  1.7135,  0.0367],
    [ 0.0389, -0.0685,  1.0296]
])
M_sRGB_to_LMS = M_Bradford @ M_sRGB_to_XYZ
M_LMS_to_sRGB = np.linalg.inv(M_sRGB_to_LMS)

# ---------------------------------------------------------------
# LMS-space Filter Matrices
# ---------------------------------------------------------------
filters = {
    "deuteranopia": np.array([
        [1.0,        0.0,        0.0      ],
        [0.9513092,  0.0,        0.04866992],
        [0.0,        0.0,        1.0      ]
    ]),
    "protanopia": np.array([
        [0.0,       1.05118294, -0.05116099],
        [0.0,       1.0,         0.0],
        [0.0,       0.0,         1.0]
    ]),
    "tritanopia": np.array([
        [1.0,       0.0,         0.0],
        [0.0,       1.0,         0.0],
        [-0.395913, 0.801109,    0.0]
    ])
}

# ---------------------------------------------------------------
# Function to Process Image Using the LMS Method
# ---------------------------------------------------------------
def apply_colorblindness_filter_cv(image, filter_type="deuteranopia"):
    # Convert image from BGR to RGB and scale to [0,1]
    rgb = cv2.cvtColor(image, cv2.COLOR_BGR2RGB).astype(np.float32) / 255.0

    # Convert sRGB -> Linear RGB
    linear = srgb_to_linear(rgb)

    # Convert Linear RGB -> LMS
    lms = np.tensordot(linear, M_sRGB_to_LMS.T, axes=([2], [0]))

    # Get filter matrix for the requested type
    filter_matrix = filters.get(filter_type.lower())
    if filter_matrix is None:
        raise ValueError("Unknown filter type: " + filter_type)

    # Apply LMS filter
    lms_filtered = np.tensordot(lms, filter_matrix.T, axes=([2], [0]))

    # Convert LMS -> Linear RGB
    linear_out = np.tensordot(lms_filtered, M_LMS_to_sRGB.T, axes=([2], [0]))
    linear_out = np.clip(linear_out, 0.0, 1.0)

    # Convert Linear RGB -> sRGB
    srgb_out = linear_to_srgb(linear_out)
    srgb_out = np.clip(srgb_out, 0.0, 1.0)
    
    # Scale to [0,255] and convert to uint8, then back to BGR for OpenCV
    rgb_out = (srgb_out * 255).astype(np.uint8)
    bgr_out = cv2.cvtColor(rgb_out, cv2.COLOR_RGB2BGR)
    return bgr_out

# ---------------------------------------------------------------
# Flask Endpoint
# ---------------------------------------------------------------
@app.route('/apply_filter', methods=['POST'])
def apply_filter():
    try:
        # Get image file from the request
        file = request.files.get('image')
        if file is None:
            return jsonify({"error": "No image provided"}), 400

        # Get filter type; default to "deuteranopia" if not provided
        filter_type = request.form.get('filter', 'deuteranopia')

        # Read image file into numpy array
        file_bytes = np.frombuffer(file.read(), np.uint8)
        image = cv2.imdecode(file_bytes, cv2.IMREAD_COLOR)
        if image is None:
            return jsonify({"error": "Invalid image file"}), 400

        # Process image using the selected filter
        filtered_image = apply_colorblindness_filter_cv(image, filter_type=filter_type)

        # Encode the processed image as PNG
        is_success, buffer = cv2.imencode(".png", filtered_image)
        if not is_success:
            return jsonify({"error": "Could not encode image"}), 500

        # Return the image as a file-like response
        return send_file(
            io.BytesIO(buffer.tobytes()),
            mimetype='image/png',
            as_attachment=False,
            download_name='filtered.png'
        )
    except Exception as e:
        # Print the error to console for debugging
        print(f"Exception in /apply_filter: {e}")
        return jsonify({"error": str(e)}), 500

# ---------------------------------------------------------------
# Run the Flask Application
# ---------------------------------------------------------------
if __name__ == '__main__':
    # Listen on all interfaces (0.0.0.0), port 5000, with debug mode on
    app.run(host='0.0.0.0', port=5000, debug=True)
