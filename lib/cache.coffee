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

    notation = notation.toUpperCase()

    pattern = /(\d+)([B|K|M|G])/
    matches = pattern.exec(notation)

    if matches?
        return matches[1] * SIZE_UNITS[matches[2]]
    else
        console.log "Could not to exchange the noation."            

    return 

class Exception

    constructor: (msg) ->
        @msg = msg
        @name = 'Exception' 

class Cache

    constructor: (opt) ->
        opt = {} if not opt?
        @_index = {}
        @_cache = {}

        # TODO: check the unit of size (K,M,G)
        @limit_bytes = opt.limit_bytes || DEFAULT.LIMIT_BYTES
        @auto_save = opt.auto_save || DEFAULT.AUTO_SAVE
        @filename = opt.filename || DEFAULT.FILENAME


        # private method begin
        @_isCouldAdd = (needSize) ->
            _cache_bytes = @_getContentBytes()
            _limit_bytes = @_getNotationToBytess @limit_bytes

            return (_cache_bytes + needSize) < _limit_bytes

        @_getNotationToBytess = (notation) ->
            _getNotationToBytes notation

        @_getContentBytes = (obj) ->
            obj = @_cache if not obj?
                
            if not _.isObject obj
                console.log "Could not the know the content size , because is not object type."

            return JSON.stringify(obj).length

        # clean unsed cache object
        @_gc = (needSize) ->
            return false if needSize > @limit_bytes        

        # private method end

        @load()
        return @

    set: (key, val) ->
        needSize =  @_getContentBytes key:val

        # check the cache size
        if not @_isCouldAdd needSize
            console.log "Size not enough"

            # TODO : remove some data if the cache size is over than limit size
            @_gc needSize

        count = if @_index[key]? then @_index[key].count else 0

        @_index[key] = 
            count: count + 1
            size: needSize

        # replace the value if the key is exist
        @_cache[key] = val

        # auto save if enable
        @save() if @auto_save is true
           
        return

    get: (key) ->       
        if @_cache[key]?
            @_index[key].count += 1
            return @_cache[key]

        return null

    save: ->
        fs.writeFileSync(@filename, @content())
        return

    clear: (key) ->
        _isCorrect = false

        # clear all cache objects
        if not key?
            @_cache = {}
            _isCorrect = true

        # remove the cache object by key
        if key? and _.has @_cache, key
            delete @_cache[key]
            _isCorrect = true

        @save() if @auto_save and _isCorrect
        
        _isCorrect

    load: ->
        try
            obj = JSON.parse fs.readFileSync(@filename)
            @_cache = obj.cache
            @_index = obj.index

        catch e
            
        return

    size: ->
        _.size(@_cache)

    content: ->
        _content = 
            index: @_index
            cache: @_cache

        JSON.stringify _content

module.exports = Cache
module.exports.getNotationToBytes = _getNotationToBytes