//+------------------------------------------------------------------+
//|                                               GestorArchivos.mqh |
//|                                  Copyright 2025, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Alexander Nova."
#property link      "alexnova25"
#property version   "1.00"


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class GestorArchivos
  {
private:
   string            m_filename;
public:
   //constructor por defecto: INicializa la clase
                     GestorArchivos();
                     GestorArchivos(string fileName_param);
   void              setFileName(string fileName_param);
   string            getFileName() {return m_filename;}
   bool              setFileDatas(double& datas[]);
                    ~GestorArchivos();
protected:

  };

//+------------------------------------------------------------------+
//|       Si no se le da un nombre al archivo, será guardado con
//| nombre por default                                |
//+------------------------------------------------------------------+
GestorArchivos::GestorArchivos()
  {
   m_filename = "default_line.csv";
   
  }
//+------------------------------------------------------------------+
//|                se le dara un nombre a archivo                              |
//+------------------------------------------------------------------+
GestorArchivos::GestorArchivos(string fileName_param)
  {

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void GestorArchivos::setFileName(string fileName_param)
  {
   if(StringLen(fileName_param) > 0)
     {
      m_filename = fileName_param+"_.csv";
     }
   else
     {
      Print("Error: ",__FUNCTION__, " No se puede guardar vacio, se usara el nombre por default.");
      m_filename = "default_line.csv";
     }
  }
//+------------------------------------------------------------------+
//|           Metodo principal para guardar una array de cadenas
//|Retorna "true" si se guardo con exito; "false" si hubo error                              |
//+------------------------------------------------------------------+
bool GestorArchivos::setFileDatas(double &datas[])
  {
   if(ArraySize(datas) == 0)
     {
      Print("Error en : ",__FUNCTION__," no hay datos por guardar, no se guardará nda.");
     }
// 2. Abrir el archivo para escritura.
//    FILE_WRITE: Abre el archivo para escribir. Si existe, su contenido se sobrescribe.
//    FILE_CSV:   Indica que el archivo es de formato CSV.
//    FILE_ANSI:  Utiliza la codificación ANSI, que es compatible con la mayoría de los editores y hojas de cálculo.
//    FILE_COMMON: Guarda el archivo en la carpeta compartida 'MQL5/Files', facilitando su acceso.
   int file_handled = FileOpen(getFileName(),FILE_READ | FILE_WRITE | FILE_CSV | FILE_ANSI | FILE_COMMON );
//verificar si el archivo se abrio correctamente
   if(file_handled == INVALID_HANDLE)
     {
      Print("Error  "__FUNCTION__,", no se pudo abrir el archivo -> ",getFileName());
      return false;
     }
   Print("Ok:  ",__FUNCTION__,"  Archivo <",getFileName(),"> abierto exitosamente");
  //    0 es el offset, o sea, 0 bytes desde el final.
 
        
      Print("C_CSVWriter::setFileDatas - Archivo '", m_filename, "' abierto para añadir datos.");

//construir la linea completa CSV
   string line_to_write= "";
   for(int i = 0; i < ArraySize(datas); i++)
     {
      line_to_write+=datas[i]; //Añade el elemento actual
      //aqui se añade la coma que separa lo elementos por columnas para se leido en python
      if(i < ArraySize(datas) - 1)
        {
         line_to_write += ",";
        }
     }
       
//escribir la linea completa en el archivo
//    FileWriteString escribe la cadena y automáticamente añade un salto de línea al final.
//    Este salto de línea es lo que hace que la línea sea una "línea" completa en el CSV.

   FileSeek(file_handled,0,SEEK_END);
   if(FileWrite(file_handled, line_to_write) == -1)//-1 indicará un error de escritura
     {
      Print(""__FUNCTION__," ERROR: fallo al escribir en el archivo: ",m_filename," Codigo de Error: <",GetLastError(),">");
      FileClose(file_handled);
      return false;
     }
     
//cerrar el archivo
   FileFlush(file_handled);
   FileClose(file_handled);
   Print("",__FUNCTION__," - Datos Guardados con EXITO");

   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
GestorArchivos::~GestorArchivos()
  {
  }
//+------------------------------------------------------------------+
