:- use_module(piezas).

% Sublista

% sublista(+Descartar, +Tomar, +L, -R)
sublista(D, T, L, R) :- append(P, S, L), length(P, D), append(R, _, S), length(R, T).

% Analizar el comportamiento de sublista(-Descartar, ?Tomar, +L, +R)

% El predicado sublista/4 es reversible en el primer y cuarto argumento.

% Como L va a estar instanciada, el primer append de sublista enumera finitas soluciones para P y S (todas las concatenaciones de dos listas que formen L), por lo tanto, 
% al evaluar length, P ya estará instanciado y, como length es reversible en el segundo argumento, instanciará correctamente tanto a D como a la longitud de P. 
% Al evaluar el segundo append, el R y el S estarán instanciados, por lo que no se colgará. Por último, en length(R, T), en caso de que T esté instanciado, 
% se evalúa si el predicado da true, y en caso de que no lo esté, se le da el valor a T de la longitud de la lista R que sí estará instanciada.

% Como estamos generando casos FINITOS en el primer append porque el L está instanciado, y luego simplemente vemos si los predicados construyen una respuesta correcta
% (los predicados son reversibles en todos sus argumentos), en caso que se encuentre una solución, la devuelve, en caso que no se encuentre ninguna, dará false.  


% Tablero

% Es valida cuando T tiene todos sus elementos de tamaño K

% todasFilasMiden(?K, ?T)
todasFilasMiden(K,[F]) :- length(F,K).
todasFilasMiden(K, [F|FS]) :- length(F, K), todasFilasMiden(K, FS).

% tablero(+K, ?T)
tablero(K, T) :- tamaño(T, 5, K).

% Tamaño

% tamaño(+M, -F, -C)
tamaño(M, F, C) :- length(M, F), todasFilasMiden(C, M).

% Coordenadas

% coordenadas(+T, -IJ)
coordenadas(T, (X, Y)) :- between(1, 5, X), tamaño(T, 5, C), between(1, C, Y). 

% como un tablero tiene 5 filas, la coordenada X puede estar entre 1 y 5, luego con tamaño buscamos el número de columnas y lo instanciamos en C,
% luego la coordenada Y va a estar entre 1 y C, de está manera generamos todas las coordenadas válidas de un tablero.

% K-Piezas

% kPiezas(+K, -PS)
kPiezas(K,Ps) :- nombrePiezas(L), tomarKPiezas(K, L, Ps).

% tomarKPiezas(+K,+L,-Ps)
tomarKPiezas(0, _, []).
tomarKPiezas(K, [X|Xs], [X|Ps]) :- length([X|Xs], L), L >= K, K > 0, Km1 is K - 1, tomarKPiezas(Km1, Xs, Ps).
tomarKPiezas(K, [_|Xs], Ps) :- length(Xs, L), L >= K, K > 0, tomarKPiezas(K, Xs, Ps).

% En este predicado auxiliar, formamos todas las posibles listas tomando o no tomando el primero elemento de la lista, cuando tomamos el primer elemento restamos uno al K
% y en caso de no tomarlo, descartamos ese elemento y seguimos la recursión sin restar el K, de esta manera mantenemos el mismo orden de L en Ps, 
% hacemos esto hasta llegar a K = 0. 
% En caso de que la longitud de la lista sea menor a K, no va a poder entrar a ninguna de las clausulas, por lo que cortará lo antes posible esta rama
% que sabemos que no va a llevar a una solución válida. 

% SeccionTablero

% seccionTablero(+T, +ALTO, +ANCHO, +IJ, ?ST)
seccionTablero(T, Alto, Ancho, (X, Y), Sec) :- Xp is X - 1, sublista(Xp, Alto, T, Tp),
                                                Yp is Y - 1, maplist(sublista(Yp, Ancho), Tp, Sec).

% Ubicar pieza

% ubicarPieza(+Tablero, +Identificador)
ubicarPieza(T, I) :- pieza(I, P), tamaño(P, F, C), coordenadas(T, IJ), seccionTablero(T, F, C, IJ, P).

% por cada coordenada del tablero, ubicamos la pieza a partir de esa coordenada, en caso de ser posible. 

% Ubicar piezas (por ahora la poda es sinPoda)

% poda(sinPoda, _).

% ubicarPiezas(+Tablero, +Poda, +Identificador)
ubicarPiezas(_, _, []).
ubicarPiezas(T, Poda, [P|PS]) :- ubicarPieza(T, P), poda(Poda, T), ubicarPiezas(T, Poda, PS).

% Por cada pieza de la lista la vamos ubicando (siempre que se cumpla la poda), de modo que unifique con una seccion del tablero, 
% hasta que la lista de piezas quede vacía, en caso contrario da false.

% Llenar Tablero

% llenarTablero(+Poda, +Columnas, -Tablero)
llenarTablero(P, C, T) :- tablero(C, T), kPiezas(C, LP), ubicarPiezas(T, P, LP).

% Creamos el tablero con C columnas, y con kPiezas buscamos todas las formas de tomar C piezas y para cada combinación, 
% intentamos ubicar las C piezas en el tablero.

% Medición

% cantSoluciones(Poda, Columnas, N) :- findall(T, llenarTablero(Poda, Columnas, T), TS), length(TS, N).

% Estos fueron nuestros resultados en nuestra (humilde) computadora:

% time(cantSoluciones(sinPoda,3,N)).             
% % 41,137,617 inferences, 3.266 CPU in 3.312 seconds (99% CPU, 12597165 Lips)
% N = 28.

% time(cantSoluciones(sinPoda,4,N)).
% % 1,575,480,512 inferences, 130.719 CPU in 134.449 seconds (97% CPU, 12052445 Lips)
% N = 200.

% ?- time(cantSoluciones(podaMod5,4,N)).
% % 380,567,279 inferences, 25.980 CPU in 25.986 seconds (100% CPU, 14648247 Lips)
% N = 200.

% ?- time(cantSoluciones(podaMod5,3,N)).
% % 18,961,582 inferences, 1.293 CPU in 1.294 seconds (100% CPU, 14663761 Lips)
% N = 28.


cantSoluciones(Poda, Columnas, N) :- findall(T, llenarTablero(Poda, Columnas, T), TS), length(TS, N).


% Optimización

poda(sinPoda, _).
poda(podaMod5, T) :- todosGruposLibresModulo5(T).

% coordenadaLibre(+T, ?IJ)
coordenadaLibre(T, (I, J)) :- coordenadas(T, (I, J)), nth1(I, T, F), nth1(J, F, E), var(E).

% coordenadaLibre es verdadero si la coordenada IJ es válida y su valor es una variable libre.

% todasCoordenadasLibres(+T, -L)
todasCoordenadasLibres(T, L) :- findall(IJ, coordenadaLibre(T, IJ), L).

% Dado un tablero T, todasCoordenadasLibres instancia una lista L con las coordenadas del tablero con variables libres.

% todosGruposLibres(+T, -G)
todosGruposLibres(T, G) :- todasCoordenadasLibres(T, L), agrupar(L, G).

% Dado un tablero T, el predicado todosGruposLibres es verdadero si G es el resultado de agrupar todas las coordenadas con variables libres en el tablero.

% tieneLargoModulo5(+L)
tieneLargoModulo5(L) :- length(L, N), 0 =:= N mod 5.

% Dada una lista L, el predicado tieneLargoModulo5 es verdadero si, la longitud de la lista es multiplo de 5. 

% todosGruposLibresModulo5(+Tablero)
todosGruposLibresModulo5(T) :- todosGruposLibres(T, GS), forall(member(G, GS), tieneLargoModulo5(G)).

% Dado un tablero T, el predicado todosGruposLibresModulo5 es verdadero si, todo elemento de la lista de grupos de coordenadas con variables libres, 
% cumple el predicado tieneLargoModulo5. 

