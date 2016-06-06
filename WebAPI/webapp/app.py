# -*- coding: utf-8 -*-
from os import path
from flask import Flask, jsonify
import yaml
import json
import datetime
import glob

app = Flask(__name__)

base_path = path.dirname(path.dirname(path.abspath(__file__)))


class DateTimeSupportJSONEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, datetime.datetime):
            return o.isoformat()
        return super(DateTimeSupportJSONEncoder, self).default(o)


@app.route('/speakers')
def speakers():
    yaml_path = path.join(base_path, "source", "speakers", "*.yaml")
    match = glob.glob(yaml_path)
    data = list(map(lambda path: yaml.load(open(path).read()), match))
    return jsonify(speakers=data)


@app.route('/sessions')
def sessions():
    yaml_path = path.join(base_path, "source", "sessions", "*.yaml")
    match = glob.glob(yaml_path)
    data = list(map(lambda path: yaml.load(open(path).read()), match))
    return jsonify(sessions=data)


@app.route('/<category>/<entity>')
def get_entity(category, entity):
    yaml_path = path.join(base_path, "source", category, entity + ".yaml")
    yaml_data = open(yaml_path).read()
    return jsonify(yaml.load(yaml_data))


if __name__ == '__main__':
    app.run(debug=True)

