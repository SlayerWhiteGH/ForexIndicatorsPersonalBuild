//
//+------------------------------------------------------------------+
//|                                      ZONE EXTENDER               |
//|                                                                  |
//|                                                                  |
//|                                    clevasys@gmail.com            |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Configured by ClevaSys"
#property indicator_chart_window
#property description "Draw Your Rectangle or box and this will extend it" 
extern string GridSpace_Info = "Amount to extend past the current candle...";
extern int Extend=2;

 
//VOID INITIALISATION
void init()
 {
 }
//VOID START
void start() 
 {
  int RectangleTime;
  
  
  if(Time[0] > RectangleTime)
   {
       for(int i = ObjectsTotal()-1; i >= 0; i--)
       if(ObjectType(ObjectName(i)) == 16)
        ObjectSet(ObjectName(i), OBJPROP_TIME2, Time[0]+Extend*5000);

      RectangleTime = Time[0];
   }
   
 

 }

//-----------------------------------------------------------------------------
void deinit()
 {

 }

//-----------------------------------------------------------------------------

