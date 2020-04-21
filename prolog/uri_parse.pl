:- module(
  uri_parse,
  [
    check_iri/1,   % +Iri
    check_uri/1,   % +Uri
    is_http_uri/1, % @Term
    is_iri/1,      % @Term
    is_uri/1,      % @Term
    resolve_uri/3  % +Base, +Relative, ?Absolute
  ]
).
:- reexport(library(uri)).

/** <module> Prolog uriparser binding

*/

:- use_module(library(uri_ext)).

:- use_foreign_library(foreign(uri_parse)).





%! check_iri(+Iri:atom) is semidet.
%
% Succeeds iff `Iri' is an absolute IRI.
%
% TODO: Only checking for URI compliance ATM.

check_iri(Iri) :-
  uri_iri(Uri, Iri),
  check_uri(Uri).



%! check_uri(+Uri:atom) is semidet.
%
% Succeeds iff `Uri' is an absolute URI.
%
% @throws existence_error(uri_scheme,Scheme:atom)

check_uri(Uri) :-
  uri_components(Uri, uri_components(Scheme,Auth,Path,_,_)),
  check_scheme_(Scheme, Uri),
  scheme_specific_checks(Uri, Scheme, Auth, Path),
  is_uri_(Uri).

check_scheme_(Scheme, _) :-
  uri_scheme(Scheme), !.
check_scheme_(Schema, Uri) :-
  throw(error(existence_error(uri_scheme,Schema),Uri)).

scheme_specific_checks(_, Scheme, Auth, Path) :-
  (   % URI schemes that require a ground authority component.
      memberchk(Scheme, [http,https])
  ->  ground(Auth)
  ;   % URI schemes that require a ground path component.
      memberchk(Scheme, [file,mailto,urn])
  ->  ground(Path)
  ;   true
  ), !.
scheme_specific_checks(Uri, _, _, _) :-
  syntax_error(grammar(uri,Uri)).



%! is_http_uri(@Term) is semidet.
%
% Succeeds iff Term is an atom that conforms to the URI grammar.

is_http_uri(Uri) :-
  is_uri(Uri),
  uri_components(Uri, Comps),
  uri_data(scheme, Comps, Scheme),
  memberchk(Scheme, [http,https]).



%! is_iri(@Term) is semidet.

is_iri(Term) :-
  catch(check_iri(Term), E, print_message(warning, E)),
  var(E).



%! is_uri(@Term) is semidet.

is_uri(Term) :-
  catch(check_uri(Term), E, print_message(warning, E)),
  var(E).



%! resolve_uri(+Base:atom, +Relative:atom, +Absolute:atom) is semidet.
%! resolve_uri(+Base:atom, +Relative:atom, -Absolute:atom) is det.

resolve_uri(Base, Relative, Absolute) :-
  resolve_uri_(Base, Relative, Absolute).
