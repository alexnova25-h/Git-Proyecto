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
   double            getFuncionDensidad(double Z)//(double U, double ds, double x)
     {


      double densidad=0.0;

      for(double i=-400.0;i<=(Z/Point());i++)

        {
         double e = (1.0/MathSqrt(2*Pi))*MathPow(E,-(MathPow((i/100.0),2.0)/2));
         densidad+= e;

        }
      

      return MathFloor(NormalizeDouble((densidad/100.0),3)*100);
     }
  
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   double            getPointMax(int numBarras)
     {
      double max;
      double arrayMax[];
      ArrayResize(arrayMax,100000000,100000000);
      ArrayInitialize(arrayMax,EMPTY_VALUE);

      for(int i=0;i<numBarras;i++)
        {
         arrayMax[i] = iHigh(_Symbol,PERIOD_CURRENT,i);
         max = ArrayMaximum(arrayMax,0,numBarras);
        }
      ArrayFree(arrayMax);
      return max;

     }






   //---
   double            getPointMin(int numBarras)
     {
      double min;
      for(int j=0;j<numBarras;j++)
        {

        }
      return min;
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
