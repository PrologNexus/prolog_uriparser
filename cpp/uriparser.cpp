#include <cstdlib>
#include <iostream>
#include <memory>
#include <stdio.h>
#include <SWI-Stream.h>
#include <SWI-cpp.h>
#include <uriparser/Uri.h>
#include <wchar.h>

#define CVT_TEXT (CVT_ATOM|CVT_STRING|CVT_EXCEPTION|REP_UTF8)

PREDICATE(is_uri_, 1) {
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

// base, rel, abs
PREDICATE(resolve_uri_, 3) {
  char* baseStr;
  char* relStr;
  size_t baseLen, relLen;
  if (!PL_get_nchars(A1, &baseLen, &baseStr, CVT_TEXT) ||
	  !PL_get_nchars(A2, &relLen, &relStr, CVT_TEXT)) {
	PL_fail;
  }
  UriParserStateA state;
  UriUriA baseUri;
  state.uri = &baseUri;
  if (uriParseUriA(&state, baseStr) != URI_SUCCESS) {
	uriFreeUriMembersA(&baseUri);
	PL_fail; // TBD: throw something
  };
  UriUriA relUri;
  state.uri = &relUri;
  if (uriParseUriA(&state, relStr) != URI_SUCCESS) {
	uriFreeUriMembersA(&baseUri);
	uriFreeUriMembersA(&relUri);
	PL_fail; // TBD: throw something
  }
  UriUriA absUri;
  if (uriAddBaseUriA(&absUri, &relUri, &baseUri) != URI_SUCCESS) {
    uriFreeUriMembersA(&absUri);
    PL_fail; // TBD: throw something
  }
  char* absStr;
  int absLen;
  if (uriToStringCharsRequiredA(&absUri, &absLen) != URI_SUCCESS) {
	PL_fail; // TBD: throw something
  }
  absLen++;
  absStr = (char*)malloc(absLen * sizeof(char));
  if (absStr == nullptr) {
    PL_fail; // TBD: throw something
  }
  if (uriToStringA(absStr, &absUri, absLen, nullptr) != URI_SUCCESS) {
    PL_fail; // TBD: throw something
  }
  uriFreeUriMembersA(&absUri);
  return A3 = absStr;
}
