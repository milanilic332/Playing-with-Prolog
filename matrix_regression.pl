% Some matrix functions and linear regression (matrix_inversion used from matrix mdule)

make_vec([], N, _, N) :- !.
make_vec([1|T], K, K, N) :- K1 is K + 1,
                            make_vec(T, K1, K, N).

make_vec([0|T], P, K, N) :- P =\= K,
                            K1 is P + 1,
                            make_vec(T, K1, K, N).

make_eye([], N, N) :- !.
make_eye([H|T], K, N) :- make_vec(H, 0, K, N),
                         K1 is K + 1,
                         make_eye(T, K1, N).
%%%%%%%%%%%%%%%%%%%%%%%%% MULTIPLICATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
scalar([], [], 0) :- !.
scalar([H1|T1], [H2|T2], K) :- scalar(T1, T2, K1),
                               K is K1 + H1*H2.

nuls([]) :- !.
nuls([[]|T]) :- nuls(T).

remove_first(T, [], []) :- nuls(T), !.
remove_first([[H|T]|T1], [T|T2], [H|T3]) :- remove_first(T1, T2, T3).

transpose(T, []) :- nuls(T), !.
transpose(L, [H|K]) :- remove_first(L, Z, H),
                       transpose(Z, K).

calc(_, [], []) :- !.
calc(H1, [H|T], [H2|T2]) :- scalar(H1, H, H2),
                            calc(H1, T, T2).

dot_([], _, []) :- !.
dot_([H1|T1], P, [K|T3]) :- calc(H1, P, K),
                            dot_(T1, P, T3).

dot(L, R, K) :- transpose(R, R1),
                dot_(L, R1, K).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ones(0, []).
ones(N, [1|T]) :- N1 is N - 1,
                  ones(N1, T).

conc([], [], []).
conc([H1|T1], [H2|T2], [Z|TZ]) :- append([H1], [H2], Z),
                                  conc(T1, T2, TZ).

write_([[X], [Y]]) :- write('f(height) = '), write(X), write(' + '),
                      write(Y), write('*height').

regression() :- ones(10, L),
                X = [4.0, 4.5, 5.0, 5.2, 5.4, 5.8, 6.1, 6.2, 6.4, 6.8],
                Y = [42, 44, 49, 55, 53, 58, 60, 64, 66, 69],
                conc(L, X, XP),
                transpose(XP, XT),
                dot(XT, XP, XTdotX),
                matrix:matrix_inversion(XTdotX, Inv),
                dot(Inv, XT, Almost),
                transpose([Y], YT),
                dot(Almost, YT, Result),
                write_(Result), nl, !.
