#include <cstdio>
#include <cstdlib>
#include <cwchar>
#include <iostream>
#include <memory>

#include <SWI-Prolog.h>
#include <SWI-Stream.h>
#include <SWI-cpp.h>
#include <uriparser/Uri.h>
#include <uriparser/UriBase.h>

#define CVT_TEXT (CVT_ATOM|CVT_STRING|CVT_EXCEPTION|REP_UTF8)

extern "C" {
  static functor_t FUNCTOR_error2;
  static functor_t FUNCTOR_relative_uri1;
  static functor_t FUNCTOR_uri_error2;
  static functor_t FUNCTOR_uri_error3;
#define MKFUNCTOR(n,a) FUNCTOR_ ## n ## a = PL_new_functor(PL_new_atom(#n), a)
  auto install_uri_ext(void) -> install_t
  {
    MKFUNCTOR(error, 2);
    MKFUNCTOR(relative_uri, 1);
    MKFUNCTOR(uri_error, 2);
    MKFUNCTOR(uri_error, 3);
  }
}

// is_uri_(@Term) is semidet.
PREDICATE(is_uri_, 1)
{
  char* s;
  std::size_t length;
  if (!PL_get_nchars(A1, &length, &s, CVT_TEXT)) {
    PL_fail;
  }
  UriParserStateA state;
  UriUriA uri;
  state.uri = &uri;
  const bool ok {uriParseUriA(&state, s) == URI_SUCCESS};
  const bool absolute {uri.scheme.first};
  uriFreeUriMembersA(&uri);
  if (ok && absolute) {
    PL_succeed;
  } else {
    PL_fail;
  }
}

// resolve_uri_(+Base:atom, +Relative:atom, -Absolute:atom) is det.
PREDICATE(resolve_uri_, 3)
{
  char* baseStr;
  char* relativeStr;
  std::size_t baseLength, relativeLength;
  if (!PL_get_nchars(A1, &baseLength, &baseStr, CVT_TEXT) ||
      !PL_get_nchars(A2, &relativeLength, &relativeStr, CVT_TEXT)) {
    PL_fail;
  }
  UriParserStateA state;
  UriUriA baseUri;
  state.uri = &baseUri;
  if (uriParseUriA(&state, baseStr) != URI_SUCCESS) {
    uriFreeUriMembersA(&baseUri);
    PL_fail; // TBD: throw something
  };
  UriUriA relativeUri;
  state.uri = &relativeUri;
  if (uriParseUriA(&state, relativeStr) != URI_SUCCESS) {
    uriFreeUriMembersA(&baseUri);
    uriFreeUriMembersA(&relativeUri);
    PL_fail; // TBD: throw something
  }
  UriUriA absoluteUri;
  if (uriAddBaseUriA(&absoluteUri, &relativeUri, &baseUri) != URI_SUCCESS) {
    uriFreeUriMembersA(&absoluteUri);
    PL_fail; // TBD: throw something
  }
  char* absoluteStr;
  int absoluteLength;
  if (uriToStringCharsRequiredA(&absoluteUri, &absoluteLength) != URI_SUCCESS) {
    PL_fail; // TBD: throw something
  }
  ++absoluteLength;
  absoluteStr = (char*)malloc(absoluteLength * sizeof(char));
  if (!absoluteStr) {
    PL_fail; // TBD: throw something
  }
  if (uriToStringA(absoluteStr, &absoluteUri, absoluteLength, nullptr) != URI_SUCCESS) {
    PL_fail; // TBD: throw something
  }
  uriFreeUriMembersA(&absoluteUri);
  return A3 = absoluteStr;
}
