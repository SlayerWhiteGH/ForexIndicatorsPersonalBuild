//+------------------------------------------------------------------+
//|                                                   InsideBars.mq4 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#property  copyright "Flyer415"

//---- indicator settings
#property  indicator_chart_window
#property indicator_buffers 4 

#property indicator_color3 Lime//candle
#property indicator_color4 Yellow//candle 
#property indicator_width1 1 
#property indicator_width2 1
#property indicator_width3 1
#property indicator_width4 1

bool Candles = true;
extern int BarWidth = 1, CandleWidth = 2; 


//---- indicator buffers




double Bar1[], Bar2[], Candle1[], Candle2[],buf2[], buf3[],Bar3[], Bar4[], Candle3[], Candle4[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {

   if(Candles == True)
				{
					SetIndexBuffer(0,Bar1); 
               SetIndexBuffer(1,Bar2); 
               SetIndexBuffer(2,Candle1); 
               SetIndexBuffer(3,Candle2); 
               
              SetIndexStyle(0,DRAW_HISTOGRAM,0,BarWidth); 
               SetIndexStyle(1,DRAW_HISTOGRAM,0,BarWidth); 
               SetIndexStyle(2,DRAW_HISTOGRAM,0,CandleWidth); 
               SetIndexStyle(3,DRAW_HISTOGRAM,0,CandleWidth); 
              
				}
			else
				{
					SetIndexStyle(1, DRAW_HISTOGRAM, STYLE_SOLID, 5);
					SetIndexBuffer(1, buf2);   
					SetIndexStyle(0, DRAW_HISTOGRAM, STYLE_SOLID,5);   
					SetIndexBuffer(0, buf3);
				}
  
   
   //---- initialization done
   return(0);
  }
 
//+------------------------------------------------------------------+
//|                                              |
//+------------------------------------------------------------------+
int start()
  {
   
   int      limit,i; 
   int      counted_bars=IndicatorCounted();
   
   
   
   //---- check for possible errors
   if(counted_bars<0) return(-1);

   //---- initial zero
   
   //---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;

   //----Calculation---------------------------
   for( i=0; i<limit; i++)
   {
  	  
   
       
      if(Low[i+1]<= Low[i] && High[i+1]>=High[i] && Close[i] > Open[i]) 
       {
        
        SetCandleColor(1,i); // 
       }
       else if(Low[i+1] <= Low[i] && High[i+1] >= High[i] && Open[i] > Close[i])
       {
        
        SetCandleColor(2,i); // 
        }

   
     }
   //---- done

   return(0);
  }
  
  
   void SetCandleColor(int col, int i) 
 { 
 double high,low,bodyHigh,bodyLow; 
 {
  bodyHigh = MathMax(Open[i],Close[i]); 
  bodyLow = MathMin(Open[i],Close[i]); 
  high = High[i]; 
  low = Low[i]; 
  } 
  Bar1[i] = low;
   Candle1[i] = bodyLow;
    Bar2[i] = low;
     Candle2[i] = bodyLow;
     Bar3[i] = low;
   Candle3[i] = bodyLow;
    Bar4[i] = low;
     Candle4[i] = bodyLow;
    // Bar1[i] = low;
   
      switch(col)
       { 
       case 1: 
       Bar1[i] = high; 
       Candle1[i] = bodyHigh; 
       break; 
       
       case 2: 
       Bar2[i] = high;
        Candle2[i] = bodyHigh;
         break; 
         
         case 3: 
       Bar3[i] = high; 
       Candle3[i] = bodyHigh; 
       break; 
       
       case 4: 
        Bar4[i] = high;
        Candle4[i] = bodyHigh;
         break; 
         
      
         }
          }