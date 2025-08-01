from flask import Flask, render_template
import os
from dotenv import load_dotenv

# Load environment variables from .env file
# load_dotenv()

app = Flask(__name__)

@app.route('/')
def home():
    # Get the header text from environment variable
    header_text = os.getenv('HEADER_TEXT', 'Welcome to Flask!')
    # Get the image URL from environment variable
    image_url = os.getenv('IMAGE_URL', '')
    return render_template('index.html', header_text=header_text, image_url=image_url)

@app.route('/health')
def health():
    return {'status': 'healthy'}, 200

if __name__ == '__main__':
    port = int(os.getenv('PORT', 5000))
    debug = os.getenv('FLASK_DEBUG', 'False').lower() == 'true'
    
    app.run(
        host='0.0.0.0',
        port=port,
        debug=debug
    )