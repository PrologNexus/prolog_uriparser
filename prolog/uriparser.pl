:- module(
  uriparser,
  [
    is_uri/1 % @Term
  ]
).

/** <module> uriparser

@author Wouter Beek
@versioin 2018
*/

:- use_foreign_library(foreign(uriparser)).

is_uri(Term) :-
  is_uri_(Term).
