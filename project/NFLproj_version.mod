/*********************************************
 * OPL 12.4 Model
 * Author: cvalert
 * Creation Date: Mar 26, 2014 at 9:40:07 PM
 *********************************************/

{string} afcn = ...; 
{string} afcs = ...;
{string} afce = ...;
{string} afcw = ...;
{string} nfcn = ...;
{string} nfcs = ...;
{string} nfce = ...;
{string} nfcw = ...;

{string} teams = afcn union afcs union afce union
             afcw union nfcn union nfcs union
         nfce union nfcw; /* all teams are the union of all the divisions */



int nweeks = ...;
int f = ...;

int derby = ...;

int bweeks = ...;

int ndivisions = ...;



range weeks = 1..nweeks;

range byeweeks = 3..bweeks;

range gapweeks = 1..10;

{int} specialweeks = ...;



{string} days = ...;

{string} divisions[1..ndivisions] = ...;



 dvar boolean game[teams][teams][weeks][days]; /*first "teams" index represents the home team, second one the away team */
 dvar boolean bye[teams][weeks]; /*1 if one team has a bye week on a given week */

 

 maximize 

    sum (v in 1..ndivisions,i in teams: i in divisions[v],j in teams: j in divisions[v],d in days,w in weeks) 
     derby * game[i][j][w][d] * 2*(w - 1) /* this sum captures the weight of divisional games  */

      +
  sum (v in 1..ndivisions,i in teams: i in divisions[v],j in teams: j not in divisions[v],d in days,w in weeks)
     game[i][j][w][d] * 2*(w - 1) /* this sum captures the weight of non-divisional games  */
      +
    sum (w in weeks,d in days) (f - 1) * game["New England Patriots"]["Philadelphia Eagles"][w][d] * 2 *(w - 1) /*representsthe importance factor for the matchup we chose (Eagles vs Patriots) using f-1 since the previous summation has already counted the weight factor once */
      +
    sum (w in weeks,d in days) (f - 1) * game["Philadelphia Eagles"]["New England Patriots"][w][d] * 2 *(w - 1); /* once captures the Eagles at home, Patriots and Eagles away vs Patriots at home*/



  subject to {



    forall (i in teams) ctr4and10: { /* each team must play a total of 16 games */

      sum (j in teams, d in days,w in weeks) game[i][j][w][d] == 8; /*8 home games for each team i */

      sum (j in teams, d in days,w in weeks) game[j][i][w][d] == 8;} /*8 away games for each team i*/

    

    forall (i in teams) ctr5a: /*a team must not play itself */

      sum(w in weeks,d in days) game[i][i][w][d] == 0;



  forall (i in teams) ctr5b: /* each team gets one bye week in the season where they play no games */

    sum(w in weeks) bye[i][w] == 1;



    forall (i in teams)

        forall(w in weeks) ctr6: /* a team can either play a home or away game or have a bye each week */

          sum(d in days, j in teams) (game[i][j][w][d] + game[j][i][w][d])+ bye[i][w] == 1;



    forall (i in teams) ctr7: /*there can be no byes before week 3 or after week 10 */

      sum(w in weeks: w not in byeweeks) bye[i][w] == 0;



    forall (w in weeks: w not in specialweeks) ctr8: /* there must be one monday game in all weeks except 13,16 and 17 */

      sum(i in teams,j in teams) game[i][j][w]["Monday"] == 1;



    forall (w in weeks: w not in specialweeks) /* there must be one Thursday game in all weeks except 13, 17 and 16 */

      sum(i in teams,j in teams) game[i][j][w]["Thursday"] == 1;



    sum(i in teams,j in teams) game[i][j][13]["Thursday"] == 3; /*there must be 3 games on thursday in week 13*/

    sum(i in teams,j in teams) game[i][j][13]["Monday"] == 1;  /*there must be 1 game on Monday in week 13*/



    sum(i in teams,j in teams) game[i][j][16]["Thursday"] == 0; /*there is no game on Thursday in week 16*/

    sum(i in teams,j in teams) game[i][j][16]["Monday"] == 1; /*there is 1 game on Monday for week 16*/ 



    sum(i in teams,j in teams) game[i][j][17]["Thursday"] == 0; /*there is no game on Thursday for week 17*/

    sum(i in teams,j in teams) game[i][j][17]["Monday"] == 0; /* there is no game on Monday for week 17*/


    forall(v in 1..ndivisions, i in divisions[v], j in divisions[v]: j!= i) /*this constraint considers the divional games; this is saying, each team in the same division plays against others at HOME exactly once.*/ 

      sum(w in weeks,d in days) game[i][j][w][d]== 1;


    forall(i in teams,j in teams) ctr12a:  /*this constraint says for each team, they can only play against any other team at HOME at most once*/

        sum(w in weeks,d in days) game[i][j][w][d] <= 1;  



    forall(i in teams,j in teams: i != j) ctr12b:/* this one, combining with the previous constraint, says, each team can only play against any other team at most two times, and one HOME, one AWAY!*/

        sum(w in weeks,d in days) ( game[i][j][w][d] + game[j][i][w][d]) <= 2;



    forall(w in gapweeks, i in teams,j in teams) ctr13: /*this constraint captures the "at least 8 weeks away" criteria*/

        sum(w in w..w+7,d in days) (game[i][j][w][d] + game[j][i][w][d]) <= 1;



    forall(i in teams,j in teams ,w in weeks) ctr14: /*Two New York teams cannot play at home in the same week*/

        sum(d in days) (game["New York Giants"][i][w][d] + game["New York Jets"][j][w][d]) <= 1;



    forall(i in teams) ctr15: /*every team must play at least one thursday game, it can be either HOME or AWAY*/

        sum(j in teams, w in weeks) (game[i][j][w]["Thursday"] + game[j][i][w]["Thursday"]) >= 1;



    forall(i in teams) /*every team must play at least one Monday game, it can be either HOME or AWAY*/

        sum(j in teams, w in weeks) (game[i][j][w]["Monday"] + game[j][i][w]["Monday"]) >= 1;



    forall(i in teams, w in weeks: w < 17) ctr16: /*for each team, they cant play on Thursday after they play on Monday in the previous week; this constraint considers both HOME and AWAY games.*/

       sum(j in teams) (game[i][j][w]["Monday"] + game[j][i][w]["Monday"] + game[i][j][w+1]["Thursday"] + game[j][i][w+1]["Thursday"]) <= 1 ;





  }



// TO EDIT:



execute

{

    var i, j, w, d;

    // Let us write a nice formatted output

    writeln( "****************************************" );

    writeln( " FORMATTED OUTPUT " );

    writeln( "****************************************" );

    //for( i in teams )

    //{

    //   if( ctr[i].slack == 0 )

    //   {

    //      writeln( "Constraint for ", i, " is tight!");

    //   }

    //}  

  /*  writeln( "*****************************" );

    writeln( " INFORMATION PER WEEK " );

    writeln( "*****************************" );      

    for( w in weeks )

    {

       writeln( "Week ", w, "games played on:" );

       // NOTE: For some weird reason this does not work if

       // I use     for( d in 1..ndays )

       // I need to use the defined    range days = 1..ndays that I had above

       for( d in days)

       {

          for(i in teams){

              for( j in teams){

                if( game[i][j][w][d] == 1 )

                {

                   writeln( "  Day ", d, ": Matchup: ", i, "versus ", j );

                }            

             }

        }

      }                  

    }
*/

    writeln( "*****************************" );

    writeln( " INFORMATION PER TEAM " );

    writeln( "*****************************" );

    // NOTE: For some weird reason this does not work if

    // I use     for( d in 1..ndays )

    // I need to use the defined    range days = 1..ndays that I had above

    for( i in teams )

    {

       writeln( "Team ", i, "  : Games played at home");

        for(w in weeks){ 
      if( bye[i][w] == 1){
            writeln( "  Bye for ", i, " on Week: ",w);
            }
           for( j in teams ){

              for(d in days){

                 {

                    if( game[i][j][w][d] == 1 )

                    {

                       writeln( "  Home Team ", i, "played : ",j," on Week:",w ,"on Day:",d );

                    }            
                      
                 } 

              } 

            }        

       }



       writeln( "Team ", i, "  : Games played away");

        for(w in weeks){ 

           for( j in teams ){

              for(d in days){

                 {

                    if( game[j][i][w][d] == 1 )

                    {

                       writeln( "  Away Team ", i, "played : ",j," on Week:",w ,"on Day:",d );

                    }            

                 }

              } 

            }        

       }

    }

}