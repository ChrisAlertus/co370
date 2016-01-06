/*********************************************
 * OPL 12.4 Model
 * Author: wningchu
 * Creation Date: 2014-01-28 at 10:08:43 AM
 *********************************************/

int NbProducts = ...;
int NbHours = ...;

range Products = 1..NbProducts;
range Hours = 1..NbHours;

float Revenue[Products] = ...;
float Raw[Products] = ...;
float Labor[Products] = ...;
float Availability[Hours] = ...;

int NbPatterns = ...;
range PatternRange = 1..NbPatterns;
float Patterns[Hours][PatternRange] = ...;
float PatternCost[PatternRange] = ...;

dvar float+ x[Products][Hours];
dvar float+ y[PatternRange];

maximize
  (sum ( i in Products ) Revenue[i] *
    sum (j in Hours) x[i][j] )  - 
  sum ( k in PatternRange ) PatternCost[k] * y[k];
  
subject to {
  forall ( j in Hours )
    ct1:
      sum ( i in Products ) Raw[i] * x[i][j] <= Availability[j];
  forall ( j in Hours)
    ct2:
      sum ( k in PatternRange ) Patterns[j][k] * y[k] >= sum ( i in Products ) x[i][j] * Labor[i];
}      