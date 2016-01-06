/*********************************************
 * OPL 12.4 Model
 * Author: wningchu
 * Creation Date: 2014-01-28 at 10:10:50 AM
 *********************************************/

float SunflowerCost = ...;
float PeashooterCost = ...;
float SunflowerBenefit = ...;
int NbPeriods = ...;
range Periods = 1..NbPeriods;
int StartingSuns = ...;
float StartingSunflowers = ...;
float StartingPeashooters = ...;
int SunflowerGain = ...;
int MaxS = ...;
int MaxP = ...;
int MaxPlants = ...;

dvar float+ Sunflowers[Periods];
dvar float+ Peashooters[Periods];
dvar float+ SunInventory[0..NbPeriods]; 
dvar float+ TotalSunflowers[0..NbPeriods];
dvar float+ TotalPeashooters[0..NbPeriods];
dvar float+ UprootedS[Periods];
dvar float+ UprootedP[Periods];

// don't forget about uprooting

maximize
  TotalPeashooters[NbPeriods] + SunflowerBenefit * SunInventory[NbPeriods];
  
subject to {
  forall( t in Periods )
    ct1:
      SunInventory[t] == SunInventory[t-1] - SunflowerCost*Sunflowers[t] -
      PeashooterCost*Peashooters[t] + SunflowerGain * TotalSunflowers[t-1];
  forall( t in Periods )
    ct2:
      TotalSunflowers[t] == TotalSunflowers[t-1] + Sunflowers[t] - UprootedS[t];
  forall( t in Periods )
    ct3:
      TotalPeashooters[t] == TotalPeashooters[t-1] + Peashooters[t] - UprootedP[t];
  forall ( t in Periods )
    ct4:
      Sunflowers[t] <= MaxS;
  forall ( t in Periods )
    ct5:
      Peashooters[t] <= MaxP;
  forall ( t in Periods )
    ct6:
      TotalSunflowers[t] + TotalPeashooters[t] <= MaxPlants;
  SunInventory[0] == StartingSuns;
  TotalSunflowers[0] == StartingSunflowers;
  TotalPeashooters[0] == StartingPeashooters;
}