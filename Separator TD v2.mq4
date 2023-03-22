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
#property indicator_buffers 3

extern bool ShowAll               = true;
extern bool ShowLondonNewYork     = true;
extern int HourTime               = 5;                 //Hour Number:
extern int MinuteTime             = 0;                 //Minute Number:
extern color Line_Color           = clrYellow;          //VLine Color:
extern ENUM_LINE_STYLE linestyle  = STYLE_DOT;         //VLine Style:

extern color clrlondonkz          = clrMediumSeaGreen; //LoKZ Color:
extern color clrnykz              = clrMaroon;         //NYKZ Color:

double trendBuffer[], tmpTrendValue;
double londonBuffer[], tmpLondonValue;
double nyBuffer[], tmpNyValue;

string stDy[] = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"};
string iName = "Separator TD ";

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
//---- indicators
    if (ObjectFind(0, getLineSeparator(getSeparatorTime())) == -1){
        Sett(VLineCreate(0, getLineSeparator(getSeparatorTime()), 0, getSeparatorTime(), Line_Color, linestyle));
        Sett(Text(0, getTextSeparator(getSeparatorTime()), 0, getSeparatorTime(), getLowestYPos(), getDayName(getSeparatorTime()), "Arial", 8, Line_Color, 90));
    }
    if (ObjectFind(0, getLineLondonOpen(getLondonOpenTime())) == -1){
        Sett(VLineCreate(0, getLineLondonOpen(getLondonOpenTime()), 0, getLondonOpenTime(), clrlondonkz, 2, 1));
        Sett(Text(0, getTextLondonOpen(getLondonOpenTime()), 0, getLondonOpenTime(), getLowestYPos(), "London Open", "Arial", 7, clrlondonkz, 90));
    }
    if (ObjectFind(0, getLinePreNYOpen(getPreNYOpenTime())) == -1){
        Sett(VLineCreate(0, getLinePreNYOpen(getPreNYOpenTime()), 0, getPreNYOpenTime(), clrnykz, 2, 1));
        Sett(Text(0, getTextPreNYOpen(getPreNYOpenTime()), 0, getPreNYOpenTime(), getLowestYPos(), "Pre NY", "Arial", 7, clrnykz, 90));
    }
    if (ObjectFind(0, getLineNYOpen(getNYOpenTime())) == -1){
        Sett(VLineCreate(0, getLineNYOpen(getNYOpenTime()), 0, getNYOpenTime(), clrnykz, 2, 1));
        Sett(Text(0, getTextNYOpen(getNYOpenTime()), 0, getNYOpenTime(), getLowestYPos(), "NY Open", "Arial", 7, clrnykz, 90));
    }
    if (ObjectFind(0, getLine8AM(get830Time())) == -1){
        Sett(VLineCreate(0, getLine8AM(get830Time()), 0,get830Time(), clrnykz, 2, 1));
        Sett(Text(0, getText8AM(get830Time()), 0, get830Time(), getLowestYPos(), "8.30 AM", "Arial", 7, clrnykz, 90));
    }
    if (ObjectFind(0, getLineLondonClose(getLondonCloseTime())) == -1){
        Sett(VLineCreate(0, getLineLondonClose(getLondonCloseTime()), 0, getLondonCloseTime(), clrlondonkz, 2, 1));
        Sett(Text(0, getTextLondonClose(getLondonCloseTime()), 0, getLondonCloseTime(), getLowestYPos(), "London Close", "Arial", 7, clrlondonkz, 90));
    }
    if (ObjectFind(0, getLineNYLaunch(getNYLaunchTime())) == -1){
        Sett(VLineCreate(0, getLineNYLaunch(getNYLaunchTime()), 0, getNYLaunchTime(), clrnykz, 2, 1));
        Sett(Text(0, getTextNYLaunch(getNYLaunchTime()), 0, getNYLaunchTime(), getLowestYPos(), "London Close", "Arial", 7, clrnykz, 90));
    }

    SetIndexBuffer(0, trendBuffer);
    SetIndexStyle(0, DRAW_LINE, 0, 1, Line_Color);
    SetIndexEmptyValue(0, 0.0);
    
    SetIndexBuffer(1, londonBuffer);
    SetIndexStyle(1, DRAW_LINE, 0, 1, clrlondonkz);
    SetIndexEmptyValue(1, 0.0);
    
    SetIndexBuffer(2, nyBuffer);
    SetIndexStyle(2, DRAW_LINE, 0, 1, clrnykz);
    SetIndexEmptyValue(2, 0.0);
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
//+------

//+------
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
    for (int i = 0; i < rates_total; i++){
        if (ShowAll && isValidTimeframe()) {
            // Before Today
            if (beforeToday(time[i])) {
                if (TimeHour(time[i]) == HourTime){
                    if (ObjectFind(0, getLineSeparator(time[i])) == -1){
                        Sett(VLineCreate(0, getLineSeparator(time[i]), 0, time[i], Line_Color, linestyle));
                    }
                    if (ObjectFind(0, getTextSeparator(time[i])) == -1) {
                        Sett(Text(0, getTextSeparator(time[i]), 0, time[i], getLowestYPos(), getDayName(time[i]), "Arial", 8, Line_Color, 90));
                    }
                }
                else if (TimeHour(time[i]) == TimeHour(getLondonOpenTime())){
                    if (ObjectFind(0, getLineLondonOpen(time[i])) == -1){
                        Sett(VLineCreate(0, getLineLondonOpen(time[i]), 0, time[i], clrlondonkz, 2, 1));
                    }
                    if (ObjectFind(0, getTextLondonOpen(time[i])) == -1) {
                        Sett(Text(0, getTextLondonOpen(time[i]), 0, time[i], getLowestYPos(), "London Open", "Arial", 7, clrlondonkz, 90));
                    } 
                }
                else if (TimeHour(time[i]) == TimeHour(getPreNYOpenTime())){
                    if (ObjectFind(0, getLinePreNYOpen(time[i])) == -1){
                        Sett(VLineCreate(0, getLinePreNYOpen(time[i]) + "a", 0, time[i], clrnykz, 2, 1));
                    }
                    if (ObjectFind(0, getTextPreNYOpen(time[i])) == -1) {
                        Sett(Text(0, getTextPreNYOpen(time[i]), 0, time[i], getLowestYPos(), "Pre NY", "Arial", 7, clrnykz, 90));
                    }
                }
                else if (TimeHour(time[i]) == TimeHour(getNYOpenTime())){
                    if (ObjectFind(0, getLineNYOpen(time[i])) == -1){
                        Sett(VLineCreate(0, getLineNYOpen(time[i]) + "a", 0, time[i], clrnykz, 2, 1));
                    }
                    if (ObjectFind(0, getTextNYOpen(time[i])) == -1) {
                        Sett(Text(0, getTextNYOpen(time[i]), 0, time[i], getLowestYPos(), "NY Open", "Arial", 7, clrnykz, 90));
                    }
                }
                else if (TimeHour(time[i]) == TimeHour(getLondonCloseTime())){
                    if (ObjectFind(0, getLineLondonClose(time[i])) == -1){
                        Sett(VLineCreate(0, getLineLondonClose(time[i]) + "a", 0, time[i], clrlondonkz, 2, 1));
                    }
                    if (ObjectFind(0, getTextLondonClose(time[i])) == -1) {
                        Sett(Text(0, getTextLondonClose(time[i]), 0, time[i], getLowestYPos(), "London Close", "Arial", 7, clrlondonkz, 90));
                    }
                }
                else if (TimeHour(time[i]) == TimeHour(getNYLaunchTime())){
                    if (ObjectFind(0, getLineNYLaunch(time[i])) == -1){
                        Sett(VLineCreate(0, getLineNYLaunch(time[i]) + "a", 0, time[i], clrnykz, 2, 1));
                    }
                    if (ObjectFind(0, getTextNYLaunch(time[i])) == -1) {
                        Sett(Text(0, getTextNYLaunch(time[i]), 0, time[i], getLowestYPos(), "NY Launch", "Arial", 7, clrnykz, 90));
                    }
                }
            }
            else if (afterToday(time[i])) {
                if (time[i] == getSeparatorTime()) {
                    if (tmpTrendValue == NULL) {
                        tmpTrendValue = open[i];
                    }
                    trendBuffer[i] = tmpTrendValue;
                }
                else if (time[i] >= getSeparatorTime()) {
                    trendBuffer[i] = tmpTrendValue;

                    Sett(Text(0, getTextTrend(), 0, time[i], tmpTrendValue, "MOP", "Arial Bold", 8, Line_Color));
                }
                if (ShowLondonNewYork) {
                    if (time[i] == getLondonOpenTime()) {
                        if (tmpLondonValue == NULL) {
                            tmpLondonValue = open[i];
                        }
                        londonBuffer[i] = tmpLondonValue;
                    }
                    else if (time[i] >= getLondonOpenTime() && time[i] <= getLondonCloseTime()) {
                        londonBuffer[i] = tmpLondonValue;
                    }
                    if (time[i] == getNYOpenTime()) {
                        if (tmpNyValue == NULL) {
                            tmpNyValue = open[i];
                        }
                        nyBuffer[i] = tmpNyValue;
                    }
                    else if(time[i] >= getNYOpenTime() && time[i] <= getNYLaunchTime()) {
                        nyBuffer[i] = tmpNyValue;
                    }
                }
            }
        }     
    }

    if (!isValidTimeframe()){
        // Remove all objects if the timeframe is not valid
        objDelete();
    }
    
    return(rates_total);
}
//+--------------------
bool beforeToday(datetime waktu) {
    return TimeMinute(waktu) == 0 && TimeHour(waktu) >= HourTime && waktu <= getCurrentTime();
}
bool afterToday(datetime waktu) {
   return waktu > getCurrentTime();
}
string getLineSeparator(datetime waktu) {
     return "VLine Separator-" + string(waktu);
}
string getLineLondonOpen(datetime waktu) {
     return "VLine London Open-" + string(waktu);
}
string getLinePreNYOpen(datetime waktu) {
     return "VLine Pre NY Open-" + string(waktu);
}
string getLineNYOpen(datetime waktu) {
     return "VLine NY Open-" + string(waktu);
}
string getLine8AM(datetime waktu) {
     return "VLine 8.30 AM-" + string(waktu);
}
string getLineLondonClose(datetime waktu) {
     return "VLine London Close-" + string(waktu);
}
string getLineNYLaunch(datetime waktu) {
    return "VLine NY Launch-" + string(waktu);
}
string getTextSeparator(datetime waktu) {
     return "Text Separator-" + string(waktu);
}
string getTextLondonOpen(datetime waktu) {
     return "Text London Open-" + string(waktu);
}
string getTextPreNYOpen(datetime waktu) {
     return "Text Pre NY Open-" + string(waktu);
}
string getTextNYOpen(datetime waktu) {
     return "Text NY Open-" + string(waktu);
}
string getText8AM(datetime waktu) {
     return "Text 8.30 AM-" + string(waktu);
}
string getTextLondonClose(datetime waktu) {
     return "Text London Close-" + string(waktu);
}
string getTextNYLaunch(datetime waktu) {
    return "Text NY Launch-" + string(waktu);
}
string getTextTrend() {
    return "Text Trend Separator";
}
datetime getSeparatorTime() {
    return StrToTime(string(TimeYear(TimeCurrent())) + "." + string(TimeMonth(TimeCurrent())) + "." + string(TimeDay(TimeCurrent())) + " 0" + string(HourTime) + ":00:00");
}
datetime getLondonOpenTime() {
    return StrToTime(string(TimeYear(TimeCurrent())) + "." + string(TimeMonth(TimeCurrent())) + "." + string(TimeDay(TimeCurrent())) + " 0" + string(HourTime + 2) + ":00:00");
}
datetime getPreNYOpenTime() {
    return StrToTime(string(TimeYear(TimeCurrent())) + "." + string(TimeMonth(TimeCurrent())) + "." + string(TimeDay(TimeCurrent())) + " 0" + string(HourTime + 5) + ":00:00");
}
datetime getNYOpenTime() {
    return StrToTime(string(TimeYear(TimeCurrent())) + "." + string(TimeMonth(TimeCurrent())) + "." + string(TimeDay(TimeCurrent())) + " 0" + string(HourTime + 7) + ":00:00");
}
datetime get830Time() {
    return StrToTime(string(TimeYear(TimeCurrent())) + "." + string(TimeMonth(TimeCurrent())) + "." + string(TimeDay(TimeCurrent())) + " 0" + string(HourTime + 8) + ":30:00");
}
datetime getLondonCloseTime() {
    return StrToTime(string(TimeYear(TimeCurrent())) + "." + string(TimeMonth(TimeCurrent())) + "." + string(TimeDay(TimeCurrent())) + " 0" + string(HourTime + 10) + ":00:00");
}
datetime getNYLaunchTime() {    
    return StrToTime(string(TimeYear(TimeCurrent())) + "." + string(TimeMonth(TimeCurrent())) + "." + string(TimeDay(TimeCurrent())) + " 0" + string(HourTime + 12) + ":00:00");
}
string getDayName(datetime waktu) {
    return stDy[TimeDayOfWeek(waktu) == 0 ? 6 : TimeDayOfWeek(waktu) - 1];
}
bool isValidTimeframe() {
    return Period() <= PERIOD_M30;
}
datetime getCurrentTime() {
    return TimeLocal() - (24*60*60); 
}
//double getLowestYPos() {
//    return Low[iLowest(Symbol(), PERIOD_CURRENT, MODE_LOW, WindowFirstVisibleBar())];
//}
int chart_height() {
    return ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS);
}
double chart_price_range() {
    return ChartGetDouble(0, CHART_PRICE_MAX) - ChartGetDouble(0, CHART_PRICE_MIN);
}
double price_per_pixel() {
    return (chart_price_range() / chart_height() );
}
double y_pos(){
    return ChartGetInteger(0, chart_price_range()  - 1);
}
double getLowestYPos() {
    return ChartGetDouble(0, CHART_PRICE_MIN) + y_pos() * price_per_pixel();
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
          const bool              hidden=true,              // hidden in the object list 
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
                 const bool            hidden=true,       // hidden in the object list 
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