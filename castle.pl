% Base case, empty list, do nothing
printList([]) :-
  writeln([]).
% base case 2: one item in the list
printList([Item]) :-
  writeln(Item).
% otherwise recursively print each item in the list
printList([Head | Tail]) :-
  writeln(Head),
  printList(Tail).

% SOLVE ROOMS SECTION
% this will determine if, given a list of rooms, if you can get from entry to exit using all those rooms along the path
solveRooms(Castle, L) :-
  % use the helper to traverse through the tree starting at the start node
  traverse(Castle, enter, L, PathList),
  % print the list at the end
  printList(PathList).

% helper to actually traverse the graph
% this is a helper base case, where we're at the exit and the given room list is empty
traverse(Castle, exit, [], [exit]) :-
  true. % we did it if we made it here

% recursive case 1 for helper: if the next room matches the head of our list
traverse(Castle, CurrentRoom, GivenList, [CurrentRoom | PathTail]) :-
  % find a connected room that matches the head item of our list
  room(Castle, CurrentRoom, NextRoom, Cost),

  % this will search the full given list for the CurrentRoom, and if it does find it it will give us the list without that element
  select(CurrentRoom, GivenList, NewGivenList),

  % since we found a match keep recursing starting from that room and also remove the current room from the list
  traverse(Castle, NextRoom, NewGivenList, PathTail). % we keep on adding to the return list by continuing to add to the head of its tail, thus adding them from left to right in the list

% recursive case 2 for helper: if the next room doesn't match the first item in the list
traverse(Castle, CurrentRoom, GivenList, [CurrentRoom | PathTail]) :-
  % find a connected room
  room(Castle, CurrentRoom, NextRoom, Cost),

  % make sure that the next room doesn't equal any of the elements in the given list
  \+ memberOfX(CurrentRoom, GivenList),

  % keep recursing starting on the next room, and keep the given list as is
  traverse(Castle, NextRoom, GivenList, PathTail).

% recursive case 3 for helper: keep going until we get to the exit even if the given list is empty
traverse(Castle, CurrentRoom, [], [CurrentRoom | PathTail]) :-
  room(Castle, CurrentRoom, NextRoom, Cost),
  traverse(Castle, NextRoom, [], PathTail).

% helper to determine if an element is a member of a list
memberOfX(X, [X | _]). % base case, if X is the head of the array then that means we found it 
% otherwise, keep recursing until we hit the base case
memberOfX(X, [_|Tail]) :- 
	memberOfX(X, Tail).

% SOLVE ROOMS WITH COST SECTION
% this will determine if some path exists from the entry to the exit, whose weight is under or equal to the cost limit
solveRoomsWithinCost(Castle, Limit) :- 
  % run the traversal starting at the start room and with the given limit
  traverseWithCost(Castle, enter, Limit, Limit, PathList),
  printList(PathList). % print the path that was taken

% helper for finding if a path exists that's under the limit
% base case: if we made it to the end check if the path was under the limit 
% prolog will just traverse every path on its own through the recursion in the recursive case so i just need to specify what paths i do want to return true for
traverseWithCost(Castle, exit, Limit, OriginalLimit, [exit]) :- % also put the exit into the return list
  Limit >= 0, % make sure its remaning limit is greater than 0

  % calculate what we spent
  Spent is OriginalLimit - Limit,

  % printout how much we spent and the limit (i don't think this is required but it's displayed in his test cases so i'm going to do it)
  format('Cost is ~w with limit of ~w~n', [Spent, OriginalLimit]).

% recursive case 1: find the next room that sums the path weight to still be under the limit
traverseWithCost(Castle, CurrentRoom, Limit, OriginalLimit, [CurrentRoom | PathTail]) :-
  % stop looping if we've hit an exit
  CurrentRoom \= exit,

  % get one of the next rooms connected to the current room
  room(Castle, CurrentRoom, NextRoom, Cost), 

  % calculate the remaining cost
  NewLimit is Limit - Cost, 

  % check if we still have enough cost left
  NewLimit >= 0,

  % keep recursing and keep recording the path
  traverseWithCost(Castle, NextRoom, NewLimit, OriginalLimit, PathTail).
