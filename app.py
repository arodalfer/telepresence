from flask import Flask, request, jsonify
import json
import requests
import logging
import argparse

app = Flask(__name__)

arg_parser = argparse.ArgumentParser()
arg_parser.add_argument('--color', type=str, required=False)
arg_parser.add_argument('--port', type=int, required=False)
args = arg_parser.parse_args()

DEFAULT_ENV = 'local'
DEFAULT_COLOR = 'green'
DEFAULT_PORT = 4000  

color = args.color if args.color else DEFAULT_COLOR
port = args.port if args.port else DEFAULT_PORT
environment = DEFAULT_ENV

log = logging.getLogger()
console = logging.StreamHandler()
log.addHandler(console)
log.setLevel(logging.INFO)


@app.route('/')
def root():
    log.info(request)
    return f'<p style="color:{color}">HELLO WORLD with Telepresence</p>'

# Color
@app.route('/color')
def get_color():
    log.info('color endpoint entry')
    return color

# Environment
@app.route('/environment')
def get_environment():
    log.info('environment endpoint entry')
    return environment

if __name__ == '__main__':
    log.info('Welcome!')
    app.run(debug=True, host='0.0.0.0', port=port)
