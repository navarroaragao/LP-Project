% lp24 - ist1113402 - projecto 
:- use_module(library(clpfd)). % para poder usar transpose/2
:- set_prolog_flag(answer_write_options,[max_depth(0)]). % ver listas completas
:- [puzzles]. % Ficheiro dado. A avaliação terá mais puzzles.
:- [codigoAuxiliar]. % Ficheiro dado. Não alterar.
% Atenção: nao deves copiar nunca os puzzles para o teu ficheiro de código
% Nao remover nem modificar as linhas anteriores. Obrigado.
% Segue-se o código
%%%%%%%%%%%% 



/* --------------------------------------------------------------------------------------------------  
   | visualiza(Lista):
   | Predicado que recebe uma lista e escreve todos os elementos da lista. 
   | Cada elemento é colocado numa linha diferente.
   --------------------------------------------------------------------------------------------------
*/
visualiza([]).
visualiza([Primeiro | Resto]) :-
    writeln(Primeiro), % Escreve cada elemento numa linha diferente
    visualiza(Resto).


/* --------------------------------------------------------------------------------------------------  
   | visualizaLinha(Lista):
   | Predicado que recebe uma lista e escreve todos os elementos da lista, cada elemento da lista é 
   | acompanhado pelo seu índice (índice da linha).
   | visualizaLinhaAux(Lista, N) - Predicado auxiliar que recebe uma lista e um número N.      
   --------------------------------------------------------------------------------------------------
*/
visualizaLinha(L) :- 
    visualizaLinhaAux(L, 1).

visualizaLinhaAux([], _).
visualizaLinhaAux([H|T], N) :-
    write(N), 
    write(': '), 
    writeln(H),
    NovoN is N + 1, % Incrementa o índice
    visualizaLinhaAux(T, NovoN). 


/* --------------------------------------------------------------------------------------------------  
   | insereObjecto((L, C), Tabuleiro, Obj):
   | Predicado que recebe uma coordenada (L, C), um tabuleiro e um objeto.
   | Após a aplicação deste predicado o objeto fica na posição (L, C) do tabuleiro.
   | Caso a posição (L, C) seja válida e esteja vazia, o objeto é inserido na posição (L, C) do tabuleiro.
   --------------------------------------------------------------------------------------------------
*/
insereObjecto((L, C), Tabuleiro, Obj) :- 
    nth1(L, Tabuleiro, Linha), % Obtém a linha L
    nth1(C, Linha, Obj), % Insere o objeto na posição
    !. % Não tenta inserir o objeto noutra posição

insereObjecto(_, _, _) :- !. % Caso em que a posição não é válida ou está ocupada


/* --------------------------------------------------------------------------------------------------
   | insereVariosObjectos(ListaCoords, Tabuleiro, ListaObjs):
   | Predicado que recebe uma lista de coordenadas, um tabuleiro e uma lista de objetos.
   | O resultado deste predicado é um tabuleiro com os objetos colocados nas respetivas coordenadas.
   | Se alguma posicao estiver ocupada, o predicado passa para a próxima.
   --------------------------------------------------------------------------------------------------
*/
insereVariosObjectos([], _, []) :- !. % Caso base: lista de objetos vazia
insereVariosObjectos([(Linha, Coluna) | RestoCoords], Tabuleiro, [Obj | RestoObjs]) :- !,
    length([(Linha, Coluna) | RestoCoords], NC), % Número total de coordenadas
    length([Obj | RestoObjs], NO), % Número total de objetos
    NC =:= NO, % Verifica se o número de coordenadas é igual ao número de objetos
    (insereObjecto((Linha, Coluna), Tabuleiro, Obj) ; true), % Insere o objeto na posição
    insereVariosObjectos(RestoCoords, Tabuleiro, RestoObjs), % Insere os restantes objetos
    !. % Não tenta inserir o objeto noutra posição


/* --------------------------------------------------------------------------------------------------
   | inserePontosVolta(Tabuleiro, (L, C)):
   | Predicado que recebe um tabuleiro e uma coordenada (L, C).
   | Insere pontos no tabuleiro à volta da posição (L, C).
   | Posições - (cima, baixo, esquerda, direita e diagonais).
   --------------------------------------------------------------------------------------------------
*/
inserePontosVolta(Tabuleiro, (L, C)) :-
    L1 is L - 1, % Linha de cima
    L2 is L + 1, % Linha  de baixo
    C1 is C - 1, % Coluna à esquerda
    C2 is C + 1, % Coluna à direita
    % Insere pontos p nas posições ao redor de (L, C)
    % Lista com todas as coordenadas possíveis
    ListaCoords = [(L1, C1), (L1, C), (L1, C2), (L, C1), (L, C2), (L2, C1), (L2, C), (L2, C2)], 
    inserePontos(Tabuleiro, ListaCoords), !. % Insere pontos ('p') nas coordenadas da lista de coordenadas


/* --------------------------------------------------------------------------------------------------
   | inserePontos(Tabuleiro, ListaCoord): 
   | Predicado que recebe um tabuleiro e uma lista de coordenadas.
   | Insere pontos em todas as coordenadas da lista de coordenadas.
   | Se alguma destas posições estiver ocupada, o predicado passa para a seguinte posição.
   --------------------------------------------------------------------------------------------------
*/
inserePontos(_, []). % Caso base: sem mais coordenadas
inserePontos(Tabuleiro, [Coord | RestoCoords]) :-
    insereObjecto(Coord, Tabuleiro, p), % Insere o ponto na coordenada
    inserePontos(Tabuleiro, RestoCoords), !. % Insere pontos nas restantes coordenadas


/* --------------------------------------------------------------------------------------------------
   | objectosEmCoordenadas(ListaCoords, Tabuleiro, ListaObjs):
   | Predicado que recebe uma lista de coordenadas, um tabuleiro e uma lista de objetos.
   | Verifica se os objetos nas coordenadas da lista são iguais aos objetos da lista.
   | Se algum objeto for diferente, o predicado falha.
   | --------------------------------------------------------------
   | objectoEmCoordenada((L, C), Tab, Obj):
   | Predicado auxiliar que recebe uma coordenada (L, C), um tabuleiro e um objeto.
   | Verifica se o objeto na posição (L, C) do tabuleiro é uma estrela, um ponto ou uma variável.
   --------------------------------------------------------------------------------------------------
*/
objectoEmCoordenada((L, C), Tab, Obj) :-
    nth1(L, Tab, Linha), % Obtém a linha L
    nth1(C, Linha, Obj), % Obtém o objeto na posição (L, C)
    (Obj == e ; Obj == p ; var(Obj)), !. % Verifica se o objeto é 'e', 'p' ou uma variável

objectosEmCoordenadas([], _, []).
objectosEmCoordenadas([(Linha, Coluna) | RestoCoords], Tabuleiro, [Obj | RestoObjs]) :- !,
    objectoEmCoordenada((Linha, Coluna), Tabuleiro, Obj), % Verifica se o objeto na posição é igual ao objeto da lista
    objectosEmCoordenadas(RestoCoords, Tabuleiro, RestoObjs). % Verifica os restantes objetos


/* --------------------------------------------------------------------------------------------------
   | coordObjectos(Objecto, Tabuleiro, ListaCoords, ListaCoordObjs, NumObjectos): 
   | Predicado que recebe um objeto, um tabuleiro, uma lista de coordenadas, uma sublista de coordenadas 
   | com as coordenadas onde o objeto se encontra e o número de objetos encontrados.
   | ListaCoordObjs é ordenada por linha e coluna
   | --------------------------------------------------------------
   | coordObjectosAux(Objecto, Tabuleiro, Coords, ListaCoordObjs, NumAtual, NumFinal):
   | Predicado auxiliar que recebe um objeto, um tabuleiro, uma lista de coordenadas não ordenadas,
   | uma sublista de coordenadas com as coordenadas onde o objeto se encontra, 
   | um número atual de objetos e um número final de objetos.
   | Verifica se o objeto está presente nas coordenadas da lista.
    --------------------------------------------------------------------------------------------------
*/
coordObjectos(Objecto, Tabuleiro, Coords, ListaCoordObjs, NumObjectos) :- !, 
     coordObjectosAux(Objecto, Tabuleiro, Coords, ListaCoordObjsNaoOrdenada, 0, NumObjectos), % Predicado auxiliar
     sort(ListaCoordObjsNaoOrdenada, ListaCoordObjs),!. % Ordena a lista de coordenadas

% Predicado auxiliar recursivo que processa as coordenadas e conta os objetos
coordObjectosAux(_, _, [], [], Num, Num) :- !. % Caso base: lista de coordenadas vazia
coordObjectosAux(Objecto, Tabuleiro, [(L, C) | Resto], [(L, C) | RestoObjs], NumAtual, NumFinal) :-
     objectoEmCoordenada((L, C), Tabuleiro, Obj), % Obtém o objeto que está na coordenada (L, C)
     (nonvar(Obj), % Verifica se o objeto não é uma variável
     Obj == Objecto ; var(Obj) , var(Objecto)), !, % Verifica se o objeto na posição é igual ao objeto
     NumProx is NumAtual + 1, % Incrementa o contador de objetos encontrados
     coordObjectosAux(Objecto, Tabuleiro, Resto, RestoObjs, NumProx, NumFinal), !. 

coordObjectosAux(Objecto, Tabuleiro, [_ | Resto], RestoObjs, NumAtual, NumFinal) :-
     % Caso em que a coordenada não é válida ou o objeto não corresponde
     coordObjectosAux(Objecto, Tabuleiro, Resto, RestoObjs, NumAtual, NumFinal), !.


/* --------------------------------------------------------------------------------------------------
   | coordenadasVars(Tabuleiro, ListaVars):
   | Predicado que recebe um Tabuleiro e devolve uma lista com as posições ocupadas por variáveis.
   | ListaVars é ordenada por linha e coluna.
   --------------------------------------------------------------------------------------------------
*/
coordenadasVars(Tabuleiro, ListaVars) :-
    % Encontra todas as coordenadas (Linha, Coluna) de variáveis no tabuleiro
    findall((Linha, Coluna),(nth1(Linha, Tabuleiro, LinhaTab),nth1(Coluna, LinhaTab, Obj), var(Obj)), ListaVars), !, 
    sort(ListaVars, _), !.


/* --------------------------------------------------------------------------------------------------
   | fechaListaCoordenadas(Tabuleiro, ListaCoord): 
   | Predicado que recebe um tabuleiro e uma lista de coordenadas e fecha a lista de coordenadas
   | de acordo com as seguintes hipóteses:
   | - Se a lista tem 2 estrelas, preenche as restantes posições da lista com pontos.
   | - Se a lista tem 1 estrela e 1 posição livre, preenche a posição livre com uma estrela e insere pontos à sua volta.
   | - Se a lista não tem estrelas e 2 posições livres, insere 2 estrelas e coloca pontos à sua volta.
   --------------------------------------------------------------------------------------------------
*/
fechaListaCoordenadas(Tabuleiro, ListaCoord) :- 
    coordObjectos(e, Tabuleiro, ListaCoord, _, 2), % Verifica se há 2 estrelas na lista
    inserePontos(Tabuleiro, ListaCoord), !. % Coloca pontos nas restantes posições da lista

fechaListaCoordenadas(Tabuleiro, ListaCoord) :- 
    coordObjectos(e, Tabuleiro, ListaCoord, _, 1), % Verifica se há 1 estrela na lista
    coordObjectos(Obj, Tabuleiro, ListaCoord, [(L, C)], 1), % verifica que se há 1 posição livre
    var(Obj),
    insereObjecto((L, C), Tabuleiro, e), % Insere a estrela na posição
    inserePontosVolta(Tabuleiro, (L, C)), !. % Insere pontos à volta da estrela

fechaListaCoordenadas(Tabuleiro, ListaCoord) :-  
    coordObjectos(e, Tabuleiro, ListaCoord, _, 0), % Verifica que não há nenhuma estrela colocada
    coordObjectos(Obj, Tabuleiro, ListaCoord,[(L1, C1), (L2, C2)], 2), % Verifica se há 2 posições livres
    var(Obj), 
    insereVariosObjectos([(L1, C1), (L2, C2)], Tabuleiro, [e, e]), % Insere as estrelas nas 2 posições livres
    % Insere pontos à volta de cada uma das estrelas
    inserePontosVolta(Tabuleiro, (L1, C1)), 
    inserePontosVolta(Tabuleiro, (L2, C2)), !.
    
fechaListaCoordenadas(_, _) :- !.


/* --------------------------------------------------------------------------------------------------
   | fecha(Tabuleiro, ListaCoord):
   | Predicado que recebe um tabuleiro e uma lista de coordenadas.
   | Após a aplicação deste predicado, todas as listas foram sujeitas ao predicado fechaListaCoordenadas/2.
   --------------------------------------------------------------------------------------------------   
*/
fecha(_, []) :- !.
fecha(Tabuleiro, [Coord | RestoCoords]) :- !,
    fechaListaCoordenadas(Tabuleiro, Coord), 
    fecha(Tabuleiro, RestoCoords), !.


/* --------------------------------------------------------------------------------------------------
   | encontraSequencia(Tabuleiro, N, ListaCoords, Seq):
   | Predicado que recebe um tabuleiro, uma lista de coordenadas, um número que representa o tamanho da lista
   | Seq, que é uma sublista de ListaCoods.
   |    Seq verifica o seguinte:
   |    - As suas coordenadas representam posições com variáveis;
   |    - As suas coordenadas aparecem seguidas (numa linha, coluna ou região);
   |    - Seq pode ser concatenada com duas listas, uma antes e uma depois, eventualmente
   |    vazias ou com pontos nas coordenadas respectivas, permitindo obter ListaCoords.
   |    De notar que se houver mais variáveis na sequência que N o predicado deve falhar.
   | --------------------------------------------------------------
   | sublistaConsecutiva(Lista, Sublista):
   | Predicado auxiliar que recebe uma lista e gera sublistas consecutivas de tamanho N.
   |    Sublista é uma sublista de Lista.
   |    Sublista pode ser concatenada com duas listas, uma antes e uma depois, eventualmente
   |    vazias ou com pontos nas coordenadas respectivas, permitindo obter ListaCoords.
   | --------------------------------------------------------------
   | coordTemVar(Tabuleiro, (L, C)):
   | Predicado que recebe um tabuleiro uma coordenada.
   | Verifica se o posição de coordenadas (L, C) é uma posição livre, ocupada por uma variável.
   --------------------------------------------------------------------------------------------------   
*/
encontraSequencia(Tabuleiro, N, ListaCoords, Seq) :- !,
    coordObjectos(e, Tabuleiro, ListaCoords, _, 0), % Verifica se não há estrelas nas coordenadas
    include(coordTemVar(Tabuleiro), ListaCoords, Seq), % Filtra as coordenadas com variáveis
    sublistaConsecutiva(ListaCoords, Seq), % Gera sublistas consecutivas
    length(Seq, N), % Verifica se Seq tem tamanho N
    !.

coordTemVar(Tabuleiro, (L, C)) :- !, 
    nth1(L, Tabuleiro, Linha), % Obtém a linha L
    nth1(C, Linha, Obj), % Obtém o objeto na posição (L, C)
    var(Obj), !. % Verifica se o objeto é uma variável (não instanciado)

sublistaConsecutiva(Lista, Sublista) :- !,
    append(_, Resto, Lista), % Separa a lista em duas partes
    append(Sublista, _, Resto), !. % Separa a sublista em duas partes


/* --------------------------------------------------------------------------------------------------
   | aplicaPadraoI(Tabuleiro, [(L1, C1), (L2, C2), (L3, C3)]) :
   | Predicado que recebe um tabuleiro e uma lista de coordenadas.
   | São colocadas estrelas nas coordenadas (L1, C1), (L3, C3) e pontos à volta das estrelas.
   --------------------------------------------------------------------------------------------------
*/
aplicaPadraoI(Tabuleiro, [(L1, C1), _, (L3, C3)]) :- !,
    insereObjecto((L1, C1), Tabuleiro, e), % Insere as estrelas nas posições inicial
    inserePontosVolta(Tabuleiro, (L1, C1)),!, % Insere os pontos à volta da coordenada (L1, C1)
    insereObjecto((L3, C3), Tabuleiro, e), % Insere as estrelas nas posições final
    inserePontosVolta(Tabuleiro, (L3, C3)), !. % Insere os pontos à volta da coordenada (L3, C3)


/* --------------------------------------------------------------------------------------------------
   | aplicaPadroes(Tabuleiro, ListaListaCoords):
   | Predicado que recebe um tabuleiro e uma lista de listas de coordenadas.
   | É aplicado o predicado aplicaPadraoI/2 em listas onde é encontrada uma sequência com tamanho 3.
   | É aplicado o predicado aplicaPadraoT/2 em listas onde é encontrada uma sequência com tamanho 4.
    --------------------------------------------------------------------------------------------------
*/
aplicaPadroes(_, []) :- !.
aplicaPadroes(Tabuleiro, [Lista | RestoLista]) :- 
    (
        (
            encontraSequencia(Tabuleiro, 3, Lista, _), % Verifica se há uma sequência de tamanho 3
            aplicaPadraoI(Tabuleiro, Lista), ! 
        )
        ;
        (
            encontraSequencia(Tabuleiro, 4, Lista, _), % verifica se há uma sequência de tamanho 4
            aplicaPadraoT(Tabuleiro, Lista), !
        )
        ;
            true % Se não encontrar nenhuma das sequências o programa continua, não falha
    ),
    aplicaPadroes(Tabuleiro, RestoLista), !.


/* --------------------------------------------------------------------------------------------------
   | resolve(Estruturas, Tabuleiro):
   | O predicado recebe estruturas e um tabuleiro.
   | São aplicados os predicados fecha/2 e aplicaPadroes/2, até não ser possível fazer mais nenhuma alteração.
   | --------------------------------------------------------------
   | repeteAteFinal(Tabuleiro, CT):
   | Predicado auxiliar que recebe um tabuleiro e uma lista de coordenadas.
   | Este predicado aplica os predicados fecha/2 até que não haja mais mudanças nas coordenadas das variáveis.
   | Se não houver mais mudanças o predicado termina.
   --------------------------------------------------------------------------------------------------
*/
resolve(Estruturas, Tabuleiro) :- 
    coordTodas(Estruturas, CT), % Passa Estruturas para coordenadas
    repeteAteFinal(Tabuleiro, CT). % Aplica os predicados até não haver mais mudanças

repeteAteFinal(Tabuleiro, CT) :-
    coordenadasVars(Tabuleiro, VarsAntes), % Obtém as coordenadas das variáveis antes de verificar padrões
    aplicaPadroes(Tabuleiro, CT), % Aplica os padrões
    fecha(Tabuleiro, CT), 
    coordenadasVars(Tabuleiro, VarsDepois), % Obtém as coordenadas das variáveis depois de verificar padrões
    (dif(VarsAntes,VarsDepois) -> repeteAteFinal(Tabuleiro, CT) ; true), !. % verifica se houve mudanças
