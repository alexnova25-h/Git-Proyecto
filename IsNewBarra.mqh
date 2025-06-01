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

public:

   void              setNewBarr(string simbolo,ENUM_TIMEFRAMES frame,int shift);
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
void CIsNewBarra::setNewBarr(string simbolo,ENUM_TIMEFRAMES frame, int shift)
  {
   m_Simbolo = simbolo;
   m_Frames = frame;
   m_newBar=false;
   datetime i_time= iTime(m_Simbolo,m_Frames,shift);
   if(m_last_time!=i_time)
     {
      m_last_time=i_time;
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
