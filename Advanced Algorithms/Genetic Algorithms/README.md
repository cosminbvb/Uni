## Genetic Algorithm - Maximum of a positive function

"A genetic algorithm is a search heuristic that is inspired by Charles Darwin’s theory of natural evolution. This algorithm reflects the process of natural selection where the fittest individuals are selected for reproduction in order to produce offspring of the next generation." [(Source)](https://towardsdatascience.com/introduction-to-genetic-algorithms-including-example-code-e396e98d8bf3)

#### Problem statement:
Write a genetic algorithm for determining the maximum of a **positive** polynomial function on a given domain.

#### Input variables (**input.txt**):
- Polynomial coefficients 
  **OBS**: the example uses a 3rd degree polynomial function, meaning we need 4 coefficients. However, we can use a **n**-degree polynom, by quickly redefining the function at **line 7**, and giving the right number of coefficients as input. 
- Function Domain ([a, b])
- Population Dimension (**number of Chromosomes**)
- Precision
- Crossover Probability
- Mutation Probability
- Number of iterations

#### Explanation:

Before we jump into the steps, we need to find a way to encode and decode chromosomes. This can be achieved with the following rule:

![](https://github.com/cosminbvb/Uni/blob/master/Advanced%20Algorithms/Genetic%20Algorithms/codificare_decodificare.png?raw=true)

Given the precision p as input, we can calculate the number of "buckets": ```(b-a)*10^p```.

Then, we can compute the fixed length of a chromosome (the number of bits necessary for binary representing any number in the given interval with the given precision), by applying the following rule:
```l = ceil(log((b-a)*(10**p), 2))```

So, a chromosome will be represented by *l* bits (genes).

Finally, the decoding can be done with the last rule. To get the real value of a chromosome, convert it to integer, multiply it by ```(b-a)/(2^l-1)``` and then add the start value of the interval (a).

Also, the **fitness function** represents the polynomial function we are trying to maximize. (line 7)
##### 1. Creating the initial population
We need to generate n random chromosomes, n being the population dimension. So, repeat the following steps n times:

Generate a non-negative integer with *l* random bits. Convert it to binary. Add it to the population.
Now, in order to decode it (for monitoring the evolution), follow the last rule described above.

##### 2. Selection probabilities
The selection probability for each chromosome will be computed by dividing the fitness of the given chromosome (apply the fitness function f) by the sum of the all the fitnesses.

##### 3. Selection intervals
After we computed the selection probability for each chromosome, we need to define n intervals of selection. Let's see an example starting with the selection probabilities computed at step 2:
```
cromozom 1 probability 0.024699602747342522
cromozom 2 probability 0.08001529948255053
cromozom 3 probability 0.024432678116920764
cromozom 4 probability 0.04062885273753368
cromozom 5 probability 0.041697382151605254
cromozom 6 probability 0.03662006624591702
cromozom 7 probability 0.04449895652120226
cromozom 8 probability 0.0659768387475237
cromozom 9 probability 0.026144809216312747
cromozom 10 probability 0.057282460532441466
cromozom 11 probability 0.056534761262652194
cromozom 12 probability 0.07597118248024953
cromozom 13 probability 0.04286062898587039
cromozom 14 probability 0.079677746693983
cromozom 15 probability 0.023850528358446327
cromozom 16 probability 0.05261104159733176
cromozom 17 probability 0.053430447838577304
cromozom 18 probability 0.05292915322799844
cromozom 19 probability 0.08000524281206668
cromozom 20 probability 0.040132320243474406
```
From there, the intervals should look like this:
```
0
0.024699602747342522
0.10471490222989305
0.1291475803468138
0.16977643308434748
0.21147381523595274
0.24809388148186975
0.292592838003072
0.3585696767505957
0.38471448596690844
0.4419969464993499
0.49853170776200206
0.5745028902422515
0.6173635192281219
0.6970412659221049
0.7208917942805513
0.773502835877883
0.8269332837164604
0.8798624369444588
0.9598676797565254
1
```

##### 4. Selection
So here, we need to select the new generation of chromosomes.
The chromosome which will automatically be selected is the one with the best fitness (in our case, this means the chromosome which has the maximum value of the function f). This is also known as **elitist selection**.
The rest n-1 chromosomes will be selected using the intervals computed earlier.
This is where step 3 will make sense. 
So for n-1 iterations, we will generate a random number *u* in [0, 1), and we will find which interval *u* belongs to. Knowing that, we select the chromosome that is represented by that exact interval.

For example, if ```u=0.5382202678476368```, it falls in the ```[0.49853170776200206, 0.5745028902422515)``` interval, which belongs to chromosome number 12. So, chromosome 12 is selected.

##### 5. Crossover selection (which chromosomes will participate in crossover)
**OBS**: The elitist chromosome (1) is left out of crossover. However, it will likely be selected at least twice at step 4, given that it has the best fitness and therefore the highest probability of being selected, in which case it **will** take part in crossover.

For each chromosome starting from the second one:
- generate a random number in [0,1). 
- if that number is less than the crossover probability given as input, the cromosome is selected for crossover

##### 6. Crossover
First of all, we shuffle the chromosomes.
Then, if we have at least 2 chromosomes selected for crossover, we take pairs and crossover the pair members. In case we have an odd number of chromosomes, we should crossover the last 3 together.
How does crossover work?
We generate a random integer <= the length of the chromosome, called breaking point. Each chromosome will keep the first n = breaking point bits and take the remaining from the other one.
Here's an example of recombining 2 chromosomes:
```
Let's say we have the following 2 chromosomes:
1: 10110110011110100011000 
2: 11111010100011010001001
and we generate a breaking point = 13
1: 1011011001111|0100011000
2: 1111101010001|1010001001
So, the first one will keep the first 13 genes (bits) and take the remaining from the other one. Same thing for the second one.
1: 10110110011111010001001
2: 11111010100010100011000
```
In case of 3 chromosomes, 1 will crossover with 2, 2 with 3 and 3 with 1.

##### 7. Mutation
 
```
For each chromosome:
    For each gene (bit):
       Generate a random number u in [0, 1)
       If u <= mutation_probability then
           Reverse the bit (0->1, 1->0)
```          
    


