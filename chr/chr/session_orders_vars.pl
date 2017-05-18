#!/usr/bin/swipl -q
:- module(orders, [ev/1,hb/2,cb/2,snot/1,test/0]).
:- use_module(library(chr)).

:- initialization start.
:- chr_constraint ev/1,hb/2,cb/2,snot/1,test/0.


% disable singleton warning
:- style_check(-singleton).


% %% HOW TO USE
% Evs are pairs of role x label:
% e.g.  ev(A,1), ev(B2,a)

% Happens-before relations are tuples of (ev x ev):
% e.g.  hb(A,1,B2,a)

% Communicates-before relations are pairs of (ev x ev):
% e.g.  cb(A,a,B2,a)

%% SAMPLE QUERIES
%Q: hb(X,1,Y,2),hb(X,0,Y,2),hb(Y,2,Z,3),hb(Z,3,Y,2).
%A: false

%Q: hb(X,1,Y,2),hb(X,0,Y,2),hb(Y,2,Z,3).
%A: true


%%%%%%%%%%
%%%% RULES
%%%%%%%%%%
%negation rules for hb and ev
% neg0   @ snot(hb(A,A)) <=> true. %;(B=A,L2=L1).
% neg1   @ snot(hb(A,B)) ==> A\=B | hb(B,A). %;(B=A,L2=L1).
neg2   @ snot(A;B) <=> snot(A),snot(B).
neg3   @ snot((A,B)) <=> snot(A);snot(B).
neg4   @ ev(A) \ snot(ev(A))  <=> false.
asy0   @ hb(A,B) \ snot(hb(A,B)) <=> false.
sym1   @ hb(A,B) \ hb(A,B) <=> true .
asy2   @ hb(A,B), hb(B,A) ==> A=B.
asy3   @ hb(A,A)  <=> true.
% HB transitivity 
hbhb   @ hb(A,B), hb(B,C) ==> hb(A,C).
% CB transitivity 
cbhb   @ cb(A,B), hb(B,C) ==> B\=C | hb(A,C).
% cbhb   @ cb(A,L1,B,L1), hb(B,L1,C,L4) ==>  hb(A,L1,C,L4).

% hb(A,L1,B,L2) :- hb(A,L1,C,L3),hb(C,L3,B,L2).
% hb(A,L1,B,L2) :- cb(A,L1,C,L1),hb(C,L1,B,L2).

%%%%%%%%%%
%%%% UTILS
%%%%%%%%%%
writeln(T) :- write(T), nl.

checkff :-
        catch(read(user_input, Gl), E,
              ( print_message(error, E),
                halt
              ) ),
        (once((Gl)) -> writeln(true); writeln(false)).

start :-
    repeat,
    checkff,
    fail.


%  hb(X,1,Y,2),hb(X,0,Y,2),hb(Y,2,Y,2),hb(X,1,Z,3).
% halt.
% ^C
% Action (h for help) ? abort
                                % % Execution Aborted

% hb(X,1,Z,3), ?? |- hb(X,1,Y,2)

% hb(X,1,Z,3), hb(Z,3,Y,2) |- hb(X,1,Y,2)

% hb(Z,3,X,1) ;  hb(X,1,Y,2)
 
% hb(A,L1,B,L2) :- hb(A,L1,C,L3),hb(C,L3,B,L2).
% hb(A,L1,B,L2) :- cb(A,L1,C,L1),hb(C,L1,B,L2).

% A , Q |- B.
