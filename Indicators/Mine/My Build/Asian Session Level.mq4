//+------------------------------------------------------------------+
//|                                       Asian Session Level SD.mq4 |
//|                                                   Copyright 2023 |
//|                                                        W H I T E |
//+------------------------------------------------------------------+

#property copyright "Copyright 2023, W H I T E"
#property link      "W H I T E"
#property description " "
#property description " "
#property description " "
#property description "                     ---@2023--- "
#property indicator_chart_window
#property indicator_buffers 8


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

input int lookback         = 5;        //LookBack
input int StartTime        = 0;        //Start Time
input int EndTime          = 5;        //End Time
input bool showlevel        = true;    //Show Level 
input color clevelr         = clrBlack;   //Clr Resistance
input color clevels         = clrBlack;  //Clr Support


double HighBuffer[];
double LowBuffer[];
double HighBuffer1[];
double HighBuffer2[];
double HighBuffer3[];
double LowBuffer1[];
double LowBuffer2[];
double LowBuffer3[];

string indicatorFileName;
string iName="Assian Session Level";  

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

int OnInit() {
    
    SetIndexBuffer(0, HighBuffer);
    SetIndexStyle (0, DRAW_LINE,STYLE_DASH,1,clevelr);
    SetIndexLabel (0, "Highest");

    SetIndexBuffer(1, LowBuffer);
    SetIndexStyle (1, DRAW_LINE,STYLE_DASH,1,clevels);
    SetIndexLabel (1, "Lowest");

    SetIndexBuffer(2, HighBuffer1);
    SetIndexStyle (2, DRAW_LINE,STYLE_DASH,1,clevelr);
    SetIndexLabel (2, "Level 1");

    SetIndexBuffer(3, LowBuffer1);
    SetIndexStyle (3, DRAW_LINE,STYLE_DASH,1,clevels);
    SetIndexLabel (3, "Level 1");
    
    SetIndexBuffer(4, HighBuffer2);
    SetIndexStyle (4, DRAW_LINE,STYLE_DASH,1,clevelr);
    SetIndexLabel (4, "Level 2");

    SetIndexBuffer(5, LowBuffer2);
    SetIndexStyle (5, DRAW_LINE,STYLE_DASH,1,clevels);
    SetIndexLabel (5, "Level 2");
    
    SetIndexBuffer(6, HighBuffer3);
    SetIndexStyle (6, DRAW_LINE,STYLE_DASH,1,clevelr);
    SetIndexLabel (6, "Level 3");

    SetIndexBuffer(7, LowBuffer3);
    SetIndexStyle (7, DRAW_LINE,STYLE_DASH,1,clevels);
    SetIndexLabel (7, "Level 3");


    return 0;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
void OnDeinit(const int reason){
   objDelete();
	Comment("");
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

void objDelete(string inpStr=""){
   inpStr = inpStr!=""?inpStr:iName;
   for(int i=ObjectsTotal(); i>=0; i--){
      if(StringSubstr(ObjectName(i),0,StringLen(inpStr))==inpStr)
         ObjectDelete(ObjectName(i));
   }
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
    
    int year = TimeYear(TimeCurrent());
    int month = TimeMonth(TimeCurrent());
    int day = TimeDay(TimeCurrent());
    
    for (int i = lookback; i > 0; i--){
        datetime dtStart, dtStop;

        if (day == 0) {
            month--;
            if (month == 0) {
                year--;
                month = 12;
            }

            day = getLastDayOfMonth(year, month);
        }

        if (EndTime <= StartTime) {
            if (day - 1 == 0) {
                int tmpMonth = (month - 1 == 0) ? 12 : month - 1;
                int tmpYear = (tmpMonth == 12) ? year - 1 : year;
                int tmpDay = getLastDayOfMonth(tmpYear, tmpMonth);

                dtStart = getDateTime(tmpYear, tmpMonth, tmpDay, StartTime);
            }
            else {
                dtStart = getDateTime(year, month, day - 1, StartTime);
            }

            dtStop = getDateTime(year, month, day, EndTime);
        } else {
            dtStart = getDateTime(year, month, day, StartTime);
            dtStop = getDateTime(year, month, day, EndTime);
        }

        if (timeIsWeekend(dtStart) && timeIsWeekend(dtStop)) {
            i++;
            day--;
            continue;
        }
        if (timeIsWeekend(dtStart) && !timeIsWeekend(dtStop)) {
            i++;
            day--;
            continue;
        }
        if (!timeIsWeekend(dtStart) && timeIsWeekend(dtStop)) {
            if (day + 2 > getLastDayOfMonth(year, month)) {
                tmpDay = day + 2 - getLastDayOfMonth(year, month);
                tmpMonth = month == 12 ? 1 : month + 1;
                tmpYear = month == 1 ? year + 1 : year;

            
                dtStop = getDateTime(tmpYear, tmpMonth, tmpDay, EndTime);
            }
            else {
                dtStop = getDateTime(year, month, day + 2, EndTime);
            }
        }

        int IndexStart = getBarIndex(dtStart);
        if (barExists(IndexStart)) {
            int IndexStop = getBarIndex(dtStop) + 2;
            if (!barExists(IndexStop)) IndexStop = 0;

            int barCount = IndexStart - IndexStop;
            int highestIndex = iHighest(Symbol(), Period(), MODE_HIGH, barCount, IndexStop);
            int lowestIndex = iLowest(Symbol(), Period(), MODE_LOW, barCount, IndexStop);
            double range = (high[highestIndex] - Low[lowestIndex]);

            //Highest, Lowest & Range
            for (int j = IndexStart; j >= IndexStop; j--) {
                HighBuffer[j] = high[highestIndex];
                LowBuffer[j] = low[lowestIndex];
                
                if (showlevel) {
                    HighBuffer1[j] = range + high[highestIndex];
                    LowBuffer1[j] = low[lowestIndex] - range;
                    HighBuffer2[j] = 2 * range + high[highestIndex];
                    LowBuffer2[j] = low[lowestIndex] - range * 2;
                    HighBuffer3[j] = 3 * range + high[highestIndex];
                    LowBuffer3[j] = low[lowestIndex] - range * 3;
                }
                else {
                    HighBuffer1[j] = LowBuffer1[j] = HighBuffer2[j] = LowBuffer2[j] = HighBuffer3[j] = LowBuffer3[j] = EMPTY_VALUE;
                }
            }
        }

        day--;
        
    }

    return 0;
}


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
bool timeIsWeekend(datetime dateTime) {
    return TimeDayOfWeek(dateTime) == 0 || TimeDayOfWeek(dateTime) == 6;
}

datetime getCurrentDay() {
    string dateCurrent = TimeToStr(TimeCurrent(), TIME_DATE);
    string time = " 00:00:00";
    return StrToTime(dateCurrent + time);
}

datetime getDateTime(int year, int month, int day, int hour) {
    return StrToTime(
        year
        + "."
        + (month >= 10 ? string(month) : ("0" + string(month)))
        + "."
        + (day >= 10 ? string(day) : ("0" + string(day)))
        + (hour >= 10 ? (" " + string(hour)) : (" 0" + string(hour)))
        + ":00:00"
    );
}

int getLastDayOfMonth(int year, int month) {
    return month == 1 ? 31
            : month == 2 ? (isLeapYear(year) ? 29 : 28)
            : month == 3 ? 31
            : month == 4 ? 30
            : month == 5 ? 31
            : month == 6 ? 30
            : month == 7 ? 31
            : month == 8 ? 31
            : month == 9 ? 30
            : month == 10 ? 31
            : month == 11 ? 30
            : 31;
}

int getBarIndex(datetime waktu) {
    return iBarShift(Symbol(), Period(), waktu, true);
}

bool isEndTime(int index) {
  //printf("Endtime : " + Time[index] + " --- Hour : " + TimeHour(Time[index]) + " --- Minute : " + TimeMinute(Time[index]) + " --- Second : " + TimeSeconds(Time[index]));
   return TimeHour(Time[index]) == EndTime && TimeMinute(Time[index]) == 0 && TimeSeconds(Time[index]) == 0;
}

bool isStartTime(int index) {
  //printf("StartTime : " + Time[index] + " --- Hour : " + TimeHour(Time[index]) + " --- Minute : " + TimeMinute(Time[index]) + " --- Second : " + TimeSeconds(Time[index]));
   return TimeHour(Time[index]) == StartTime && TimeMinute(Time[index]) == 0 && TimeSeconds(Time[index]) == 0;
}

bool isWithinTimeline(int index) {
  //printf("Timeline : " + TimeHour(Time[index]));
   return TimeHour(Time[index]) >= StartTime && TimeHour(Time[index]) < EndTime;
}

bool barExists(int barIndex) {
    return barIndex != -1;
}

bool isLeapYear(int year) {
    if (year % 100 == 0) {
        return year % 400 == 0;
    }
    else {
        return year % 4 == 0;
    }
}

void calculateDate(int year, int month, int day) {
    if (day == 0) {
        month--;
        if (month == 0) {
            year--;
            month = 12;
        }

        day = getLastDayOfMonth(year, month);
    }
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~