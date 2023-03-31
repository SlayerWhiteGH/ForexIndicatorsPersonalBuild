//+------------------------------------------------------------------+
//|                                        BBMA MA TRICK 2022.mq4 |
//|                                                Copyright 2022 |
//|                           https://www.facebook.com/Zhou.FanFx |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, W H I T E"
#property link      "W H I T E"
#property strict
#property description " "
#property description " "
#property description " "
#property description "                     --- @2022 --- "
#property indicator_chart_window
#property indicator_buffers 32

enum eModeLine       {_0L/*Solid*/,_1L/*Dash*/,_2L/*Dot*/,_3L/*Dash Dot*/,_4L/*Dash Dot Dot*/};
enum eDis            {eDis0/*Disable*/,eDis1/*Show MA*/,eDis2/*Show SD*/,eDis3/*Show MA & SD*/};
enum eModeBB         {_DisableBB/*Disable*/,_shSD2/*Show BB SD 2*/};


input bool iOn                   = true;           //Indicator On
input bool bbmaoa                = true;           //BBMA 40
input bool xlsma                 = false;          //LSMA MODE
input bool matall                = false;          //Turn OFF MATrick 
input double   vDev              = 2.0;//Deviation
   
input string                 _000;//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
input ENUM_APPLIED_PRICE
               appPrice          = PRICE_CLOSE;//MA Applied Price
input string                     _00;//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
input bool Entry1                = true;   //TF Active
input eModeBB  s1ModeBB          = _shSD2;  //BB Period 01 
input color    clSMA1            = clrAqua,//MA Color Period 01
               clSDP1            = clrBlue,//SD Plus Color Period 01
               clSDM1            = clrBlue;//SD Minus Color Period 01
input string                     _01;//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
input bool Entry2                = true;   //TFx Active
input eModeBB  s2ModeBB          = _shSD2;//BB Period 02 
input color    clSMA2            = clrWhite,   //MA Color Period 02
               clSDP2            = clrDimGray,   //SD Plus Color Period 02
               clSDM2            = clrDimGray;   //SD Minus Color Period 02
input string                     _02;//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
input bool Entry3                = false;   //TF Upward
input eModeBB  s3ModeBB          = _DisableBB;//BB Period 03
input color    clSMA3            = clrDodgerBlue,   //MA Color Period 03
               clSDP3            = clrDodgerBlue,   //SD Plus Color Period 03
               clSDM3            = clrDodgerBlue;   //SD Minus Color Period 03
input string                     _03;//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  
input bool Entry4                = false;   //TFx Upward
input eModeBB  s4ModeBB          = _DisableBB;//BB Period 04            
input color    clSMA4            = clrNONE,   //MA Color Period 04
               clSDP4            = clrNONE,   //SD Plus Color Period 04
               clSDM4            = clrNONE;   //SD Minus Color Period 04 
input string                     _04;//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  
input bool Entry5                = false;   //TF 2 Upward
input eModeBB  s5ModeBB          = _DisableBB;//BB Period 05         
input color    clSMA5            = clrNONE,   //MA Color Period 05
               clSDP5            = clrNONE,   //SD Plus Color Period 05
               clSDM5            = clrNONE;   //SD Minus Color Period 05               
input string                     _05;//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 
input color    clMAHIGH          = clrRed,//LWMA HIGH Color 
               clMALOW           = clrDodgerBlue,//LWMA LOW Color
               clMASh            = clrDimGray;//LWMA Shadow Color
            


string iName; 
int    iP0,iP1,iP2,iP3,iP4,iP5,
       tP0,tP1,tP2,tP3,tP4,tP5;
       
double 
SMA01[],SDP01[],SDM01[],SMAT01[],
SMA02[],SDP02[],SDM02[],SMAT02[],
SMA03[],SDP03[],SDM03[],SMAT03[],
SMA04[],SDP04[],SDM04[],SMAT04[],
SMA05[],SDP05[],SDM05[],SMAT05[],


HLWMA01[],HLWMA02[],LLWMA01[],LLWMA02[],
HLWMASH01[],HLWMASH02[],HLWMASH03[],HLWMASH04[],
LLWMASH01[],LLWMASH02[],LLWMASH03[],LLWMASH04[];

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#define shMA 1
#define shD1 2
#define shD2 3
#define shMAT 4

bool BB1_enable = s1ModeBB==_shSD2,
     BB2_enable = s2ModeBB==_shSD2,
     BB3_enable = s3ModeBB==_shSD2,
     BB4_enable = s4ModeBB==_shSD2,
     BB5_enable = s5ModeBB==_shSD2;

       

//+==================================================================+
//| Custom indicator initialization function                         |
//+==================================================================+ 
int OnInit() {
//--- code start
{
int my_acc = (int)AccountInfoInteger(ACCOUNT_LOGIN);
   //--- add as many accounts as necessary -- example-
int AccNbr[] = { 1300010838,
                 2100269645,6821216,8409880,12049506,19044318,
               };
bool is_auth = false;
for(int i=0;i<ArraySize(AccNbr);i++)
   if(AccNbr[i] == my_acc)
      is_auth = true;
 
   if(is_auth)
     {Comment("");}
   else 
     {
     Comment("Account : Not Authorized  |  EXPIRE 05.11.2023");
     datetime TrialEndDate = D'01.11.2023 23:00:00'; // <-- write here the date when you the MT4 program stops
     if (TimeCurrent() > TrialEndDate)
     {Alert("Trial period has expired!"); return(-1);}
     }  
}
//--- code end 
if(WindowExpertName()!="!BBMA OA MTF 2022"){
      Alert("Warning !!!\n INDICATOR'S NAME HAS BEEN CHANGED '"+WindowExpertName()+"'\n PLEASE RETURN TO '"+"!BBMA KG MATrick 2022"+"'");
      ChartIndicatorDelete(0,0,WindowExpertName());}
      
   iName="!BBMA OA MTF 2022";   
    
   //SMA    
   iP1=StrToInteger(getPer(95,0,1));
   iP2=StrToInteger(getPer(96,0,1));
   iP3=StrToInteger(getPer(97,0,1));
   iP4=StrToInteger(getPer(98,0,1));
   iP5=StrToInteger(getPer(99,0,1));
   
   tP1=StrToInteger(getPer(105,0,1));
   tP2=StrToInteger(getPer(106,0,1));
   tP3=StrToInteger(getPer(107,0,1));
   tP4=StrToInteger(getPer(108,0,1));
   tP5=StrToInteger(getPer(109,0,1));
    
   IndicatorBuffers(27);
   
   SetIndexBuffer(0,HLWMA01); SetIndexStyle(0,0,0,1,getClr(0,0,false,clMAHIGH));
   SetIndexBuffer(1,HLWMA02); SetIndexStyle(1,0,0,1,getClr(0,0,false,clMAHIGH));
   SetIndexBuffer(2,LLWMA01); SetIndexStyle(2,0,0,1,getClr(0,0,false,clMALOW));
   SetIndexBuffer(3,LLWMA02); SetIndexStyle(3,0,0,1,getClr(0,0,false,clMALOW));
      
   SetIndexBuffer(4,HLWMASH01); SetIndexStyle(4,0,2,1,getClr(0,0,false,clMASh));
   SetIndexBuffer(5,HLWMASH02); SetIndexStyle(5,0,2,1,getClr(0,0,false,clMASh));
   SetIndexBuffer(6,HLWMASH03); SetIndexStyle(6,0,2,1,getClr(0,0,false,clMASh));
   SetIndexBuffer(7,HLWMASH04); SetIndexStyle(7,0,2,1,getClr(0,0,false,clMASh));
   
   SetIndexBuffer(8,LLWMASH01);  SetIndexStyle(8,0,2,1,getClr(0,0,false,clMASh));
   SetIndexBuffer(9,LLWMASH02);  SetIndexStyle(9,0,2,1,getClr(0,0,false,clMASh));
   SetIndexBuffer(10,LLWMASH03); SetIndexStyle(10,0,2,1,getClr(0,0,false,clMASh));
   SetIndexBuffer(11,LLWMASH04); SetIndexStyle(11,0,2,1,getClr(0,0,false,clMASh));
   
   SetIndexBuffer(12,SMA01); SetIndexStyle(12,0,0,1,getClr(95,0,true,clSMA1)); SetIndexLabel(12,"MidBB " +getPer(95,0,0,false)+"");  
   SetIndexBuffer(13,SDP01); SetIndexStyle(13,BB1_enable?0:12,0,1,getClr(95,0,true,clSDP1)); SetIndexLabel(13,"BB20UPR_SD _" +getPer(95,0,0,false)+"");
   SetIndexBuffer(14,SDM01); SetIndexStyle(14,BB1_enable?0:12,0,1,getClr(95,0,true,clSDM1)); SetIndexLabel(14,"BB20LWR_SD _" +getPer(95,0,0,false)+"");

   SetIndexBuffer(15,SMA02); SetIndexStyle(15,0,0,1,getClr(96,0,true,clSMA2)); SetIndexLabel(15,"MidBB " +getPer(96,0,0,false)+"");  
   SetIndexBuffer(16,SDP02); SetIndexStyle(16,BB2_enable?0:12,4,1,getClr(96,0,true,clSDP2)); SetIndexLabel(16,"BB20UPR_SD _" +getPer(96,0,0,false)+"");
   SetIndexBuffer(17,SDM02); SetIndexStyle(17,BB2_enable?0:12,4,1,getClr(96,0,true,clSDM2)); SetIndexLabel(17,"BB20LWR_SD _" +getPer(96,0,0,false)+"");
   
   SetIndexBuffer(18,SMA03); SetIndexStyle(18,0,0,1,getClr(97,0,true,clSMA3)); SetIndexLabel(18,"MidBB " +getPer(97,0,0,false)+"");  
   SetIndexBuffer(19,SDP03); SetIndexStyle(19,BB3_enable?0:12,4,1,getClr(97,0,true,clSDP3)); SetIndexLabel(19,"BB20UPR_SD _" +getPer(97,0,0,false)+"");
   SetIndexBuffer(20,SDM03); SetIndexStyle(20,BB3_enable?0:12,4,1,getClr(97,0,true,clSDM3)); SetIndexLabel(20,"BB20LWR_SD _" +getPer(97,0,0,false)+"");

   SetIndexBuffer(21,SMA04); SetIndexStyle(21,0,0,1,getClr(98,0,true,clSMA4)); SetIndexLabel(21,"MidBB " +getPer(98,0,0,false)+""); 
   SetIndexBuffer(22,SDP04); SetIndexStyle(22,BB4_enable?0:12,4,1,getClr(98,0,true,clSDP4)); SetIndexLabel(22,"BB20UPR_SD _" +getPer(98,0,0,false)+"");
   SetIndexBuffer(23,SDM04); SetIndexStyle(23,BB4_enable?0:12,4,1,getClr(98,0,true,clSDM4)); SetIndexLabel(23,"BB20LWR_SD _" +getPer(98,0,0,false)+"");
   
   SetIndexBuffer(24,SMA05); SetIndexStyle(24,0,0,1,getClr(99,0,true,clSMA5)); SetIndexLabel(24,"MidBB " +getPer(99,0,0,false)+"");
   SetIndexBuffer(25,SDP05); SetIndexStyle(25,BB5_enable?0:12,4,1,getClr(99,0,true,clSDP5)); SetIndexLabel(25,"BB20UPR_SD _" +getPer(99,0,0,false)+"");
   SetIndexBuffer(26,SDM05); SetIndexStyle(26,BB5_enable?0:12,4,1,getClr(99,0,true,clSDM5)); SetIndexLabel(26,"BB20LWR_SD _" +getPer(99,0,0,false)+"");
   
   
   SetIndexBuffer(27,SMAT01);SetIndexStyle(27,0,2,1,(matall==true)?clrNONE:getClr(105,0,true,clSMA1)); SetIndexLabel(27,"MaTrick " +getPer(105,0,0,false)+"");
   SetIndexBuffer(28,SMAT02);SetIndexStyle(28,0,2,1,(matall==true)?clrNONE:getClr(106,0,true,clSMA2)); SetIndexLabel(28,"MaTrick " +getPer(106,0,0,false)+"");
   SetIndexBuffer(29,SMAT03);SetIndexStyle(29,0,2,1,(matall==true)?clrNONE:getClr(107,0,true,clSMA3)); SetIndexLabel(29,"MaTrick " +getPer(107,0,0,false)+"");  
   SetIndexBuffer(30,SMAT04);SetIndexStyle(30,0,2,1,(matall==true)?clrNONE:getClr(108,0,true,clSMA4)); SetIndexLabel(30,"MaTrick " +getPer(108,0,0,false)+"");  
   SetIndexBuffer(31,SMAT05);SetIndexStyle(31,0,2,1,(matall==true)?clrNONE:getClr(109,0,true,clSMA5)); SetIndexLabel(31,"MaTrick " +getPer(109,0,0,false)+"");  
   
   return(INIT_SUCCEEDED);
}
//+==================================================================+
//| Custom indicator deinitialization function                       |
//+==================================================================+
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
int DrawBegin(int inpModeBar,int inpPer){
   return(inpModeBar==1?((Bars-WindowFirstVisibleBar())<inpPer?(Bars-WindowFirstVisibleBar())+inpPer:Bars-WindowFirstVisibleBar()):
          inpModeBar==2?Bars-inpPer:0);
}
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
double getSMA(int inpPer,int shift=0,double StDev=1){
   double R=0,S=0,PosisiHarga=0;
   for(int j=1; j<=inpPer; j++){
		PosisiHarga = iMA(_Symbol,_Period,1,0,MODE_SMA,PRICE_CLOSE,shift+j-1);
		R	+= PosisiHarga;
    	S	+= PosisiHarga*PosisiHarga;
	}//R/inpPer //SMA
   return((MathSqrt(((inpPer*S)-(R*R))/(inpPer*inpPer))*StDev));
}
//+==================================================================+
//| Custom indicator iteration function                              |
//+==================================================================+
int OnCalculate(const int rates_total,const int prev_calculated,const datetime &time[],
                const double &open[],const double &high[],const double &low[],const double &close[],
                const long &tick_volume[],const long &volume[],const int &spread[]){
   if(!iOn) return(0);
        
   for(int j=0; j<9; j++)
      SetIndexDrawBegin(j,DrawBegin(Bars,j<=2?iP3:j>=3&&j<=5?iP2:iP1));
        
   for(int i=0; i<MathMin(Bars-IndicatorCounted(),Bars-1); i++){
     
      //SMA/MIDBB

      SMA01[i] = Entry1?iMA(_Symbol,_Period,bbmaoa?iP1*2:iP1,0,MODE_SMA,PRICE_CLOSE,i):EMPTY_VALUE;
      SDP01[i] = BB1_enable?SMA01[i]+getSMA(bbmaoa?iP1*2:iP1,i,vDev):EMPTY_VALUE;
      SDM01[i] = BB1_enable?SMA01[i]-getSMA(bbmaoa?iP1*2:iP1,i,vDev):EMPTY_VALUE;
      
      SMA02[i] = Entry2?iMA(_Symbol,_Period,bbmaoa?iP2*2:iP2,0,MODE_SMA,PRICE_CLOSE,i):EMPTY_VALUE;
      SDP02[i] = BB2_enable?SMA02[i]+getSMA(bbmaoa?iP2*2:iP2,i,vDev):EMPTY_VALUE;
      SDM02[i] = BB2_enable?SMA02[i]-getSMA(bbmaoa?iP2*2:iP2,i,vDev):EMPTY_VALUE;
      
      SMA03[i] = Entry3?iMA(_Symbol,_Period,bbmaoa?iP3*2:iP3,0,MODE_SMA,PRICE_CLOSE,i):EMPTY_VALUE;
      SDP03[i] = BB3_enable?SMA03[i]+getSMA(bbmaoa?iP3*2:iP3,i,vDev):EMPTY_VALUE;
      SDM03[i] = BB3_enable?SMA03[i]-getSMA(bbmaoa?iP3*2:iP3,i,vDev):EMPTY_VALUE;
       
      SMA04[i] = Entry4?iMA(_Symbol,_Period,bbmaoa?iP4*2:iP4,0,MODE_SMA,PRICE_CLOSE,i):EMPTY_VALUE;
      SDP04[i] = BB4_enable?SMA04[i]+getSMA(bbmaoa?iP4*2:iP4,i,vDev):EMPTY_VALUE;
      SDM04[i] = BB4_enable?SMA04[i]-getSMA(bbmaoa?iP4*2:iP4,i,vDev):EMPTY_VALUE;
            
      SMA05[i] = Entry5?iMA(_Symbol,_Period,bbmaoa?iP5*2:iP5,0,MODE_SMA,PRICE_CLOSE,i):EMPTY_VALUE;
      SDP05[i] = BB5_enable?SMA05[i]+getSMA(bbmaoa?iP5*2:iP5,i,vDev):EMPTY_VALUE;
      SDM05[i] = BB5_enable?SMA05[i]-getSMA(bbmaoa?iP5*2:iP5,i,vDev):EMPTY_VALUE;
      
      SMAT01[i] = Entry1? (3*iMA(_Symbol,_Period,bbmaoa?tP1*2:tP1,0,(xlsma==true)?MODE_LWMA:MODE_EMA,PRICE_CLOSE,i)) - (2*iMA(_Symbol,_Period,bbmaoa?tP1*2:tP1,0,MODE_SMA,PRICE_CLOSE,i)):EMPTY_VALUE; 
      SMAT02[i] = Entry2? (3*iMA(_Symbol,_Period,bbmaoa?tP2*2:tP2,0,(xlsma==true)?MODE_LWMA:MODE_EMA,PRICE_CLOSE,i)) - (2*iMA(_Symbol,_Period,bbmaoa?tP2*2:tP2,0,MODE_SMA,PRICE_CLOSE,i)):EMPTY_VALUE; 
      SMAT03[i] = Entry3? (3*iMA(_Symbol,_Period,bbmaoa?tP3*2:tP3,0,(xlsma==true)?MODE_LWMA:MODE_EMA,PRICE_CLOSE,i)) - (2*iMA(_Symbol,_Period,bbmaoa?tP3*2:tP3,0,MODE_SMA,PRICE_CLOSE,i)):EMPTY_VALUE; 
      SMAT04[i] = Entry4? (3*iMA(_Symbol,_Period,bbmaoa?tP4*2:tP4,0,(xlsma==true)?MODE_LWMA:MODE_EMA,PRICE_CLOSE,i)) - (2*iMA(_Symbol,_Period,bbmaoa?tP4*2:tP4,0,MODE_SMA,PRICE_CLOSE,i)):EMPTY_VALUE; 
      SMAT05[i] = Entry5? (3*iMA(_Symbol,_Period,bbmaoa?tP5*2:tP5,0,(xlsma==true)?MODE_LWMA:MODE_EMA,PRICE_CLOSE,i)) - (2*iMA(_Symbol,_Period,bbmaoa?tP5*2:tP5,0,MODE_SMA,PRICE_CLOSE,i)):EMPTY_VALUE; 
      
      
      HLWMA01[i] = iMA(_Symbol,_Period,bbmaoa?10:5,0,MODE_LWMA,PRICE_HIGH,i);
      HLWMA02[i] = iMA(_Symbol,_Period,bbmaoa?20:10,0,MODE_LWMA,PRICE_HIGH,i);
      LLWMA01[i] = iMA(_Symbol,_Period,bbmaoa?10:5,0,MODE_LWMA,PRICE_LOW,i);
      LLWMA02[i] = iMA(_Symbol,_Period,bbmaoa?20:10,0,MODE_LWMA,PRICE_LOW,i);
      
      HLWMASH01[i] = iMA(_Symbol,_Period,bbmaoa?12:6,0,MODE_LWMA,PRICE_HIGH,i);
      HLWMASH02[i] = iMA(_Symbol,_Period,bbmaoa?14:7,0,MODE_LWMA,PRICE_HIGH,i);
      HLWMASH03[i] = iMA(_Symbol,_Period,bbmaoa?16:8,0,MODE_LWMA,PRICE_HIGH,i);
      HLWMASH04[i] = iMA(_Symbol,_Period,bbmaoa?18:9,0,MODE_LWMA,PRICE_HIGH,i);
      
      LLWMASH01[i] = iMA(_Symbol,_Period,bbmaoa?12:6,0,MODE_LWMA,PRICE_LOW,i);
      LLWMASH02[i] = iMA(_Symbol,_Period,bbmaoa?14:7,0,MODE_LWMA,PRICE_LOW,i);
      LLWMASH03[i] = iMA(_Symbol,_Period,bbmaoa?16:8,0,MODE_LWMA,PRICE_LOW,i);
      LLWMASH04[i] = iMA(_Symbol,_Period,bbmaoa?18:9,0,MODE_LWMA,PRICE_LOW,i);
  
    }
return(rates_total);
}

//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
color  getClr(int enumPer,int manPer,bool clrLight=true,color inpClr=clrNONE){
   return(inpClr==clrNONE||inpClr==2147483647?StringToColor(getPer(enumPer,manPer,2,clrLight)):inpClr);
}
string getPer(int enumPer,int manPer,int modeRes=0,bool mClr=true){
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
   string strPer="";
   int    mn=20,hr=1200,dy=28800,wk=201600,mh=806400,yr=9676800,intPer=0;
   color clrPer=clrNONE;
   switch(enumPer){
      case  0: strPer= IntegerToString(manPer);  intPer=manPer;   clrPer=mClr?C'250,250,250':C'100,100,100';  break;
          
      case 95: switch(_Period){
                  case  PERIOD_M1 : strPer= "M1";  intPer=            mn;   clrPer=mClr?C'000,000,000':C'000,000,000';  break;/*TF Active / PERIOD 20*/
                  case  PERIOD_M5 : strPer= "M5";  intPer=          5*mn;   clrPer=mClr?C'128,000,128':C'128,000,128';  break;
                  case  PERIOD_M15: strPer= "M15"; intPer=         15*mn;   clrPer=mClr?C'000,000,255':C'000,000,255';  break;
                  case  PERIOD_M30: strPer= "M30"; intPer=         30*mn;   clrPer=mClr?C'255,140,000':C'255,140,000';  break;
                  case  PERIOD_H1 : strPer= "H1";  intPer=            hr;   clrPer=mClr?C'255,000,000':C'125,000,000';  break;
                  case  PERIOD_H4 : strPer= "H4";  intPer=          4*hr;   clrPer=mClr?C'000,100,000':C'000,100,000';  break;
                  case  PERIOD_D1 : strPer= "D1";  intPer=            dy;   clrPer=mClr?C'000,000,255':C'000,000,255';  break;
                  case  PERIOD_W1 : strPer= "W1";  intPer=            wk;   clrPer=mClr?C'255,000,255':C'255,000,255';  break;
                  case  PERIOD_MN1: strPer= "MN1"; intPer=         30*dy;   clrPer=mClr?C'000,128,000':C'000,128,000';  break;
               } break;
 
      case 96: switch(_Period){
                  case  PERIOD_M1 : strPer= "M5";  intPer=          5*mn;   clrPer=mClr?C'128,000,128':C'128,000,128';  break;/*TFX / PERIOD 20 ACUAN 1*/
                  case  PERIOD_M5 : strPer= "M15"; intPer=         15*mn;   clrPer=mClr?C'000,000,255':C'000,000,255';  break;
                  case  PERIOD_M15: strPer= "H1";  intPer=            hr;   clrPer=mClr?C'255,000,000':C'125,000,000';  break;
                  case  PERIOD_M30: strPer= "H1";  intPer=            hr;   clrPer=mClr?C'255,000,000':C'125,000,000';  break;
                  case  PERIOD_H1 : strPer= "H4";  intPer=          4*hr;   clrPer=mClr?C'000,100,000':C'000,100,000';  break;
                  case  PERIOD_H4 : strPer= "D1";  intPer=            dy;   clrPer=mClr?C'000,000,255':C'000,000,255';  break;
                  case  PERIOD_D1 : strPer= "W1";  intPer=            wk;   clrPer=mClr?C'255,000,255':C'255,000,255';  break;
                  case  PERIOD_W1 : strPer= "MN1"; intPer=         30*dy;   clrPer=mClr?C'000,128,000':C'000,128,000';  break;
               } break;
               
      case 97: switch(_Period){
                  case  PERIOD_M1 : strPer= "M15"; intPer=         15*mn;   clrPer=mClr?C'000,000,255':C'000,000,255';  break;/*TF Up / PERIOD 20 ACUAN 2*/
                  case  PERIOD_M5 : strPer= "H1";  intPer=            hr;   clrPer=mClr?C'255,000,000':C'125,000,000';  break;
                  case  PERIOD_M15: strPer= "H4";  intPer=          4*hr;   clrPer=mClr?C'000,100,000':C'000,100,000';  break;
                  case  PERIOD_M30: strPer= "H4";  intPer=          4*hr;   clrPer=mClr?C'000,100,000':C'000,100,000';  break;
                  case  PERIOD_H1 : strPer= "D1";  intPer=            dy;   clrPer=mClr?C'000,000,255':C'000,000,255';  break;
                  case  PERIOD_H4 : strPer= "W1";  intPer=            wk;   clrPer=mClr?C'255,000,255':C'255,000,255';  break;
                  case  PERIOD_D1 : strPer= "MN1"; intPer=         30*dy;   clrPer=mClr?C'000,128,000':C'000,128,000';  break;
               } break;
               
      case 98: switch(_Period){
                  case  PERIOD_M1 : strPer= "H1";  intPer=            hr;   clrPer=mClr?C'255,000,000':C'125,000,000';  break; /*TFX Up / PERIOD 20 ACUAN 3*/
                  case  PERIOD_M5 : strPer= "H4";  intPer=          4*hr;   clrPer=mClr?C'000,100,000':C'000,100,000';  break;
                  case  PERIOD_M15: strPer= "D1";  intPer=            dy;   clrPer=mClr?C'000,000,255':C'000,000,255';  break;
                  case  PERIOD_M30: strPer= "D1";  intPer=            dy;   clrPer=mClr?C'000,000,255':C'000,000,255';  break;
                  case  PERIOD_H1 : strPer= "W1";  intPer=            wk;   clrPer=mClr?C'255,000,255':C'255,000,255';  break;
                  case  PERIOD_H4 : strPer= "MN1"; intPer=         30*dy;   clrPer=mClr?C'000,128,000':C'000,128,000';  break;

               } break;
      case 99: switch(_Period){
                  case  PERIOD_M1 : strPer= "H4";  intPer=          4*hr;   clrPer=mClr?C'000,100,000':C'000,100,000';  break; /*TF 2 Up / PERIOD 20 ACUAN 4*/
                  case  PERIOD_M5 : strPer= "D1";  intPer=            dy;   clrPer=mClr?C'000,000,255':C'000,000,255';  break;
                  case  PERIOD_M15: strPer= "W1";  intPer=            wk;   clrPer=mClr?C'255,000,255':C'255,000,255';  break;
                  case  PERIOD_M30: strPer= "W1";  intPer=            wk;   clrPer=mClr?C'255,000,255':C'255,000,255';  break;
               } break;
      
      //------------------------------------------------------------------------------------------------------------------------//
      
      case 105: switch(_Period){
                  case  PERIOD_M1 : strPer= "M1";  intPer=            mn*2;   clrPer=mClr?C'000,000,000':C'000,000,000';  break;/*TF Active / PERIOD 20*/
                  case  PERIOD_M5 : strPer= "M5";  intPer=          5*mn*2;   clrPer=mClr?C'128,000,128':C'128,000,128';  break;
                  case  PERIOD_M15: strPer= "M15"; intPer=         15*mn*2;   clrPer=mClr?C'000,000,255':C'000,000,255';  break;
                  case  PERIOD_M30: strPer= "M30"; intPer=         30*mn*2;   clrPer=mClr?C'255,140,000':C'255,140,000';  break;
                  case  PERIOD_H1 : strPer= "H1";  intPer=            hr*2;   clrPer=mClr?C'255,000,000':C'125,000,000';  break;
                  case  PERIOD_H4 : strPer= "H4";  intPer=          4*hr*2;   clrPer=mClr?C'000,100,000':C'000,100,000';  break;
                  case  PERIOD_D1 : strPer= "D1";  intPer=            dy*2;   clrPer=mClr?C'000,000,255':C'000,000,255';  break;
                  case  PERIOD_W1 : strPer= "W1";  intPer=            wk*2;   clrPer=mClr?C'255,000,255':C'255,000,255';  break;
                  case  PERIOD_MN1: strPer= "MN1"; intPer=         30*dy*2;   clrPer=mClr?C'000,128,000':C'000,128,000';  break;
               } break;
 
      case 106: switch(_Period){
                  case  PERIOD_M1 : strPer= "M5";  intPer=          5*mn*2;   clrPer=mClr?C'128,000,128':C'128,000,128';  break;/*TFX / PERIOD 20 ACUAN 1*/
                  case  PERIOD_M5 : strPer= "M15"; intPer=         15*mn*2;   clrPer=mClr?C'000,000,255':C'000,000,255';  break;
                  case  PERIOD_M15: strPer= "H1";  intPer=            hr*2;   clrPer=mClr?C'255,000,000':C'125,000,000';  break;
                  case  PERIOD_M30: strPer= "H1";  intPer=            hr*2;   clrPer=mClr?C'255,000,000':C'125,000,000';  break;
                  case  PERIOD_H1 : strPer= "H4";  intPer=          4*hr*2;   clrPer=mClr?C'000,100,000':C'000,100,000';  break;
                  case  PERIOD_H4 : strPer= "D1";  intPer=            dy*2;   clrPer=mClr?C'000,000,255':C'000,000,255';  break;
                  case  PERIOD_D1 : strPer= "W1";  intPer=            wk*2;   clrPer=mClr?C'255,000,255':C'255,000,255';  break;
                  case  PERIOD_W1 : strPer= "MN1"; intPer=         30*dy*2;   clrPer=mClr?C'000,128,000':C'000,128,000';  break;
               } break;
               
      case 107: switch(_Period){
                  case  PERIOD_M1 : strPer= "M15"; intPer=         15*mn*2;   clrPer=mClr?C'000,000,255':C'000,000,255';  break;/*TF Up / PERIOD 20 ACUAN 2*/
                  case  PERIOD_M5 : strPer= "H1";  intPer=            hr*2;   clrPer=mClr?C'255,000,000':C'125,000,000';  break;
                  case  PERIOD_M15: strPer= "H4";  intPer=          4*hr*2;   clrPer=mClr?C'000,100,000':C'000,100,000';  break;
                  case  PERIOD_M30: strPer= "H4";  intPer=          4*hr*2;   clrPer=mClr?C'000,100,000':C'000,100,000';  break;
                  case  PERIOD_H1 : strPer= "D1";  intPer=            dy*2;   clrPer=mClr?C'000,000,255':C'000,000,255';  break;
                  case  PERIOD_H4 : strPer= "W1";  intPer=            wk*2;   clrPer=mClr?C'255,000,255':C'255,000,255';  break;
                  case  PERIOD_D1 : strPer= "MN1"; intPer=         30*dy*2;   clrPer=mClr?C'000,128,000':C'000,128,000';  break;
               } break;
               
      case 108: switch(_Period){
                  case  PERIOD_M1 : strPer= "H1";  intPer=            hr*2;   clrPer=mClr?C'255,000,000':C'125,000,000';  break; /*TFX Up / PERIOD 20 ACUAN 3*/
                  case  PERIOD_M5 : strPer= "H4";  intPer=          4*hr*2;   clrPer=mClr?C'000,100,000':C'000,100,000';  break;
                  case  PERIOD_M15: strPer= "D1";  intPer=            dy*2;   clrPer=mClr?C'000,000,255':C'000,000,255';  break;
                  case  PERIOD_M30: strPer= "D1";  intPer=            dy*2;   clrPer=mClr?C'000,000,255':C'000,000,255';  break;
                  case  PERIOD_H1 : strPer= "W1";  intPer=            wk*2;   clrPer=mClr?C'255,000,255':C'255,000,255';  break;
                  case  PERIOD_H4 : strPer= "MN1"; intPer=         30*dy*2;   clrPer=mClr?C'000,128,000':C'000,128,000';  break;

               } break;
      case 109: switch(_Period){
                  case  PERIOD_M1 : strPer= "H4";  intPer=          4*hr*2;   clrPer=mClr?C'000,100,000':C'000,100,000';  break; /*TF 2 Up / PERIOD 20 ACUAN 4*/
                  case  PERIOD_M5 : strPer= "D1";  intPer=            dy*2;   clrPer=mClr?C'000,000,255':C'000,000,255';  break;
                  case  PERIOD_M15: strPer= "W1";  intPer=            wk*2;   clrPer=mClr?C'255,000,255':C'255,000,255';  break;
                  case  PERIOD_M30: strPer= "W1";  intPer=            wk*2;   clrPer=mClr?C'255,000,255':C'255,000,255';  break;
               } break;
                        
      default: strPer="";  intPer=0; clrPer=clrNONE;      
   }
   switch(modeRes){
      case  1: return(enumPer==0?IntegerToString(intPer):IntegerToString((int)MathCeil(intPer/_Period))); break;
      case  2: return(ColorToString(clrPer)); break;
      default: return(strPer);
   }
}
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
bool LimitTF(int inpEnumPer,int inpManPer){
   string iPX=getPer(inpEnumPer,inpManPer,0);
   int MinTF, MaxTF;
        if(iPX=="1Yr") {MinTF=PERIOD_H4;  MaxTF=PERIOD_MN1;}
   else if(iPX=="4Mh") {MinTF=PERIOD_H4;  MaxTF=PERIOD_MN1;}
   else if(iPX=="1Mh") {MinTF=PERIOD_M30; MaxTF=PERIOD_MN1;}
   else if(iPX=="2Wk") {MinTF=PERIOD_M1;  MaxTF=PERIOD_MN1;}
   else if(iPX=="1Wk") {MinTF=PERIOD_M1;  MaxTF=PERIOD_MN1;}
   else if(iPX=="2Dy") {MinTF=PERIOD_M1;  MaxTF=PERIOD_W1; }
   else if(iPX=="1Dy") {MinTF=PERIOD_M1;  MaxTF=PERIOD_W1; }
   else if(iPX=="4Hr") {MinTF=PERIOD_M1;  MaxTF=PERIOD_D1; }
   else if(iPX=="2Hr") {MinTF=PERIOD_M1;  MaxTF=PERIOD_H4; }
   else if(iPX=="1Hr") {MinTF=PERIOD_M1;  MaxTF=PERIOD_H4; }
   else if(iPX=="15Mn"){MinTF=PERIOD_M1;  MaxTF=PERIOD_H1; }
   else if(iPX=="8Mn") {MinTF=PERIOD_M1;  MaxTF=PERIOD_M15;}
   else if(iPX=="5Mn") {MinTF=PERIOD_M1;  MaxTF=PERIOD_M15;}
   else if(iPX=="2Mn") {MinTF=PERIOD_M1;  MaxTF=PERIOD_M15;}
   else if(iPX=="1Mn") {MinTF=PERIOD_M1;  MaxTF=PERIOD_M5; }
    
   else                {MinTF=PERIOD_M1;  MaxTF=PERIOD_MN1;}
   return(_Period>=MinTF && _Period<=MaxTF?true:false);
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
void Sett(bool Action){
   ResetLastError();
   if(!Action){
      Print(__FUNCTION__,": failed to draw = ",GetLastError());
      return;
   }
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
bool cLabel(const long              chart_ID=0,               // chart's ID 
               const string            name="Label",             // label name 
               const int               x=0,                      // X coordinate 
               const int               y=0,                      // Y coordinate 
               const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // chart corner for anchoring 
               const string            text="Label",             // text 
               const string            font="Arial",             // font 
               const int               font_size=10,             // font size 
               const color             clr=clrRed,               // color 
               const double            angle=0.0,                // text slope 
               const ENUM_ANCHOR_POINT anchor=ANCHOR_RIGHT_UPPER, // anchor type 
               const bool              back=false,               // in the background 
               const bool              selection=false,          // highlight to move 
               const bool              hidden=true,              // hidden in the object list 
               const long              z_order=0){               // priority for mouse click 
   ResetLastError(); 
   string Name=iName+name;
   if(ObjectFind(Name)==WRONG_VALUE)
      ObjectCreate(chart_ID,Name,OBJ_LABEL,0,0,0); 
   ObjectSetInteger(chart_ID,Name,OBJPROP_XDISTANCE,x); 
   ObjectSetInteger(chart_ID,Name,OBJPROP_YDISTANCE,y); 
   ObjectSetInteger(chart_ID,Name,OBJPROP_CORNER,corner); 
   ObjectSetString(chart_ID,Name,OBJPROP_TEXT,text); 
   ObjectSetString(chart_ID,Name,OBJPROP_FONT,font); 
   ObjectSetInteger(chart_ID,Name,OBJPROP_FONTSIZE,font_size); 
   ObjectSetDouble(chart_ID,Name,OBJPROP_ANGLE,angle); 
   ObjectSetInteger(chart_ID,Name,OBJPROP_ANCHOR,corner==CORNER_LEFT_UPPER?ANCHOR_LEFT_UPPER:
                                                 corner==CORNER_RIGHT_UPPER?ANCHOR_RIGHT_UPPER:
                                                 corner==CORNER_LEFT_LOWER?ANCHOR_LEFT_LOWER:ANCHOR_RIGHT_LOWER);  
   ObjectSetInteger(chart_ID,Name,OBJPROP_COLOR,clr); 
   ObjectSetInteger(chart_ID,Name,OBJPROP_BACK,back); 
   ObjectSetInteger(chart_ID,Name,OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(chart_ID,Name,OBJPROP_SELECTED,selection); 
   ObjectSetInteger(chart_ID,Name,OBJPROP_HIDDEN,hidden);
   ObjectSetInteger(chart_ID,Name,OBJPROP_ZORDER,z_order); 
   ObjectSetString(chart_ID,Name,OBJPROP_TOOLTIP,"\n");  
   return(true); 
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~