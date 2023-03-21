//+------------------------------------------------------------------+
//|                                                 Separator TD.mq4 |
//|                                                   Copyright 2023 |
//|                                                        W H I T E |
//+------------------------------------------------------------------+

#property copyright "Copyright 2023, W H I T E"
#property link      "W H I T E"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Yellow

extern bool ShowAll               = false;
extern int NumLookBack            = 1;                 //Look Back 1 = 5 Days
extern int HourTime               = 5;                 //Hour Number:
extern int MinuteTime             = 0;                 //Minute Number:
extern color Line_Color           = clrBlack;          //VLine Color:
extern ENUM_LINE_STYLE linestyle  = STYLE_DOT;         //VLine Style:

extern color clrlondonkz          = clrMediumSeaGreen; //LoKZ Color:
extern color clrnykz              = clrMaroon;         //NYKZ Color:

string stDy[] = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"};
string iName="Separator TD ";
bool is_valid_timeframe = (Period() <= PERIOD_M15) ? true : false;
   

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
//---- indicators

//----
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
{
//----
   objDelete();
	Comment("");
//----
   return(0);
}

//+------------------------------------------------------------------+
void objDelete(string inpStr=""){
   inpStr = inpStr!=""?inpStr:iName;
   for(int i=ObjectsTotal(); i>=0; i--){
      if(StringSubstr(ObjectName(i),0,StringLen(inpStr))==inpStr)
         ObjectDelete(ObjectName(i));
   }
}
//+------------------------------------------------------------------+
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
//---- 
   int limit            = Bars - IndicatorCounted();
   int lookback         = NumLookBack;
   int startingPoint    = 0;
   int iterator         = 0;
   int londonOpen       = 7;
   int preNYOpen        = 10;
   int NYOpen           = 12;
   int londonClose      = 15;
//----
   int chart_height = ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS);
   double chart_price_range = ChartGetDouble(0, CHART_PRICE_MAX) - ChartGetDouble(0, CHART_PRICE_MIN);
   double price_per_pixel = chart_price_range / chart_height;
   double y_pos = ChartGetInteger(0, chart_price_range)  - 1;
   double price_at_bottom = ChartGetDouble(0, CHART_PRICE_MIN) + y_pos * price_per_pixel; 
//----
   datetime currentTime = TimeLocal() - (24*60*60);
   datetime lookbackTime = currentTime - (lookback*7*24*60*60);
   int pos = startingPoint + iterator;
    
   datetime today = TimeLocal();
   datetime tomorrow = TimeLocal() + 24 * 60 * 60; // tambahkan 24 jam ke waktu saat ini
   int last_day;
   last_day = TimeDayOfWeek(today); // Mendapatkan hari dalam seminggu (0-6) pada waktu saat ini
  
//----

//----
   for (int i = 0; i < rates_total; i++){
      if (ShowAll) {
         if (TimeMinute(time[i]) == 0 && TimeHour(time[i]) >= HourTime && time[i] <= currentTime) {
            if (TimeHour(time[i]) == HourTime){
               if (ObjectFind(0, getLineSeparator(i)) == -1){
                   Sett(VLineCreate(0, getLineSeparator(i), 0, time[i], Line_Color, linestyle));
                   string day_str = stDy[TimeDayOfWeek(time[i]) == 0 ? 6 : TimeDayOfWeek(time[i]) - 1];
                   Sett(Text(0, getLineSeparator(i) + string(time[i]), 0, time[i], price_at_bottom, day_str, "Arial", 8, clrBlack, 90));
                  }
               }
              else if (TimeHour(time[i]) == londonOpen){
                  if (ObjectFind(0, getLineLondonOpen(i)) == -1){
                      Sett(VLineCreate(0, getLineLondonOpen(i), 0, time[i], clrlondonkz, 2, 1));
                      Sett(Text(0, getLineLondonOpen(i), 0, time[i], price_at_bottom, "London Open", "Arial", 7, clrlondonkz, 90));
                  }
              }
              else if (TimeHour(time[i]) == preNYOpen){
                  if (ObjectFind(0, getLinePreNYOpen(i)) == -1){
                      Sett(VLineCreate(0, getLinePreNYOpen(i), 0, time[i], clrnykz, 2, 1));
                      Sett(Text(0, getLinePreNYOpen(i), 0, time[i], price_at_bottom, "Pre NY", "Arial", 7, clrnykz, 90));
                  }
              }
              else if (TimeHour(time[i]) == NYOpen){
                  if (ObjectFind(0, getLineNYOpen(i)) == -1){
                      Sett(VLineCreate(0, getLineNYOpen(i), 0, time[i], clrnykz, 2, 1));
                      Sett(Text(0, getLineNYOpen(i), 0, time[i], price_at_bottom, "NY Open", "Arial", 7, clrnykz, 90));
                  }
              }
              else if (TimeHour(time[i]) == londonClose){
                  if (ObjectFind(0, getLineLondonClose(i)) == -1){
                      Sett(VLineCreate(0, getLineLondonClose(i), 0, time[i], clrlondonkz, 2, 1));
                      Sett(Text(0, getLineLondonClose(i), 0, time[i], price_at_bottom, "London Close", "Arial", 7, clrlondonkz, 90));
                  }
              }
         } 
      }     
       
    if (today >= currentTime) {
         
         datetime separator_time = D'05:00:00';
         datetime london_open = D'07:00:00';
         datetime pre_ny_open = D'10:00:00';
         datetime ny_open = D'12:00:00';
         datetime eight_am = D'13:30:00';
         datetime london_close = D'15:00:00';
     
         if (ObjectFind(0, getLineSeparator(i)) == -1){
             Sett(VLineCreate(0, getLineSeparator(i), 0, separator_time, Line_Color, linestyle));
             string day_str = stDy[TimeDayOfWeek(time[i]) == 0 ? 6 : TimeDayOfWeek(time[i]) - 1];
             Sett(Text(0, getLineSeparator(i), 0,separator_time, price_at_bottom, day_str, "Arial", 8, clrBlack, 90));
         }
         if (ObjectFind(0, getLineLondonOpen(i)) == -1){
             Sett(VLineCreate(0, getLineLondonOpen(i), 0, london_open, clrlondonkz, 2, 1));
             Sett(Text(0, getLineLondonOpen(i), 0,london_open, price_at_bottom, "London Open", "Arial", 7, clrlondonkz, 90));
         }
         if (ObjectFind(0, getLinePreNYOpen(i)) == -1){
             Sett(VLineCreate(0, getLinePreNYOpen(i), 0,pre_ny_open, clrnykz, 2, 1));
             Sett(Text(0, getLinePreNYOpen(i), 0,pre_ny_open, price_at_bottom, "Pre NY", "Arial", 7, clrnykz, 90));
         }
         if (ObjectFind(0, getLineNYOpen(i)) == -1){
             Sett(VLineCreate(0, getLineNYOpen(i), 0,ny_open, clrnykz, 2, 1));
             Sett(Text(0, getLineNYOpen(i), 0,ny_open, price_at_bottom, "NY Open", "Arial", 7, clrnykz, 90));
         }
         if (ObjectFind(0, getLine8AM(i)) == -1){
             Sett(VLineCreate(0, getLine8AM(i), 0,eight_am, clrnykz, 2, 1));
             Sett(Text(0, getLine8AM(i), 0,eight_am, price_at_bottom, "8.30 AM", "Arial", 7, clrnykz, 90));
         }
         if (ObjectFind(0, getLineLondonClose(i)) == -1){
             Sett(VLineCreate(0, getLineLondonClose(i), 0,london_close, clrlondonkz, 2, 1));
             Sett(Text(0, getLineLondonClose(i), 0,london_close, price_at_bottom, "London Close", "Arial", 7, clrlondonkz, 90));
         } 

      }  
    }
    
 

//----
if (!is_valid_timeframe){
    // Remove all objects if the timeframe is not valid
   objDelete();}
//----
return(rates_total);
}
//+--------------------
string getLineSeparator(int barKeberapa) {
     return "Separator-" + string(Time[barKeberapa]);
}
string getLineLondonOpen(int barKeberapa) {
     return "London Open-" + string(Time[barKeberapa]);
}
string getLinePreNYOpen(int barKeberapa) {
     return "Pre NY Open-" + string(Time[barKeberapa]);
}
string getLineNYOpen(int barKeberapa) {
     return "NY Open-" + string(Time[barKeberapa]);
}
string getLine8AM(int barKeberapa) {
     return "8.30 AM-" + string(Time[barKeberapa]);
}
string getLineLondonClose(int barKeberapa) {
     return "London Close-" + string(Time[barKeberapa]);
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
void ChangeTextEmptyPoint(datetime &time,double &price){ 
   if(!time) time=TimeCurrent(); 
   if(!price)price=SymbolInfoDouble(Symbol(),SYMBOL_BID); 
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
          const color             clr=clrBlack,               // color 
          const double            angle=0.0,                // text slope 
          const ENUM_ANCHOR_POINT anchor=ANCHOR_LEFT_UPPER, // anchor type 
          const bool              back=false,               // in the background 
          const bool              selection=false,          // highlight to move 
          const bool              hidden=false,              // hidden in the object list 
          const long              z_order=0){               // priority for mouse click  
   ChangeTextEmptyPoint(time,price); 
   ResetLastError(); 
   string Name=iName+name;
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
bool VLineCreate(const long            chart_ID=0,        // chart's ID 
                 const string          name="VLine",      // line name 
                 const int             sub_window=0,      // subwindow index 
                 datetime              time=0,            // line time 
                 const color           clr=clrRed,        // line color 
                 const ENUM_LINE_STYLE style=STYLE_SOLID, // line style 
                 const int             width=1,           // line width 
                 const bool            back=true,        // in the background 
                 const bool            selection=false,    // highlight to move 
                 const bool            hidden=false,       // hidden in the object list 
                 const long            z_order=0){         // priority for mouse click 
   ResetLastError(); 
   string Name=iName+name;
   if(ObjectFind(Name)==WRONG_VALUE)
      ObjectCreate(chart_ID,Name,OBJ_VLINE,sub_window,0,0);
   ObjectSetInteger(chart_ID,Name,OBJPROP_TIME,time);
   ObjectSetInteger(chart_ID,Name,OBJPROP_COLOR,clr); 
   ObjectSetInteger(chart_ID,Name,OBJPROP_BACK,back);
   ObjectSetInteger(chart_ID,Name,OBJPROP_STYLE,style); 
   ObjectSetInteger(chart_ID,Name,OBJPROP_WIDTH,width);
   ObjectSetInteger(chart_ID,Name,OBJPROP_BACK,back);   
   ObjectSetInteger(chart_ID,Name,OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(chart_ID,Name,OBJPROP_SELECTED,selection); 
   ObjectSetInteger(chart_ID,Name,OBJPROP_HIDDEN,hidden); 
   ObjectSetInteger(chart_ID,Name,OBJPROP_ZORDER,z_order); 
   ObjectSetString(chart_ID,Name,OBJPROP_TOOLTIP,"\n"); 
   return(true); 
}
//+------------------------------------------------------------------+

bool TrendCreate(const long            chart_ID=0,        // chart's ID 
                 const string          name="TrendLine",  // line name 
                 const int             sub_window=0,      // subwindow index 
                 datetime              time1=0,           // first point time 
                 double                price1=0,          // first point price 
                 datetime              time2=0,           // second point time 
                 double                price2=0,          // second point price 
                 const color           clr=clrRed,        // line color 
                 const ENUM_LINE_STYLE style=STYLE_SOLID, // line style 
                 const int             width=1,           // line width 
                 const bool            back=false,        // in the background 
                 const bool            selection=true,    // highlight to move 
                 const bool            ray_right=false,   // line's continuation to the right 
                 const bool            hidden=false,       // hidden in the object list 
                 const long            z_order=0){        // priority for mouse click 
   ChangeTrendEmptyPoints(time1,price1,time2,price2);
   ResetLastError();                   
   string Name=iName+name;
   if(ObjectFind(Name)==WRONG_VALUE)
      ObjectCreate(chart_ID,Name,OBJ_TREND,sub_window,0,0,0,0);
   ObjectSetInteger(chart_ID,Name,OBJPROP_COLOR,clr); 
   ObjectSetInteger(chart_ID,Name,OBJPROP_STYLE,style); 
   ObjectSetInteger(chart_ID,Name,OBJPROP_WIDTH,width); 
   ObjectSetInteger(chart_ID,Name,OBJPROP_BACK,back); 
   ObjectSetInteger(chart_ID,Name,OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(chart_ID,Name,OBJPROP_SELECTED,selection); 
   ObjectSetInteger(chart_ID,Name,OBJPROP_RAY_RIGHT,ray_right); 
   ObjectSetInteger(chart_ID,Name,OBJPROP_HIDDEN,hidden); 
   ObjectSetInteger(chart_ID,Name,OBJPROP_ZORDER,z_order); 
   return(true); 
  } 

//+------------------------------------------------------------------+
void ChangeTrendEmptyPoints(datetime &time1,double &price1, 
                            datetime &time2,double &price2){ 
   if(!time1)  time1=TimeCurrent(); 
   if(!price1) price1=SymbolInfoDouble(Symbol(),SYMBOL_BID); 
   if(!time2){ 
      datetime temp[10]; 
      CopyTime(Symbol(),Period(),time1,10,temp); 
      time2=temp[0]; 
     } 
   if(!price2) price2=price1; 
  }   
  
//+------------------------------------------------------------------+