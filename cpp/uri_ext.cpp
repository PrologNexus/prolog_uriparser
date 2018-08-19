#include <cstdlib>
#include <iostream>
#include <memory>
#include <stdio.h>
#include <SWI-Prolog.h>
#include <SWI-Stream.h>
#include <SWI-cpp.h>
#include <uriparser/Uri.h>
#include <uriparser/UriBase.h>
#include <wchar.h>

#define CVT_TEXT (CVT_ATOM|CVT_STRING|CVT_EXCEPTION|REP_UTF8)

extern "C" {
  static functor_t FUNCTOR_error2;
  static functor_t FUNCTOR_uri_error2;
  static functor_t FUNCTOR_uri_error3;

#define MKFUNCTOR(n,a) FUNCTOR_ ## n ## a = PL_new_functor(PL_new_atom(#n), a)

  install_t install_uri_ext(void) {
    MKFUNCTOR(error, 2);
    MKFUNCTOR(uri_error, 2);
    MKFUNCTOR(uri_error, 3);
  }
}

// is_uri_(@Term) is semidet.
PREDICATE(is_uri_, 1) {
  char *s;
  size_t len;
  if (!PL_get_nchars(A1, &len, &s, CVT_TEXT)) {
    PL_fail;
  }
  UriParserStateA state;
  UriUriA uri;
  state.uri = &uri;
  bool ok {(uriParseUriA(&state, s) == URI_SUCCESS)};
  uriFreeUriMembersA(&uri);
  if (ok) {
    PL_succeed;
  }
  term_t err {PL_new_term_ref()};
  if (state.errorCode == URI_ERROR_SYNTAX) {
    PL_unify_term(err,
                  PL_FUNCTOR, FUNCTOR_error2,
                  PL_FUNCTOR, FUNCTOR_uri_error3,
                  PL_INT, state.errorCode,
                  PL_CHARS, s,
                  PL_LONG, (long)(state.errorPos-s),
                  PL_VARIABLE);
  } else {
    PL_unify_term(err,
                  PL_FUNCTOR, FUNCTOR_error2,
                  PL_FUNCTOR, FUNCTOR_uri_error2,
                  PL_INT, state.errorCode,
                  PL_CHARS, s,
                  PL_VARIABLE);
  }
  return PL_raise_exception(err);
}

/*
// is_xsd_string_(@Term) is semidet.
PREDICATE(is_xsd_string_, 1)
{
  char* lex;
  size_t len;
  if (!PL_get_nchars(A1, &len, &lex, CVT_TEXT)) {
    PL_fail;
  }
  for (size_t i {0}; i < len; i++) {
    if (0x1 < lex[i] ||
        (0xD7FF < lex[i] && lex[i] < 0xE000) ||
        (0xFFFD < lex[i] && lex[i] < 0x10000) ||
        0x10FFFF < lex[i]) {
      PL_fail;
    }
  }
  PL_succeed;
}
*/

// resolve_uri_(+Base:atom, +Rel:atom, -Abs:atom) is det.
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
