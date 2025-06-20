//+------------------------------------------------------------------+
//|                                                  Indicadores.mqh |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
class Indicadores
  {
private:
   string            m_Simbolo;
   ENUM_TIMEFRAMES   m_Frames;

   //manejadores indicadores
   int               h_iMA;
   int               h_Std;
   int               h_MACD;


public:
   void              Indicadores(string simbolo,ENUM_TIMEFRAMES frame);

   double            getMA(int per,int shift,ENUM_MA_METHOD metodo, ENUM_APPLIED_PRICE precio);
   double            getStd(int per,int shift,ENUM_MA_METHOD metodo, ENUM_APPLIED_PRICE precio);
   double            getMACDsignal(int shift);
   double            getMACDmain(int shift);

   void              setFreeInd()
     {
      IndicatorRelease(h_iMA);
      IndicatorRelease(h_Std);
      IndicatorRelease(h_MACD);

     }
                     Indicadores();
                    ~Indicadores();
  };


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Indicadores::Indicadores(string simbolo,ENUM_TIMEFRAMES frame):m_Simbolo(simbolo),
   m_Frames(frame)
  {
  setFreeInd();
  }
//+------------------------------------------------------------------+
//|           Medias moviles                                         |
//+------------------------------------------------------------------+
double Indicadores::getMA(int per,int shift, ENUM_MA_METHOD metodo,ENUM_APPLIED_PRICE precio)
  {
   double            b_iMA[];

   ArraySetAsSeries(b_iMA,true);

   h_iMA = iMA(m_Simbolo,m_Frames,per,shift,metodo,precio);
   CopyBuffer(h_iMA,0,-1,200,b_iMA);
  
   return b_iMA[shift];
  }
//+------------------------------------------------------------------+
//|           Desviacion estandar                                    |
//+------------------------------------------------------------------+
double Indicadores::getStd(int per,int shift, ENUM_MA_METHOD metodo,ENUM_APPLIED_PRICE precio)
  {
   double b_Std[];

   ArraySetAsSeries(b_Std,true);

   h_Std = iStdDev(m_Simbolo,m_Frames,per,shift,metodo,precio);
   CopyBuffer(h_Std,0,-1,200,b_Std);
   return b_Std[shift];
  }
//+------------------------------------------------------------------+
//|                 MACD señal                                       |
//+------------------------------------------------------------------+
double Indicadores::getMACDsignal(int shift)
  {
   double b_MACD_signal[];
   SetIndexBuffer(1,b_MACD_signal,INDICATOR_DATA);
   ArraySetAsSeries(b_MACD_signal,true);
   h_MACD= iMACD(m_Simbolo,m_Frames,12,26,9,PRICE_CLOSE);
   CopyBuffer(h_MACD,1,0,200,b_MACD_signal);

   return b_MACD_signal[shift];
  }
//+------------------------------------------------------------------+
//|                 MACD main                                        |
//+------------------------------------------------------------------+
double Indicadores::getMACDmain(int shift)
  {
   double b_MACD_main[];
   SetIndexBuffer(0,b_MACD_main,INDICATOR_CALCULATIONS);
   ArraySetAsSeries(b_MACD_main,true);
   h_MACD= iMACD(m_Simbolo,m_Frames,12,26,9,PRICE_CLOSE);
   CopyBuffer(h_MACD,0,0,200,b_MACD_main);

   return b_MACD_main[shift];
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Indicadores::Indicadores()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Indicadores::~Indicadores()
  {
 
  }
//+------------------------------------------------------------------+
