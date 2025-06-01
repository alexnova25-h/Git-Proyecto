//+------------------------------------------------------------------+
//|                                                      DataBar.mqh |
//|                                  Copyright 2025, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"




//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class DataBar
  {
private:
   string            m_Simbolo;
   string            m_Mensaje;

   ENUM_TIMEFRAMES   m_Frames;
   double            m_Open;
   double            m_Close;
   double            m_High;
   double            m_Low;

   double            m_Body;
   double            m_Wick;
   double            m_HighWick;
   double            m_LowWick;
   int               m_State;


public:
   void              DataBar(string simbolo,ENUM_TIMEFRAMES frame);
   void              setDatas();
   double            getBody() {return m_Body;};
   double            getWick() {return m_Wick;};
   double            getHighWick() {return m_HighWick;};
   double            getLowWick() {return m_LowWick;};
   int               getState() {return m_State;};

   matrix            matrizBarra(int shift);
                     DataBar();
                    ~DataBar();
   //


   string            getMensaje() {return m_Mensaje;};
protected:
   void              setMensaje();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DataBar::DataBar(string simbolo,ENUM_TIMEFRAMES frame):m_Simbolo(simbolo),
   m_Frames(frame)
  {

   setMensaje();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
matrix DataBar::matrizBarra(int shift)
  {
   m_Open =  NormalizeDouble((iOpen(m_Simbolo,m_Frames,shift)/Point()),3);
   m_Close = NormalizeDouble((iClose(m_Simbolo,m_Frames,shift)/Point()),3);
   m_High =  NormalizeDouble((iHigh(m_Simbolo,m_Frames,shift)/Point()),3);
   m_Low =   NormalizeDouble((iLow(m_Simbolo,m_Frames,shift)/Point()),3);

   m_Body = NormalizeDouble((m_Close - m_Open),Digits());
   m_Wick = NormalizeDouble((m_High -m_Low),Digits());
   if(m_Body<0)
     {
      m_State=1;
      m_HighWick = NormalizeDouble(MathAbs(m_Open-m_High),Digits());
      m_LowWick = NormalizeDouble(MathAbs(m_Close - m_Low),Digits());
     }
   else
     {
      m_State=0;
      m_HighWick = NormalizeDouble(MathAbs(m_Close-m_High),Digits());
      m_LowWick = NormalizeDouble(MathAbs(m_Open - m_Low),Digits());
     }
   matrix m_Barra= {{shift,MathAbs(m_Body),m_Wick,m_HighWick,m_LowWick,m_State}};

   return m_Barra;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DataBar::setDatas(void)
  {

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
DataBar::DataBar(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
DataBar::~DataBar()
  {
  }
//+------------------------------------------------------------------+
void DataBar::setMensaje(void)
  {

  }
//+------------------------------------------------------------------+
