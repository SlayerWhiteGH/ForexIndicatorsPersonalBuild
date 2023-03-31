//+------------------------------------------------------------------+
//|                                    MW London Close - KG like.mq4 |
//|                                      DaSimplify © 2011, MW Corp. |
//|                                      http://www.KGForexworld.com |
//+------------------------------------------------------------------+
#property copyright "DaSimplify © 2011, MW Corp."
#property link      "http://www.KGForexworld.com"
#property indicator_buffers 1
#property indicator_color1 Lime

extern string SETTINGAN_DEFAULT = " Settingan default untuk broker GMT+1 DST mulai Maret 2011. ";
extern int Jam_London_Close = 18;
extern int Menit_yang_ke    = 00;

double LC[];
double LC_temp=EMPTY_VALUE;

#property indicator_chart_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
  if(Period()>PERIOD_H1){Alert("maaf om, indi London Close max s/d TF H1."); return(-1);}
//---- indicators
   SetIndexDrawBegin(0,100);
   SetIndexBuffer(0,LC);
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,2);
   SetIndexLabel(0,"London Close");

   IndicatorShortName("MW London Close - Seperti KG punya :) ");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int limit;
   int bar=IndicatorCounted();
   if(bar>0) bar--;
   limit=Bars-bar;
      
   for(int i=limit; i>=0; i--)
   {
      if(TimeHour(Time[i+1])==Jam_London_Close && TimeMinute(Time[i+1])==Menit_yang_ke) LC_temp = iClose(NULL,0,i+1); 
      LC[i]=LC_temp;
   }
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+