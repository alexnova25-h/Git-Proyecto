//+------------------------------------------------------------------+
//|                                            GestorOperaciones.mqh |
//|                                  Copyright 2025, Alex Nova.      |
//|                                     mail: alexnova25@hotmail.com |
//+------------------------------------------------------------------+
#define SW_HIDE 0
#define SW_SHOWNORMAL 1
#define SW_NORMAL 1
#define SW_SHOWMINIMIZED 2
#define SW_SHOWMAXIMIZED 3
#define SW_MAXIMIZE 3
#define SW_SHOWNOACTIVATE 4
#define SW_SHOW 5
#define SW_MINIMIZE 6
#define SW_SHOWMINNOACTIVE 7
#define SW_SHOWNA 8
#define SW_RESTORE 9
#define SW_SHOWDEFAULT 10
#define SW_FORCEMINIMIZE 11
#define SW_MAX 11
#define DEFDIRECTORY NULL
#define OPERACION "open"
//
#import "shell32.dll"
int ShellExecuteW(int hwnd, string lpOperation, string lpFile, string lpParameters, string lpDirectory, int nShowCmd);
#import
 

#property copyright "Copyright 2025, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include "GestorMatematico.mqh"

GestorMatematico gm_o;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class GestorOperaciones
  {
private:
   string            m_Simbolo;
   ENUM_TIMEFRAMES   m_Frame;

   bool              m_isPosition;
   int               total;
   int               total_by;
   datetime          m_OpenDate;
   datetime          m_CurrenDate;
   bool              isPosition() {return m_isPosition;}
   //
   string            o_simbolo;
   string            o_comment;
   ulong             o_ticket;
   ulong             o_numMagic;
   datetime          o_openDate;
   int               o_hour;
   int               o_min;
   int               o_numBarras;
   ENUM_ORDER_TYPE   o_orderType;
   double            o_Min;
   double            o_Max;
   double            o_stopLoss;
   double            o_takeProfit;
   double            o_profitPoints;
   double            o_Swap;


   /*etiquetas para enviar al arhivo
         simbolo
         numMagico
         comentario
         dateopen
            hora;min;
         numeroBarras
         Maximo_points
         Minimo_points
         stoploos
         takeprofit


         */
   void              setStructTime(datetime time);
   void              setOpenDate(string simbolo, datetime time);
   void              setPointStopLoss(double openPrice, double priceCurrent);
   void              setProfitPoints(ENUM_ORDER_TYPE type,double openPrice,  double priceCurrent);
   void              setOperations(string simbolo,long numMagic);

   string            get_Simbolo()        {   return   o_simbolo;      };
   string            get_Comment()        {   return   o_comment;      };
   ulong             get_Ticket()         {   return   o_ticket;       };
   ulong             get_numMagic()       {   return   o_numMagic;     };
   datetime          get_openDate()       {   return   o_openDate;     };
   int               get_Hour()           {   return   o_hour;         };
   int               get_Minute()         {   return   o_min;          };
   int               get_numBarras()      {   return   o_numBarras;    };
   double            get_Min()            {   return   o_Min;          };
   double            get_Max()            {   return   o_Max;          };
   double            get_stopLoss()       {   return   o_stopLoss;     };
   double            get_takeProfit()     {   return   o_takeProfit;   };
   double            get_profitPoints()   {   return   o_profitPoints; };
   double            get_Swap()           {   return   o_Swap;         };
   //gestion para convertir objeto matrix en objeto array[]
   string            ArrayToStringDatas(const double& array[]);

   string            matrisArray(matrix& matriz);

public:
   void              GestorOperaciones(string simbolo, ENUM_TIMEFRAMES frame,int barra, matrix& datas,bool isDemo);

                     GestorOperaciones();
                    ~GestorOperaciones();
  };
//---
void GestorOperaciones::GestorOperaciones(string simbolo,ENUM_TIMEFRAMES frame,int barra, matrix &datas, bool isDemo)
  {
   if(MQLInfoInteger(MQL_TESTER))
     {
      Print("is a Tester");
     }
   else
      if(isDemo)
        {
         string batFilePath = "C:\\Program Files\\XM Global MT5\\MQL5\\Experts\\Git-Proyecto\\Python\\ejecutar_python.bat"; // Ruta de tu archivo .bat
         int cmd =ShellExecuteW(0, OPERACION, batFilePath, "", "",  SW_NORMAL); // SW_HIDE para ejecutarlo en segundo plano
         //Print("CMD: ",cmd);
        }

   //Print("Número Magico: ",matrisArray(datas));

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void GestorOperaciones::setStructTime(datetime time)
  {
   ResetLastError();
   MqlDateTime s_openDate = {};
   if(!TimeToStruct(time,s_openDate))
      Alert("TimeStruct a fallado: ",GetLastError());
   o_hour = s_openDate.hour;
   o_min = s_openDate.min;



  }
//---
void GestorOperaciones::setProfitPoints(ENUM_ORDER_TYPE type,double openPrice,double priceCurrent)
  {
   double nor_open=NormalizeDouble(openPrice,Digits())/Point();
   double nor_current=NormalizeDouble(priceCurrent,Digits())/Point();
   if(type == POSITION_TYPE_BUY)
     {
      o_profitPoints =MathRound(nor_current-nor_open);
     }
   else
      if(type == POSITION_TYPE_SELL)
        {
         o_profitPoints =MathRound(nor_open-nor_current);
        }


  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void GestorOperaciones::setOpenDate(string simbolo,datetime time)
  {
   o_numBarras =Bars(simbolo,PERIOD_CURRENT,time,TimeCurrent());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void              GestorOperaciones::setOperations(string simbolo,long numMagic)
  {
   m_Simbolo = simbolo;

   ResetLastError();



   for(int i=0;i < PositionsTotal();i++)
     {
      if(PositionGetSymbol(i) == m_Simbolo)
        {

         o_simbolo =PositionGetSymbol(i);
         o_ticket =PositionGetInteger(POSITION_TICKET);
         o_orderType = PositionGetInteger(POSITION_TYPE);
         o_comment =PositionGetString(POSITION_COMMENT);
         o_numMagic = PositionGetInteger(POSITION_MAGIC);
         o_openDate = PositionGetInteger(POSITION_TIME);
         o_stopLoss = PositionGetDouble(POSITION_SL);
         o_Swap =PositionGetDouble(POSITION_SWAP);
         o_takeProfit = PositionGetDouble(POSITION_PROFIT);
         setStructTime(o_openDate);
         setOpenDate(o_simbolo,o_openDate);
         /* Print(" ",o_simbolo," ",o_ticket," ",o_comment," ",o_numMagic," ",o_openDate," ",o_stopLoss," ",o_takeProfit,"  ",o_hour,"  ",o_min,
               "  ",o_numBarras);*/


        }
     }



  }
//---
string GestorOperaciones::ArrayToStringDatas(const double &arr[])
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
//|                                                                  |
//+------------------------------------------------------------------+
string GestorOperaciones::matrisArray(matrix &matriz)
  {
   int rows = matriz.Rows();
   int cols = matriz.Cols();
   int sizeMatriz = rows * cols;
   int index=0;
   string s="";
   double arrayMatriz[];
   ArrayResize(arrayMatriz,sizeMatriz);
   for(int i=0;i<rows;i++)
     {
      for(int j=0;j<cols;j++)
        {
         arrayMatriz[index] =matriz[i][j];
         s+=DoubleToString(arrayMatriz[index],4);
         if(j < cols -1)
           {
            s+=",";
           }
         index++;

        }
     }
   return s;
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
GestorOperaciones::GestorOperaciones()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
GestorOperaciones::~GestorOperaciones()
  {
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
