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
#property indicator_buffers 4

input string TimeInput               = "Time Input";
input int HourTime               = 5;                   // Hour Number   
input int MinuteTime             = 0;                   // Minute Number 
input int fontSize               = 7;                   // Text Font Size

input string Options               = "Options";
input int lookback               = 30;                  // Amount of Days To Lookback
input bool ShowAll               = FALSE;               // Show All Day (Kill Zone)
input bool ShowAll2Hr            = FALSE;               // Show 2 Hours Cycle
input bool ShowKillZone          = FALSE;               // Show Today KillZone
input bool Show2Hr               = TRUE;                // Show Today 2 Hours Cycle  
input bool ShowLondonNewYork     = TRUE;                // Show London & NY Opening Price

input string Colors               = "Colors";
input ENUM_LINE_STYLE lineStyle  = STYLE_DOT;           // VLine Style   
input color clrSeparator         = clrWhite;            // VLine Color   
input color clr90min             = clrBlack;            // 90 Min Cycle Color
input color clr2Hr               = clrBlack;            // 2 Hours Cycle Color     
input color clrAsia              = clrLightSalmon;      // Asia Color    
input color clrLondonKz          = clrBlue;             // London Color  
input color clrNyKz              = clrMaroon;           // New York Color

double trendBuffer[], tmpTrendValue;
double londonBuffer[], tmpLondonValue;
double nyBuffer[], tmpNyValue;
double asiaBuffer[], tmpAsiaValue;
double textAngle = 90;

string stDy[]   = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"};
string asiaOpen = "Asia Open";
string mop = "MOP";
string london[] = {"2 AM - London", "5 AM - London", "London Close", "13.00 PM"};
string newYork[] = {"7 AM - NY Open", "8.30 AM", "10 AM - NY"};
string ninetyMinutesCycle[] = {"3.30 AM", "8.30 AM", "11.30 AM"};
string twoHoursCycle[] = {"2 AM", "4 AM", "6 AM", "8 AM", "10 AM", "12 AM"};

string iName    = "KZ&Cycle";
string objName;

int startIndex;
int stopIndex;
int oneDay = 24 * 60 * 60;

datetime dt;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
    SetIndexBuffer(0, trendBuffer);
    SetIndexStyle(0, DRAW_LINE, 0, 1, clrSeparator);
    SetIndexEmptyValue(0, 0.0);
    
    SetIndexBuffer(1, londonBuffer);
    SetIndexStyle(1, DRAW_LINE, 0, 1, clrLondonKz);
    SetIndexEmptyValue(1, 0.0);
    
    SetIndexBuffer(2, nyBuffer);
    SetIndexStyle(2, DRAW_LINE, 0, 1, clrNyKz);
    SetIndexEmptyValue(2, 0.0);

    SetIndexBuffer(3, asiaBuffer);
    SetIndexStyle(3, DRAW_LINE, 0, 1, clrAsia);
    SetIndexEmptyValue(3, 0.0);


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
void objDelete(){
   for (int i = ObjectsTotal(); i >= 0; i--){
        if (StringFind(ObjectName(i), iName, 0) >= 0) {
            ObjectDelete(ObjectName(i));
        }
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
    if (isValidTimeframe()) {
        double lowestYPos = getLowestYPos();

        // Today VLine Separator
        objName = "VL " + getDayName(getCurrentTime());
        if (!findObject(objName)) {
            Sett(VLineCreate(objName, getDateTimeSeparator(), clrSeparator, lineStyle));
        }
        // Today VLine Text Separator
        objName = "VLT " + getDayName(getCurrentTime());
        if (!findObject(objName)) {
            Sett(Text(objName, getDateTimeSeparator(), lowestYPos, getDayName(getCurrentTime()), fontSize, clrSeparator, textAngle));
        }

        // Today Asia Open
        if (TimeCurrent() >= getDateTimeAsiaOpen()) {
            objName = "TT " + asiaOpen + " " + string(getDateTimeAsiaOpen());
            startIndex = getBarIndex(getDateTimeAsiaOpen());
            stopIndex = getBarIndex(getDateTimeSeparator());
            tmpAsiaValue = open[startIndex];
            if (!findObject(objName)) {
                Sett(Text(objName, getDateTimeAsiaOpen(), tmpAsiaValue, asiaOpen, fontSize, clrAsia));
                for (int i = startIndex; i >= (stopIndex != -1 ? stopIndex : 0); i--) {
                    asiaBuffer[i] = tmpAsiaValue;
                }
            }
        }
        

        // Ini 1 hari MOP
        if (TimeCurrent() >= getDateTimeSeparator()) {
            objName = "TT " + mop + " " + string(getDateTimeSeparator());
            startIndex = getBarIndex(getDateTimeSeparator());
            stopIndex = (getCurrentTime() < getDateTimeSeparator()) ? 0 : getBarIndex(getDateTimeAsiaOpen());
            tmpTrendValue = open[startIndex];
            Sett(Text(objName, getDateTimeSeparator(), tmpTrendValue, mop, fontSize, clrSeparator));
            for (int i = startIndex; i >= stopIndex; i--) {
                trendBuffer[i] = tmpTrendValue;
            }
        }

        // Today Kill Zone
        if (ShowKillZone) {
            // 3.30 AM VLine
            objName = "VL " + ninetyMinutesCycle[0];
            if (!findObject(objName)){
                Sett(VLineCreate(objName, getDateTime330AM(), clr90min, 2, 1));
            }
            // 3.30 AM Text
            objName = "VLT " + ninetyMinutesCycle[0];
            if (!findObject(objName)) {
                Sett(Text(objName, getDateTime330AM(), lowestYPos, ninetyMinutesCycle[0], 7, clr90min, textAngle));
            }

            // 8.30 AM VLine
            objName = "VL " + ninetyMinutesCycle[1];
            if (!findObject(objName)){
                Sett(VLineCreate(objName, getDateTime830AM(), clr90min, 2, 1));
            }
            // 8.30 AM Text
            objName = "VLT " + ninetyMinutesCycle[1];
            if (!findObject(objName)) {
                Sett(Text(objName, getDateTime830AM(), lowestYPos, ninetyMinutesCycle[1], 7, clr90min, textAngle));
            }

            // 11.30 AM VLine
            objName = "VL " + ninetyMinutesCycle[2];
            if (!findObject(objName)){
                Sett(VLineCreate(objName, getDateTime1130AM(), clr90min, 2, 1));
            }
            // 11.30 AM Text
            objName = "VLT " + ninetyMinutesCycle[2];
            if (!findObject(objName)) {
                Sett(Text(objName, getDateTime1130AM(), lowestYPos, ninetyMinutesCycle[2], 7, clr90min, textAngle));
            }

            // London Session 1 Start VLine
            objName = "VL " + london[0];
            if (!findObject(objName)){
                Sett(VLineCreate(objName, getDateTimeLondonSession1Start(), clrLondonKz, 2, 1));
            }
            // London Session 1 Start Text
            objName = "VLT " + london[0];
            if (!findObject(objName)) {
                Sett(Text(objName, getDateTimeLondonSession1Start(), lowestYPos, london[0], fontSize, clrLondonKz, textAngle));
            }
            
            // London Session 1 Stop Vline
            objName = "VL " + london[1];
            if (!findObject(objName)) {
                Sett(VLineCreate(objName, getDateTimeLondonSession1Stop(), clrLondonKz, 2, 1));
            }
            // London Session 1 Stop Text
            objName = "VLT " + london[1];
            if (!findObject(objName)) {
                Sett(Text(objName, getDateTimeLondonSession1Stop(), lowestYPos, london[1], fontSize, clrLondonKz, textAngle));
            }

            // NewYork Start VLine
            objName = "VL " + newYork[0];
            if (!findObject(objName)) {
                Sett(VLineCreate(objName, getDateTimeNewYorkStart(), clrNyKz, 2, 1));
            }
            // NewYork Start Text
            objName = "VLT " + newYork[0];
            if (!findObject(objName)) {
                Sett(Text(objName, getDateTimeNewYorkStart(), lowestYPos, newYork[0], fontSize, clrNyKz, textAngle));
            }

            // NewYork Stop / London Sessian 2 Start Vline
            objName = "VL " + newYork[2];
            if (!findObject(objName)) {
                Sett(VLineCreate(objName, getDateTimeNewYorkStop(), clrNyKz, 2, 1));
            }
            // NewYork Stop / London Sessian 2 Start Text
            objName = "VLT " + newYork[2];
            if (!findObject(objName)) {
                Sett(Text(objName, getDateTimeNewYorkStop(), lowestYPos, newYork[2] + " / " + london[2], fontSize, clrNyKz, textAngle));
            }

            // London Session 2 Stop Vline
            objName = "VL " + london[3];
            if (!findObject(objName)) {
                Sett(VLineCreate(objName, getDateTimeLondonSession2Stop(), clrLondonKz, 2, 1));
            }
            // London Session 2 Stop Text
            objName = "VLT " + london[3];
            if (!findObject(objName)) {
                Sett(Text(objName, getDateTimeLondonSession2Stop(), lowestYPos, london[3], fontSize, clrLondonKz, textAngle));
            }

        }

        // Today 2 Hours Cycle
        if (Show2Hr) {

            // 2 AM VLine
            objName = "VL " + twoHoursCycle[0];
            if (!findObject(objName)){
                Sett(VLineCreate(objName, getDateTime2AM(), clr2Hr, 2, 1));
            }
            // 2 AM Text
            objName = "VLT " + twoHoursCycle[0];
            if (!findObject(objName)) {
                Sett(Text(objName, getDateTime2AM(), lowestYPos, twoHoursCycle[0], 7, clr2Hr, textAngle));
            }

            // 4 AM VLine
            objName = "VL " + twoHoursCycle[1];
            if (!findObject(objName)){
                Sett(VLineCreate(objName, getDateTime4AM(), clr2Hr, 2, 1));
            }
            // 4 AM Text
            objName = "VLT " + twoHoursCycle[1];
            if (!findObject(objName)) {
                Sett(Text(objName, getDateTime4AM(), lowestYPos, twoHoursCycle[1], 7, clr2Hr, textAngle));
            }

            // 6 AM VLine
            objName = "VL " + twoHoursCycle[2];
            if (!findObject(objName)){
                Sett(VLineCreate(objName, getDateTime6AM(), clr2Hr, 2, 1));
            }
            // 6 AM Text
            objName = "VLT " + twoHoursCycle[2];
            if (!findObject(objName)) {
                Sett(Text(objName, getDateTime6AM(), lowestYPos, twoHoursCycle[2], 7, clr2Hr, textAngle));
            }

            // 8 AM VLine
            objName = "VL " + twoHoursCycle[3];
            if (!findObject(objName)){
                Sett(VLineCreate(objName, getDateTime8AM(), clr2Hr, 2, 1));
            }
            // 8 AM Text
            objName = "VLT " + twoHoursCycle[3];
            if (!findObject(objName)) {
                Sett(Text(objName, getDateTime8AM(), lowestYPos, twoHoursCycle[3], 7, clr2Hr, textAngle));
            }

            // 10 AM VLine
            objName = "VL " + twoHoursCycle[4];
            if (!findObject(objName)){
                Sett(VLineCreate(objName, getDateTime10AM(), clr2Hr, 2, 1));
            }
            // 10 AM Text
            objName = "VLT " + twoHoursCycle[4];
            if (!findObject(objName)) {
                Sett(Text(objName, getDateTime10AM(), lowestYPos, twoHoursCycle[4], 7, clr2Hr, textAngle));
            }

            // 12 AM VLine
            objName = "VL " + twoHoursCycle[5];
            if (!findObject(objName)){
                Sett(VLineCreate(objName, getDateTime12AM(), clr2Hr, 2, 1));
            }
            // 12 AM Text
            objName = "VLT " + twoHoursCycle[5];
            if (!findObject(objName)) {
                Sett(Text(objName, getDateTime12AM(), lowestYPos, twoHoursCycle[5], 7, clr2Hr, textAngle));
            }

        }

        // Today London and New York Trendlines
        if (ShowLondonNewYork) {
            // Ini 1 hari London (hari ini)
            if (TimeCurrent() >= getDateTime2AM()) {
                objName = "TT " + ((Show2Hr == true)?twoHoursCycle[0]:london[0]) + " " + string(getDateTime2AM());
                startIndex = getBarIndex(getDateTime2AM());
                stopIndex = getBarIndex((Show2Hr == true)?getDateTime12AM():getDateTimeLondonSession1Stop());
                tmpLondonValue = open[startIndex];
                if (!findObject(objName)) {
                    Sett(Text(objName, getDateTime2AM(), tmpLondonValue, ((Show2Hr == true)?twoHoursCycle[0]:london[0]), fontSize, clrLondonKz, 0, "Arial"));
                }
                for (int i = startIndex; i >= (stopIndex != -1 ? stopIndex : 0); i--) {
                    londonBuffer[i] = tmpLondonValue;
                }
            }
        

            // Ini 1 hari New York (hari ini)
            if (TimeCurrent() >= getDateTimeNewYorkStart()) {
                objName = "TT " + newYork[0] + " " + string(getDateTimeNewYorkStart());
                startIndex = getBarIndex(getDateTimeNewYorkStart());
                stopIndex = getBarIndex(getDateTimeNewYorkStop());
                tmpNyValue = open[startIndex];
                if (!findObject(objName)) {
                    Sett(Text(objName, getDateTimeNewYorkStart(), tmpNyValue, newYork[0], fontSize, clrNyKz, 0, "Arial"));
                }
                for (int i = startIndex; i >= (stopIndex != -1 ? stopIndex : 0); i--) {
                    nyBuffer[i] = tmpNyValue;
                }
            }
        }

        if (ShowAll || ShowAll2Hr) {
            datetime dtStop;
            for (int i = 1; i <= lookback; i++) {

                // VLine Separator
                dt = getDateTimeSeparator() - (oneDay * i);
                if (!currentTimeIsWeekend(dt)) {
                    // Separator VLine
                    objName = "VL " + getDayName(dt) + " " + string(dt);
                    if (!findObject(objName)) {
                        Sett(VLineCreate(objName, dt, clrSeparator, 2, 1));
                    }
                    // Separator VLine Text
                    objName = "VLT " + getDayName(dt) + " " + string(dt);
                    if (!findObject(objName)) {
                        Sett(Text(objName, dt, lowestYPos, getDayName(dt), fontSize, clrSeparator, textAngle));
                    }
                }

                // Trendline Text Asia Open
                dt = getDateTimeAsiaOpen() - (oneDay * i);
                dtStop = getDateTimeSeparator() - (oneDay * i);
                if (!currentTimeIsWeekend(dt)) {
                    startIndex = getBarIndex(dt);
                    stopIndex = getBarIndex(dtStop);
                    //tmpAsiaValue = open[startIndex];

                    if (startIndex >= 0 && stopIndex >= 0 && startIndex < ArraySize(asiaBuffer) && stopIndex < ArraySize(asiaBuffer)) {
                        tmpAsiaValue = open[startIndex];

                        objName = "TT " + asiaOpen + " " + string(dt);
                        if (!findObject(objName)) {
                            Sett(Text(objName, dt, tmpAsiaValue, asiaOpen, fontSize, clrAsia));        
                        }

                        for (int j = startIndex; j >= stopIndex; j--) {
                            asiaBuffer[j] = tmpAsiaValue;
                            if (j == stopIndex) {
                                asiaBuffer[j-1] = 0;
                            }
                        }
                    }
                }

                // Trendline Text Separator/MOP
                dt = getDateTimeSeparator() - (oneDay * i);
                dtStop = getDateTimeAsiaOpen() - (oneDay * i) + oneDay;
                if (!currentTimeIsWeekend(dt)) {
                    startIndex = getBarIndex(dt);
                    stopIndex = getBarIndex(dtStop);
                    //tmpTrendValue = open[startIndex];

                    if (startIndex >= 0 && stopIndex >= 0 && startIndex < ArraySize(trendBuffer) && stopIndex < ArraySize(trendBuffer)) {
                        tmpTrendValue = open[startIndex];
                    
                        objName = "TT " + mop + " " + string(dt);
                        if (!findObject(objName)) {
                            Sett(Text(objName, dt, tmpTrendValue, mop, fontSize, clrSeparator));
                        }
                        
                        for (int j = startIndex; j >= stopIndex; j--) {
                            trendBuffer[j] = tmpTrendValue;
                            if (j == stopIndex) {
                                trendBuffer[j-1] = 0;
                            }
                        }
                    }
                }

                // London Buffer
                dt = getDateTimeLondonSession1Start() - (oneDay * i);
                dtStop = (Show2Hr == true?getDateTime12AM():getDateTimeLondonSession1Stop()) - (oneDay * i);
                if (!currentTimeIsWeekend(dt)) {
                    startIndex = getBarIndex(dt);
                    stopIndex = getBarIndex(dtStop);
                    //tmpLondonValue = open[startIndex];

                    if (startIndex >= 0 && stopIndex >= 0 && startIndex < ArraySize(londonBuffer) && stopIndex < ArraySize(londonBuffer)) {
                    tmpLondonValue = open[startIndex];

                        objName = "TT " + london[0] + " " + string(dt);
                        if (!findObject(objName)) {
                            Sett(Text(objName, dt, tmpLondonValue, london[0], fontSize, clrLondonKz));        
                        }

                        for (int j = startIndex; j >= stopIndex; j--) {
                            londonBuffer[j] = tmpLondonValue;
                        }
                    }
                }


                // New York Buffer
                dt = getDateTimeNewYorkStart() - (oneDay * i);
                dtStop = getDateTimeNewYorkStop() - (oneDay * i);
                if (!currentTimeIsWeekend(dt)) {
                    startIndex = getBarIndex(dt);
                    stopIndex = getBarIndex(dtStop);
                    //tmpNyValue = open[startIndex];

                    if (startIndex >= 0 && stopIndex >= 0 && startIndex < ArraySize(nyBuffer) && stopIndex < ArraySize(nyBuffer)) {
                    tmpNyValue = open[startIndex];

                        objName = "TT " + newYork[0] + " " + string(dt);
                        if (!findObject(objName)) {
                            Sett(Text(objName, dt, tmpNyValue, newYork[0], fontSize, clrNyKz));        
                        }

                        for (int j = startIndex; j >= stopIndex; j--) {
                            nyBuffer[j] = tmpNyValue;
                        }
                    }    
                }

            }
        }

        if (ShowAll) {
            for (int i = 1; i <= lookback; i++) {
                // Datetime 3.30 AM
                dt = getDateTime330AM() - (oneDay * i);
                if (!currentTimeIsWeekend(dt)) {
                    // 3.30 AM VLine
                    objName = "VL " + ninetyMinutesCycle[0] + " " + string(dt);
                    if (!findObject(objName)){
                        Sett(VLineCreate(objName, dt, clr90min, 2, 1));
                    }
                    // 3.30 AM Text
                    objName = "VLT " + ninetyMinutesCycle[0] + " " + string(dt);
                    if (!findObject(objName)) {
                        Sett(Text(objName, dt, lowestYPos, ninetyMinutesCycle[0], fontSize, clr90min, textAngle));
                    }
                }

                // Datetime 8.30 AM
                dt = getDateTime830AM() - (oneDay * i);
                if (!currentTimeIsWeekend(dt)) {
                    // 8.30 AM VLine
                    objName = "VL " + ninetyMinutesCycle[1] + " " + string(dt);
                    if (!findObject(objName)){
                        Sett(VLineCreate(objName, dt, clr90min, 2, 1));
                    }
                    // 8.30 AM Text
                    objName = "VLT " + ninetyMinutesCycle[1] + " " + string(dt);
                    if (!findObject(objName)) {
                        Sett(Text(objName, dt, lowestYPos, ninetyMinutesCycle[1], fontSize, clr90min, textAngle));
                    }
                }

                // Datetime 11.30 AM
                dt = getDateTime1130AM() - (oneDay * i);
                if (!currentTimeIsWeekend(dt)) {
                    // 11.30 AM VLine
                    objName = "VL " + ninetyMinutesCycle[2] + " " + string(dt);
                    if (!findObject(objName)){
                        Sett(VLineCreate(objName, dt, clr90min, 2, 1));
                    }
                    // 11.30 AM Text
                    objName = "VLT " + ninetyMinutesCycle[2] + " " + string(dt);
                    if (!findObject(objName)) {
                        Sett(Text(objName, dt, lowestYPos, ninetyMinutesCycle[2], fontSize, clr90min, textAngle));
                    }
                }

                // Datetime Separator
                dt = getDateTimeSeparator() - (oneDay * i);
                if (!currentTimeIsWeekend(dt)) {
                    // VLine Separator
                    objName = "VL " + getDayName(dt) + " " + string(dt);
                    if (!findObject(objName)) {
                        Sett(VLineCreate(objName, dt, clrSeparator, lineStyle));
                    }
                    // VLine Text Separator
                    objName = "VLT " + getDayName(dt) + " " + string(dt);
                    if (!findObject(objName)) {
                        Sett(Text(objName, dt, lowestYPos, getDayName(dt), fontSize, clrSeparator, textAngle));
                    }
                }

                // Datetime London Session 1 Start
                dt = getDateTimeLondonSession1Start() - (oneDay * i);
                if (!currentTimeIsWeekend(dt)) {
                    // London Session 1 Start VLine
                    objName = "VL " + london[0] + " " + string(dt);
                    if (!findObject(objName)){
                        Sett(VLineCreate(objName, dt, clrLondonKz, 2, 1));
                    }
                    // London Session 1 Start Text
                    objName = "VLT " + london[0] + " " + string(dt);
                    if (!findObject(objName)) {
                        Sett(Text(objName, dt, lowestYPos, london[0], fontSize, clrLondonKz, textAngle));
                    }
                }

                // Datetime London Session 1 Stop
                dt = getDateTimeLondonSession1Stop() - (oneDay * i);
                if (!currentTimeIsWeekend(dt)) {
                    // London Session 1 Stop Vline
                    objName = "VL " + london[1] + " " + string(dt);
                    if (!findObject(objName)) {
                        Sett(VLineCreate(objName, dt, clrLondonKz, 2, 1));
                    }
                    // London Session 1 Stop Text
                    objName = "VLT " + london[1] + " " + string(dt);
                    if (!findObject(objName)) {
                        Sett(Text(objName, dt, lowestYPos, london[1], fontSize, clrLondonKz, textAngle));
                    }
                }

                // Datetime NewYork Start
                dt = getDateTimeNewYorkStart() - (oneDay * i);
                if (!currentTimeIsWeekend(dt)) {
                    // NewYork Start VLine
                    objName = "VL " + newYork[0] + " " + string(dt);
                    if (!findObject(objName)) {
                        Sett(VLineCreate(objName, dt, clrNyKz, 2, 1));
                    }
                    // NewYork Start Text
                    objName = "VLT " + newYork[0] + " " + string(dt);
                    if (!findObject(objName)) {
                        Sett(Text(objName, dt, lowestYPos, newYork[0], fontSize, clrNyKz, textAngle));
                    }
                }

                // Datetime NewYork Stop / London Session 2 Start
                dt = getDateTimeNewYorkStop() - (oneDay * i);
                if (!currentTimeIsWeekend(dt)) {
                    // NewYork Stop / London Sessian 2 Start Vline
                    objName = "VL " + newYork[2] + " " + string(dt);
                    if (!findObject(objName)) {
                        Sett(VLineCreate(objName, dt, clrNyKz, 2, 1));
                    }
                    // NewYork Stop / London Sessian 2 Start Text
                    objName = "VLT " + newYork[2] + " " + string(dt);
                    if (!findObject(objName)) {
                        Sett(Text(objName, dt, lowestYPos, newYork[2] + " / " + london[2], fontSize, clrNyKz, textAngle));
                    }
                }

                // Datetime London Session 2 Stop
                dt = getDateTimeLondonSession2Stop() - (oneDay * i);
                if (!currentTimeIsWeekend(dt)) {
                    // London Session 2 Stop Vline
                    objName = "VL " + london[3] + " " + string(dt);
                    if (!findObject(objName)) {
                        Sett(VLineCreate(objName, dt, clrLondonKz, 2, 1));
                    }
                    // London Session 2 Stop Text
                    objName = "VLT " + london[3] + " " + string(dt);
                    if (!findObject(objName)) {
                        Sett(Text(objName, dt, lowestYPos, london[3], fontSize, clrLondonKz, textAngle));
                    }
                }

            }
        }
   
        if (ShowAll2Hr) {
            for (int i = 1; i <= lookback; i++) {
                // Datetime 2 AM
                dt = getDateTime2AM() - (oneDay * i);
                if (!currentTimeIsWeekend(dt)) {
                    // 2 AM VLine
                    objName = "VL " + twoHoursCycle[0] + " " + string(dt);
                    if (!findObject(objName)){
                        Sett(VLineCreate(objName, dt, clr2Hr, 2, 1));
                    }
                    // 2 AM Text
                    objName = "VLT " + twoHoursCycle[0] + " " + string(dt);
                    if (!findObject(objName)) {
                        Sett(Text(objName, dt, lowestYPos, twoHoursCycle[0], fontSize, clr2Hr, textAngle));
                    }
                }

                // Datetime 4 AM
                dt = getDateTime4AM() - (oneDay * i);
                if (!currentTimeIsWeekend(dt)) {
                    // 4 AM VLine
                    objName = "VL " + twoHoursCycle[1] + " " + string(dt);
                    if (!findObject(objName)){
                        Sett(VLineCreate(objName, dt, clr2Hr, 2, 1));
                    }
                    // 4 AM Text
                    objName = "VLT " + twoHoursCycle[1] + " " + string(dt);
                    if (!findObject(objName)) {
                        Sett(Text(objName, dt, lowestYPos, twoHoursCycle[1], fontSize, clr2Hr, textAngle));
                    }
                }

                // Datetime 6 AM
                dt = getDateTime6AM() - (oneDay * i);
                if (!currentTimeIsWeekend(dt)) {
                    // 6 AM VLine
                    objName = "VL " + twoHoursCycle[2] + " " + string(dt);
                    if (!findObject(objName)){
                        Sett(VLineCreate(objName, dt, clr2Hr, 2, 1));
                    }
                    // 6 AM Text
                    objName = "VLT " + twoHoursCycle[2] + " " + string(dt);
                    if (!findObject(objName)) {
                        Sett(Text(objName, dt, lowestYPos, twoHoursCycle[2], fontSize, clr2Hr, textAngle));
                    }
                }                

                // Datetime 8 AM
                dt = getDateTime8AM() - (oneDay * i);
                if (!currentTimeIsWeekend(dt)) {
                    // 8 AM VLine
                    objName = "VL " + twoHoursCycle[3] + " " + string(dt);
                    if (!findObject(objName)){
                        Sett(VLineCreate(objName, dt, clr2Hr, 2, 1));
                    }
                    // 8 AM Text
                    objName = "VLT " + twoHoursCycle[3] + " " + string(dt);
                    if (!findObject(objName)) {
                        Sett(Text(objName, dt, lowestYPos, twoHoursCycle[3], fontSize, clr2Hr, textAngle));
                    }
                }

                // Datetime 10 AM
                dt = getDateTime10AM() - (oneDay * i);
                if (!currentTimeIsWeekend(dt)) {
                    // 10 AM VLine
                    objName = "VL " + twoHoursCycle[4] + " " + string(dt);
                    if (!findObject(objName)){
                        Sett(VLineCreate(objName, dt, clr2Hr, 2, 1));
                    }
                    // 10 AM Text
                    objName = "VLT " + twoHoursCycle[4] + " " + string(dt);
                    if (!findObject(objName)) {
                        Sett(Text(objName, dt, lowestYPos, twoHoursCycle[4], fontSize, clr2Hr, textAngle));
                    }
                }

                // Datetime 12 AM
                dt = getDateTime12AM() - (oneDay * i);
                if (!currentTimeIsWeekend(dt)) {
                    // 12 AM VLine
                    objName = "VL " + twoHoursCycle[5] + " " + string(dt);
                    if (!findObject(objName)){
                        Sett(VLineCreate(objName, dt, clr2Hr, 2, 1));
                    }
                    // 12 AM Text
                    objName = "VLT " + twoHoursCycle[5] + " " + string(dt);
                    if (!findObject(objName)) {
                        Sett(Text(objName, dt, lowestYPos, twoHoursCycle[5], fontSize, clr2Hr, textAngle));
                    }
                }                

            }
        }

    }

    else {
        // Remove all objects if the timeframe is not valid
        objDelete();
    }

    return(rates_total);
}
//+--------------------
int getBarIndex(datetime waktu) {
    return iBarShift(Symbol(), Period(), waktu, true);
}
int chart_height() {
    return ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS);
}
//+--------------------
string timeToStringHourMinutes(datetime time) {
    return TimeToStr(time, TIME_MINUTES);
}
string getDayName(datetime waktu) {
    return stDy[TimeDayOfWeek(waktu) == 0 ? 6 : TimeDayOfWeek(waktu) - 1];
}
//+--------------------
bool beforeToday(datetime waktu) {
    return waktu < getCurrentTime();
}
bool afterToday(datetime waktu) {
   return waktu > getCurrentTime();
}
bool isValidTimeframe() {
    return Period() <= PERIOD_M15;
}
bool findObject(string name) {
    return ObjectFind(0, name) >= 0;
}
bool currentTimeIsWeekend() {
   return TimeDayOfWeek(TimeCurrent()) == 0 || TimeDayOfWeek(TimeCurrent()) == 6;
}
bool currentTimeIsWeekend(datetime dateTime) {
    return TimeDayOfWeek(dateTime) == 0 || TimeDayOfWeek(dateTime) == 6;
}
//+--------------------
datetime getCurrentTime() {
    string dateCurrent = TimeToStr(TimeCurrent(), TIME_DATE);
    string time = " 00:00:00";
    return StrToTime(dateCurrent + time);
}
datetime getDateTime330AM() {
    return StrToTime(string(TimeYear(TimeCurrent())) + "." + string(TimeMonth(TimeCurrent())) + "." + string(TimeDay(TimeCurrent())) + (HourTime + 3 >= 10 ? " " + string(HourTime + 3) : " 0" + string(HourTime + 3)) + ":30:00");
}
datetime getDateTime830AM() {
    return StrToTime(string(TimeYear(TimeCurrent())) + "." + string(TimeMonth(TimeCurrent())) + "." + string(TimeDay(TimeCurrent())) + (HourTime + 8 >= 10 ? " " + string(HourTime + 8) : " 0" + string(HourTime + 8)) + ":30:00");
}
datetime getDateTime1130AM() {
    return StrToTime(string(TimeYear(TimeCurrent())) + "." + string(TimeMonth(TimeCurrent())) + "." + string(TimeDay(TimeCurrent())) + (HourTime + 11 >= 10 ? " " + string(HourTime + 11) : " 0" + string(HourTime + 11)) + ":30:00");
}
datetime getDateTimeAsiaOpen() {
    return StrToTime(string(TimeYear(TimeCurrent())) + "." + string(TimeMonth(TimeCurrent())) + "." + string(TimeDay(TimeCurrent())) + (HourTime - 4 >= 10 ? " " + string(HourTime - 4) : " 0" + string(HourTime - 4)) + ":00:00");
}
datetime getDateTimeSeparator() {
    return StrToTime(string(TimeYear(TimeCurrent())) + "." + string(TimeMonth(TimeCurrent())) + "." + string(TimeDay(TimeCurrent())) + (HourTime >= 10 ? " " + string(HourTime) : " 0" + string(HourTime)) + ":00:00");
}
datetime getDateTimeLondonSession1Start() {
    return StrToTime(string(TimeYear(TimeCurrent())) + "." + string(TimeMonth(TimeCurrent())) + "." + string(TimeDay(TimeCurrent())) + (HourTime + 2 >= 10 ? " " + string(HourTime + 2) : " 0" + string(HourTime + 2)) + ":00:00");
}
datetime getDateTimeLondonSession1Stop() {
    return StrToTime(string(TimeYear(TimeCurrent())) + "." + string(TimeMonth(TimeCurrent())) + "." + string(TimeDay(TimeCurrent())) + (HourTime + 5 >= 10 ? " " + string(HourTime + 5) : " 0" + string(HourTime + 5)) + ":00:00");
}
datetime getDateTimeNewYorkStart() {
    return StrToTime(string(TimeYear(TimeCurrent())) + "." + string(TimeMonth(TimeCurrent())) + "." + string(TimeDay(TimeCurrent())) + (HourTime + 7 >= 10 ? " " + string(HourTime + 7) : " 0" + string(HourTime + 7)) + ":00:00");
}
datetime getDateTimeNewYorkStop() {
    return StrToTime(string(TimeYear(TimeCurrent())) + "." + string(TimeMonth(TimeCurrent())) + "." + string(TimeDay(TimeCurrent())) + (HourTime + 10 >= 10 ? " " + string(HourTime + 10) : " 0" + string(HourTime + 10)) + ":00:00");
}
datetime getDateTimeLondonSession2Stop() {    
    return StrToTime(string(TimeYear(TimeCurrent())) + "." + string(TimeMonth(TimeCurrent())) + "." + string(TimeDay(TimeCurrent())) + (HourTime + 13 >= 10 ? " " + string(HourTime + 13) : " 0" + string(HourTime + 13)) + ":00:00");
}
datetime getDateTime2AM() {
    return StrToTime(string(TimeYear(TimeCurrent())) + "." + string(TimeMonth(TimeCurrent())) + "." + string(TimeDay(TimeCurrent())) + (HourTime + 2 >= 10 ? " " + string(HourTime + 2) : " 0" + string(HourTime + 2)) + ":00:00");
}
datetime getDateTime4AM() {
    return StrToTime(string(TimeYear(TimeCurrent())) + "." + string(TimeMonth(TimeCurrent())) + "." + string(TimeDay(TimeCurrent())) + (HourTime + 4 >= 10 ? " " + string(HourTime + 4) : " 0" + string(HourTime + 4)) + ":00:00");
}
datetime getDateTime6AM() {
    return StrToTime(string(TimeYear(TimeCurrent())) + "." + string(TimeMonth(TimeCurrent())) + "." + string(TimeDay(TimeCurrent())) + (HourTime + 6 >= 10 ? " " + string(HourTime + 6) : " 0" + string(HourTime + 6)) + ":00:00");
}
datetime getDateTime8AM() {
    return StrToTime(string(TimeYear(TimeCurrent())) + "." + string(TimeMonth(TimeCurrent())) + "." + string(TimeDay(TimeCurrent())) + (HourTime + 8 >= 10 ? " " + string(HourTime + 8) : " 0" + string(HourTime + 8)) + ":00:00");
}
datetime getDateTime10AM() {
    return StrToTime(string(TimeYear(TimeCurrent())) + "." + string(TimeMonth(TimeCurrent())) + "." + string(TimeDay(TimeCurrent())) + (HourTime + 10 >= 10 ? " " + string(HourTime + 10) : " 0" + string(HourTime + 10)) + ":00:00");
}
datetime getDateTime12AM() {
    return StrToTime(string(TimeYear(TimeCurrent())) + "." + string(TimeMonth(TimeCurrent())) + "." + string(TimeDay(TimeCurrent())) + (HourTime + 12 >= 10 ? " " + string(HourTime + 12) : " 0" + string(HourTime + 12)) + ":00:00");
}
//+--------------------

// double getLowestYPos() {
//    return Low[iLowest(Symbol(), PERIOD_CURRENT, MODE_LOW, WindowFirstVisibleBar())];
// }
double chart_price_range() {
    return ChartGetDouble(0, CHART_PRICE_MAX) - ChartGetDouble(0, CHART_PRICE_MIN);
}
double price_per_pixel() {
    return (chart_price_range() / chart_height());
}
double y_pos(){
    return chart_price_range() - 1;
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
bool Text(const string            name="Text",              // object name 
          datetime                time=0,                   // anchor point time 
          double                  price=0,                  // anchor point price 
          const string            text="Text",              // the text itself 
          const int               font_size=8,               // font size 
          const color             clr=clrBlack,             // color 
          const double            angle=0.0,                // text slope 
          const string            font = "Arial",           // Font
          const ENUM_ANCHOR_POINT anchor = ANCHOR_LEFT_UPPER, // anchor type 
          const bool              back = false,               // in the background 
          const bool              selection = false,          // highlight to move 
          const bool              hidden = true,              // hidden in the object list 
          const long              z_order = 0){               // priority for mouse click  
    ChangeTextEmptyPoint(time,price); 
    ResetLastError();
    string Name= iName + " " + name;
    ObjectCreate(0, Name, OBJ_TEXT,0,0,0);
    ObjectSetInteger(0, Name, OBJPROP_TIME,time);
    ObjectSetDouble(0, Name, OBJPROP_PRICE,price);
    ObjectSetString(0, Name, OBJPROP_TEXT,text); 
    ObjectSetString(0, Name, OBJPROP_FONT,font); 
    ObjectSetInteger(0, Name, OBJPROP_FONTSIZE,fontSize);
    ObjectSetDouble(0, Name, OBJPROP_ANGLE,angle); 
    ObjectSetInteger(0, Name, OBJPROP_ANCHOR,anchor); 
    ObjectSetInteger(0, Name, OBJPROP_COLOR,clr); 
    ObjectSetInteger(0, Name, OBJPROP_BACK,back); 
    ObjectSetInteger(0, Name, OBJPROP_SELECTABLE,selection); 
    ObjectSetInteger(0, Name, OBJPROP_SELECTED,selection); 
    ObjectSetInteger(0, Name, OBJPROP_HIDDEN,hidden); 
    ObjectSetInteger(0, Name, OBJPROP_ZORDER,z_order); 
    ObjectSetString(0, Name, OBJPROP_TOOLTIP,"\n"); 
    return(findObject(Name)); 
}
//+------------------------------------------------------------------+
bool VLineCreate(const string          name="VLine",      // line name 
                 datetime              time=0,            // line time 
                 const color           clr=clrRed,        // line color 
                 const ENUM_LINE_STYLE style=STYLE_SOLID, // line style 
                 const int             width=1,           // line width 
                 const bool            back=true,        // in the background 
                 const bool            selection=false,    // highlight to move 
                 const bool            hidden=true,       // hidden in the object list 
                 const long            z_order=0){         // priority for mouse click 
    ResetLastError();
    string Name= iName + " " + name;
    ObjectCreate(0, Name, OBJ_VLINE, 0, 0, 0);
    ObjectSetInteger(0, Name, OBJPROP_TIME, time);
    ObjectSetInteger(0, Name, OBJPROP_COLOR, clr); 
    ObjectSetInteger(0, Name, OBJPROP_BACK, back);
    ObjectSetInteger(0, Name, OBJPROP_STYLE, style); 
    ObjectSetInteger(0, Name, OBJPROP_WIDTH, width);
    ObjectSetInteger(0, Name, OBJPROP_BACK, back);   
    ObjectSetInteger(0, Name, OBJPROP_SELECTABLE, selection); 
    ObjectSetInteger(0, Name, OBJPROP_SELECTED, selection); 
    ObjectSetInteger(0, Name, OBJPROP_HIDDEN, hidden); 
    ObjectSetInteger(0, Name, OBJPROP_ZORDER, z_order); 
    ObjectSetString(0, Name, OBJPROP_TOOLTIP, "\n"); 
    return(findObject(Name)); 
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
   string Name= iName + " " + name;
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
   return(findObject(Name)); 
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