#include <SWI-Stream.h>
#include <SWI-cpp.h>
#include <uriparser/Uri.h>

#include <iostream>
#include <memory>
#include <stdio.h>
#include <wchar.h>

#define CVT_TEXT (CVT_ATOM|CVT_STRING|CVT_EXCEPTION|REP_UTF8)

PREDICATE(is_uri_, 1)
{
  char *s;
  size_t len;
  if (!PL_get_nchars(A1, &len, &s, CVT_TEXT)) {
    PL_fail;
  }
  UriParserStateA state;
  UriUriA uri;
  state.uri = &uri;
  bool isUri {(uriParseUriA(&state, s) == URI_SUCCESS ? true : false)};
  uriFreeUriMembersA(&uri);
  if (isUri) {
    PL_succeed;
  } else {
    PL_fail;
  }
}
