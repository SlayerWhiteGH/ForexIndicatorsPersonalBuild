//+------------------------------------------------------------------+
//|                                                       Awptic.mq4 |
//|                                           Copyright 2023, Awptic |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Awptic"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window

#include "Object.mqh"

Object *myObjects[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
    ArrayResize(myObjects, ObjectsTotal());
    for (int i = 0; i < ObjectsTotal(); i++) {
        string name = ObjectName(i);
        ENUM_OBJECT type = ObjectGet(name, OBJPROP_TYPE);
        myObjects[i] = new Object(false, name, type);
        printf("Name : " + myObjects[i].getName());
    }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
    
  }
//+------------------------------------------------------------------+
