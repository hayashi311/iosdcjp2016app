# -*- coding: utf-8 -*-
from os import path, environ
from flask import Flask, jsonify, abort
import yaml
import json
from glob import glob
import itertools
import urbanairship as ua
import redis
import datetime
import time
from flask_admin import Admin, BaseView, expose
from flask_admin.contrib import rediscli

app = Flask(__name__)
base_path = path.dirname(path.abspath(__file__))

ua_app_key = environ["UA_APP_KEY"]
ua_master_secret = environ["UA_MASTER_SECRET"]
airship = ua.Airship(ua_app_key, ua_master_secret)

r = redis.from_url(environ.get("REDIS_URL"))


class DateTimeSupportJSONEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, datetime.datetime):
            return o.isoformat()
        return super(DateTimeSupportJSONEncoder, self).default(o)


@app.route('/apns')
def apns_send():
    now = datetime.datetime.now()
    timestamp = int(time.mktime(now.timetuple()))
    notification = json.dumps({"message": "Hello, world!",
                               "url": "hoge.com", "created_at": timestamp})
    r.set("notification:{}".format(timestamp), notification)
    try:
        push = airship.create_push()
        push.audience = ua.all_
        push.notification = ua.notification(alert="Hello, world!")
        push.device_types = ua.all_
        push.send()
    except:
        return "error"
    return "success"


@app.route('/notifications')
def notifications_list():
    keys = sorted(r.keys("notification:*"), reverse=True)
    notifications = r.mget(keys)
    n = map(lambda n: json.loads(n.decode('utf-8')), notifications)
    return jsonify(notification=list(n))


@app.route('/speakers')
def speakers_list():
    yaml_path = path.join(base_path, "data", "speakers", "*.yaml")
    speakers = map(lambda path: yaml.load(open(path).read()), glob(yaml_path))

    def f(speakers):
        for s in speakers:
            r = s["speaker"]
            r["session"] = s["session"]
            del(r["session"]["speaker"])
            yield r
    return jsonify(speakers=list(f(speakers)))


def group_by_time(paths):
    data = list(map(lambda path: yaml.load(open(path).read()), paths))
    sessions = map(lambda x: x["session"], data)

    def start_at(session):
        return session["start_at"]

    tires = itertools.groupby(sorted(sessions, key=start_at), key=start_at)
    for k, g in tires:
        yield {"start_at": k,
               "sessions": sorted(list(g), key=lambda s: s["room"])}


@app.route('/sessions')
def sessions_list():
    yaml_path = path.join(base_path, "data", "speakers", "*.yaml")
    match = glob(yaml_path)
    return jsonify(schedule=list(group_by_time(match)))


@app.route('/<entity>')
def get_entity(entity):
    match = glob(path.join(base_path, "data", "speakers", entity + "*.yaml"))
    for m in match:
        yaml_data = open(m).read()
        return jsonify(yaml.load(yaml_data))
    abort(404)

admin = Admin(app, name='iosdc', template_mode='bootstrap3')
admin.add_view(rediscli.RedisCli(r))


class AdminNotificationView(BaseView):
    @expose('/')
    def index(self):
        return self.render('admin_notifications_index.html')


admin.add_view(AdminNotificationView(name='Notification', endpoint='notifications'))


if __name__ == '__main__':
    app.run(debug=True)

