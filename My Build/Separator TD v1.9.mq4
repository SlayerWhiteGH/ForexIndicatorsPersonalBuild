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

extern bool ShowDailyOpenLevel    = true;             //Daily Open:
extern color coloropenam          = clrYellow;         //Open AM Color:


double TodayOpenBuffer[];
string iName="Separator TD ";
bool is_valid_timeframe = (Period() <= PERIOD_M30) ? true : false;
   

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
//---- indicators
printf("Time Current : " + string(TimeCurrent()));
printf("Time GMT : " + string(TimeGMT()));
printf("Time Local : " + string(TimeLocal()));

// SetIndexStyle(0, DRAW_LINE);
SetIndexBuffer(0, TodayOpenBuffer);
// SetIndexLabel(0, "Open");
// SetIndexEmptyValue(0, 0.0);
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
   datetime currentTime = TimeCurrent() - (24*60*60);
   datetime lookbackTime = currentTime - (lookback*7*24*60*60);
    int tzdiffsec = (HourTime*3600) + (MinuteTime*60);
    double barsper30 = 1.0*PERIOD_M30/Period();
    int pos = MathMin(Bars-20*barsper30-1, limit);

   for (int i = 0; i < pos; i++){
    if (time[i] < lookbackTime) continue;
    int current_hour = TimeHour(time[i]);
    int current_minute = TimeMinute(time[i]);

    if (current_minute == 0 && current_hour >= HourTime && time[i] >= lookbackTime && time[i] <= currentTime){
        if (current_hour == HourTime){
            string separator_name = "Separator-" + string(time[i]);
            if (ObjectFind(0, separator_name) == -1){
                Sett(VLineCreate(0, separator_name, 0, time[i], Line_Color, linestyle));
                string day_str = stDy[TimeDayOfWeek(time[i]) == 0 ? 6 : TimeDayOfWeek(time[i]) - 1];
                Sett(Text(0, "DayName-" + string(time[i]), 0, time[i], price_at_bottom, day_str, "Arial", 8, clrBlack, 90));
            }
            if (ShowDailyOpenLevel) {
                string line_name = "Open AM-" + string(TimeDayOfWeek(time[i]));
                TodayOpenBuffer[i] = Open[i];
                Sett(TrendCreate(0, line_name, 0, time[i], TodayOpenBuffer[i], time[i-1], TodayOpenBuffer[i-1], coloropenam, STYLE_SOLID, 1, false, true, false, false, 0));
                Sett(Text(0, line_name, 0, time[i], TodayOpenBuffer[i], "Open AM", "Arial", 8, coloropenam, 0.0, ANCHOR_LEFT_UPPER, true, false, false, 0));

                printf("i : " + string(TodayOpenBuffer[i]));
                printf("i - 1 :" + string(TodayOpenBuffer[i]));
                printf("------------");
            }
        }
        else if (current_hour == londonOpen){
            string london_name = "London vLine-" + string(time[i]);
            if (ObjectFind(0, london_name) == -1){
                Sett(VLineCreate(0, london_name, 0, time[i], clrlondonkz, 2, 1));
                Sett(Text(0, "London-" + string(time[i]), 0, time[i], price_at_bottom, "London Open", "Arial", 7, clrlondonkz, 90));
            }
            TodayOpenBuffer[i] = TodayOpenBuffer[i-1];
        }
        else if (current_hour == preNYOpen){
            string preNY_name = "preNYOpen vLine-" + string(time[i]);
            if (ObjectFind(0, preNY_name) == -1){
                Sett(VLineCreate(0, preNY_name, 0, time[i], clrnykz, 2, 1));
                Sett(Text(0, "Pre NY-" + string(time[i]), 0, time[i], price_at_bottom, "Pre NY", "Arial", 7, clrnykz, 90));
            }
            TodayOpenBuffer[i] = TodayOpenBuffer[i-1];
        }
        else if (current_hour == NYOpen){
            string NY_name = "NY vLine-" + string(time[i]);
            if (ObjectFind(0, NY_name) == -1){
                Sett(VLineCreate(0, NY_name, 0, time[i], clrnykz, 2, 1));
                Sett(Text(0, "NY-" + string(time[i]), 0, time[i], price_at_bottom, "NY Open", "Arial", 7, clrnykz, 90));
            }
            TodayOpenBuffer[i] = TodayOpenBuffer[i-1];
        }
        else if (current_hour == londonClose){
            string londonclose_name = "London Close vLine-" + string(time[i]);
            if (ObjectFind(0, londonclose_name) == -1){
                Sett(VLineCreate(0, londonclose_name, 0, time[i], clrlondonkz, 2, 1));
                Sett(Text(0, "London Close-" + string(time[i]), 0, time[i], price_at_bottom, "London Close", "Arial", 7, clrlondonkz, 90));
            }
            TodayOpenBuffer[i] = TodayOpenBuffer[i-1];
        }
        else {
            TodayOpenBuffer[i] = TodayOpenBuffer[i-1];
        }
       }
     else if (time[i] >= lookbackTime && day_changed(current_hour, current_minute) == true) {
         
         datetime separator_time = D'05:00:00';
         datetime london_open = D'07:00:00';
         datetime pre_ny_open = D'10:00:00';
         datetime ny_open = D'12:00:00';
         datetime eight_am = D'13:30:00';
         datetime london_close = D'15:00:00';
     
         string separator_name = "Separator-" + "Next Day";
         if (ObjectFind(0, separator_name) == -1){
             Sett(VLineCreate(0, separator_name, 0, separator_time, Line_Color, linestyle));
             string day_str = stDy[TimeDayOfWeek(time[i]) == 0 ? 6 : TimeDayOfWeek(time[i]) - 1];
             Sett(Text(0, "DayName-" + string(separator_time), 0, separator_time, price_at_bottom, day_str, "Arial", 8, clrBlack, 90));
         }
         string london_name = "London vLine-" + "London Open Next Day";
         if (ObjectFind(0, london_name) == -1){
             Sett(VLineCreate(0, london_name, 0, london_open, clrlondonkz, 2, 1));
             Sett(Text(0, "London-" + string(london_open), 0, london_open, price_at_bottom, "London Open", "Arial", 7, clrlondonkz, 90));
         }
         string preNY_name = "preNYOpen vLine-" + "Pre NY Next Day";
         if (ObjectFind(0, preNY_name) == -1){
             Sett(VLineCreate(0, preNY_name, 0, pre_ny_open, clrnykz, 2, 1));
             Sett(Text(0, "Pre NY-" + string(pre_ny_open), 0, pre_ny_open, price_at_bottom, "Pre NY", "Arial", 7, clrnykz, 90));
         }
         string NY_name = "NY vLine-" + "NY Open Next Day";
         if (ObjectFind(0, NY_name) == -1){
             Sett(VLineCreate(0, NY_name, 0, ny_open, clrnykz, 2, 1));
             Sett(Text(0, "NY-" + string(ny_open), 0, ny_open, price_at_bottom, "NY Open", "Arial", 7, clrnykz, 90));
         }
         string eight_am_name = "NY vLine-" + "8.30 Next Day";
         if (ObjectFind(0, eight_am_name) == -1){
             Sett(VLineCreate(0, eight_am_name, 0, eight_am, clrnykz, 2, 1));
             Sett(Text(0, "8.30 AM-" + string(eight_am), 0, eight_am, price_at_bottom, "8.30 AM", "Arial", 7, clrnykz, 90));
         }
         string londonclose_name = "London Close vLine-" + "London Close Next Day";
         if (ObjectFind(0, londonclose_name) == -1){
             Sett(VLineCreate(0, londonclose_name, 0, london_close, clrlondonkz, 2, 1));
             Sett(Text(0, "London Close-" + string(london_close), 0, london_close, price_at_bottom, "London Close", "Arial", 7, clrlondonkz, 90));
         }
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

bool day_changed(int current_hour, int current_minute) {
   return current_hour == 0 && current_minute == 0;
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