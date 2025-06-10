//+------------------------------------------------------------------+
//|                                             GestorMatematico.mqh |
//|                                  Copyright 2025, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
const double E =  2.71828;
const double Pi = 3.14159265359;
class GestorMatematico
  {
private:

public:

   //---

   double            getNormal(double U, double ds, double X)
     {
      double Z=0;

      Z = (X-U)/ds;

      return Z;

     }
   //---
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   double           getFuncionDensidad(double Z)//(double U, double ds, double x)
     {


      double densidad=0.0;

      for(double i=-400.0;i<=(Z/Point());i++)

        {
         double e = (1.0/MathSqrt(2*Pi))*MathPow(E,-(MathPow((i/100.0),2.0)/2));
         densidad+= e;

        }
      

      return MathFloor(NormalizeDouble((densidad/100.0),3)*100);
     }
  




                     GestorMatematico();
                    ~GestorMatematico();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
GestorMatematico::GestorMatematico()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
GestorMatematico::~GestorMatematico()
  {
  }
//+------------------------------------------------------------------+
