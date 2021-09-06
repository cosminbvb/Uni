# Tema 1 AI
## [Problema de cautare (un mesaj)](http://www.irinaciocan.ro/inteligenta_artificiala/exemple-teme-a-star.php)

### Apelare
`>py <py file> <input folder> <output folder> <number of solutions> <timeout (in seconds)>`

Exemplu: `>py main.py input output 10 1`

### Algoritmi folositi:
- Uniform Cost Search
- A*
- A* optimizat (cu listele open si closed)
- IDA* (Iterative deepening A*)

### Euristici implementate:
- Euristica banala
    - 0 pentru stari finale, 1 pentru restul
- Euristica admisibila 1
    - Acesta euristica ignora urmatoarele conditii:
        - nu se poate da biletul catre o banca libera
        - nu se poate trece de pe o coloana pe alta decat in ultimele doua banci
        - biletul nu se poate deplasa intre doua persoane certate
        - biletul nu se poate afla langa banca celui ascultat (nici in banca sa, nici in cele vecine)
    - Se calculeaza distanta minima dintre sursa si destinatie, respectandu-se costurile mutarilor (0 in aceeasi banca,
      1 pe verticala, 2 intre coloane de banci). Este ca o distanta Manhattan cu ponderi.  
      Euristica este admisibila deoarece calculeaza un cost minim al unei variante a problemei din
      care au fost eliminate mai multe restrictii.
- Euristica admisibila 2
    - Comparativ cu euristica admisibila 1, se mai ia in considerare conditia ca biletul sa fie in ultimele
      doua banci pentru a trece de pe o coloana pe alta
    - Astfel, vrem sa calculam costul minim avand in vedere aceste restrictii.
      Daca sursa si destinatia se afla pe aceeasi coloana de banci, costul este egal cu numarul de banci parcurse vertical.  
      `Cost = |sursa.i - destinatie.i|`  
      Altfel, fie x banca cea mai apropiata de sursa (dintre ultima si penultima).  
      `Cost = |sursa.i - x.i| + |destinatie.i - x.i| + 2*|sursa.j//2 - destinatie.j//2|`  
      Euristica este admisibila deoarece calculeaza un cost minim al unei variante a problemei din
      care au fost eliminate mai multe restrictii.
- Euristica neadmisibila
    - Distanta Manhattan*2  
      `Cost = (|sursa.i - destinatie.i| + |sursa.j - destinatie.j|)*2`



### Fisiere de input
- Fisier de input care nu are solutii (input_a)  
  Configuratia nu are solutie deoarece destinatarul e certat cu toti vecinii lui
- Fisier de input care se afla deja in stare finala (input_b)
- Fisier de input care nu se blocheaza pe niciun algoritm (input_c)  
  De asemenea, pe acest input se poate observa cum euristica neadmisibila ofera un rezultat gresit
  (de exemplu pe A*, cu un numar de solutii >= 2)
- Fisier de input care sa blocheze un algoritm la timeout, dar minim un alt algoritm sa ofere solutia (input_d)  
  Avand in vedere contextul problemei, este dificil sa generez un astfel de fisier, independent de tipul de euristica ales,
  deoarece ar presupune o clasa extrem de mare, pentru un timeout de o secunda.
  In schimb, pentru fisierul input_d, daca toti algoritmii sunt rulati cu euristica banala, conditiile sunt indeplinite,
  acesta esuand pe IDA*


### Analiza performantelor
Urmatoarele date au fost obtinute pe input_d, timeout = 1 s :  
| Algoritm  | Euristica | Solutii gasite (intr-o secunda) | Numar total de noduri calculate | Numarul maxim de noduri din memorie (la un moment dat) | Durata pana la gasirea primei solutii (secunde) | Numarul de noduri calculate pana la prima solutie |
| :-------: | :-------: | :-----------------------------: | :-----------------------------: | :---------------------------: | :---------------------------------------------: | :------------------------------------------------:|
| UCS | - | 600 | 114181 | 114181 | 0.3055081367492676 | 43036 |
| A* | banala | 450 | 109007 | 109007 | 0.40990400314331055 | 56968 |
| A* | admisibila 1 | 2750 | 102287 | 102287 | 0.03623390197753906 | 5590 |
| A* | admisibila 2 | 4100 | 88642 | 88642 | 0.006062746047973633 | 1065 |      
| A* OPT | banala | - | 106 | nu a fost calculat | 0.0009970664978027344 | 106 |
| A* OPT | admisibila 1 | - | 101 | nu a fost calculat | 0.0009598731994628906 | 101 |
| A* OPT | admisibila 2 | - | 89 | nu a fost calculat | 0.0009479522705078125 | 89 |
| IDA* | banala | 0 | 172739 | 45 | TLE | N/A |
| IDA* | admisibila 1 | 1900 | 155962 | 49 | 0.051598548889160156 | 10099 |
| IDA* | admisibila 2 | 3500 | 132571 | 52 | 0.010008096694946289 | 1736 |

