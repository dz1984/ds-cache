Simple data storage for cache.

# Install

```shell
$ node i ds-cache
```

# Example
```js
var Cache = require("ds-cache");

// initial cache instance
var cache = new Cache(
    {
        limit_bytes: '2M',
        auto_save:  true,
        filename: 'ds_cache.json'
    }
);

// set something
cache.set('name', 'Donald');


// get value
cache.get('name');


// clear a data
cache.clear('name');


// clear all data
cache.clear()

```
