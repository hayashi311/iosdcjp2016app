# -*- coding: utf-8 -*-
from os import path
from flask import Flask, jsonify, abort
import yaml
import json
import datetime
import glob
import itertools

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


def group_by_time(paths):
    s = list(map(lambda path: yaml.load(open(path).read()), paths))

    def start_at(s):
        return s["start_at"]

    tires = itertools.groupby(sorted(s, key=start_at), key=start_at)
    for k, g in tires:
        yield {"start_at": k,
               "sessions": sorted(list(g), key=lambda s: s["room"])}


@app.route('/sessions')
def sessions():
    yaml_path = path.join(base_path, "source", "sessions", "*.yaml")
    match = glob.glob(yaml_path)
    # sorted(match)
    # data = list(map(lambda path: yaml.load(open(path).read()), match))
    return jsonify(schedule=list(group_by_time(match)))


@app.route('/<category>/<entity>')
def get_entity(category, entity):
    try:
        yaml_path = path.join(base_path, "source", category, entity + "_*.yaml")
        match = glob.glob(yaml_path)
        yaml_data = open(match[0]).read()
        return jsonify(yaml.load(yaml_data))
    except:
        abort(404)


if __name__ == '__main__':
    app.run(debug=True)

