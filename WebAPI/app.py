# -*- coding: utf-8 -*-
from os import path, environ
from flask import Flask, jsonify, abort, redirect
import yaml
import json
from glob import glob
import itertools
import urbanairship as ua
import redis
import datetime
import time
import uuid
import sys
from flask_admin import Admin, BaseView, expose
from flask_admin.contrib import rediscli
from flask_wtf import Form
from wtforms import StringField
from wtforms.validators import DataRequired

app = Flask(__name__)
base_path = path.dirname(path.abspath(__file__))

ua_app_key = environ['UA_APP_KEY']
ua_master_secret = environ['UA_MASTER_SECRET']
airship = ua.Airship(ua_app_key, ua_master_secret)


class DateTimeSupportJSONEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, datetime.datetime):
            return o.isoformat()
        return super(DateTimeSupportJSONEncoder, self).default(o)


class Notification:
    def __init__(self, uuid, message, url, created_at):
        self.uuid = uuid
        self.message = message
        self.url = url
        self.created_at = created_at

    def key(self):
        return "notification.{}".format(self.uuid)

    def to_json(self):
        return json.dumps(self.to_hash())

    def to_hash(self):
        return {'uuid': self.uuid, 'message': self.message,
                'url': self.url, 'created_at': self.created_at}

    @classmethod
    def loads(cls, json_str):
        d = json.loads(json_str)
        return Notification(**d)


class NotificationStore:
    key = 'notifications'

    def __init__(self):
        self.r = redis.from_url(environ.get('REDIS_URL'))

    def add_notification(self, notification):
        self.r.zadd(self.key, notification.key(), notification.created_at)
        self.r.set(notification.key(), notification.to_json())

    def fetch_notifications(self):
        keys = self.r.zrange(self.key, 0, 100, desc=True)
        if len(keys) == 0:
            return []
        notifications = self.r.mget(keys)
        print(keys, file=sys.stderr)
        print(notifications, file=sys.stderr)
        return map(lambda n: Notification.loads(n.decode('utf-8')),
                   notifications)

    def remove_all(self):
        self.r.delete(self.key)


store = NotificationStore()


def send_notification(message):
    now = datetime.datetime.now()
    timestamp = int(time.mktime(now.timetuple()))
    store.add_notification(Notification(str(uuid.uuid4()), message,
                                        "hoge.com", timestamp))
    try:
        push = airship.create_push()
        push.audience = ua.all_
        push.notification = ua.notification(alert=message)
        push.device_types = ua.all_
        push.send()
    except:
        return False
    return True


@app.route('/remove-all')
def remove_all():
    store.remove_all()
    return "done"


@app.route('/apns')
def apns_send():
    message = 'Hello world2'
    send_notification(message)
    push = airship.create_push()
    push.audience = ua.all_
    push.notification = ua.notification(alert=message)
    push.device_types = ua.all_
    push.send()
    # try:
    # except:
    #     return 'error'
    return 'success'


@app.route('/notifications')
def notifications_list():
    notifications = store.fetch_notifications()
    n = map(lambda n: n.to_hash(), notifications)
    return jsonify(notifications=list(n))


@app.route('/speakers')
def speakers_list():
    yaml_path = path.join(base_path, 'data', 'speakers', '*.yaml')
    speakers = map(lambda path: yaml.load(open(path).read()), glob(yaml_path))

    def f(speakers):
        for s in speakers:
            r = s['speaker']
            r['session'] = s['session']
            del(r['session']['speaker'])
            yield r
    return jsonify(speakers=list(f(speakers)))


def group_by_time(paths):
    data = list(map(lambda path: yaml.load(open(path).read()), paths))
    sessions = map(lambda x: x['session'], data)

    def start_at(session):
        return session['start_at']

    tires = itertools.groupby(sorted(sessions, key=start_at), key=start_at)
    for k, g in tires:
        yield {'start_at': k,
               'sessions': sorted(list(g), key=lambda s: s['room'])}


@app.route('/sessions')
def sessions_list():
    yaml_path = path.join(base_path, 'data', 'speakers', '*.yaml')
    match = glob(yaml_path)
    return jsonify(schedule=list(group_by_time(match)))


@app.route('/<entity>')
def get_entity(entity):
    match = glob(path.join(base_path, 'data', 'speakers', entity + '*.yaml'))
    for m in match:
        yaml_data = open(m).read()
        return jsonify(yaml.load(yaml_data))
    abort(404)



if __name__ == '__main__':
    app.run(debug=True)
