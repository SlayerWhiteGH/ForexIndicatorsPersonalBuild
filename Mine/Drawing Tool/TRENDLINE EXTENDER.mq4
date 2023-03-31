//+------------------------------------------------------------------+
//|                                           TRENDLINE EXTENDER.mq4 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
#property copyright "Configured by ClevaSys"
#property indicator_chart_window
#property description "Draw Your Trendline or box and this will extend it" 
extern string GridSpace_Info = "Amount to extend past the current candle...";
extern int Extend=2;

 
//VOID INITIALISATION
void init()
 {
 }
//VOID START
void start() 
 {
  int TrendTime;

  if(Time[0] > TrendTime)
   {
       for(int i = ObjectsTotal()-1; i >= 0; i--)
       if(ObjectType(ObjectName(i)) == OBJ_TREND)
        ObjectSet(ObjectName(i), OBJPROP_TIME2, Time[0]+Extend*5000)
        ;

      TrendTime = Time[0];     
   }
  
    for(int i = ObjectsTotal()-1; i >= 0; i--) {
        if(ObjectType(ObjectName(i)) == OBJ_TREND) {
            ObjectSet(ObjectName(i), OBJPROP_PRICE2, ObjectGetDouble(0,ObjectName(i),OBJPROP_PRICE1));
        }
    }

 }

//-----------------------------------------------------------------------------
void deinit()
 {

 }

//-----------------------------------------------------------------------------

