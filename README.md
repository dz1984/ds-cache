# ds-cache [![Build Status](https://travis-ci.org/dz1984/ds-cache.svg?branch=master)](https://travis-ci.org/dz1984/ds-cache) [![NPM](http://img.shields.io/npm/v/ds-cache.svg)](https://www.npmjs.org/package/ds-cache)

Provide a tool that is simple data storage as cache and easy to use. 

The feature includes:

+ File size as Cache size.
+ Implement the LRU algorithm.

## Documents

Generate the document.
```shell
$ code lib/cache.coffee
```
Or you can go to CoffeeDoc.info watch [this doc](http://coffeedoc.info/github/dz1984/ds-cache/master/).

## Installation

```shell
$ node i ds-cache
```
## API
+ Cache(option) 

+ set(key, value) - Put data into cache.

+ get(key) - Catch data via key.

+ clear([key]) - Remove the data via key. Clear all data in the cache if you invoke this method without any arguments

+ save() - Write the cache into the file.

+ load() - Load the cache from file.

+ size() - Return the number of data in the cache.

+ content() - Return the JSON string of cache.


## Examples
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
