%% -*- mode: Prolog; fill-column: 75; comment-column: 50; coding: utf-8 -*-

/* Codificacion: tej(Arriba,Derecha,Abajo,Izquierda)*/
tej(_,_,_,_).

/* Comprueba que la lista pasada sea de tejuelos */
listaTej([tej(_,_,_,_)]):-!.
listaTej([tej(_,_,_,_)|L]):-listaTej(L).

/* Comprueba que combinen dos tejuelos */
/* El de la izquierda con el de la derecha */
combinanHorizontal(tej(_,C,_,_),tej(_,_,_,C)).
/* El de arriba con el de abajo */
combinanVertical(tej(_,_,C,_),tej(C,_,_,_)).

/* Expande el patron añadiendole hueco para las columnas */
expandePatron([X],Long):-length(X,Long),!.
expandePatron([X|Y],Long):-
	length(X,Long),
	expandePatron(Y,Long).

/* Crea el patron a rellenar*/
crearPatron(X,Y,Patron):-
	length(Patron,X), /*Crea espacio para las filas */
	expandePatron(Patron,Y). /*rellena las filas con hueco para las columnas*/

/* Declaración de not */
not(X):-call(X),!,fail.
not(_).

/* Imprime una fila */
pintaFila([A|B]):-write('|'),write(A),write('|'),pintaFila(B).
pintaFila([]).
/* Imprime todas las filas */
pintaResultado([A|B]):-pintaFila(A),nl,pintaResultado(B).
pintaResultado([]).

/* Da las 4 rotaciones posibles de un tejuelo */
/* Sin girar */
rota(tej(A,B,C,D),tej(A,B,C,D)).
/* Giro a la izquierda */
rota(tej(A,B,C,D),tej(B,C,D,A)).
/* Del revés */
rota(tej(A,B,C,D),tej(C,D,A,B)).
/* Giro a la derecha */
rota(tej(A,B,C,D),tej(D,A,B,C)).

quitaTej(_,[],[]):-!.
quitaTej(X,[X|Y],Y):-!.
quitaTej(X,[A|Y],[A|Z]):-quitaTej(X,Y,Z).

/* Completa una fila sin tener en cuenta la fila que hay encima (para llenar la primera fila) */
completaFila1([X],Tej,Resto):-
	member(A,Tej),
	rota(A,X), /* X es una rotacion de A */
	quitaTej(A,Tej,Resto).

completaFila1([X|Y],Tej,Resto):-
	member(A,Tej),
	rota(A,X), /*X es una rotación de A */
	quitaTej(A,Tej,NuevaLista),
	completaFila1(Y,NuevaLista,Resto),
	Y=[B|_], /*B es el tejuelo a la derecha de X */
	combinanHorizontal(X,B).

/* Completa una fila teniendo en cuenta la fila que hay encima */
completaFila2([A],[B],Tej,Resto):-
	member(C,Tej),
	rota(C,B),/* B es una rotación de C */
	combinanVertical(A,B),
	quitaTej(C,Tej,Resto).

completaFila2([A|B],[C|D],Tej,Resto):-
	member(E,Tej),
	rota(E,C), /* C es una rotación de E */
	combinanVertical(A,C),
	quitaTej(E,Tej,Nuevos),
	completaFila2(B,D,Nuevos,Resto),
	D=[F|_], /*F es el tejuelo que queda a la derecha de C */
	combinanHorizontal(C,F).

/* Coloca los tejuelos en el resto de filas. La primera fila tiene que estar rellena */
completaElResto([A,B],Tej):-
	completaFila2(A,B,Tej,Restos).

completaElResto([A,B|C],Tej):-
	completaFila2(A,B,Tej,Resto),
	completaElResto([B|C],Resto).

/* Da las instrucciones para colocar los tejuelos. Primero la primera fila, y luego el resto de ellas */
completaPatron([A],Tej):-completaFila1(A,Tej,Resto).
completaPatron(Patron,Tej):-
	Patron=[A|_],
	completaFila1(A,Tej,Resto),
	completaElResto(Patron,Resto).

/* Rellena el área dado por las filas y columnas con los tejuelos de la lista */
resolverTablero(Filas,Columnas,Tej):-
	length(Tej,X),	/*Comprueba que haya*/
	Y is Filas*Columnas,	/*al menos tantos*/
	X>=Y,!,			/*tejuelos como huecos*/
	crearPatron(Filas,Columnas,Patron),
	completaPatron(Patron,Tej),
	pintaResultado(Patron).



