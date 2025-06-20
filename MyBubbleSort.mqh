//+------------------------------------------------------------------+
//|                                                  MyBubleSort.mqh |
//|                                  Copyright 2025, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
class MyBubbleSort
  {
private:

public:
   void              MyBubleSort(double &arra[]);
   bool              compararIndices(const double& arr1[], const double& arr2[], bool& resultado[]);

                     MyBubbleSort();
                    ~MyBubbleSort();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MyBubbleSort::MyBubleSort(double &arra[])
  {
   int n = ArraySize(arra);
   bool swapped;
//recorrer el array n-1 veces

   for(int i=0;i < n -1 ; i++)
     {
      swapped = false;//asumimos que no habra intercambios
      for(int j =0 ;j < n - 1 -i; j++)
        {
         //comparar elementos adyacentes
         if(arra[j] > arra[j + 1])
           {
            //si el elemento acual es mayor que el siguiente
            double temp = arra[j];
            arra[j]  = arra[j+1];
            arra[j + 1]  = temp;
            swapped = true; // hubo un intercambio
           }
        }
      //si no hubo un intercambio en esta pasada, el array ya está ordenado
      if(!swapped)
        {
         break;
        }
     }
  }
  bool MyBubbleSort::compararIndices(const double& arr1[], const double& arr2[], bool& resultado[])
  {
   // Verificar que los arrays de entrada no sean nulos o no tengan tamaño
   // En MQL5, los arrays declarados pero no inicializados pueden tener ArraySize() == 0 o ser considerados inválidos en ciertos contextos.
   // ArrayIsNull() es una función para verificar si un array dinámico es nulo (no asignado).
   if (ArraySize(arr1) == 0 || ArraySize(arr2) == 0)
     {
      Print("Error: Uno o ambos arrays de entrada son nulos o vacíos.");
      return false; // Indicar que la operación falló
     }

   // Determinar la longitud del array booleano resultante
   // Será la del array más corto para evitar IndexOutOfBoundsException
   int longitudResultante = MathMin(ArraySize(arr1), ArraySize(arr2));

   // Redimensionar el array 'resultado' que se pasó por referencia
   if (ArrayResize(resultado, longitudResultante) == -1)
     {
      Print("Error al redimensionar el array booleano de resultado.");
      return false; // Indicar que la operación falló
     }

   // Iterar sobre los arrays hasta la longitud más corta
   for (int i = 0; i < longitudResultante; i++)
     {
      // Comparar los elementos en la posición actual
      resultado[i] = (arr1[i] == arr2[i]);
     }

   return true; // Indicar que la operación fue exitosa
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MyBubbleSort::MyBubbleSort()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MyBubbleSort::~MyBubbleSort()
  {
  }
//+------------------------------------------------------------------+
