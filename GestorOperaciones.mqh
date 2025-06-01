//+------------------------------------------------------------------+
//|                                            GestorOperaciones.mqh |
//|                                  Copyright 2025, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
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

public:
   void              setOperations(string simbolo, ENUM_TIMEFRAMES frame);

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
                     GestorOperaciones();
                    ~GestorOperaciones();
  };
//---
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
void              GestorOperaciones::setOperations(string simbolo,ENUM_TIMEFRAMES frame)
  {
   m_Simbolo = simbolo;
   m_Frame = frame;
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
         if(PositionGetInteger(POSITION_TICKET,o_ticket))
           {
            setProfitPoints(o_orderType,PositionGetDouble(POSITION_PRICE_OPEN),PositionGetDouble(POSITION_PRICE_CURRENT));
            Print("Ticket:  ",o_ticket,"  Maximo: ", gm_o.getPointMax(get_numBarras()));
           }

        }
     }



  }
//---

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
