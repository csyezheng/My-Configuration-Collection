# -*- coding: utf-8 -*-

import redis


class RedisConn(object):

    def __init__(self, host, port, db, password, decode_responses):
        pool = redis.ConnectionPool(host=host, port=port, db=db, password=password, decode_responses=True)
        self.redis_conn = redis.Redis(connection_pool=pool)

    def