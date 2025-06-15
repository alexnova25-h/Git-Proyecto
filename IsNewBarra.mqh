//+------------------------------------------------------------------+
//|                                                   IsNewBarra.mqh |
//|                                  Copyright 2025, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
class CIsNewBarra
  {
private:
   string            m_Simbolo;
   ENUM_TIMEFRAMES   m_Frames;
   datetime          m_lastBar;

public:

   void              CIsNewBarra(string simbolo,ENUM_TIMEFRAMES frame,int shift);
   bool              getIsNewBar()     {  return m_newBar;}
                     CIsNewBarra();
                    ~CIsNewBarra();
protected:
   datetime          m_last_time;
   bool              m_newBar;
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CIsNewBarra::CIsNewBarra(string simbolo,ENUM_TIMEFRAMES frame, int shift)
  {
   m_Simbolo = simbolo;
   m_Frames = frame;
   m_newBar=false;
   datetime  currentBar = iTime(m_Simbolo,m_Frames,shift);
   if(currentBar != m_lastBar)
     {
      m_lastBar = currentBar;
      m_newBar=true;
     }
   datetime time = TimeCurrent();
   MqlDateTime tm= {};
   if(!TimeToStruct(time,tm))
     {
      Alert("Error Time() ",GetLastError(),__FUNCTION__);

     }


  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CIsNewBarra::CIsNewBarra()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CIsNewBarra::~CIsNewBarra()
  {
  }
//+------------------------------------------------------------------+
