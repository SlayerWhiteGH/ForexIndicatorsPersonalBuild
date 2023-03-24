//+------------------------------------------------------------------+
//|                                                  Time_vLines.mq4 |
//|                                                         Zen_Leow |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Zen_Leow"
#property link      ""
#property strict

#property indicator_chart_window

extern int Hour_Num = 15; //Hour Number:
extern int Minute_Num = 0; //Minute Number:
extern color Line_Color = clrDodgerBlue; //Line Color:
extern ENUM_LINE_STYLE style=STYLE_DOT; //Line Style:
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
//---- indicators
//----
   return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
{
//----
   int ObjectCount = ObjectsTotal();
   for (int i=ObjectCount-1; i>=0; i--)
   {
      if(StringFind(ObjectName(i),"Time_vLine-") != -1)
      {
         ObjectDelete(ObjectName(i));
      }  
   }
//----
   return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{
   int Counted_bars=IndicatorCounted(); // Number of counted bars   
   int i=Bars-Counted_bars-1;           // Index of the first uncounted   
   
   while(i>=0)                      // Loop for uncounted bars     
   {  
      if(TimeHour(Time[i]) == Hour_Num && TimeMinute(Time[i]) == Minute_Num)
      {
         if (ObjectFind("Time_vLine-"+string(Time[i])) != 0)
         {
            ObjectCreate( "Time_vLine-"+string(Time[i]),"London", OBJ_TEXT,0, Time[i],0);
            ObjectCreate( "Time_vLine-"+string(Time[i]), OBJ_VLINE, 0, Time[i], 0 );
            ObjectSet   ( "Time_vLine-"+string(Time[i]), OBJPROP_COLOR, Line_Color );
            ObjectSet   ( "Time_vLine-"+string(Time[i]), OBJPROP_BACK, true );
            ObjectSetInteger(0,"Time_vLine-"+string(Time[i]),OBJPROP_STYLE,style);          //--- set line display style 
            ObjectSetInteger(0,"Time_vLine-"+string(Time[i]),OBJPROP_SELECTABLE,false);     //--- when creating a graphical object using ObjectCreate function, the object cannot be highlighted and moved by default. Inside this method, selection parameteris true by default making it possible to highlight and move the object  
            ObjectSetInteger(0,"Time_vLine-"+string(Time[i]),OBJPROP_SELECTED,false); 
            ObjectSetText("Time_vLine-"+string(Time[i]), "London",10,"Arial Black", Line_Color );
          
         }
      }
      i--;
   }
//----
   return(0);
}
//+------------------------------------------------------------------+