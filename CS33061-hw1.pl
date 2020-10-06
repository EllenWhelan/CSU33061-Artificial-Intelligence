
:- dynamic(kb/1).
% makeKB/1
makeKB(File):- open(File,read,Str),readK(Str,K),reformat(K,KB),asserta(kb(KB)), close(Str).

% readK/2
readK(Stream,[]):- at_end_of_stream(Stream),!.
readK(Stream,[X|L]):- read(Stream,X), readK(Stream,L).


% reformat/2
% takes the head of list1, encapsulates it in a list and prepends it to list2
reformat([],[]).
reformat([end_of_file],[]) :- !.
reformat([:-(H,B)|L],[[H|BL]|R]) :- !, mkList(B,BL), reformat(L,R).
reformat([A|L],[[A]|R]) :- reformat(L,R).

% mklist/2 
mkList((X,T),[X|R]) :- !, mkList(T,R).
mkList(X,[X]).

% initkb/1
initKB(File) :- retractall(kb(_)), makeKB(File).
% ----------------------------------------------------------------
% N=node c=cost
% arc/4
% arc finds possible actions that can be taken and their cost and returns possible destination node and the cost of the arc to that node
arc([H|T],N,C,KB) :- member([H|B],KB),append(B,T,N), length(B,L),C is L+1.

% addtofrontier/3 
% 'Frontier' is queue with the next node to expand at the head
addtofrontier(Children, Frontier, NewFrontier) :- append(Children, Frontier, Temp), minSort(Temp, NewFrontier).

minSort([H|T], Res) :- sort(H, [], T, Res).
sort(H, S, [], [H|S]).
sort(C, S, [H|T], Res) :- lessthan(C, H),sort(C, [H|S], T, Res);sort(H, [C|S], T, Res).

% lessthan/2
lessthan([N1,_,C1|_],[N2,_,C2|_]) :- heuristic(N1,Hval1),heuristic(N2,Hval2),F1 is C1+Hval1, F2 is C2+Hval2, F1 =< F2.

% heuristic/2
% the heuristic is length of the list
heuristic(N, H) :- length(N, H).

%------------------------------------------------------------------------
% astar
% c=cost N=node
astar(N,Path,Cost) :- kb(KB), astar2([[N, [], 0]],Path,C,KB).
astar2([[N, Path, C]|_], [N,Path], C, _) :- goal(N).
astar2([[N, P, C]|Rest], Path, C, KB) :-findall([X,[N|P],Sum], (arc(N, X, Y, KB), Sum is Y+C), Children),addtofrontier(Children, Rest, Temp),astar(Temp, Path, C, KB).

% goal/1
% the goal true when list empty 
goal([]).

