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

extern int StartTime        = 0;        //Start Time
extern int EndTime          = 5;        //End Time
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
    
    int limit = Bars - IndicatorCounted();
    int startingPoint = 0;
    int iterator = 0;
    

    for (int i = limit; i >= 0; i--){
        if (!isWithinTimeline(i)){
            HighBuffer1[i] = LowBuffer1[i] = HighBuffer2[i] = LowBuffer2[i] = HighBuffer3[i] = LowBuffer3[i] = EMPTY_VALUE;
        }

        if (isStartTime(i)){
            startingPoint = i;
            iterator = 0;
        }
        if (isWithinTimeline(i)){
            iterator++;
        }
        if (isEndTime(i)){
            int highest = iHighest(Symbol(), Period(), MODE_HIGH, iterator, i);
            int lowest = iLowest(Symbol(), Period(), MODE_LOW, iterator, i);
            double range = (high[highest] - low[lowest]);

            //for(int j=startingPoint; j>startingPoint-iterator; j--)
            for(int j=startingPoint; j>=0; j--){
                if (TimeHour(time[j]) >= StartTime && TimeHour(time[j]) < EndTime){
                    HighBuffer[j] = high[highest];
                    LowBuffer[j] = low[lowest];
                    if (showlevel){
                        HighBuffer1[j] = range + high[highest];
                        LowBuffer1[j] = low[lowest] - range;
                        HighBuffer2[j] = 2 * range + high[highest];
                        LowBuffer2[j] = low[lowest] - range * 2;
                        HighBuffer3[j] = 3 * range + high[highest];
                        LowBuffer3[j] = low[lowest] - range * 3;
                    }else{
                        HighBuffer1[j] = LowBuffer1[j] = HighBuffer2[j] = LowBuffer2[j] = HighBuffer3[j] = LowBuffer3[j] = EMPTY_VALUE;
                    }
                }
            }
            startingPoint = 0;
            iterator = 0;
        }
    }



    return 0;
}


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


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
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~