import os
import sys
import traceback

import psycopg2

from flask_cors import CORS
from flask import Flask, jsonify, request
from gevent.pywsgi import WSGIServer

db_url = os.environ.get('DATABASE_URL', "postgresql://green:green@127.0.0.1:5432/postgres")
LISTEN_PORT = os.environ.get('PORT', '5001')
app = Flask(__name__)
CORS(app)


def exception_tool(e):
    error_class = e.__class__.__name__  # 取得錯誤類型
    detail = e.args[0]  # 取得詳細內容
    cl, exc, tb = sys.exc_info()  # 取得Call Stack
    lastCallStack = traceback.extract_tb(tb)[-1]  # 取得Call Stack的最後一筆資料
    fileName = lastCallStack[0]  # 取得發生的檔案名稱
    lineNum = lastCallStack[1]  # 取得發生的行號
    funcName = lastCallStack[2]  # 取得發生的函數名稱
    return lineNum, detail


def get_user(conn, path):
    _d = None
    cur = conn.cursor()
    sql = "select path, policyholderid from tree where path=%s;"
    cur.execute(sql, (path,))
    row = cur.fetchone()
    if row is not None:
        sql = "select policyholderid, name, joindate, referrerid from policyholders where policyholderid=%s;"
        cur.execute(sql, (row[1],))
        row = cur.fetchone()
        if row is not None:
            _d = {}
            _d['code'] = row[0]
            _d['name'] = row[1]
            _d['registration_date'] = row[2]
            _d['introducer_code'] = row[3]
            _d['path'] = path
    return _d


@app.route('/test', methods=['GET'])
def test():
    return jsonify({'message': 'test'})


@app.route('/api/policyholders', methods=['POST'])
def policyholders():
    data = request.get_json()
    code = data.get('code', None)
    conn = psycopg2.connect(db_url)
    cur = conn.cursor()
    response_data = {}
    try:
        sql = "select policyholderid, name, joindate, referrerid from policyholders where policyholderid=%s;"
        cur.execute(sql, (code,))
        row = cur.fetchone()
        if row is None:
            return jsonify({'message': '查無此人'}), 400
        else:
            response_data['code'] = row[0]
            response_data['name'] = row[1]
            response_data['registration_date'] = row[2]
            response_data['introducer_code'] = row[3]
        sql = "select policyholderid, path from tree where policyholderid=%s;"
        cur.execute(sql, (code,))
        row = cur.fetchone()
        if row is None:
            return jsonify({'message': '查無此人'}), 400
        else:
            path = str(row[1])
            lift = f'{path}.1'
            right = f'{path}.2'

            # 先查左邊
            sql = "select path from tree where path <@ %s;"
            cur.execute(sql, (lift,))
            rows = cur.fetchall()
            if len(rows) > 0:
                response_data['l'] = []
                for row in rows:
                    _d = get_user(conn, row[0])
                    if _d is not None:
                        response_data['l'].append(_d)

            # 再查右邊
            sql = "select path from tree where path <@ %s;"
            cur.execute(sql, (right,))
            rows = cur.fetchall()
            if len(rows) > 0:
                response_data['r'] = []
                for row in rows:
                    _d = get_user(conn, row[0])
                    if _d is not None:
                        response_data['r'].append(_d)
    except Exception as e:
        lineNum, detail = exception_tool(e)
        return jsonify({'message': f'line:{lineNum}, {detail}'}), 400
    return jsonify(response_data)


@app.route('/api/policyholders/<code>/top', methods=['GET'])
def get_top(code):
    conn = psycopg2.connect(db_url)
    cur = conn.cursor()
    response_data = {}
    try:
        sql = "select policyholderid, name, joindate, referrerid from policyholders where policyholderid=%s;"
        cur.execute(sql, (code,))
        row = cur.fetchone()
        if row is None:
            return jsonify({'message': '查無此人'}), 400

        sql = "select path from tree where policyholderid=%s;"
        cur.execute(sql, (row[0],))
        row = cur.fetchone()
        path = str(row[0])
        split_path = path.rsplit('.', 1)
        parent_path = split_path[0] if len(split_path) > 1 else path
        sql = "select policyholderid, path from tree where path=%s;"
        cur.execute(sql, (parent_path,))
        row = cur.fetchone()
        if row is None:
            return jsonify({'message': '查無此人'}), 400
        else:
            policyholderid = row[0]
            sql = "select policyholderid, name, joindate, referrerid from policyholders where policyholderid=%s;"
            cur.execute(sql, (policyholderid,))
            row = cur.fetchone()
            if row is None:
                return jsonify({'message': '查無此人'}), 400
            else:
                response_data['code'] = row[0]
                response_data['name'] = row[1]
                response_data['registration_date'] = row[2]
                response_data['introducer_code'] = row[3]
            sql = "select policyholderid, path from tree where policyholderid=%s;"
            cur.execute(sql, (policyholderid,))
            row = cur.fetchone()
            if row is None:
                return jsonify({'message': '查無此人'}), 400
            else:
                path = str(row[1])
                lift = f'{path}.1'
                right = f'{path}.2'

                # 先查左邊
                sql = "select path from tree where path <@ %s;"
                cur.execute(sql, (lift,))
                rows = cur.fetchall()
                if len(rows) > 0:
                    response_data['l'] = []
                    for row in rows:
                        _d = get_user(conn, row[0])
                        if _d is not None:
                            response_data['l'].append(_d)

                # 再查右邊
                sql = "select path from tree where path <@ %s;"
                cur.execute(sql, (right,))
                rows = cur.fetchall()
                if len(rows) > 0:
                    response_data['r'] = []
                    for row in rows:
                        _d = get_user(conn, row[0])
                        if _d is not None:
                            response_data['r'].append(_d)
    except Exception as e:
        lineNum, detail = exception_tool(e)
        return jsonify({'message': f'line:{lineNum}, {detail}'}), 400
    return jsonify(response_data)


if __name__ == '__main__':
    # 啟動flask(套接Gevent高效能WSGI Server)
    http_server = WSGIServer(('0.0.0.0', int(LISTEN_PORT)), app)
    print('★★★★★★ 啟動Flask... port num : ' + LISTEN_PORT)
    http_server.serve_forever()
