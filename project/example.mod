/*********************************************
 * OPL 12.4 Model
 * Author: rfukasaw
 * Creation Date: Mar 5, 2014 at 11:36:16 AM
 *********************************************/

 {string} Products = ... ;
 
 {string} Resources = ... ; 
 
 int ndays = ...;
 
 range days = 1..ndays;
 
 
 float a[Resources][Products] = ...;
 
 float c[Products][days] = ...;
 
 float b[Resources] = ...;
 
 float f[Products] = ...;
 
 float maxqty[days] = ...;
 
 dvar float+ x[Products][days];
 
  dvar boolean y[Products][days];
 
 maximize sum( j in Products, d in days ) c[j][d] * x[j][d] -
    sum( j in Products, d in days ) f[j] * y[j][d];
    
subject to
{
  forall( i in Resources )  ctr:
      sum( j in Products, d in days ) a[i][j] * x[j][d] <= b[i];


  forall( j in Products, d in days ) maxctr: 
     x[j][d] <= maxqty[d] * y[j][d];  
  
}   
 

execute
{
    var i, j, d;
    // Let us write a nice formatted output
    writeln( "****************************************" );
    writeln( " FORMATTED OUTPUT " );
    writeln( "****************************************" );
    for( i in Resources )
    {
       if( ctr[i].slack == 0 )
       {
          writeln( "Constraint for ", i, " is tight!");
       }
    }  
    writeln( "*****************************" );
    writeln( " INFORMATION PER PRODUCT " );
    writeln( "*****************************" );     
    for( j in Products )
    {
       writeln( "Product ", j, ":  produced in days:" );
       // NOTE: For some weird reason this does not work if
       // I use     for( d in 1..ndays )
       // I need to use the defined    range days = 1..ndays that I had above
       for( d in days )
       {
          if( y[j][d] == 1 )
          {
             writeln( "  Day ", d, ": Amount produced: ", x[j][d] );
          }            
           
       }         
    }
    writeln( "*****************************" );
    writeln( " INFORMATION PER DAY " );
    writeln( "*****************************" );
    // NOTE: For some weird reason this does not work if
    // I use     for( d in 1..ndays )
    // I need to use the defined    range days = 1..ndays that I had above
    for( d in days )
    {
       writeln( "Day ", d, "  : Products produced ");
       for( j in Products )
       {
          if( y[j][d] == 1 )
          {
             writeln( "  Product ", j, ": Amount produced: ", x[j][d] );
          }            
           
       }         
    }
} 
 