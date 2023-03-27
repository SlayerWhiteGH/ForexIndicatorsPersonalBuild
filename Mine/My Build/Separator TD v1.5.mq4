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

extern int NumLookBack            = 1;                 //Look Back 1 = 5 Days
extern int HourTime               = 5;                 //Hour Number:
extern int MinuteTime             = 0;                 //Minute Number:
extern color Line_Color           = clrBlack;          //VLine Color:
extern ENUM_LINE_STYLE linestyle  = STYLE_DOT;         //VLine Style:

extern color clrlondonkz          = clrMediumSeaGreen; //LoKZ Color:
extern color clrnykz              = clrMaroon;         //NYKZ Color:

extern bool ShowDailyOpenLevel    = false;             //Daily Open:
extern color coloropenam          = clrYellow;         //Open AM Color:

string iName="Separator TD ";
bool is_valid_timeframe = (Period() <= PERIOD_M30) ? true : false;
   

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
   int ObjectCount = ObjectsTotal();
   for (int i=ObjectCount-1; i>=0; i--){
      if(StringFind(ObjectName(i),iName) != -1){
         ObjectDelete(ObjectName(i));
         }  
      }    
//----
   return(0);
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
//---- 
string stDy[] = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"};
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
   datetime currentTime = TimeCurrent();
   datetime lookbackTime = currentTime - (lookback*7*24*60*60);
   for (int i = 0; i < rates_total; i++){
    if (time[i] < lookbackTime) continue;
    int pos = startingPoint + iterator;
    if (pos >= rates_total) break;
    int current_hour = TimeHour(time[pos]);
    int current_minute = TimeMinute(time[pos]);

    if (current_minute == 0 && current_hour >= HourTime && time[pos] >= lookbackTime && time[pos] <= currentTime){
        if (current_hour == HourTime){
            string separator_name = "Separator-" + string(time[pos]);
            if (ObjectFind(0, separator_name) == -1){
                Sett(VLineCreate(0, separator_name, 0, time[pos], Line_Color, linestyle));
                string day_str = stDy[TimeDayOfWeek(time[pos]) == 0 ? 6 : TimeDayOfWeek(time[pos]) - 1];
                Sett(Text(0, "DayName-" + string(time[pos]), 0, time[pos], price_at_bottom, day_str, "Arial", 8, clrBlack, 90));
            }
        }
        else if (current_hour == londonOpen){
            string london_name = "London vLine-" + string(time[pos]);
            if (ObjectFind(0, london_name) == -1){
                Sett(VLineCreate(0, london_name, 0, time[pos], clrlondonkz, 2, 1));
                Sett(Text(0, "London-" + string(time[pos]), 0, time[pos], price_at_bottom, "London Open", "Arial", 7, clrlondonkz, 90));
            }}
        else if (current_hour == preNYOpen){
            string preNY_name = "preNYOpen vLine-" + string(time[pos]);
            if (ObjectFind(0, preNY_name) == -1){
                Sett(VLineCreate(0, preNY_name, 0, time[pos], clrnykz, 2, 1));
                Sett(Text(0, "Pre NY-" + string(time[pos]), 0, time[pos], price_at_bottom, "Pre NY", "Arial", 7, clrnykz, 90));
            }}
        else if (current_hour == NYOpen){
            string NY_name = "NY vLine-" + string(time[pos]);
            if (ObjectFind(0, NY_name) == -1){
                Sett(VLineCreate(0, NY_name, 0, time[pos], clrnykz, 2, 1));
                Sett(Text(0, "NY-" + string(time[pos]), 0, time[pos], price_at_bottom, "NY Open", "Arial", 7, clrnykz, 90));
            }}
        else if (current_hour == londonClose){
            string londonclose_name = "London Close vLine-" + string(time[pos]);
            if (ObjectFind(0, londonclose_name) == -1){
                Sett(VLineCreate(0, londonclose_name, 0, time[pos], clrlondonkz, 2, 1));
                Sett(Text(0, "London Close-" + string(time[pos]), 0, time[pos], price_at_bottom, "London Close", "Arial", 7, clrlondonkz, 90));
            }}
       }  
    
    iterator++;
}

//----
if (!is_valid_timeframe){
    // Remove all objects if the timeframe is not valid
   int ObjectCount = ObjectsTotal();
   for (int i=ObjectCount-1; i>=0; i--){
      if(StringFind(ObjectName(i),iName) != -1){
         ObjectDelete(ObjectName(i));
         }  
      } }
//----
return(rates_total);
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
          const bool              back=true,               // in the background 
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