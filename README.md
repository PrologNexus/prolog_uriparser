# Prolog uriparser

Prolog bindings for the [uriparser](https://uriparser.github.io/)
library.

## Prerequisites

The uriparser library must be installed instance-wide prior to
installing this package:

```sh
apt install liburiparser-dev
```

## Installation

Run the following in [SWI-Prolog](http://www.swi-prolog.org):

```pl
pack_install(prolog_uriparser).
```

## Use

Include the library with the following declaration:

```pl
?- [library(uriparser)].
```

Then parse your first URI:

```
?- is_uri('https://check /').
false.
```
