//+------------------------------------------------------------------+
//|                                                   Parametros.mqh |
//|                                                        Alex Nova |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Alex Nova"
#property link      ""
#property version   "1.00"

#include "DataBar.mqh"
#include "Indicadores.mqh"
#include "GestorMatematico.mqh"
#include "Util.mqh"
#include "MyBubbleSort.mqh"
#include "Tendencia.mqh"

Indicadores c_Ind;
GestorMatematico c_Math;
DataBar d_Bar;
MyBubbleSort c_b,c_Bub ;
Tendencia c_Tend;
CUtil c_util;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Parametros
  {
private:
   ulong             m_Magic;
public:
   void              Parametros(string simbolo,ENUM_TIMEFRAMES frame, int shift);

   string            ArrayToString( double& arr[]);
   string            ArrayToString( bool& arr[]);
   string            getConcatenar( bool& arrayA[], bool& arrayB[], bool& concat[]);
   ulong             getNumMagic() {return m_Magic;};
                     Parametros();
                    ~Parametros();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Parametros::Parametros()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Parametros::~Parametros()
  {
   c_Ind.setFreeInd();
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Parametros::Parametros(string simbolo,ENUM_TIMEFRAMES frame, int shift)
  {
   d_Bar.matrizBarra(shift);
   c_Ind = Indicadores(simbolo,frame);
   
   ENUM_TIMEFRAMES periodo = frame;
//iOpen - iClose
   double b_Open = NormalizeDouble(iOpen(simbolo,frame,shift),Digits())/Point();
   double b_Close= NormalizeDouble(iClose(simbolo,frame,shift),Digits())/Point();
//MAs
   double ma_Signal     = NormalizeDouble(c_Ind.getMA(5,shift,MODE_LWMA,PRICE_WEIGHTED),Digits())/Point();
   double ma_Base       = NormalizeDouble(c_Ind.getMA(8,shift,MODE_EMA,PRICE_WEIGHTED),Digits())/Point();
   double ma_Long       = NormalizeDouble(c_Ind.getMA(21,shift,MODE_EMA,PRICE_WEIGHTED),Digits())/Point();
   double ma_Long_2     = NormalizeDouble(c_Ind.getMA(34,shift,MODE_EMA,PRICE_WEIGHTED),Digits())/Point();
   double ma_Long_3     = NormalizeDouble(c_Ind.getMA(55,shift,MODE_EMA,PRICE_WEIGHTED),Digits())/Point();
   double ma_Long_4     = NormalizeDouble(c_Ind.getMA(233,shift,MODE_EMA,PRICE_WEIGHTED),Digits())/Point();

//DesVs
   double ds_Signal     = NormalizeDouble(c_Ind.getStd(5,shift,MODE_LWMA,PRICE_WEIGHTED),Digits())/Point();
   double ds_Base       = NormalizeDouble(c_Ind.getStd(8,shift,MODE_EMA,PRICE_WEIGHTED),Digits())/Point();
   double ds_Long       = NormalizeDouble(c_Ind.getStd(21,shift,MODE_EMA,PRICE_WEIGHTED),Digits())/Point();
   double ds_Long_2     = NormalizeDouble(c_Ind.getStd(34,shift,MODE_EMA,PRICE_WEIGHTED),Digits())/Point();
   double ds_Long_3     = NormalizeDouble(c_Ind.getStd(55,shift,MODE_EMA,PRICE_WEIGHTED),Digits())/Point();
   double ds_Long_4    = NormalizeDouble(c_Ind.getStd(233,shift,MODE_EMA,PRICE_WEIGHTED),Digits())/Point();

//Normalizar
   double z_Signal      = NormalizeDouble(c_Math.getNormal(ma_Signal,ds_Signal,b_Close),3);
   double z_Base        = NormalizeDouble(c_Math.getNormal(ma_Base,ds_Base,b_Close),3);
   double z_Long        = NormalizeDouble(c_Math.getNormal(ma_Long,ds_Long,b_Close),3);
   double z_Long_2      = NormalizeDouble(c_Math.getNormal(ma_Long_2,ds_Long_2,b_Close),3);
   double z_Long_3      = NormalizeDouble(c_Math.getNormal(ma_Long_3,ds_Long_3,b_Close),3);
   double z_Long_4      = NormalizeDouble(c_Math.getNormal(ma_Long_4,ds_Long_3,b_Close),3);

//
   CUtil stateSignal  = CUtil(b_Close,ma_Signal);
   CUtil stateBase    = CUtil(b_Close,ma_Base);
   CUtil stateLong    = CUtil(b_Close,ma_Long);
   CUtil stateLong_2  = CUtil(b_Close,ma_Long_2);
   CUtil stateLong_3  = CUtil(b_Close,ma_Long_3);
   CUtil stateLong_4  = CUtil(b_Close,ma_Long_3);

//
   double arrayZ[] = {(double)periodo,c_Math.getFuncionDensidad(z_Signal),c_Math.getFuncionDensidad(z_Base),c_Math.getFuncionDensidad(z_Long),c_Math.getFuncionDensidad(z_Long_2),c_Math.getFuncionDensidad(z_Long_3),c_Math.getFuncionDensidad(z_Long_4)};
   double arrayState[]= {stateSignal.getStateMa(),stateBase.getStateMa(),stateLong.getStateMa(),stateLong_2.getStateMa(),stateLong_3.getStateMa(),stateLong_4.getStateMa()};

//declarar arreglos de salida
   double original[]={ma_Signal,ma_Base,ma_Long,ma_Long_2,ma_Long_3,ma_Long_4};

   double copia[];
   double revers[];
   bool res_mayor[];
   bool res_menor[];
   int size= ArraySize(original);

//redimencionar todos los array destino

   ArrayResize(copia,size);
   ArrayResize(revers,size);
   ArrayResize(res_mayor,size);
   ArrayResize(res_menor,size);

//crear copias iniciales del array original

   ArrayCopy(copia,original,0,0,size);
   ArrayCopy(revers,original,0,0,size);
//procesar las copias
   ArraySort(copia);
//invertir 'reverse'
   ArrayReverse(revers);

//crear comparciones
   c_Bub.compararIndices(original,revers,res_mayor);
   c_Bub.compararIndices(original,copia,res_menor);
   bool concat[];
// --- 6. Imprimir los resultados ---
   getConcatenar(res_mayor,res_menor,concat);

   m_Magic =ArrayToString(concat);
   
//
   matrix m_Indicadores =
     {
        {ma_Signal,ma_Base,ma_Long,ma_Long_2,ma_Long_3},
        {z_Signal,z_Base,z_Long,z_Long_2,z_Long_3},
        {c_Math.getFuncionDensidad(z_Signal),c_Math.getFuncionDensidad(z_Base),c_Math.getFuncionDensidad(z_Long),c_Math.getFuncionDensidad(z_Long_2),c_Math.getFuncionDensidad(z_Long_3)},
        {d_Bar.getState(),d_Bar.getBody(),d_Bar.getWick(),d_Bar.getHighWick(),d_Bar.getLowWick()},
        {stateSignal.getStateMa(),stateBase.getStateMa(),stateLong.getStateMa(),stateLong_2.getStateMa(),stateLong_3.getStateMa()}
     };
Print("Desde Parametros:  ",ArrayToString(res_mayor),"\n",ArrayToString(res_menor));
 
//


  }



//+------------------------------------------------------------------+
//| Función auxiliar para imprimir arrays (útil para depuración)     |
//+------------------------------------------------------------------+
string Parametros::ArrayToString( double& arr[])
  {
   string s = "";
   int size = ArraySize(arr);
   for(int i = 0; i < size; i++)
     {
      s += DoubleToString(arr[i]);
      if(i < size - 1)
        {
         s += "";
        }
     }
   s += "";
   return s;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string Parametros:: ArrayToString(bool& arr[])
  {
   string s = "[";
   int size = ArraySize(arr);
   for(int i = 0; i < size; i++)
     {
      s += (arr[i] ? 1 : 0);
      if(i < size - 1)
        {
         s += ",";
        }
     }
   s += "]";
   return s;
  }
//+------------------------------------------------------------------+
string Parametros:: getConcatenar(bool &arrayA[],bool &arrayB[], bool &concat[])
  {
   int size_a=ArraySize(arrayA);
   int size_b=ArraySize(arrayB);
   int total_size = size_a+size_b;

   ArrayResize(concat,total_size);
   ArrayCopy(concat,arrayA,0,0,size_a);
   ArrayCopy(concat,arrayB,size_a,0,size_b);
   return true;
  }
//+------------------------------------------------------------------+
