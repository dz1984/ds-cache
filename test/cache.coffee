Cache = require '../index.js'

INITIAL=
    LIMIT_BYTES: '1K'
    AUTO_SAVE: true

EXPECT = 
    NAME: 'Donald'
    AGE: 30
    NUM: 100

_random = (max, min = 0) ->
    return Math.floor(Math.random() * (max-min)) + min

module.exports = 
    'setUp': (callback) ->
        @cache = new Cache limit_bytes: INITIAL.LIMIT_BYTES, auto_save:INITIAL.AUTO_SAVE
        callback()

    'tearDown': (callback) ->
        callback()

    'initial cache': (test) ->
        test.equal @cache.limit_bytes, INITIAL.LIMIT_BYTES
        test.done()

    'add a new cache and only onece in the cache.': (test) ->
        @cache.set 'name', EXPECT.NAME
        name = @cache.get 'name'
        test.equal name, EXPECT.NAME
        isExpect = if INITIAL.AUTO_SAVE then @cache.size() >= 1 else @cache.size() is 1
        test.ok isExpect
        
        test.done()

    'add some cache objects and clear all': (test) ->
        @cache.set 'name', EXPECT.NAME
        @cache.set 'age', EXPECT.AGE
        isExpect = if INITIAL.AUTO_SAVE then @cache.size() >= 2 else @cache.size() is 2
        test.ok isExpect

        # clear all the cache 
        @cache.clear()
        test.equal @cache.size(), 0 

        test.done()

    'add cache objects over than limit size.': (test) ->
        @cache.clear()
        test.equal @cache.size(), 0

        for i in [1..EXPECT.NUM]
            key = Math.random().toString(36).substring(7)
            val = _random(1000)

            @cache.set key, val  

        cache_bytes = @cache.content().length
        initial_bytes =  Cache.getNotationToBytes INITIAL.LIMIT_BYTES

        test.ok @cache.size() <= EXPECT.NUM
        test.ok cache_bytes <= initial_bytes

        test.done()