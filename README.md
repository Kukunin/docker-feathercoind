This is ARMhf version of feathercoind

**Usage**

To start a feathercoind instance running the latest version:

```
$ docker run --name some-feathercoin kukunin/armhf-feathercoind
```

To run a feathercoin container in the background, pass the `-d` option to `docker run`:

```
$ docker run -d --name some-feathercoin kukunin/armhf-feathercoind
```

**Data Volumes**

By default, Docker will create ephemeral containers. That is, the blockchain data will not be persisted if you create a new feathercoin container.

To create a simple `busybox` data volume and link it to a feathercoin service:

```
$ docker create -v /data --name ftcdata armhf/busybox chown 999:999 /data
$ docker run --volumes-from ftcdata -d -p 9336:9336 -p 127.0.0.1:9337:9337 kukunin/armhf-feathercoind
```
