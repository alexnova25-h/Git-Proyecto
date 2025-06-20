//+------------------------------------------------------------------+
//|                                                           XM.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
//#include "Parametros.mqh"
#import "shell32.dll"
int ShellExecuteW(int hwnd, string lpOperation, string lpFile, string lpParameters, string lpDirectory, int nShowCmd);
#import


#include "DataBar.mqh"
#include "Indicadores.mqh"
#include "GestorMatematico.mqh"
#include "Util.mqh"
#include "MyBubbleSort.mqh"
#include "Tendencia.mqh"
#include "GestorArchivos.mqh"
#include "GestorOperaciones.mqh"
#include "IsNewBarra.mqh"


Indicadores c_Ind;
GestorMatematico c_Math;
DataBar d_Bar;
MyBubbleSort c_b,c_Bub ;
Tendencia c_Tend;
CUtil c_util;
GestorArchivos c_file;

//Parametros c_Param;//
ENUM_TIMEFRAMES periodo_M1 = PERIOD_M1;
int barra = 1;
long numMagic;
int timerCounter=0;
int secoundsTimer =10;
bool isDemo = false;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   ResetLastError();
   c_file = GestorArchivos();
   ENUM_ACCOUNT_TRADE_MODE account_type=(ENUM_ACCOUNT_TRADE_MODE)AccountInfoInteger(ACCOUNT_TRADE_MODE);
//--- ahora transformaremos el valor de la enumeración en una forma comprensible
   string trade_mode;
   switch(account_type)
     {
      case  ACCOUNT_TRADE_MODE_DEMO:
         trade_mode="demo";
         isDemo = true;
         break;
      case  ACCOUNT_TRADE_MODE_CONTEST:
         trade_mode="de concurso";
         break;
      default:
         trade_mode="real";
         break;
     }

//temporizador
   if(!EventSetTimer(secoundsTimer))
     {
      Print("Error: Fallo en el evento 'Iniciar el Temporizado'");
      return(INIT_FAILED);
     }
   Print("Temporizador Iniciado");
//--
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   ResetLastError();

   Comment("");
   c_Ind.setFreeInd();
//Detener el timer cuando el EA dea desinializado
   EventKillTimer();
   Print("Temporizador detenedio");
  }

//+------------------------------------------------------------------+
//|       funcion OnTimer()                                          |
//+------------------------------------------------------------------+
void OnTimer(void)
  {
//Accion a ejecutar cada secoundsTimer
   timerCounter++;
   datetime currentTime = TimeCurrent();
//Print("Acción ejecutada #%d - Hora actual del servidor  :",currentTime);
//Alert("Accion ejecutada por el Timer:",currentTime);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   matrix m = {{1,2,3,4},{5,6,7,8}};
   setEjemploMatriz(m);
   indicadores(_Symbol,periodo_M1,barra);
   Comment("m_Magic:  ",getNumMagic());
// En alguna parte de tu EA (ej. OnTick() o una función custom)
   CIsNewBarra newBar = CIsNewBarra(_Symbol,periodo_M1,barra);
   if(newBar.getIsNewBar())
     {
      //Alert("Nueva Barra");
      setScriptPython();
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void indicadores(string simbolo,ENUM_TIMEFRAMES frame, int shift)
  {
   d_Bar.matrizBarra(shift);
   c_Ind = Indicadores(simbolo,frame);
   ENUM_TIMEFRAMES periodo = frame;

   CIsNewBarra newBar= CIsNewBarra(_Symbol,frame,shift);
   if(newBar.getIsNewBar())
     {

     }
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
//MACD
   double macd_signal   = c_Ind.getMACDsignal(shift);
   double macd_main     = c_Ind.getMACDmain(shift);
   int macd_type=-1;
   if(macd_signal < macd_main)
     {
      macd_type = 0;
     }
   else
     {
      macd_type=1;
     }

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
   double original[]= {ma_Signal,ma_Base,ma_Long,ma_Long_2,ma_Long_3,ma_Long_4};
   string Z[]= {c_Math.getFuncionDensidad(z_Signal),c_Math.getFuncionDensidad(z_Base),c_Math.getFuncionDensidad(z_Long),c_Math.getFuncionDensidad(z_Long_2),c_Math.getFuncionDensidad(z_Long_3)};

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
   c_Bub.compararIndices(original,copia,res_menor);
   c_Bub.compararIndices(original,revers,res_mayor);

//
   matrix m_Indicadores =
     {
        {ma_Signal,ma_Base,ma_Long,ma_Long_2,ma_Long_3},
        {z_Signal,z_Base,z_Long,z_Long_2,z_Long_3},
        {c_Math.getFuncionDensidad(z_Signal),c_Math.getFuncionDensidad(z_Base),c_Math.getFuncionDensidad(z_Long),c_Math.getFuncionDensidad(z_Long_2),c_Math.getFuncionDensidad(z_Long_3)},
        {d_Bar.getState(),d_Bar.getBody(),d_Bar.getWick(),d_Bar.getHighWick(),d_Bar.getLowWick()},
        {stateSignal.getStateMa(),stateBase.getStateMa(),stateLong.getStateMa(),stateLong_2.getStateMa(),stateLong_3.getStateMa()}
     };

   string mensaje =IntegerToString(periodo,0,0)+IntegerToString(macd_type)+ArrayToString(res_menor)+ArrayToString(Z);
   numMagic =StringToInteger(mensaje);

   matrix datasEA = {{
         numMagic,
         d_Bar.getState(),d_Bar.getBody(),d_Bar.getWick(),d_Bar.getHighWick(),d_Bar.getLowWick(),
         stateSignal.getStateMa(),stateBase.getStateMa(),stateLong.getStateMa(),stateLong_2.getStateMa(),stateLong_3.getStateMa(),
         macd_main,macd_signal,macd_type
        }
     };
//
   GestorOperaciones c_Goper_M1 = GestorOperaciones(simbolo,periodo,barra,datasEA,isDemo);

  }
//+------------------------------------------------------------------+
//|           funcion que ejecutará un archivo *.bat                 |
//+------------------------------------------------------------------+
void setScriptPython()
  {
  if(MQLInfoInteger(MQL_TESTER))
    {
      string batFilePath = "C:\\Program Files\\XM Global MT5\\MQL5\\Experts\\Git-Proyecto\\Python\\ejecutar_python.bat"; // Ruta de tu archivo .bat
   int cmd =ShellExecuteW(0, OPERACION, batFilePath, "", "",  SW_HIDE); // SW_HIDE para ejecutarlo en segundo plano
   Print("CMD_tester: ",cmd);
    }
  

  }
//+------------------------------------------------------------------+
//| Función auxiliar para enviar a GestorArchivos en formato string  |
//+------------------------------------------------------------------+
string ArrayToStringDatas(const double& arr[])
  {
   string s = "";
   int size = ArraySize(arr);
   for(int i = 0; i < size; i++)
     {
      s += (int)(arr[i]);
      if(i < size - 1)
        {
         s += "";
        }
     }
   s += "";
   return s;
  }
//+------------------------------------------------------------------+
//| Función auxiliar para imprimir arrays (útil para depuración)     |
//+------------------------------------------------------------------+
string ArrayToString(const string& arr[])
  {
   string s = "";
   int size = ArraySize(arr);
   for(int i = 0; i < size; i++)
     {
      s += (int)(arr[i]);
      if(i < size - 1)
        {
         s += "";
        }
     }
   s += "";
   return s;
  }
//+------------------------------------------------------------------+
//| Función auxiliar para imprimir arrays (útil para depuración)     |
//+------------------------------------------------------------------+
string ArrayToString(const int& arr[])
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
//| Función auxiliar para imprimir arrays (útil para depuración)     |
//+------------------------------------------------------------------+
string ArrayToString(const double& arr[])
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
string ArrayToString(const bool& arr[])
  {
   string s = "";
   int size = ArraySize(arr);
   for(int i = 0; i < size; i++)
     {
      s += (arr[i] ? 1 : 0);
      if(i < size - 1)
        {
         s += "";
        }
     }
   s += "";
   return s;
  }
//+------------------------------------------------------------------+
string getConcatenar(const bool &arrayA[],const bool &arrayB[], bool &concat[])
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
long getNumMagic()
  {
   return numMagic;
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
void setEjemploMatriz(matrix& matriz)
  {
   int rows = matriz.Rows();
   int cols = matriz.Cols();
   int sizeMatriz = rows * cols;
   int index=0;
   double arrayMatriz[];
   ArrayResize(arrayMatriz,sizeMatriz);
   for(int i=0;i<rows;i++)
     {
      for(int j=0;j<cols;j++)
        {
         arrayMatriz[index] = matriz[i][j];
         index++;
        }
     }

  }

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
