from flask import Flask, send_from_directory
app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello World!'

@app.route('/files/<path:path>')
def send_report(path):
    return send_from_directory('files', path)