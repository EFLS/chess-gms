# Graphs on Chess Grandmasters

A simple R script that creates graphs about Chess players with the
Grandmaster title.

I made this to freshen up my R skills, but I remain a beginner. 

I created the following charts:
1. The number of GM titles by federation
2. The number of GM titles awarded each year.
3. GM titles by year, but with the highest year highlighted.
4. The total number of GM titles awarded over time.

The charts are available in PDF in `./graphs/`.

I'd like to add an overview of *alive* GMs, or a comparison by gender.

## Data used

Data is scraped from Wikipedia:
https://en.wikipedia.org/wiki/List_of_chess_grandmasters

Note:
- "Federation" is registered at the time the title was awarded. Chess
  players might have changed federations since achieving their title,
  or the federation might have ceased to exist (e.g. Soviet Union or
  East & West Germany).
- From time to time, FIDE awards honorary titles, sometimes to
  deceased chess players (e.g. Sultan Khan in 2024).

## License

Anyone is free to use or modify this code for whathever purpose they
see fit.

