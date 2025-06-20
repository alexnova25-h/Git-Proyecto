//+------------------------------------------------------------------+
//|                                                        Datos.mqh |
//|                                  Copyright 2025, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include "IsNewBarra.mqh"


//
CIsNewBarra d_newBar;



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CDatos
  {
private:
   string            m_Mensaje;
   string            m_Simbolo;

   int               m_CountBars;
   int               m_Shift;

   bool              m_IsNewBar;
   ENUM_TIMEFRAMES   m_Frame;

public:
   void              initDatos(string simbolo,ENUM_TIMEFRAMES frame,int shift);
                     CDatos();
                    ~CDatos();

   string            getMensaje() {return m_Mensaje;};


protected:

   void              setMensaje()
     {

      int leng = StringConcatenate(m_Mensaje,"Mensaje Datos :)","\n",
                                   d_newBar.getIsNewBar(),"\n",
                                   m_CountBars);
     };
   int               getCount(bool newBar);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CDatos::initDatos(string simbolo,ENUM_TIMEFRAMES frame,int shift)
  {
   m_Mensaje="";
   m_Simbolo = simbolo;
   m_Frame = frame;
   m_Shift = shift;
   m_IsNewBar = d_newBar.getIsNewBar();
   setMensaje();

   d_newBar.setNewBarr(m_Simbolo,m_Frame,m_Shift);
getCount(m_IsNewBar);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CDatos::getCount(bool newBar)
  {

   m_CountBars;

   if(newBar)
     {
      m_CountBars++;
     }
   return m_CountBars;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CDatos::CDatos()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CDatos::~CDatos()
  {
  }
//+------------------------------------------------------------------+
