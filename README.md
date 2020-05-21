# Prolog uriparser

Prolog bindings for the [uriparser](https://uriparser.github.io/)
library.

## Dependencies

  1. Install [SWI-Prolog](https://www.swi-prolog.org).

  2. Install the uriparser library:

```sh
apt install liburiparser-dev
```

## Installation

Install this library:

```pl
swipl -g 'pack_install(prolog_uriparser)' -t halt
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
