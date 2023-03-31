//+------------------------------------------------------------------+
//|                                            NinjaCandlesticks.mq4 |
//|                      Copyright c 2004, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
//| Here is a simple code to plot the candlesticks in the NinjaTrader| 
//| or eSignal style. After you apply this indicator, change the     |
//| settings in Properties (F8) Bar Up/Down, Bull/Bear Candle to None|
//| and the color scheme "... on White". You'll have the candles     |
//| displayed with the shadows (wicks) black and candle bodies       |
//| (themselves only) lime and red.                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2004, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Black
#property indicator_color2 Black
#property indicator_color3 Red
#property indicator_color4 Lime
#property indicator_width1 1
#property indicator_width2 1
#property indicator_width3 3
#property indicator_width4 3

//----
extern color color1 = Black;
extern color color2 = Black;
extern color color3 = Red;
extern color color4 = Lime;
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
//----
int ExtCountedBars=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//|------------------------------------------------------------------|
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_HISTOGRAM, 0, 1, color1);
   SetIndexBuffer(0, ExtMapBuffer1);
   SetIndexStyle(1,DRAW_HISTOGRAM, 0, 1, color2);
   SetIndexBuffer(1, ExtMapBuffer2);
   SetIndexStyle(2,DRAW_HISTOGRAM, 0, 3, color3);
   SetIndexBuffer(2, ExtMapBuffer3);
   SetIndexStyle(3,DRAW_HISTOGRAM, 0, 3, color4);
   SetIndexBuffer(3, ExtMapBuffer4);
//----
   SetIndexDrawBegin(0,10);
   SetIndexDrawBegin(1,10);
   SetIndexDrawBegin(2,10);
   SetIndexDrawBegin(3,10);
//---- indicator buffers mapping
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexBuffer(2,ExtMapBuffer3);
   SetIndexBuffer(3,ExtMapBuffer4);
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//---- TODO: add your code here
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   double haOpen, haHigh, haLow, haClose;
   if(Bars<=10) return(0);
   ExtCountedBars=IndicatorCounted();
//---- check for possible errors
   if (ExtCountedBars<0) return(-1);
//---- last counted bar will be recounted
   if (ExtCountedBars>0) ExtCountedBars--;
   int pos=Bars-ExtCountedBars-1;
   while(pos>=0)
     {
      haOpen=Open[pos];
      haClose=Close[pos];
      haHigh=High[pos];
      haLow=Low[pos];
      
      ExtMapBuffer1[pos]=haLow;
      ExtMapBuffer2[pos]=haHigh;
      ExtMapBuffer3[pos]=haOpen;
      ExtMapBuffer4[pos]=haClose;
 	   pos--;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+