//*
//* my_DailyOpen_indicator
//*
//* Revision 1.1  2005/11/13 Midnite
//* Initial DailyOpen indicator
//
// *** The original indicator has input for drawing a horizontal line on the hour (9:00, 11:00, 15:00 etc)
// *** but not past the hour (09:30, 15:15 etc).
// *** Edits by file45 :
// *** Added - the ability to input minutes and set the horizontal line start time
// *** at any minute past the hour (9:30, 10:42, 12:56 etc).
// *** Added - Alerts to hours entry > 23 and minutes entry > 59.

#property copyright "Midnite"
#property link      "me@home.net"

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Yellow
#property indicator_style1 0
#property indicator_width1 0

double TodayOpenBuffer[];
extern int Hour_= 9;
extern int Minutes = 0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()

{
   if (Hour_>23){
   Alert ("Please enter a value lower than 24 hours");
   return(0);}

   if (Minutes>59){
   Alert ("Please enter a value lower than 60 minutes");
   return (0);}
  
SetIndexStyle(0,DRAW_LINE);
SetIndexBuffer(0,TodayOpenBuffer);
SetIndexLabel(0,"Open");
SetIndexEmptyValue(0,0.0);
return(0);
}
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
{
return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{
   int i;
   int counted_bars= IndicatorCounted();
  
   if (counted_bars>0) counted_bars--;
   i = Bars-counted_bars;
   DailyOpen(0,i);
  
   return (0);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int DailyOpen(int offset, int i){
   int shift;
   int tzdiffsec= (Hour_*3600)+(Minutes*60);
   double barsper30= 1.0*PERIOD_M30/Period();
   bool ShowDailyOpenLevel= True;
   // lastbar+= barsperday+2;  // make sure we catch the daily open
   
   i= MathMin(Bars-20*barsper30-1, i);

   for(shift=i;shift>=offset;shift--){
   TodayOpenBuffer[shift]= 0;
   if (ShowDailyOpenLevel){
       if(TimeDay(Time[shift]-tzdiffsec) != TimeDay(Time[shift+1]-tzdiffsec)){
          TodayOpenBuffer[shift]= Open[shift];        
          TodayOpenBuffer[shift+1]= 0;
          }else{
          TodayOpenBuffer[shift]= TodayOpenBuffer[shift+1];}
       }
   }
   return(0);
}
//+------------------------------------------------------------------+
void Sett(bool Action){
   ResetLastError();
   if(!Action){
      Print(": failed to draw = ",GetLastError());
      return;
   }
}
//+------------------------------------------------------------------+
bool Text(const long              chart_ID=0,               // chart's ID 
          const string            name="Text",              // object name 
          const int               sub_window=0,             // subwindow index 
          datetime                time=0,                   // anchor point time 
          double                  price=0,                  // anchor point price 
          const string            text="Text",              // the text itself 
          const string            font="Arial",             // font 
          const int               font_size=8,             // font size 
          const color             clr=clrYellow,               // color 
          const double            angle=0.0,                // text slope 
          const ENUM_ANCHOR_POINT anchor=ANCHOR_LEFT_UPPER, // anchor type 
          const bool              back=true,               // in the background 
          const bool              selection=false,          // highlight to move 
          const bool              hidden=false,              // hidden in the object list 
          const long              z_order=0){               // priority for mouse click  
   ChangeTextEmptyPoint(time,price); 
   ResetLastError(); 
   string Name=name;
   if(ObjectFind(Name)==WRONG_VALUE)
      ObjectCreate(chart_ID,Name,OBJ_TEXT,sub_window,0,0);
   ObjectSetInteger(chart_ID,Name,OBJPROP_TIME,time);
   ObjectSetDouble(chart_ID,Name,OBJPROP_PRICE,price);
   ObjectSetString(chart_ID,Name,OBJPROP_TEXT,text); 
   ObjectSetString(chart_ID,Name,OBJPROP_FONT,font); 
   ObjectSetInteger(chart_ID,Name,OBJPROP_FONTSIZE,font_size); 
   ObjectSetDouble(chart_ID,Name,OBJPROP_ANGLE,angle); 
   ObjectSetInteger(chart_ID,Name,OBJPROP_ANCHOR,anchor); 
   ObjectSetInteger(chart_ID,Name,OBJPROP_COLOR,clr); 
   ObjectSetInteger(chart_ID,Name,OBJPROP_BACK,back); 
   ObjectSetInteger(chart_ID,Name,OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(chart_ID,Name,OBJPROP_SELECTED,selection); 
   ObjectSetInteger(chart_ID,Name,OBJPROP_HIDDEN,hidden); 
   ObjectSetInteger(chart_ID,Name,OBJPROP_ZORDER,z_order); 
   ObjectSetString(chart_ID,Name,OBJPROP_TOOLTIP,"\n"); 
   return(true); 
}
//+------------------------------------------------------------------+
void ChangeTextEmptyPoint(datetime &time,double &price){ 
   if(!time) time=TimeCurrent(); 
   if(!price)price=SymbolInfoDouble(Symbol(),SYMBOL_BID); 
  } 
//+------------------------------------------------------------------+