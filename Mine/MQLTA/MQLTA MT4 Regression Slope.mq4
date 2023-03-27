#property link          "https://www.earnforex.com/metatrader-indicators/linear-regression-slope/"
#property version       "1.01"
#property strict
#property copyright     "EarnForex.com - 2019-2021"
#property description   "A regression slope following the candles"
#property description   " "
#property description   "WARNING : You use this software at your own risk."
#property description   "The creator of these plugins cannot be held responsible for damage or loss."
#property description   " "
#property description   "Find More on EarnForex.com"
#property icon          "\\Files\\EF-Icon-64x64px.ico"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 LightSeaGreen
#property indicator_type1 DRAW_HISTOGRAM
#property indicator_width1  3
#property indicator_label1  "Regression Slope"
#property indicator_level1 0
#property indicator_levelstyle STYLE_DOT

/*

When using iCustom pay attention at the calculation because at every candle shift all the values will change
Buffer 0 = Regression Slope

*/

#include <Math\Alglib\alglib.mqh>

input string Comment1="========================";   //MQLTA Regression Channel
input string IndicatorName="MQLTA-REGSLOPE";    //Indicator Short Name

input string Comment2="========================";   //Indicator Parameters
input int RegChannelInterval=20;             //Candles To Include In The Calculation
input int RegChannelShift=0;                 //Delay In The Channel
input int RegLimit=1000;                     //Bars To Draw (0=No Limit)
bool iCustomMode=false;                //Enable iCustom Mode

double ChannelSlope[];
int Shift=0;


int OnInit(void){

   IndicatorSetString(INDICATOR_SHORTNAME,IndicatorName);

   OnInitInitialization();
   if(!OnInitPreChecksPass()){
      return(INIT_FAILED);
   }   

   InitialiseBuffers();

   return(INIT_SUCCEEDED);
}


int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[]){

   int UpTo=0;
   if(prev_calculated==0){
      ArrayFill(ChannelSlope,0,ArraySize(ChannelSlope),EMPTY_VALUE);
      if(RegLimit==0) UpTo=Bars(Symbol(),PERIOD_CURRENT);
      else UpTo=RegLimit;
   }
   else UpTo=1;
   
   for(int k=0;k<UpTo;k++){
      int Vars=1;
      CMatrixDouble TimePrice(RegChannelInterval,Vars+1);
      for(int j=0;j<RegChannelInterval;j++){
         int i=j+k;
         TimePrice[j].Set(0,i);
         TimePrice[j].Set(1,iClose(Symbol(),PERIOD_CURRENT,i+RegChannelShift));
      }
      int Info;
      CLinearModelShell LinearModel;
      CLRReportShell Ar;
      double LinearCoefficient[];
      CAlglib::LRBuild(TimePrice,RegChannelInterval,Vars,Info,LinearModel,Ar);
      CAlglib::LRUnpack(LinearModel,LinearCoefficient,Vars);
      ChannelSlope[k]=-LinearCoefficient[0];
   }
   if(CheckIfNewCandle()){
      
   }

   if(IsStopped()) return(0);
      
   return(rates_total);
}
  
  
void OnDeinit(const int reason){

}  


void OnInitInitialization(){

}


bool OnInitPreChecksPass(){
   if(RegChannelInterval<=0 || RegChannelShift<0){
      Print("Wrong input parameter, period and delay can't be less than zero");
      return false;
   }   
   if(Bars(Symbol(),PERIOD_CURRENT)<RegChannelInterval+RegChannelShift){
      Print("Not Enough Historical Candles");
      return false;
   }   
   return true;
}


void InitialiseHandles(){

}


void InitialiseBuffers(){
   IndicatorSetInteger(INDICATOR_DIGITS,_Digits);
   ArraySetAsSeries(ChannelSlope,true);
   SetIndexBuffer(0,ChannelSlope,INDICATOR_DATA);
}


datetime NewCandleTime=TimeCurrent();
bool CheckIfNewCandle(){
   if(NewCandleTime==iTime(Symbol(),0,0)) return false;
   else{
      NewCandleTime=iTime(Symbol(),0,0);
      return true;
   }
}

