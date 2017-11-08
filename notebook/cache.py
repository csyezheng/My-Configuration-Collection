# -*- coding: utf-8 -*-

# Interface, just define interface
# Virtual,implement some method and define some new interface should be implemented
# Entity, add special attribute needed, real class can be used

import logging
import json

logger = logging.getLogger(__name__)


class CacheInterface(object):
    """Cache abstract base class"""

    def load_cache(self):
        raise NotImplementedError('Subclasses should implement this!')

    def reflash_cache(self):
        raise NotImplementedError('Subclasses should implement this!')

    def delete_cache(self):
        raise NotImplementedError('Subclasses should implement this!')

    def get_cache(self):
        raise NotImplementedError('Subclasses should implement this!')


class CacheBaseVirtual(CacheInterface):

    def __init__(self, redis_db, cache_key, db_conn, key_prefix, expire_time):
        self.redis_db = redis_db
        self.cache_key = cache_key
        self.db = db_conn
        self.key_prefix = key_prefix
        self.tobe_del_key = self.key_prefix + '*'
        self.expire_time = expire_time

    __load_cache_switch = True

    def load_cache(self):
        self.__check_attrs()
        if self.__class__.__load_cache_switch and not self.redis_db.exists(self.cache_key):
            logger.info('No match cache, loading {0} into cache'.format(self.cache_key))
            self.__set_cache()

    def reflash_cache(self):
        self.__set_cache()

    def delete_cache(self):
        self.__check_attrs()
        key_list = self.redis_db.keys(self.tobe_del_key)
        for key in key_list:
            self.redis_db.delete(key)

    def get_cache(self):
        self.__check_input()
        self.load_cache()
        return self.__get_cache()

    def __set_cache(self):
        data = self.__read_from_db()
        self.__save_to_redis(data)

    def __check_attrs(self):
        arr_list = ['redis_db', 'cache_key', 'tobe_del_key']
        for attr in arr_list:
            if not getattr(self, attr, None):
                raise Exception('{0} have not attribute {1}'.format(self.__class__.__name__, attr))

    def __check_input(self):
        raise NotImplementedError('Subclasses should implement this!')

    def __get_cache(self):
        raise NotImplementedError('Subclasses should implement this!')

    def __read_from_db(self):
        raise NotImplementedError('Subclasses should implement this!')

    def __save_to_redis(self, data):
        raise NotImplementedError('Subclasses should implement this!')


class UserCacheEntity(CacheBaseVirtual):

    def __init__(self, redis_db, cache_key, db_conn, key_prefix, expire_time, user_id):
        super().__init__(redis_db, cache_key, db_conn, key_prefix, expire_time)
        self.user_id = user_id

    def __check_input(self):
        if not self.user_id:
            raise Exception('the attribute user_id of class {0} can not be None')

    def __get_cache(self):
        result = {}
        serialized_dict = self.redis_db.get(self.cache_key)
        if serialized_dict:
            result = json.loads(serialized_dict)
        return result

    def __read_from_db(self):
        sql = ''           # TODO Write effect sql about self.user_id
        ret = self.db.query(sql)
        return ret

    def __save_to_redis(self, data):
        for row in data:
            user_id = row.get('user_id', '')
            key = self.key_prefix + str(user_id)
            serialized_dict = json.dumps(row)
            self.redis_db.expire(key, serialized_dict)

class Another(object):

    def __init__(self, redis_db, info):
        self.redis_db = redis_db
        self.info = info
        self.key = 'special prefix:' + info

    def set(self, data):
        serialized_dict = json.dumps(data) if type(data) == dict else data
        self.redis_db.set(self.key, serialized_dict)

    def get(self):
        result = {}
        serialized = self.redis_db.get(self.key)
        if serialized:
            result = json.loads(serialized)
        return result

