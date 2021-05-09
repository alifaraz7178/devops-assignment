from flask import Flask
from flask_prometheus import monitor

app = Flask(__name__)


@app.route('/')
def index():
    return "<h1>Please select the right Parameter</h1>"
@app.route('/<data>')
def info(data):
    if data == "check.txt":
        return "<h1>Its working!!!</h1>"
    elif data == "404":
        return "<h1>Not Found</h1>", 404
    elif data == "403":
        return "<h1>Forbidden</h1>", 403
    elif data == "500":
        return "<h1>Application error</h1>", 500
    elif data == "502":
        return "<h1>Bad Gateway</h1>", 502
    else:
        return "Enter Correct Parameter"

monitor(app, port=8000)
app.run()
