# Prolog uriparser

Prolog bindings for the [uriparser]() library.

## Prerequisites

The uriparser library must be installed instance-wide prior to
installing this package:

```sh
apt install liburiparser-dev
```

## Installation

Perform the following call in [SWI-Prolog](http://www.swi-prolog.org):

```pl
pack_install(uriparser).
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
