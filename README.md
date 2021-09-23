# fossa
free objective-c stochastic simulation algorithm   
A command-line tool to simulate reaction of membrane receptors with stochastic Petri nets.

by Sebastian Malkusch (c) 2021   
Data Science| Klinische Pharmakologie   
Institut für Klinische Pharmakologie   
Goethe - Universität   
Theodor-Stern-Kai 7   
60590 Frankfurt am Main   

## Petri Nets
An introduction to petri nets can be found on wikipedia (https://en.wikipedia.org/wiki/Petri_net)

## Model Structure
The fossa stochastic Petri net consists of a total of 6 parameters which are composed of 4 vectors and 2 matrices.
 * places: States that can be assigned to the instances. Each instance is uniquely assigned to a place at each point in time of the simulation. Over time, the assigned place can change.
* transitions: Nomenclature of transitions allowed to an instance.
* initState: Die initiale Verteilung der Instanzen auf die places.
* reactionConstants: The propensities of the transitions to occur.
* eductMatrix: A matrix whose columns correspond to the places and whose rows correspond to the transitions. The integer numbers in each row indicate how many instances of which places are needed for the transition assigned to the respective row.
* productMatrix: A matrix whose columns correspond to the places and whose rows correspond to the transitions. The integer numbers in each row indicate how many instances of which places result from the transition assigned to the respective row.

## Compiling
Compile with gnustep (http://www.gnustep.org/) using the gnuMakefile. 

## Running the simulation
After compiling the code, you should get an executable file fossa_cli.
Simulate the example model for a tme interval of 20 s with the command:   

*./fossa_cli --tmax 20 --seed 42 --model data/Fab_CS6_cell20_fossa_model.txt*
