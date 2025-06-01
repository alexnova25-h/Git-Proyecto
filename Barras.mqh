//+------------------------------------------------------------------+
//|                                                       Barras.mqh |
//|                                  Copyright 2025, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Barras
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
   string            b_simbolo;


public:
   void              initBarras(string simbolo, ENUM_TIMEFRAMES frames);
   void              Barras(string simbolo);
   string            getB() {return b_simbolo;};
   //precio por barra
   double            getOpen(int shift);
   double            getClose(int shift);
   double            getHight(int shift);
   double            getLow(int shift);
   //calculos sobre la barra
   double            getBody(int shift);
   double            getWick(int shift) ;
   double            getHighWick(int shift) ;
   double            getLowWick(int shift);
   int               getState(int shift);

   string            getMensaje() {return m_Mensaje;};
                     Barras();
                    ~Barras();
   void              setDatasBarra(int barra);
protected:
   void              setMensaje();
  };

void Barras::Barras( string simbolo):b_simbolo(simbolo){
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Barras::initBarras(string simbolo,ENUM_TIMEFRAMES frames)
  {
   m_Simbolo = simbolo;
   m_Frames = frames;
  }

//
double Barras::getBody(int shift)
  {
   m_Body = MathAbs(iOpen(m_Simbolo,m_Frames,shift)
                    -
                    iClose(m_Simbolo,m_Frames,shift));

   return NormalizeDouble(m_Body,2);
  }
//

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Barras::getWick(int shift)
  {

   m_Wick = MathAbs(iHigh(m_Simbolo,m_Frames,shift)
                    -
                    iLow(m_Simbolo,m_Frames,shift));
   return NormalizeDouble(m_Wick,2);
  }

//
double Barras::getHighWick(int shift)
  {
   m_Open = iOpen(m_Simbolo,m_Frames,shift);
   m_Close = iClose(m_Simbolo,m_Frames,shift);
   m_High =iHigh(m_Simbolo,m_Frames, shift);


   if(m_Close > m_Open)
     {
      m_HighWick = m_High - m_Close;

     }
   else
     {
      m_HighWick =m_High - m_Open;
     }
   return NormalizeDouble(m_HighWick,2);

  }
//
double Barras::getLowWick(int shift)
  {
   m_Open = iOpen(m_Simbolo,m_Frames,shift);
   m_Close = iClose(m_Simbolo,m_Frames,shift);
   m_Low =iLow(m_Simbolo,m_Frames, shift);


   if(m_Close < m_Open)
     {
      m_LowWick = m_Close - m_Low;

     }
   return NormalizeDouble(m_LowWick,2);

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int Barras::getState(int shift)
  {
   m_State =(-1);
   m_Open = iOpen(m_Simbolo,m_Frames,shift);
   m_Close = iClose(m_Simbolo,m_Frames,shift);
   if(m_Close > m_Open)
     {
      m_State = 0;
     }
   else
      if(m_Close < m_Open)
        {
         m_State = 1;
        }
      
   return m_State;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Barras::setDatasBarra(int barra)
  {

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Barras::setMensaje(void)
  {
   m_Mensaje ="";

   int leng = StringConcatenate(m_Mensaje,"Mesaje desde Barras... :)","\n");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Barras::Barras()
  {
   setMensaje();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Barras::~Barras()
  {
  }
//+------------------------------------------------------------------+
