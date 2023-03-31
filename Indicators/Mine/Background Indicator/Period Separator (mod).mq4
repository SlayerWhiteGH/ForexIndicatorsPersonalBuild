#property copyright "www.forex-station.com"
#property link      "www.forex-station.com"

#property indicator_chart_window

extern string  Group1 = ""; //----------------------------------

ENUM_TIMEFRAMES timeFrame;

extern ENUM_TIMEFRAMES for1min = PERIOD_H1;
extern ENUM_TIMEFRAMES for5min = PERIOD_H1;
extern ENUM_TIMEFRAMES for15min = PERIOD_D1;
extern ENUM_TIMEFRAMES for30min = PERIOD_D1;
extern ENUM_TIMEFRAMES forH1 = PERIOD_W1;
extern ENUM_TIMEFRAMES forH4 = PERIOD_W1;
extern ENUM_TIMEFRAMES forD1 = PERIOD_MN1;

//int forW1 = 9999;
//int forMN = 9999;

extern string  Group2 = ""; //----------------------------------

extern color   LineColor = DarkOliveGreen; 
extern int     LineStyle = STYLE_DOT;
extern int     LineWidth = 1;
extern string  LinesID   = "PeriodSeparator";
extern bool    ObjOnBckgrnd = true;

double dummyBuffer[];
bool returnBars;
string indicatorFileName;
int init()
{
   IndicatorBuffers(1);
      SetIndexBuffer(0,dummyBuffer);
   returnBars        = timeFrame==-99;
   indicatorFileName = WindowExpertName();
   timeFrame  = MathMax(timeFrame,_Period);
   return(0);
}
   
int deinit()
{
   int lookForLength = StringLen(LinesID);
      for (int i=ObjectsTotal()-1; i>=0; i--) 
      {
         string name = ObjectName(i);  if (StringSubstr(name,0,lookForLength) == LinesID) ObjectDelete(name);
      }
   return(0); 
}

//
//
//
//
//
   
int start()
{
//
//
//
//
//
  if(_Period == 1)
  {
  timeFrame = for1min;
  }
  
  if(_Period == 5)
  {
  timeFrame = for5min;
  }
  
  if(_Period == 15)
  {
  timeFrame = for15min;
  }
  
  if(_Period == 30)
  {
  timeFrame = for30min;
  }
  
  if(_Period == 60)
  {
  timeFrame = forH1;
  }

  if(_Period == 240)
  {
  timeFrame = forH4;
  }

  if(_Period == 1440)
  {
  timeFrame = forD1;
  }


//
//
//
//
//
   int counted_bars = IndicatorCounted();

      if(counted_bars<0) return(-1);
      if(counted_bars>0) counted_bars--;
            int limit = MathMin(Bars-counted_bars,Bars-1);
            if (returnBars) { dummyBuffer[0] = limit; return(0); }

      if (timeFrame!=_Period) limit = (int)MathMax(limit,MathMin(Bars-1,iCustom(NULL,timeFrame,indicatorFileName,-99,0,0)*timeFrame/Period()));
      for(int i=limit;i>=0;i--)
      {
         double y = iBarShift(NULL,timeFrame,Time[i]);
         double x = iBarShift(NULL,timeFrame,Time[i+1]);
         string name = LinesID+":"+Time[i];
            ObjectDelete(name);
            if (x!=y)
            {
                  ObjectCreate(name,OBJ_VLINE,0,Time[i],High[i]);
                     ObjectSet(name,OBJPROP_COLOR,LineColor); // Color value to set/get object color.
                     ObjectSet(name,OBJPROP_STYLE,LineStyle); // Value is one of STYLE_SOLID, STYLE_DASH, STYLE_DOT, STYLE_DASHDOT, STYLE_DASHDOTDOT constants to set/get object line style.
                     ObjectSet(name,OBJPROP_WIDTH,LineWidth); // Integer value to set/get object line width. Can be from 1 to 5.
                     ObjectSet(name,OBJPROP_BACK,ObjOnBckgrnd); // Boolean value to set/get background drawing flag for object. (for example "true" will hide the value at the bottom of the chart.)
                     ObjectSet(name,OBJPROP_SELECTABLE,false);
            }                              
      }
   return(0);
}