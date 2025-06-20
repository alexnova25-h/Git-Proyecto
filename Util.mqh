//+------------------------------------------------------------------+
//|                                                         Util.mqh |
//|                                  Copyright 2025, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
class CUtil
  {
private:

   int               m_StateMa;
   double            m_Close;
   double            m_Ma;

   string            string_type;
   matrix            m_Fuerza;


public:


   void              OrderTypeDescription(const ENUM_ORDER_TYPE type) ;
   void              CUtil(double &mas[]);
   void              CUtil(double close,double ma);
   void              setFuerzaMas(double& mas[]);
   int               getStateMa() { return m_StateMa; };
   bool              ConcatenateTwoDoubleArrays(double &arr1[], double &arr2[], double &resultArray[]);
   matrix            getMatrizFuerza() {return m_Fuerza;}
                     CUtil();
                    ~CUtil();
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CUtil::CUtil(double &mas[])
  {


   for(int i=0;i<ArraySize(mas);i++)
     {

      ArraySort(mas);

     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CUtil::CUtil(double close,double ma):
   m_Close(close),m_Ma(ma)
  {
//
   if(close > ma)
     {
      m_StateMa =0;
     }
   else
      if(close < ma)
        {
         m_StateMa =1;
        }

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CUtil:: ConcatenateTwoDoubleArrays(double &arr1[], double &arr2[], double &resultArray[])
  {
// Obtener los tamaños de los arrays de entrada
   int size1 = ArraySize(arr1);
   int size2 = ArraySize(arr2);

// Calcular el tamaño total del nuevo array concatenado
   int totalSize = size1 + size2;

// Redimensionar el array 'resultArray' para que tenga el tamaño combinado
   if(!ArrayResize(resultArray, totalSize))
     {
      // Si la redimensión falla, imprimir un error y retornar false
      Print("Error: No se pudo redimensionar el array de resultado a ", totalSize);
      return false;
     }

// Copiar los elementos del primer array (arr1) al inicio de resultArray
// ArrayCopy(destino, origen, indice_destino, indice_origen, cantidad_elementos)
   ArrayCopy(resultArray, arr1, 0, 0, size1);

// Copiar los elementos del segundo array (arr2) después de los de arr1
// El índice de destino es 'size1' porque ahí es donde termina el primer array copiado
   ArrayCopy(resultArray, arr2, size1, 0, size2);

   return true; // La concatenación fue exitosa
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CUtil::OrderTypeDescription(const ENUM_ORDER_TYPE type)
  {
   switch(type)
     {
      case ORDER_TYPE_BUY              :
         string_type ="Buy";
      case ORDER_TYPE_SELL             :
         string_type ="Sell";
      case ORDER_TYPE_BUY_LIMIT        :
         string_type ="Buy Limit";
      case ORDER_TYPE_SELL_LIMIT       :
         string_type ="Sell Limit";
      case ORDER_TYPE_BUY_STOP         :
         string_type ="Buy Stop";
      case ORDER_TYPE_SELL_STOP        :
         string_type ="Sell Stop";
      case ORDER_TYPE_BUY_STOP_LIMIT   :
         string_type ="Buy Stop Limit";
      case ORDER_TYPE_SELL_STOP_LIMIT  :
         string_type ="Sell Stop Limit";
      default                          :
         string_type ="Unknown order type: "+(string)string_type;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CUtil::CUtil()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CUtil::~CUtil()
  {
  }
//+------------------------------------------------------------------+
