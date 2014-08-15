# ds-cache [![Build Status](https://travis-ci.org/dz1984/ds-cache.svg?branch=master)](https://travis-ci.org/dz1984/ds-cache)

Simple data storage for cache.

+ LRU algorithm

## Installation

```shell
$ node i ds-cache
```
## API
+ set(key, value)

+ get(key)

+ save()

+ size()

+ content()

+ load()

## Example
```js
var Cache = require("ds-cache");

// initial cache instance
var cache = new Cache(
    {
        limit_bytes: '2M',  // limit file size
        auto_save:  true,
        filename: 'ds_cache.json'
    }
);

// set a data
cache.set('name', 'Donald');


// get value via key
cache.get('name');


// clear a data via key
cache.clear('name');


// clear all data
cache.clear()

```
