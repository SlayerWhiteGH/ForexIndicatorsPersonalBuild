#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Blue
#property indicator_color2 Red
#property indicator_width1 2
#property indicator_width2 2

extern int StartTime = 0;
extern int EndTime = 5;

double HighBuffer[];
double LowBuffer[];

int init() {
    SetIndexBuffer(0, HighBuffer);
    SetIndexStyle(0, DRAW_LINE);
    SetIndexLabel(0, "Highest");

    SetIndexBuffer(1, LowBuffer);
    SetIndexStyle(1, DRAW_LINE);
    SetIndexLabel(1, "Lowest");

    return 0;
}

int start() {
    int counted_bars = IndicatorCounted();
    int limit = Bars - counted_bars;
    
    int startingPoint;
    int iterator = 0;
    
    for (int i = limit; i >= 0; i--) {
      if (isEndTime(i)) {
         startingPoint = i;
         printf("Starting Point : " + startingPoint);
      }
      if (isWithinTimeline(i)) {
         iterator++;
      }
      if (isStartTime(i)) {
         int highest = iHighest(Symbol(), PERIOD_CURRENT, MODE_HIGH, iterator, startingPoint);
         int lowest = iLowest(Symbol(), PERIOD_CURRENT, MODE_LOW, iterator, startingPoint);
         printf("Iterator : " + iterator);
         printf("Highest : " + highest);
         printf("Lowest : " + lowest);
         for (int j = startingPoint; j > startingPoint - iterator; j--) {
            HighBuffer[j] = High[highest];
            LowBuffer[j] = Low[lowest];
         }
         
         startingPoint = 0;
         iterator = 0;
      }
    }
    
    return 0;
}

bool isEndTime(int index) {
   printf("Endtime : " + Time[index] + " --- Hour : " + TimeHour(Time[index]) + " --- Minute : " + TimeMinute(Time[index]) + " --- Second : " + TimeSeconds(Time[index]));
   return TimeHour(Time[index]) == EndTime && TimeMinute(Time[index]) == 0 && TimeSeconds(Time[index]) == 0;
}

bool isStartTime(int index) {
   printf("StartTime : " + Time[index] + " --- Hour : " + TimeHour(Time[index]) + " --- Minute : " + TimeMinute(Time[index]) + " --- Second : " + TimeSeconds(Time[index]));
   return TimeHour(Time[index]) == StartTime && TimeMinute(Time[index]) == 0 && TimeSeconds(Time[index]) == 0;
}

bool isWithinTimeline(int index) {
   printf("Timeline : " + TimeHour(Time[index]));
   return TimeHour(Time[index]) >= StartTime && TimeHour(Time[index]) <= EndTime;
}

double countHigh(double prevHigh, double currentHigh){
   if (currentHigh > prevHigh) {
      return currentHigh;
   }
   return prevHigh;
}

double countLow(double prevLow, double currentLow) {
   if (currentLow < prevLow) {
      return currentLow;
   }
   return prevLow;
}