import os

from flask import (
    Flask, 
    send_from_directory, 
    render_template, 
    request
)

def execute(cmd):
    return os.popen(cmd).read()

app = Flask(__name__, template_folder=".", static_folder='static',)
app.config['UPLOAD_FOLDER'] = "uploads/"    
app.jinja_env.globals.update(execute=execute)

@app.route('/')
def hello_world():
    return render_template('index.html')

@app.route('/files/<path:path>')
def files(path):
    return send_from_directory('files', path)

@app.route('/upload', methods = ['GET', 'POST'])
def upload():
    msg = ''
    allowed_extensions = ['.jpg', '.png', '.jpeg', '.gif']
    if request.method == 'POST':
        f = request.files['file']
        if not any(ext in f.filename for ext in allowed_extensions):
            msg='File extension is not allowed!'
        else:
            f.save(os.path.join(app.config['UPLOAD_FOLDER'], f.filename))
            msg='File upload was successful!'
    return render_template('upload.html', msg=msg)

@app.route('/uploads', methods=['GET'])
@app.route('/uploads/<file_name>', methods=['GET'])
def uploads(file_name=None):
    if not file_name:
        return '<h1>Missing file name in URL parameter.</h1>'
    else:
        if not os.path.exists('uploads/' + file_name):
            return '<h1>File not found.</h1>'
    return render_template('uploads/' + file_name)