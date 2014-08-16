'use strict'

_ = require 'lodash'
fs = require 'fs'

DEFAULT =
    LIMIT_BYTES: '100K'
    AUTO_SAVE: false
    FILENAME: 'ds_cache.json'

SIZE_UNITS =
    'B' : 1
    'K' : 1000
    'M' : 1000000
    'G' : 1000000000

_getNotationToBytes = (notation) ->
    if not _.isString notation
        console.log "The size notation isn't String type."
        return 0

    notation = notation.toUpperCase()

    pattern = /(\d+)([B|K|M|G])/
    matches = pattern.exec(notation)

    if matches?
        return matches[1] * SIZE_UNITS[matches[2]]
    else
        console.log "Could not to exchange the noation."            

    return 0

class Exception

    constructor: (msg) ->
        @msg = msg
        @name = 'Exception' 

class Cache

    constructor: (opt) ->
        opt = {} if not opt?
        @_queue = []
        @_cache = {}

        # TODO: check the unit of size (K,M,G)
        @limit_bytes = opt.limit_bytes || DEFAULT.LIMIT_BYTES
        @auto_save = opt.auto_save || DEFAULT.AUTO_SAVE
        @filename = opt.filename || DEFAULT.FILENAME


        # private method begin
        @_isCouldAdd = (needBytes) ->
            cache_bytes = @content().length
            limit_bytes = @_getNotationToBytes @limit_bytes

            return (cache_bytes + needBytes) < limit_bytes

        @_getNotationToBytes = (notation) ->
            return _getNotationToBytes notation

        @_getContentBytes = (obj) ->                
            if not _.isObject obj
                console.log "Could not the know the content size , because is not object type."
                return -1

            return JSON.stringify(obj).length

        # clean unsed cache object
        @_gc = (needBytes) ->
            return false if needBytes > @limit_bytes || @_queue.length is 0

            # apply LRU algorithm via Array
            until @_queue.length > 0 and @_isCouldAdd(needBytes)

                releaseKey = @_queue.pop()
                delete @_cache[releaseKey] 

            return true 

        @_update = (key) ->
            @_queue = _.without @_queue, key
            @_queue.unshift key
            return

        @_calculateNeedBytes = (key, val) ->
            cache_bytes = @content().length

            clone_q = _.cloneDeep @_queue
            clone_c = _.cloneDeep @_cache
            clone_q.push key
            clone_c[key] = val

            clone_content = 
                q: clone_q
                c: clone_c

            return @_getContentBytes(clone_content) - cache_bytes 

        # private method end

        @load()
        return @

    set: (key, val) ->
        needBytes =  @_calculateNeedBytes key, val

        # the key already exist
        if key in @_queue and @_getContentBytes(key:@_cache[key]) <= needBytes
            @_cache[key] = val
                
            @_update key
            return
        
        # check the cache buffer size
        if not @_isCouldAdd needBytes
            console.log "Need more cache buffer."

            # remove some data if the cache buffer over than limit bytes.
            @_gc needBytes

        @_update key
        @_cache[key] = val

        # auto save if enable
        @save() if @auto_save is true
           
        return

    get: (key) ->       
        return null if not @_cache[key]?

        @_update key
        return @_cache[key]

    save: ->
        fs.writeFileSync(@filename, @content())
        return true

    clear: (key) ->
        _isCorrect = false

        # clear all cache objects
        if not key?
            @_cache = {}
            @_queue = []
            _isCorrect = true

        # remove the cache object by key
        if key? and _.has @_cache, key
            @_queue = _.without @_queue, key
            delete @_cache[key]
            _isCorrect = true

        @save() if @auto_save and _isCorrect
        
        return _isCorrect

    load: ->
        try
            obj = JSON.parse fs.readFileSync(@filename)
            @_cache = obj.c
            @_queue = obj.q

        catch e
            return false

        return true

    size: ->
        return _.size(@_cache)

    content: ->
        _content = 
            q: @_queue
            c: @_cache

        return JSON.stringify _content

module.exports = Cache
module.exports.getNotationToBytes = _getNotationToBytes