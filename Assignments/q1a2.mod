/*********************************************
 * OPL 12.4 Model
 * Author: wningchu
 * Creation Date: 2014-01-28 at 10:02:35 AM
 *********************************************/

int NbProducts = ...;
int NbPeriods = ...;

range Products = 1..NbProducts;
range Periods = 1..NbPeriods;

float Revenue[Products] = ...;
float Raw[Products] = ...;
float a[Periods] = ...;
float b[Periods] = ...;

float MaxRaw = ...;
float MinPercent = ...;
{int} MinProducts = ...;

dvar float+ Amount[Products];
dvar float+ t;

maximize
  sum( i in Products ) Revenue[i]*Amount[i] - t;
 
subject to {
  forall ( i in Periods )
    ct1:
      a[i] * ( sum ( j in Products ) Raw[j] * Amount[j] ) + b[i] <= t;
  sum ( j in Products ) Raw[j] * Amount[j] <= 5000;
  MinPercent * sum ( i in Products ) Amount[i] <= sum ( i in MinProducts ) Amount[i];
}
 