'use strict'

_ = require 'lodash'
fs = require 'fs'

LIMIT_SIZE = '100K'

SIZE_UNITS =
    'B' : 1
    'K' : 1000
    'M' : 1000000
    'G' : 1000000000

class Exception
    constructor: (msg) ->
        @msg = msg
        @name = 'Exception'

class Cache
    constructor: (opt) ->
        opt = {} if not opt?
        @_cache = {}

        # TODO: check the unit of size (K,M,G)
        @limit_size = opt.limit_size || LIMIT_SIZE
        @auto_save = opt.auto_save || false
        @filename = opt.filename || 'ds_cache.json'


        # private method begin
        @_isCouldAdd = (key, val) ->
            _cacheSize = @_getContentSize()
            _dataSize = @_getContentSize key:val
            _limitSize = @_getNotationToByte @limit_size

            return (_cacheSize + _dataSize) < _limitSize

        @_getNotationToByte = (notation) ->
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

        @_getContentSize = (obj) ->
            obj = @_cache if not obj?
                
            if not _.isObject obj
                console.log "Could not the know the content size , because is not object type."

            return JSON.stringify(obj).length

        # private method end

        @load()
        return @

    set: (key, val) ->
        # check the cache size
        if not @_isCouldAdd key, val
            console.log "Size not enough"

        # TODO : remove some data if the cache size is over than limit size

        # replace the value if the key is exist
        @_cache[key] = val

        # auto save if enable
        @save() if @auto_save is true
           
        return

    get: (key) ->       
        return @_cache[key] if @_cache[key]?

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
            @_cache = JSON.parse(fs.readFileSync(@filename))
        catch e
            
        return

    size: ->
        _.size(@_cache)

    content: ->
        JSON.stringify(@_cache)

module.exports = Cache