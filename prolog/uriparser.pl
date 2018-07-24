:- module(
  uriparser,
  [
    is_uri/1,     % @Term
    resolve_uri/3 % +Base, +Relative, ?Absolute
  ]
).

/** <module> uriparser

@author Wouter Beek
@versioin 2018
*/

:- use_foreign_library(foreign(uriparser)).





%! is_uri(@Term) is semidet.

is_uri(Term) :-
  is_uri_(Term).



%! resolve_uri(+Base:atom, +Relative:atom, +Absolute:atom) is semidet.
%! resolve_uri(+Base:atom, +Relative:atom, -Absolute:atom) is det.

resolve_uri(Base, Relative, Absolute) :-
  resolve_uri_(Base, Relative, Absolute).
