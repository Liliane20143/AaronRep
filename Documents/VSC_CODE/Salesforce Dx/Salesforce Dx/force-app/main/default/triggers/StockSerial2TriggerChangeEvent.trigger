trigger StockSerial2TriggerChangeEvent on Bit2Shop__Stock_Serials2__ChangeEvent (after insert){
    Plc_TriggerChangeEventDispatcher.run(new Plc_StockSerial2ChangeEventHnd());
}