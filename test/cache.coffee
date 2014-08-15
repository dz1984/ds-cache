Cache = require '../index.js'

INITIAL_BYTES = '1K'
EXPECT = 
    NAME: 'Donald'
    AGE: 30
    NUM: 100

module.exports = 
    'setUp': (callback) ->
        @cache = new Cache limit_bytes: INITIAL_BYTES
        callback()

    'tearDown': (callback) ->
        callback()

    'initial cache': (test) ->
        test.equal @cache.limit_bytes, INITIAL_BYTES
        test.done()

    'add a new cache and only onece in the cache.': (test) ->
        @cache.set 'name', EXPECT.NAME
        name = @cache.get 'name'
        test.equal name, EXPECT.NAME
        test.equal @cache.size(), 1
        
        test.done()

    'add some cache objects and clear all': (test) ->
        @cache.set 'name', EXPECT.NAME
        @cache.set 'age', EXPECT.AGE
        test.equal @cache.size(), 2 

        # clear all the cache 
        @cache.clear()
        test.equal @cache.size(), 0 

        test.done()

    'add cache objects over than limit size.': (test) ->
        for i in [1..EXPECT.NUM]
            @cache.set 'K'+i, 'V' + i

        cache_bytes = @cache.content().length
        initial_bytes =  Cache.getNotationToBytes INITIAL_BYTES

        console.log cache_bytes
        console.log initial_bytes
        test.ok @cache.size() <= EXPECT.NUM
        test.ok cache_bytes <= initial_bytes

        test.done()