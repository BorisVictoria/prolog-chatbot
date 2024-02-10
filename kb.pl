:- style_check(-singleton).

:- dynamic([male/1], [incremental(true)]).
:- dynamic([female/1], [incremental(true)]).
:- dynamic([parent/2], [incremental(true)]).
:- dynamic([child/2], [incremental(true)]).
:- dynamic([daughter/2], [incremental(true)]).
:- dynamic([son/2], [incremental(true)]).
:- dynamic([sibling/2], [incremental(true)]).
:- dynamic([sister/2], [incremental(true)]).
:- dynamic([brother/2], [incremental(true)]).
:- dynamic([grandmother/2], [incremental(true)]).
:- dynamic([grandfather/2], [incremental(true)]).
:- dynamic([grandparent/2], [incremental(true)]).
:- dynamic([aunt/2], [incremental(true)]).
:- dynamic([uncle/2], [incremental(true)]).
:- dynamic([mother/2], [incremental(true)]).
:- dynamic([father/2], [incremental(true)]).
:- dynamic([predecessor/2], [incremental(true)]).
:- dynamic([descendant/2], [incremental(true)]).
:- dynamic([relative/2], [incremental(true)]).

:- dynamic([p_parent/2], [incremental(true)]).
:- dynamic([p_child/2], [incremental(true)]).
:- dynamic([p_daughter/2], [incremental(true)]).
:- dynamic([p_son/2], [incremental(true)]).
:- dynamic([p_sibling/2], [incremental(true)]).
:- dynamic([p_sister/2], [incremental(true)]).
:- dynamic([p_brother/2], [incremental(true)]).
:- dynamic([p_grandmother/2], [incremental(true)]).
:- dynamic([p_grandfather/2], [incremental(true)]).
:- dynamic([p_aunt/2], [incremental(true)]).
:- dynamic([p_uncle/2], [incremental(true)]).
:- dynamic([p_mother/2], [incremental(true)]).
:- dynamic([p_father/2], [incremental(true)]).

:- table(male/1 as incremental).
:- table(female/1 as incremental).
:- table(parent/2 as incremental).
:- table(child/2 as incremental).
:- table(daughter/2 as incremental).
:- table(son/2 as incremental).
:- table(sibling/2 as incremental).
:- table(sister/2 as incremental).
:- table(brother/2 as incremental).
:- table(grandmother/2 as incremental).
:- table(grandfather/2 as incremental).
:- table(grandparent/2 as incremental).
:- table(aunt/2 as incremental).
:- table(uncle/2 as incremental).
:- table(mother/2 as incremental).
:- table(father/2 as incremental).
:- table(predecessor/2 as incremental).
:- table(descendant/2 as incremental).
:- table(relative/2 as incremental).

:- table(p_parent/2 as incremental).
:- table(p_child/2 as incremental).
:- table(p_daughter/2 as incremental).
:- table(p_son/2 as incremental).
:- table(p_sibling/2 as incremental).
:- table(p_sister/2 as incremental).
:- table(p_brother/2 as incremental).
:- table(p_grandmother/2 as incremental).
:- table(p_grandfather/2 as incremental).
:- table(p_aunt/2 as incremental).
:- table(p_uncle/2 as incremental).
:- table(p_mother/2 as incremental).
:- table(p_father/2 as incremental).

% checking contradictions

p_parent(X, Y) :-
    aggregate_all(count, parent(_, Y), N),
    N = 2,
    parent(X, Y),
    X \= Y,
    not(not_p_parent(X, Y)).

% check if possible to add new parent
p_parent(X, Y) :-
    not(predecessor(Y , X)),
    aggregate_all(count, parent(_, Y), N),
    N < 2,
    X \= Y,
    not(not_p_parent(X, Y)).

% check for grandparents
not_p_parent(X, Y) :-
    parent(Y, Z),
    aggregate_all(count, grandparent(_, Z), N),
    N = 4,
    X \= Y.

not_p_parent(X, Y) :-
    sibling(Y, Z),
    aggregate_all(count, parent(_, Z), N),
    N = 2,
    aggregate_all(count, parent(_, Y), M),
    M = 1,
    not(parent(X, Z)).

p_mother(X, Y) :-
    p_parent(X, Y),
    not(male(X)),
    X \= Y.

p_mother(X, Y) :-
    aggregate_all(count, parent(_, Y), N),
    N = 2,
    parent(X, Y),
    not(male(X)),
    X \= Y.

p_father(X, Y) :-
    p_parent(X, Y),
    not(female(X)),
    X \= Y.

p_father(X, Y) :-
    aggregate_all(count, parent(_, Y), N),
    N = 2,
    parent(X, Y),
    not(female(X)),
    X \= Y.

p_child(X, Y) :-
    p_parent(Y, X),
    X \= Y.

p_daughter(X, Y) :-
    aggregate_all(count, parent(_, X), N),
    N < 2,
    not(male(X)),
    X \= Y.

p_daughter(X, Y) :-
    aggregate_all(count, parent(_, X), N),
    N = 2,
    parent(Y, X),
    not(male(X)),
    X \= Y.

p_son(X, Y) :-
    aggregate_all(count, parent(_, X), N),
    N < 2,
    not(female(X)),
    X \= Y.

p_son(X, Y) :-
    aggregate_all(count, parent(_, X), N),
    N = 2,
    parent(Y, X),
    not(female(X)),
    X \= Y.

not_p_sibling(X, Y) :-
    A \= B,
    A \= C,
    A \= D,
    B \= C,
    B \= D,
    C \= D,
    parent(A, X),
    parent(B, X),
    parent(C, Y),
    parent(D, Y),
    X \= Y.

p_sibling(X, Y) :-
    not(not_p_sibling(X, Y)).

p_sister(X, Y) :-
    p_sibling(X, Y),
    not(male(X)).

p_brother(X, Y) :-
    p_sibling(X, Y),
    not(female(X)).

p_grandmother(X, Y) :-
    aggregate_all(count, grandparent(_, Y), N),
    N < 4,
    not(predecessor(Y, X)),
    not(male(X)),
    X \= Y.

p_grandmother(X, Y) :-
    aggregate_all(count, grandparent(_, Y), N),
    N = 4,
    grandmother(X, Y),
    not(predecessor(Y, X)),
    not(male(X)),
    X \= Y.

p_grandfather(X, Y) :-
    aggregate_all(count, grandparent(_, Y), N),
    N < 4,
    not(predecessor(Y, X)),
    not(female(X)),
    X \= Y.

p_grandfather(X, Y) :-
    aggregate_all(count, grandparent(_, Y), N),
    N = 4,
    grandfather(X, Y),
    not(predecessor(Y, X)),
    not(female(X)),
    X \= Y.

p_aunt(X, Y) :-
    not(predecessor(Y, X)),
    not(male(X)),
    X \= Y.

p_uncle(X, Y) :-
    not(predecessor(Y, X)),
    not(female(X)),
    X \= Y.

% gender checking
male(X) :- brother(X, _); father(X, _); grandfather(X, _); son(X, _); uncle(X, _).
female(X) :- sister(X, _); mother(X, _); grandmother(X, _); daughter(X, _); aunt(X, _).

% parent
parent(X, Y) :- father(X, Y), X \= Y.
parent(X, Y) :- mother(X, Y), X \= Y.
parent(X, Y) :- daughter(Y, X); son(Y, X), X \= Y.

father(X, Y) :- parent(X, Y), male(X), X \= Y.
mother(X, Y) :- parent(X, Y), female(X), X \= Y.

% child
child(X, Y) :- parent(Y, X), X \= Y.
child(X, Y) :- daughter(X, Y), X \= Y.
child(X, Y) :- son(X, Y), X \= Y.

son(X, Y) :- child(X, Y), male(X), X \= Y.
daughter(X, Y) :- child(X, Y), female(X), X \= Y.

% sibling
sibling(X, Y) :-
    parent(Z, X), parent(Z, Y),
    X \= Y,
    X \= Z,
    Y \= Z.

sibling(X, Y) :-
    sibling(Y, X),
    X \= Y.

sibling(X, Y) :-
    sibling(X, Z), sibling(Z, Y),
    X \= Y,
    X \= Z,
    Y \= Z.

sibling(X, Y) :- brother(X, Y); sister(X, Y), X \= Y.

brother(X, Y) :- sibling(X, Y), male(X), X \= Y.
sister(X, Y) :- sibling(X, Y), female(X), X \= Y.

% grandparent
grandparent(X, Y) :- parent(X, Z), parent(Z, Y), X \= Y, X \= Z, Y \= Z.
grandparent(X, Y) :- grandfather(X, Y), X \= Y.
grandparent(X, Y) :- grandmother(X, Y), X \= Y.
grandfather(X, Y) :- grandparent(X, Y), male(X), X \= Y.
grandmother(X, Y) :- grandparent(X, Y), female(X), X \= Y.

% relatives
aunt(X, Y) :- parent(Z, Y), sibling(X, Z), female(X), X \= Y, X \= Z, Y \= Z.
uncle(X, Y) :- parent(Z, Y), sibling(X, Z), male(X), X \= Y, X \= Z, Y \= Z.

predecessor(X, Y) :- parent(X, Y), X \= Y.
predecessor(X, Y) :- grandparent(X, Y), X \= Y.
predecessor(X, Y) :- parent(X, Z), predecessor(Z, Y), X \= Y, X \= Z, Y \= Z.

descendant(X, Y) :- predecessor(Y, X), X \= Y.
descendant(X, Y) :- parent(Z, X), descendant(Z, Y), X \= Y, X \= Z, Y \= Z.

relative(X, Y) :- predecessor(Z, X), predecessor(Z, Y), X \= Y, X \= Z, Y \= Z.
relative(X, Y) :- (predecessor(X, Y); descendant(X, Y)), X \= Y.
relative(X, Y) :- sibling(X, Y), X \= Y.
relative(X, Y) :- sibling(Z, Y), predecessor(Z, X), X \= Y, X \= Z, Y \= Z.
relative(X, Y) :- sibling(X, Z), descendant(Y, Z), X \= Y, X \= Z, Y \= Z.

