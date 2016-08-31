# ds-cache [![Build Status](https://travis-ci.org/dz1984/ds-cache.svg?branch=master)](https://travis-ci.org/dz1984/ds-cache) [![NPM](http://img.shields.io/npm/v/ds-cache.svg)](https://www.npmjs.org/package/ds-cache)

Provide a tool that is simple data storage as cache and easy to use. 

The feature includes:

+ File size as Cache size.
+ Implement the LRU algorithm.

## Documents

Generate the document.
```shell
$ codo lib/cache.coffee
```
Or you can go to CoffeeDoc.info watch [this doc](http://coffeedoc.info/github/dz1984/ds-cache/master/).

## Installation

```shell
$ npm i ds-cache
```
## API
+ Cache(option) - Constructor.
    - option.limit_bytes: limit the cache file size. Default: '100K'
    - option.auto_save: enable auto save cache. Default: false
    - option.filename: full name of save file. Default: 'ds_cache.json'

+ set(key, value) - Put data into cache.
    - key: the key of data.
    - val: the value of data.

+ get(key) - Catch data via key.
    - key: the key that you want to catch the data.

+ clear([key]) - Remove the data via key. Clear all data in the cache if you invoke this method without any arguments
    - key: optional. You could remove the data by key, either remove all data without any arguments.

+ save() - Write the cache into the file.

+ load() - Load the cache from file.

+ size() - Return the number of data in the cache.

+ content() - Return the JSON string of cache.


## Examples
```js
var Cache = require("ds-cache");

// initial the cache instance
var cache = new Cache(
    {
        limit_bytes: '2M',  // limit file size
        auto_save:  true,
        filename: 'ds_cache.json'
    }
);

// add a data
cache.set('name', 'Donald');

// get value via key
cache.get('name');

// clear data via key
cache.clear('name');

// clear all data
cache.clear();

```

# License

The MIT License (MIT)
