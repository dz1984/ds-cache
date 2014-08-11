Cache = require '../index.js'

INITIAL_SIZE = '50K'
EXPECT_NAME = 'Donald'
EXPECT_AGE = 30
EXPECT_NUM = 50

module.exports = 
    setUp: (callback) ->
        @cache = new Cache limit_size:INITIAL_SIZE, auto_save: false
        callback()

    tearDown: (callback) ->
        callback()

    'initial cache': (test) ->
        test.equal @cache.limit_size, INITIAL_SIZE
        test.done()

    'add a new cache and onece in the cache.': (test) ->
        @cache.set 'name', 'Donald'
        name = @cache.get 'name'
        test.equal 'Donald', name
        test.equal @cache.size(), 1
        
        test.done()

    'add some cache object and clear all': (test) ->
        @cache.set 'name', EXPECT_NAME
        @cache.set 'age', EXPECT_AGE
        test.equal @cache.size(), 2

        # clear all the cache 
        @cache.clear()
        test.equal @cache.size(), 0 

        test.done()

    'add a new cache over than limit size.': (test) ->
        for i in [1..EXPECT_NUM]
            @cache.set 'K'+i, 'V' + i

        test.equal @cache.size(), EXPECT_NUM
        test.equal @cache.getContentSize(), @cache.content().length
        test.done()