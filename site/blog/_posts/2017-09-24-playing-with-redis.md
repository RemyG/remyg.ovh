---
title: Playing with Redis
date: 2017-09-24T20:00:0+00:00
author: RemyG
layout: rg-post
categories: Development
tags:
  - redis
  - docker
---

A couple of weeks ago, I went to a [Redis Meetup](https://www.meetup.com/Redis-Lille/events/242026831/) in Lille, presented by [François Cerbelle](https://fcerbell.github.io/). It motivated me to look a bit more into Redis.

Redis is an open-source in-memory key-value database, which supports different kinds of data structures, such as strings, lists, maps, sets, sorted sets...

<!--more-->

Or as said on the [official website](https://redis.io/):

> Redis is an open source (BSD licensed), in-memory data structure store, used as a database, cache and message broker. It supports data structures such as strings, hashes, lists, sets, sorted sets with range queries, bitmaps, hyperloglogs and geospatial indexes with radius queries. Redis has built-in replication, Lua scripting, LRU eviction, transactions and different levels of on-disk persistence, and provides high availability via Redis Sentinel and automatic partitioning with Redis Cluster.

## Interactive tutorial

An interactive tutorial is available at [try.redis.io](http://try.redis.io/), which presents the basic but most important features of Redis.


## Basic CLI commands

```
set my_key my_value => returns OK
get my_key => return my_value
```

Atomic operations

```
set my_counter 1 => returns OK
incr my_counter => returns 2, set my_counter to 2 atomically
decr my_counter => returns 1, set my_counter to 1 atomically
```

* Handle expiration

```
set resource:lock "redis lock"
expire resource:lock 120 => the key resource:lock will be deleted in 120 seconds
ttl resource:lock => returns the number of seconds before expiration (eg. 111)
```

```ttl``` will return ```-2``` if the resource has expired, ```-1``` if the resource will never expire, or a positive number for the remaining seconds before expiration.

* Lists

```
rpush my_list my_val1 => puts my_val1 at the end of my_list, returns the size of the list
lpush my_list my_val2 => puts my_val2 at the beginning of my_list, returns the size of the list
lrange my_list 1 4 => returns the elements from index 1 to index 4 (0-based)
llen my_list => returns the size of the list
lpop my_list => removes the first element of the list and returns it
rpop my_list -> removes the last element of the list and returns it
```

* Sets

```
sadd my_set my_val1 => add my_val1 to the set, returns the number of values added (if my_set already contains my_val1, will return 0)
srem my_set my_val2 => remove my_val2 from the set, returns the number of values removed (if my_set doesn't contain my_val2, will return 0)
sismember my_set my_val1 => returns 1 if my_set contains my_val1, 0 otherwise
smembers my_set => returns the members of the set
sunion my_set1 my_set2 => returns the combined members of my_set1 and my_set2
```

* Sorted sets

```
zadd my_sorted_set 1.5 my_val1 => add my_val1 to my_sorted_set with the weight 1.5, returns the number of values added
zadd my_sorted_set 1.2 my_val2 => add my_val2 to my_sorted_set with the weight 1.2
zrange my_sorted_set 0 1
```

* Hashes

Hashes are maps between string fields and string values, so they are the perfect data type to represent objects

```
hset user:1000 name "user name"
hset user:1000 email "user email"
hset user:1000 password "user password"
hgetall user:1000 => returns all the saved data 
hmset user:1001 name "user name 2" password "hidden" email "user password 2"
hget user:1001 name => "user name 2"
```

Atomic operations on hashes

```
hset user:1000 visits 10
hincrby user:1000 visits 1 => 11
hincrby user:1000 visits 10 => 21
hdel user:1000 visits
hincrby user:1000 visits 1 => 1
```

## Running with Docker

You can use the official Docker image for Redis:

```
docker run --name some-redis -d redis:4
```

An Alpine version is available:

```
docker run --name some-redis -d redis:4-alpine
```

### Run with your own configuration

You can create (or modify) a redis.conf file for your configuration. A corresponding Dockerfile would be:

```
FROM redis:4-alpine
COPY redis.conf /usr/local/etc/redis/redis.conf
CMD [ "redis-server", "/usr/local/etc/redis/redis.conf" ]
```

If you want to test the CLI operations described here, you can run a redis-cli client :

```
docker run -it --rm redis:4-alpine redis-cli -h some-redis -p 6379
```

