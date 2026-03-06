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

% this will determine if, given a list of rooms, if you can get from entry to exit using all those rooms along the path
solveRooms(Castle, L) :-
  % print the enter room
  writeln(enter),
  % use the helper to traverse through the tree starting at the start node
  traverse(Castle, enter, L).

% helper to actually traverse the graph
% this is a helper base case, where we're at the exit and the given room list is empty
traverse(Castle, exit, []) :-
  writeln(exit), % print the exit room
  true. % we did it if we made it here

% recursive case 1 for helper: if the next room matches the head of our list
traverse(Castle, CurrentRoom, [NextRoom | GivenListTail]) :-
  % find a connected room that matches the head item of our list
  room(Castle, CurrentRoom, NextRoom, Cost),

  % print the room
  writeln(NextRoom),

  % since we found a match keep recursing starting from that room and also remove the current room from the list
  traverse(Castle, NextRoom, GivenListTail).

% recursive case 2 for helper: if the next room doesn't match the first item in the list
traverse(Castle, CurrentRoom, [Head | Tail]) :-
  % find a connected room
  room(Castle, CurrentRoom, NextRoom, Cost),

  % make sure that the next room doesn't equal the head of the given list
  Head \= NextRoom,

  % print the currnt room that we're taking along the path
  writeln(NextRoom),

  % keep recursing starting on the next room, and keep the given list as is
  traverse(Castle, NextRoom, [Head | Tail]).

% recursive case 3 for helper: keep going until we get to the exit even if the given list is empty
traverse(Castle, CurrentRoom, []) :-
  room(Castle, CurrentRoom, NextRoom, Cost),
  traverse(Castle, NextRoom, []).

% Add your comments here
solveRoomsWithinCost(Castle, Limit) :- 
  printList(NL).
