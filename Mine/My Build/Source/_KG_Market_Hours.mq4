//+------------------------------------------------------------------+
//|                                             _KG_Market_Hours.mq4 |
//|                                                            d4y47 |
//|                                      http://www.kgforexworld.com |
//+------------------------------------------------------------------+
#property copyright "d4y47"
#property link      "http://www.kgforexworld.com"

#property 		indicator_chart_window
#property		indicator_buffers 4
#property		indicator_color1 Lime
#property		indicator_width1 1
#property		indicator_color2 Yellow
#property		indicator_width2 1
#property 		indicator_maximum 9
#property 		indicator_minimum 0

extern int		LondonOpen		= 9;
extern int		LondonClose		= 12;
extern int		NewYorkOpen		= 14;
extern int		NewYorkClose	= 19;



// Buffers
double dLondonBuffer[];
double dNewYorkBuffer[];
double dSydneyBuffer[];
double dTokyoBuffer[];
double tmpLondon,tmpTokyo,tmpSydney,tmpNewyork;
int init() {

	IndicatorShortName("");
	
	SetIndexBuffer(0,dLondonBuffer);
	SetIndexLabel(0,"London");
	SetIndexBuffer(1,dNewYorkBuffer);
	SetIndexLabel(1,"New York");

	
	return(0);
}

int start() {

	// Determine number of bars to iterate over
	int iBarsToCalc = Bars - IndicatorCounted();
	if (iBarsToCalc < Bars) iBarsToCalc++;
	
	// Iterate over bars
	for (int i=iBarsToCalc-1;i>=0;i--) {
		
		// Set London Line
		if (isMarketOpen(LondonOpen, LondonClose, Time[i])){
		   if (!isMarketOpen(LondonOpen, LondonClose, Time[i+1]))tmpLondon=Open[i];
			dLondonBuffer[i] = tmpLondon;
		}
		else
			dLondonBuffer[i] = EMPTY_VALUE;
		
		// Set NewYork Line
		if (isMarketOpen(NewYorkOpen, NewYorkClose, Time[i])){
		   if (!isMarketOpen(NewYorkOpen, NewYorkClose, Time[i+1]))tmpNewyork=Open[i];
			dNewYorkBuffer[i] = tmpNewyork;
		}
		else
			dNewYorkBuffer[i] = EMPTY_VALUE;		
			
				

	}

}

bool isMarketOpen(int iOpenHour, int iCloseHour, datetime timestamp) {

	int iBarHour = TimeHour(timestamp);
	
	if (iOpenHour < iCloseHour && (iBarHour >= iOpenHour && iBarHour < iCloseHour))
		return(true);
	if (iOpenHour > iCloseHour && (iBarHour >= iOpenHour || iBarHour < iCloseHour))
		return(true);
		
	return(false);
}

