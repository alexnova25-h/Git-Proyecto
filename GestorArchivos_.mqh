//+------------------------------------------------------------------+
//|                                               GestorArchivos.mqh |
//|                                  Copyright 2025, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Arrays\Array.mqh>
#include "IsNewBarra.mqh"
#include "Barras.mqh"
#include "Indicadores.mqh"
#include "GestorMatematico.mqh"
#include "GestorEstrategias.mqh"
#include "Util.mqh"

CIsNewBarra c_newBar;
Indicadores c_Ind;
GestorMatematico c_Math;
GestorEstrategias c_Estra;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class GestorArchivos
  {
private:
   string            m_Simbolo;
   string            m_Mensaje;

   ENUM_TIMEFRAMES   m_Frames;
public:
   void              setGestorArchivos(string simbolo,ENUM_TIMEFRAMES frames,int shift);
   void              setMensajes();
   string            getMensaje() {return m_Mensaje;};
                     GestorArchivos();
                    ~GestorArchivos();
protected:

  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void GestorArchivos::setGestorArchivos(string simbolo,ENUM_TIMEFRAMES frames,int shift)
  {
   m_Simbolo = simbolo;
   m_Mensaje="";
   m_Frames = frames;


   c_newBar.setNewBarr(m_Simbolo,m_Frames,shift);
   c_Estra.initGestorEst(m_Simbolo,m_Frames,shift);


//
if(c_newBar.getIsNewBar())
  {
   int tablas[10][10];
   for(int i=0;i<10;i++)
     {
      for(int j=0;j<10;j++)
        {
         
        }
     }
  }
   
   setMensajes();

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void GestorArchivos::setMensajes(void)
  {
   int leng = StringConcatenate(m_Mensaje,"Archivos"," :)","\n",
                                "newBarr : ",c_newBar.getIsNewBar(),"\n",

                                "NumeroMagico:  ",c_Estra.getNumMagic(),"\n \n"

                                ,c_Estra.getMensaje());

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
GestorArchivos::GestorArchivos()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
GestorArchivos::~GestorArchivos()
  {
  }
//+------------------------------------------------------------------+
