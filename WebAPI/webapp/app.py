# -*- coding: utf-8 -*-
from os import path
from flask import Flask, jsonify
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
    tires = itertools.groupby(sorted(paths),
                             key=lambda p: path.basename(p).split("-")[0])
    groups = []
    for k, g in tires:
        print(k, g)
        time = k.replace("_", ":")
        s = list(map(lambda path: yaml.load(open(path).read()), g))
        yield {"time": time, "sessions": s}

    return groups


@app.route('/sessions')
def sessions():
    yaml_path = path.join(base_path, "source", "sessions", "*.yaml")
    match = glob.glob(yaml_path)
    # sorted(match)
    # data = list(map(lambda path: yaml.load(open(path).read()), match))
    return jsonify(schedule=list(group_by_time(match)))


@app.route('/<category>/<entity>')
def get_entity(category, entity):
    yaml_path = path.join(base_path, "source", category, entity + ".yaml")
    yaml_data = open(yaml_path).read()
    return jsonify(yaml.load(yaml_data))


if __name__ == '__main__':
    app.run(debug=True)

