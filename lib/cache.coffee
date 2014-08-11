'use strict'

_ = require 'lodash'
fs = require 'fs'

LIMIT_SIZE = '100K'

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
        @auto_save = opt.auto_size || true
        @filename = opt.filename || 'ds_cache.json'

        @load()
        return @

    isCouldAdd : (key, val) ->
        _cacheSize = @getContentSize()
        _dataSize = @getContentSize key:val
        _limitSize = @getNotationToByte @limit_size

        return (_cacheSize + _dataSize) < _limitSize

    set: (key, val) ->

        # check the cache size
        if not @isCouldAdd key, val
            throw new Exception("Size not enough")

        # TODO : remove some data if the cache size is over than limit size

        # replace the value if the key is exist
        @_cache[key] = val

        if @auto_save
            @save()

        return

    get: (key) ->   
        if @_cache[key]?
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

        return _isCorrect

    load: ->
        try
            @_cache = JSON.parse(fs.readFileSync(@filename))
        catch e
            
        return

    size: ->
        return _.size(@_cache)

    content: ->
        return JSON.stringify(@_cache)

    getNotationToByte: (notation) ->
        if not _.isString notation
            throw  "The size notation isn't String type."

        SIZE_UNITS =
            'B' : 1
            'K' : 1000
            'M' : 1000000
            'G' : 1000000000

        notation = notation.toUpperCase()

        pattern = /(\d+)([B|K|M|G])/
        matches = pattern.exec(notation)

        if matches?
            return matches[1] * SIZE_UNITS[matches[2]]
        else
            throw "Could not to exchange the noation."            

        return 

    getContentSize: (obj) ->
        if not obj?
            obj = @_cache

        if not _.isObject obj
            throw "Could not the know the content size , because is not object type."

        return JSON.stringify(obj).length

module.exports = Cache