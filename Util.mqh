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


public:


   void              OrderTypeDescription(const ENUM_ORDER_TYPE type) ;
   void              CUtil(double close,double ma);
   int               getStateMa() { return m_StateMa; };
                     CUtil();
                    ~CUtil();
  };


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
