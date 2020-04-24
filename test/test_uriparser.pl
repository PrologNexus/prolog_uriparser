:- use_module(library(plunit)).

:- use_module(library(uriparser)).

:- begin_tests(uriparser).

test(succeed_uri) :-
  check_uri('https://example.com/').

test(fail_uri, [fail]) :-
  check_uri('https://x y.z').

:- end_tests(uriparser).
