% Find if a list has a cycle of any length

choose(L, 0, [], L).
choose([H|T], N, [H|T1], M) :- N1 is N - 1,
                               choose(T, N1, T1, M).

same(L, [], L).
same([H|T], [H|T1], Z) :- same(T, T1, Z).

check_other([], _).
check_other(L, P) :- same(L, P, T),
                     check_other(T, P).

check_for_given_N([], _).
check_for_given_N(L, N) :- choose(L, N, L1, T1),
                           check_other(T1, L1).

find_len([], 0).
find_len([H|T], Len) :- find_len(T, LenP),
                        Len is LenP + 1.

iterate(L, 0).
iterate(L, N) :- not(check_for_given_N(L, N)),
                 N1 is N - 1,
                 iterate(L, N1).

cycle([X]).
cycle([H, H1|T]) :- find_len([H, H1|T], Len),
                    Len1 is Len div 2,
                    not(iterate([H, H1|T], Len1)).
