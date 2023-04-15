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
    
    int Day = TimeDay(TimeCurrent()) - lookback;
    
    for (int i = lookback; i > 0; i--){
    datetime dtStart, dtStop;
        int currentDayOfWeek = TimeDayOfWeek(TimeCurrent());
        if (currentTimeIsWeekend(TimeCurrent())) {
           continue;
        }
        Day++;
        if (EndTime <= StartTime) {
            dtStart = getDateTimeFromDay(Day-1, StartTime);
            dtStop = getDateTimeFromDay(Day, EndTime);
        } else {
            dtStart = getDateTimeFromDay(Day, StartTime);
            dtStop = getDateTimeFromDay(Day, EndTime);
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
        
    }

    return 0;
}


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
bool currentTimeIsWeekend(datetime dateTime) {
    return TimeDayOfWeek(dateTime) == 0 || TimeDayOfWeek(dateTime) == 6;
}

datetime getCurrentDay() {
    string dateCurrent = TimeToStr(TimeCurrent(), TIME_DATE);
    string time = " 00:00:00";
    return StrToTime(dateCurrent + time);
}

datetime getDateTimeFromDay(int Day, int Hour) {
    return StrToTime(
        string(TimeYear(TimeCurrent()))
        + "."
        + string(TimeMonth(TimeCurrent()))
        + "."
        + (Day >= 10 ? string(Day) : ("0" + string(Day)))
        + (Hour >= 10 ? (" " + string(Hour)) : (" 0" + string(Hour)))
        + ":00:00"
    );
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
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~