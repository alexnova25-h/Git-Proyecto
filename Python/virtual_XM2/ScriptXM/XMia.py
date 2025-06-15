import MetaTrader5 as mt5
import time
import pytz # Para manejar zonas horarias, muy recomendado
from datetime import datetime
import MetaTrader5 as mt5 
# mostramos los datos sobre el paquete MetaTrader5 
print("MetaTrader5 package author: ",mt5.__author__) 
print("MetaTrader5 package version: ",mt5.__version__) 
  #
  
# establecemos la conexión con el terminal MetaTrader 5 en la cuenta comercial indicada 
if not mt5.initialize(login=98066193, server="XMGlobal-MT5 5",password="Forex-Samuel168"): 
    print("initialize() failed, error code =",mt5.last_error()) 
    quit() 
  
# mostramos la información sobre el estado de la conexión, el nombre del servidor y la cuenta comercial 
print(mt5.terminal_info()) 
# mostramos la información sobre la versión de MetaTrader 5 
print(mt5.version()) 
  
# finalizamos la conexión con el terminal MetaTrader 5 
mt5.shutdown()
'''
# --- CONFIGURACIÓN DE LA CONEXIÓN ---
# Si tienes múltiples terminales MT5, especifica la ruta del ejecutable.
# De lo contrario, mt5.initialize() intentará encontrarlo.
# MT5_PATH = "C:\\Program Files\\MetaTrader 5\\terminal64.exe" # Ejemplo Windows
MT5_PATH = None # Deja None si no necesitas especificar la ruta

# --- PARÁMETROS DE LA ORDEN DE COMPRA ---
SYMBOL = "EURUSD"          # Símbolo del instrumento
VOLUME = 0.01              # Volumen de la orden (en lotes)
DEVIATION = 10             # Desviación máxima en puntos (slippage)
STOP_LOSS_PIPS = 50        # Stop Loss en pips (ej. 50 pips)
TAKE_PROFIT_PIPS = 100     # Take Profit en pips (ej. 100 pips)
MAGIC_NUMBER = 123456      # Número mágico para identificar tus órdenes
COMMENT = "My Python Buy Order" # Comentario para la orden

# --- Función para obtener el precio de Ask actual ---
def get_current_ask_price(symbol):
    symbol_info = mt5.symbol_info_tick(symbol)
    if symbol_info is None:
        print(f"Error al obtener información de tick para {symbol}: {mt5.last_error()}")
        return None
    return symbol_info.ask

# --- Función para calcular Stop Loss y Take Profit ---
def calculate_sl_tp(symbol, price, sl_pips, tp_pips, order_type):
    symbol_info = mt5.symbol_info(symbol)
    if symbol_info is None:
        print(f"Error al obtener información del símbolo para {symbol}: {mt5.last_error()}")
        return None, None

    point = symbol_info.point
    
    sl_price = 0.0
    tp_price = 0.0

    if order_type == mt5.ORDER_TYPE_BUY:
        # Para una compra, SL está por debajo del precio, TP por encima
        sl_price = price - (sl_pips * point)
        tp_price = price + (tp_pips * point)
    elif order_type == mt5.ORDER_TYPE_SELL:
        # Para una venta, SL está por encima del precio, TP por debajo
        sl_price = price + (sl_pips * point)
        tp_price = price - (tp_pips * point)
    
    # Redondear los precios a la precisión del símbolo
    digits = symbol_info.digits
    sl_price = round(sl_price, digits)
    tp_price = round(tp_price, digits)

    return sl_price, tp_price

# --- FUNCIÓN PRINCIPAL PARA ENVIAR LA ORDEN DE COMPRA ---
def send_buy_order(symbol, volume, deviation, sl_pips, tp_pips, magic, comment):
    print(f"\nIntentando enviar orden de COMPRA para {symbol} Volumen: {volume}")

    # Obtener el precio actual de ASK
    ask_price = get_current_ask_price(symbol)
    if ask_price is None:
        print("No se pudo obtener el precio de Ask. Cancelando orden.")
        return False

    print(f"Precio Ask actual: {ask_price}")

    # Calcular Stop Loss y Take Profit
    sl, tp = calculate_sl_tp(symbol, ask_price, sl_pips, tp_pips, mt5.ORDER_TYPE_BUY)
    if sl is None or tp is None:
        print("No se pudieron calcular SL/TP. Cancelando orden.")
        return False
    
    print(f"SL calculado: {sl}, TP calculado: {tp}")

    # Preparar el diccionario de la solicitud de la orden
    request = {
        "action": mt5.TRADE_ACTION_DEAL,        # Tipo de acción: ejecutar al precio de mercado
        "symbol": symbol,
        "volume": volume,                       # Volumen de la orden
        "type": mt5.ORDER_TYPE_BUY,             # Tipo de orden: COMPRA
        "price": ask_price,                     # Precio de entrada (actual Ask)
        "deviation": deviation,                 # Desviación permitida (slippage)
        "sl": sl,                               # Precio de Stop Loss
        "tp": tp,                               # Precio de Take Profit
        "magic": magic,                         # Número mágico
        "comment": comment,                     # Comentario
        "type_time": mt5.ORDER_TIME_GTC,        # Good Till Cancelled (válida hasta ser cancelada)
        "type_filling": mt5.ORDER_FILLING_FOK,  # Fill Or Kill (ejecutar toda o nada)
    }

    # Enviar la solicitud de la orden
    result = mt5.order_send(request)

    # Procesar el resultado
    if result.retcode == mt5.TRADE_RETCODE_DONE:
        print(f"Orden de COMPRA enviada exitosamente!")
        print(f"Ticket: {result.order}, Precio: {result.price}, Volumen: {result.volume}")
        
        # Opcional: Obtener detalles del resultado extendido si es necesario
        # print("Resultado de la orden:")
        # for prop in dir(result):
        #     if not prop.startswith("_"):
        #         print(f"  {prop}: {getattr(result, prop)}")
        
        return True
    else:
        print(f"Error al enviar orden de COMPRA: {result.comment} (Retcode: {result.retcode})")
        # Imprimir más detalles del error si existe
        if result.request:
            print("Detalles de la solicitud:")
            for prop in dir(result.request):
                if not prop.startswith("_"):
                    print(f"  {prop}: {getattr(result.request, prop)}")
        return False

# --- BLOQUE PRINCIPAL DE EJECUCIÓN ---
if __name__ == "__main__":
    # 1. Inicializar la conexión a MetaTrader 5
    print("Intentando inicializar la conexión con MetaTrader 5...")
    if not mt5.initialize(path=MT5_PATH):
        print(f"initialize() falló, código de error: {mt5.last_error()}")
        print("Asegúrate de que el terminal MT5 esté abierto y conectado a una cuenta.")
        exit() # Salir si la conexión falla
    print("Conexión con MetaTrader 5 establecida exitosamente.")

    # 2. Obtener información de la cuenta
    account_info = mt5.account_info()
    if account_info:
        print(f"\n--- Información de la Cuenta ---")
        print(f"Login: {account_info.login}")
        print(f"Balance: {account_info.balance:.2f} {account_info.currency}")
        print(f"Equity: {account_info.equity:.2f} {account_info.currency}")
        print(f"Bróker: {account_info.broker}")
        print(f"Servidor: {account_info.server}")
        print(f"Margen Libre: {account_info.margin_free:.2f} {account_info.currency}")
    else:
        print(f"Error al obtener información de la cuenta: {mt5.last_error()}")
        mt5.shutdown()
        exit()

    # 3. Verificar si el símbolo está disponible
    symbol_info = mt5.symbol_info(SYMBOL)
    if symbol_info is None:
        print(f"Símbolo {SYMBOL} no encontrado o no disponible. Error: {mt5.last_error()}")
        mt5.shutdown()
        exit()
    
    if not symbol_info.visible:
        print(f"Símbolo {SYMBOL} no visible en Market Watch. Intentando agregarlo...")
        if not mt5.symbol_select(SYMBOL, True):
            print(f"Error al hacer visible el símbolo {SYMBOL}: {mt5.last_error()}")
            mt5.shutdown()
            exit()
        else:
            print(f"Símbolo {SYMBOL} ahora es visible.")

    # 4. Enviar la orden de compra
    order_successful = send_buy_order(
        SYMBOL,
        VOLUME,
        DEVIATION,
        STOP_LOSS_PIPS,
        TAKE_PROFIT_PIPS,
        MAGIC_NUMBER,
        COMMENT
    )

    if order_successful:
        print("\nOrden de compra procesada. Puedes verificar en tu terminal MT5.")
    else:
        print("\nNo se pudo enviar la orden de compra.")

    # 5. Desinicializar la conexión a MetaTrader 5
    print("\nDesconectando de MetaTrader 5...")
    mt5.shutdown()
    print("Desconexión completa.")
    '''