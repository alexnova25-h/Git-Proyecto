//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+

// Definición de una clase auxiliar para las funciones de comparación
// (Esta clase es necesaria porque la usas como 'c_Bub')
class C_ComparadorArrays
  {
public:
   // Método para comparar dos arrays elemento a elemento por índice.
   // Guarda 'true' en 'resultado[i]' si 'original[i]' es igual a 'comparar_con[i]',
   // y 'false' en caso contrario.
   // Parámetros:
   //   original[]:      El primer array para la comparación.
   //   comparar_con[]:  El segundo array para comparar con el primero.
   //   resultado[]:     Array booleano donde se almacenarán los resultados de la comparación.
   void              compararIndices(double& original[], double& comparar_con[], bool& resultado[])
     {
      int size_orig = ArraySize(original);
      int size_comp = ArraySize(comparar_con);

      // Es crucial que ambos arrays tengan el mismo tamaño para una comparación directa por índice.
      if(size_orig != size_comp)
        {
         Print("ERROR: Los arrays a comparar tienen tamaños diferentes. No se puede realizar la comparación directa.");
         return; // Salir de la función si los tamaños no coinciden.
        }

      // Redimensionar el array de resultados para que coincida con el tamaño de los arrays de entrada.
      ArrayResize(resultado, size_orig);

      // Iterar a través de los arrays para comparar cada elemento en la misma posición.
      for(int i = 0; i < size_orig; i++)
        {
         if(original[i] == comparar_con[i])
           {
            resultado[i] = true; // Coinciden, establecer a verdadero.
           }
         else
           {
            resultado[i] = false; // No coinciden, establecer a falso.
           }
        }
     }
  };


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnStart()
  {
// --- Declaración de los arrays ---
   double original[] = {1, 2, 3, 4}; // Tu array inicial

   double copia[];  // Este array contendrá la versión ordenada ASCENDENTE (menor a mayor)
   double revers[]; // Este array contendrá la versión ordenada DESCENDENTE (mayor a menor)

   bool res_mayor[]; // Resultado de la comparación: original vs. revers (descendente)
   bool res_menor[]; // Resultado de la comparación: original vs. copia (ascendente)

   int size = ArraySize(original); // Obtenemos el tamaño del array original

// --- 1. Redimensionar todos los arrays de destino ---
// Esto asegura que haya espacio suficiente para los datos.
   ArrayResize(copia, size);
   ArrayResize(revers, size);
   ArrayResize(res_mayor, size);
   ArrayResize(res_menor, size);

// --- 2. Crear copias iniciales del array 'original' antes de modificarlas ---
// Necesitamos dos copias separadas porque realizaremos dos transformaciones diferentes:
// una para ordenar ascendentemente y otra para invertir el orden (que resultará en descendente).

   ArrayCopy(copia, original, 0, 0, size);  // 'copia' ahora es {1,2,3,4}
   ArrayCopy(revers, original, 0, 0, size); // 'revers' ahora también es {1,2,3,4}

// --- 3. Procesar las copias ---

// Ordenar 'copia' de menor a mayor (ascendente).
// En MQL5, ArraySort() SIEMPRE ordena de forma ascendente.
   ArraySort(copia); // 'copia' ahora es {1,2,3,4}

// Invertir 'revers' para que quede de mayor a menor (descendente).
// Esto se hace *después* de que 'revers' ya tiene los datos de 'original'.
   ArrayReverse(revers); // 'revers' ahora es {4,3,2,1}

// --- 4. Crear una instancia de la clase comparadora ---
   C_ComparadorArrays c_Bub; // Instancia de la clase que contiene 'compararIndices'

// --- 5. Realizar las comparaciones ---

// Comparar el 'original' con 'revers' (el array ordenado de MAYOR a MENOR)
   c_Bub.compararIndices(original, revers, res_mayor);

// Comparar el 'original' con 'copia' (el array ordenado de MENOR a MAYOR)
   c_Bub.compararIndices(original, copia, res_menor);

// --- 6. Imprimir los resultados ---
   Print("Original:               ", ArrayToString(original));
   Print("Copia (Ordenada Asc):   ", ArrayToString(copia));
   Print("Revers (Ordenada Desc): ", ArrayToString(revers));
   Print("Original vs Revers (res_mayor):  ", ArrayToString(res_mayor));
   Print("Original vs Copia (res_menor):   ", ArrayToString(res_menor));

   /*
   Análisis de los resultados esperados para original[]={1,2,3,4}:

   Original:                {1,2,3,4}
   Copia (Ordenada Asc):    {1,2,3,4}  (1,2,3,4 ordenado ascendente es 1,2,3,4)
   Revers (Ordenada Desc):  {4,3,2,1}  (1,2,3,4 invertido es 4,3,2,1)

   Comparación 'Original' vs 'Revers (Descendente)': res_mayor
   original[0]=1  vs  revers[0]=4  => false
   original[1]=2  vs  revers[1]=3  => false
   original[2]=3  vs  revers[2]=2  => false
   original[3]=4  vs  revers[3]=1  => false
   => {False,False,False,False}

   Comparación 'Original' vs 'Copia (Ascendente)': res_menor
   original[0]=1  vs  copia[0]=1  => true
   original[1]=2  vs  copia[1]=2  => true
   original[2]=3  vs  copia[2]=3  => true
   original[3]=4  vs  copia[3]=4  => true
   => {True,True,True,True}
  //+------------------------------------------------------------------+
  //|                                                                  |
  //+------------------------------------------------------------------+
   */
  }
//+------------------------------------------------------------------+
//|  FUNCION PARA GUARDAR UNA MATRIZ EN ARCHIVO CSV              |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   // 1. Declarar e inicializar tu objeto matrix
   // La forma correcta de inicializar un objeto matrix es crearlo y luego llenarlo.
   // matrix m(2, 6); // Crea una matriz de 2 filas y 6 columnas.
   
   // Para tu ejemplo específico, llenaremos la matriz después de crearla.
   matrix m(2, 6); // 2 filas, 6 columnas

   // Llenar la matriz con los valores que proporcionaste
   // Acceso a los elementos: m[fila][columna]
   m[0][0]=1; m[0][1]=2; m[0][2]=3; m[0][3]=4; m[0][4]=5; m[0][5]=6;
   m[1][0]=7; m[1][1]=8; m[1][2]=9; m[1][3]=10; m[1][4]=11; m[1][5]=12;

   // 2. Nombre del archivo CSV
   string filename = "mi_objeto_matrix.csv";

   // 3. Abrir el archivo para escritura
   // Usamos FILE_WRITE para escribir, FILE_CSV para el formato, FILE_ANSI para compatibilidad
   // y FILE_COMMON para guardar en la carpeta compartida (MQL5/Files).
   int file_handle = FileOpen(filename, FILE_WRITE | FILE_CSV | FILE_ANSI | FILE_COMMON);

   // 4. Verificar si el archivo se abrió correctamente
   if (file_handle == INVALID_HANDLE)
     {
      Print("ERROR: No se pudo abrir el archivo ", filename, ". Código de error: ", GetLastError());
      return; // Salir si hay un error
     }

   Print("Archivo '", filename, "' abierto correctamente.");

   // 5. Obtener las dimensiones del objeto matrix
   // Para un objeto matrix, usas los métodos Rows() y Cols()
   int num_filas = m.Rows();    // Número de filas
   int num_columnas = m.Cols(); // Número de columnas

   // 6. Recorrer la matriz y escribir cada fila en el archivo
   for (int row = 0; row < num_filas; row++)
     {
      string line = ""; // Variable para construir cada línea del CSV

      for (int col = 0; col < num_columnas; col++)
        {
         // Acceder al elemento del objeto matrix: m[fila][columna]
         // Convertir el número (double) a cadena y añadirlo a la línea
         line += DoubleToString(m[row][col], 0); // Usamos 0 decimales para los enteros del ejemplo

         // Añadir una coma si no es la última columna de la fila
         if (col < num_columnas - 1)
           {
            line += ",";
           }
        }
      
      // Escribir la línea completa en el archivo, seguida de un salto de línea
      FileWriteString(file_handle, line);
     }

   // 7. Cerrar el archivo después de escribir
   FileClose(file_handle);
   Print("Datos del objeto matrix guardados en '", filename, "' correctamente.");

   // NOTA: Para encontrar el archivo, ve a MetaTrader 5, luego a "Archivo" -> "Abrir Carpeta de Datos".
   // El archivo estará en MQL5/Files/mi_objeto_matrix.csv
  }
//+------------------------------------------------------------------+
