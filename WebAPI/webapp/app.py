# -*- coding: utf-8 -*-
from os import path
from flask import Flask, jsonify
import yaml
import json
import datetime

app = Flask(__name__)


class DateTimeSupportJSONEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, datetime.datetime):
            return o.isoformat()
        return super(DateTimeSupportJSONEncoder, self).default(o)


@app.route('/<category>/<entity>')
def hello_world(category, entity):
    base_path = path.dirname(path.dirname(path.abspath(__file__)))
    yaml_path = path.join(base_path, "source", category, entity + ".yaml")
    yaml_data = open(yaml_path).read()
    data = yaml.load(yaml_data)
    return jsonify(data)


if __name__ == '__main__':
    app.run(debug=True)
