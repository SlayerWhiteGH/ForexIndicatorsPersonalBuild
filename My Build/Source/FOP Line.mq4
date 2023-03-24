//+------------------------------------------------------------------+
//|                                             _KG_Market_Hours.mq4 |
//|                                                            d4y47 |
//|                                      http://www.kgforexworld.com |
//+------------------------------------------------------------------+
#property copyright "d4y47"
#property link      "http://www.kgforexworld.com"

#property 		indicator_chart_window
#property		indicator_buffers 1
#property		indicator_color1 Lime
#property		indicator_width1 1

extern int		StartTime		= 9;
extern int		EndTime		   = 17;


// Buffers
double dOpenBuffer[];
double tmpOpen;
int init() {

	IndicatorShortName("");
	
	SetIndexBuffer(0,dOpenBuffer);
	SetIndexLabel(0,"Opening");
	
	return(0);
}

int start() {

	// Determine number of bars to iterate over
	int iBarsToCalc = Bars - IndicatorCounted();
	if (iBarsToCalc < Bars) iBarsToCalc++;
	
	// Iterate over bars
	for (int i=iBarsToCalc-1;i>=0;i--) {
		
		// Set London Line
		if (isMarketOpen(StartTime, EndTime, Time[i])){
		   if (!isMarketOpen(StartTime, EndTime, Time[i+1]))tmpOpen=Open[i];
			dOpenBuffer[i] = tmpOpen;
		}
		else
			dOpenBuffer[i] = EMPTY_VALUE;
	

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

