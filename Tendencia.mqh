//+------------------------------------------------------------------+
//|                                                    Tendencia.mqh |
//|                                  Copyright 2025, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
class Tendencia
  {
private:

public:
   bool              sortTendencia(double &arrayOriginal[],double &arraySorted[], bool &arrayTendencia[]);
                     Tendencia();
                    ~Tendencia();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Tendencia::sortTendencia(double &arrayOriginal[],double &arraySorted[],bool &arrayTendencia[])
  {
   int size = ArraySize(arrayOriginal);
   if(ArraySize(arraySorted) != size || ArraySize(arrayTendencia) != size)
     {
      Print("Error: Los arrays no son iguales");
      return false;

     }
//1) copiar el arreglo original
   ArrayCopy(arraySorted, arrayOriginal);
//2) Ordenar el arreglo original(algoritmo burbuja)
   for(int i=0;i< size - 1;i++)
     {
      for(int j = 0; j < size -1; j++)
        {
         if(arraySorted[j] > arraySorted[j + 1])
           {
            double temp = arraySorted[j];
            arraySorted[j] = arraySorted[j + 1 ];
            arraySorted[j + 1]=temp;
           }
        }
     }
     //3. comparar el arreglo original con el ordenado para obtener la tendencia
     
     for(int i=0;i < size; i++)
       {
        if(arrayOriginal[i] == arraySorted[i])
          {
           arrayTendencia[i] = true; //el elemento está en la misma posición
          }else
             {
              arrayTendencia[i] = false; // El elemento NO está en la misma posición
             }
       }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Tendencia::Tendencia()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Tendencia::~Tendencia()
  {
  }
//+------------------------------------------------------------------+
