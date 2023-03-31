//+------------------------------------------------------------------+
//|                                        !AML KGBS 4P 1.0 2020.mq4 |
//|                                          Copyright 2020, AMLcode |
//|                                https://ammeu-lord.blogspot.co.id |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, AMLcode"
#property link      "https://ammeu-lord.blogspot.co.id"
#property version   "1.00"
#property description " "
#property description " "
#property description " "
#property description "                     -=-=-= BySu@2020 =-=-=-"

#property strict
#property indicator_chart_window
#property indicator_buffers 10


enum  eBars {eBar0/*Load All Bar*/,eBar1/*Visible Bar*/,eBar2/*Load Period Bar*/};
enum	ePer  {P00/*Manual Period*/,
             P95=95/*TF Active*/,P96=96/*TFX Active*/,
             P97=97/*TF Upward*/,P98=98/*TFX Upward*/,P99=99/*TF 2 Upward*/,
             };
enum  eDis  {eDis0/*Disable*/,eDis1/*Show MA*/,eDis2/*Show SD*/,eDis3/*Show MA & SD*/};


input bool     iOn               = true;//Indicator On
input eBars    mBar              = eBar1;//Select Mode Bar
input ENUM_MA_METHOD
               modeMA            = MODE_SMA;//MA Method
input ENUM_APPLIED_PRICE
               appPrice          = PRICE_CLOSE;//MA Applied Price
input double   vDev              = 2.0;//Deviation
input string                     _00;//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
input ePer     slPer1            = P95;//Select Period 01
input int      mnPer1            = 24;//Manual Period 01
input eDis     mBuf1             = 3;//Mode Display Buffer Period 01
input color    clSMA1            = clrSilver,//MA Color Period 01
               clSDP1            = clrSilver,//SD Plus Color Period 01
               clSDM1            = clrSilver;//SD Minus Color Period 01
input string                     _01;//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
input ePer     slPer2            = P96;//Select Period 02
input int      mnPer2            = 48;//Manual Period 02
input eDis     mBuf2             = 3;//Mode Display Buffer Period 02
input color    clSMA2            = clrNONE,//MA Color Period 02
               clSDP2            = clrNONE,//SD Plus Color Period 02
               clSDM2            = clrNONE;//SD Minus Color Period 02
input string                     _02;//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
input ePer     slPer3            = P97;//Select Period 03
input int      mnPer3            = 36;//Manual Period 03
input eDis     mBuf3             = 1;//Mode Display Buffer Period 03
input color    clSMA3            = clrNONE,//MA Color Period 03
               clSDP3            = clrNONE,//SD Plus Color Period 03
               clSDM3            = clrNONE;//SD Minus Color Period 03
input string                     _03;//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-              
input color    clSMA4            = clrBlack;//MA Color Period 03
input string                     _04;//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
input bool     shInfo            = false;//Show Info
input int      disX              = 0,//Horizontal Distance
               disY              = 0;//Vertical Distance
input color    clUbUp            = clrLime,//Text Ubnormal Up Color
               clUbDn            = clrRed,//Text Ubnormal Down Color
               clNormal          = clrGold;//Text Normal Color


string iName; 
int    iP1,iP2,iP3;
double SMA01[],SDP01[],SDM01[],SMA02[],SDP02[],SDM02[],SMA03[],SDP03[],SDM03[],EMA01[];
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#define shMA 1
#define shSD 2
bool  mDis(int inpEnum, int Mode){return(Mode==1 && (inpEnum==1||inpEnum==3)?true:Mode==2 && (inpEnum==2||inpEnum==3)?true:false);}
//+==================================================================+
//| Custom indicator initialization function                         |
//+==================================================================+ 
int OnInit(){
   if(WindowExpertName()!="!AML MABB MULTI 3 PERIOD 2020"){
      Alert("Warning !!!\n Nama Indi berubah '"+WindowExpertName()+"'\n kembalikan menjadi '"+"!AML MABB MULTI 3 PERIOD 2020"+"'");
      ChartIndicatorDelete(0,0,WindowExpertName());
   }
   
   iName="AML MABB 2020 ["+getPer(slPer1,mnPer1)+"|"+getPer(slPer2,mnPer2)+"|"+getPer(slPer3,mnPer3)+"]"; 
   
   iP1=StrToInteger(getPer(slPer1,mnPer1,1));
   iP2=StrToInteger(getPer(slPer2,mnPer2,1));
   iP3=StrToInteger(getPer(slPer3,mnPer3,1));
   
   IndicatorBuffers(10);
   SetIndexBuffer(0,SMA03); SetIndexStyle(0,mDis(mBuf3,shMA)?0:12,0,1,getClr(slPer3,mnPer3,true,clSMA3));
   SetIndexBuffer(1,SDP03); SetIndexStyle(1,mDis(mBuf3,shSD)?0:12,4,1,getClr(slPer3,mnPer3,true,clSDP3));
   SetIndexBuffer(2,SDM03); SetIndexStyle(2,mDis(mBuf3,shSD)?0:12,4,1,getClr(slPer3,mnPer3,true,clSDM3));
   
   SetIndexBuffer(3,SMA02); SetIndexStyle(3,mDis(mBuf2,shMA)?0:12,0,1,getClr(slPer2,mnPer2,true,clSMA2));
   SetIndexBuffer(4,SDP02); SetIndexStyle(4,mDis(mBuf2,shSD)?0:12,4,1,getClr(slPer2,mnPer2,true,clSDP2));
   SetIndexBuffer(5,SDM02); SetIndexStyle(5,mDis(mBuf2,shSD)?0:12,4,1,getClr(slPer2,mnPer2,true,clSDM2));
   
   SetIndexBuffer(6,SMA01); SetIndexStyle(6,mDis(mBuf1,shMA)?0:12,0,1,getClr(slPer1,mnPer1,true,clSMA1));
   SetIndexBuffer(7,SDP01); SetIndexStyle(7,mDis(mBuf1,shSD)?0:12,0,1,getClr(slPer1,mnPer1,true,clSDP1));
   SetIndexBuffer(8,SDM01); SetIndexStyle(8,mDis(mBuf1,shSD)?0:12,0,1,getClr(slPer1,mnPer1,true,clSDM1));
   
   SetIndexBuffer(9,EMA01); SetIndexStyle(9,mDis(mBuf1,shMA)?0:12,0,2,getClr(slPer3,mnPer3,true,clSMA4));
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
		PosisiHarga = iMA(_Symbol,_Period,1,0,modeMA,appPrice,shift+j-1);
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
      SetIndexDrawBegin(j,DrawBegin(mBar,j<=2?iP3:j>=3&&j<=5?iP2:iP1));
   
   int limit = fmax(WindowFirstVisibleBar(),1);
   for(int i=0; i<limit; i++){
      SMA01[i] = iMA(_Symbol,_Period,iP1,0,modeMA,appPrice,i);
      SDP01[i] = SMA01[i]+getSMA(iP1,i,vDev);
      SDM01[i] = SMA01[i]-getSMA(iP1,i,vDev);
   
      SMA02[i] = iMA(_Symbol,_Period,iP2,0,modeMA,appPrice,i);
      SDP02[i] = SMA02[i]+getSMA(iP2,i,vDev);
      SDM02[i] = SMA02[i]-getSMA(iP2,i,vDev);
      
      SMA03[i] = iMA(_Symbol,_Period,iP3,0,modeMA,appPrice,i);
      SDP03[i] = SMA03[i]+getSMA(iP3,i,vDev);
      SDM03[i] = SMA03[i]-getSMA(iP3,i,vDev);
      
      EMA01[i] = iMA(_Symbol,_Period,50,0,MODE_EMA,PRICE_CLOSE,i);
   }
   if(shInfo){
   int posX=disX+10,posY=disY+25;
      Sett(cLabel(0,"HPer1",posX,posY,CORNER_RIGHT_LOWER,getPer(slPer1,mnPer1)+" : "+SetCond(SDP01,SDM01,1),"Arial",10,StringToColor(SetCond(SDP01,SDM01)))); posY+=20;
      Sett(cLabel(0,"HPer2",posX,posY,CORNER_RIGHT_LOWER,getPer(slPer2,mnPer2)+" : "+SetCond(SDP02,SDM02,1),"Arial",10,StringToColor(SetCond(SDP02,SDM02)))); posY+=20;
      Sett(cLabel(0,"HPer3",posX,posY,CORNER_RIGHT_LOWER,getPer(slPer3,mnPer3)+" : "+SetCond(SDP03,SDM03,1),"Arial",10,StringToColor(SetCond(SDP03,SDM03))));
   }
   MARK();
   return(rates_total);
}
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
string SetCond(double &SDP[],double &SDM[],int Mode=2){
   return(Close[0]>MathMax(SDP[0],SDM[0])?(Mode==1?"Buyer's Win":ColorToString(clUbUp)):
          Close[0]<MathMin(SDP[0],SDM[0])?(Mode==1?"Seller's Win":ColorToString(clUbDn)):
          (Mode==1?"No Winner":ColorToString(clNormal)));
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
                  case  PERIOD_M30: strPer= "M30"; intPer=         30*mn;   clrPer=mClr?C'000,000,255':C'000,000,255';  break;
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
        if(iPX=="4Yr") {MinTF=PERIOD_H4;  MaxTF=PERIOD_MN1;}
   else if(iPX=="1Yr") {MinTF=PERIOD_H4;  MaxTF=PERIOD_MN1;}
   else if(iPX=="6Mh") {MinTF=PERIOD_H4;  MaxTF=PERIOD_W1; }
   else if(iPX=="4Mh") {MinTF=PERIOD_M30; MaxTF=PERIOD_W1; }
   else if(iPX=="1Mh") {MinTF=PERIOD_M5;  MaxTF=PERIOD_H4; }
   else if(iPX=="2Wk") {MinTF=PERIOD_M5;  MaxTF=PERIOD_H4; }
   else if(iPX=="1Wk") {MinTF=PERIOD_M5;  MaxTF=PERIOD_H4; }
   else if(iPX=="4Dy") {MinTF=PERIOD_M5;  MaxTF=PERIOD_H4; }
   else if(iPX=="3Dy") {MinTF=PERIOD_M5;  MaxTF=PERIOD_H4; }
   else if(iPX=="2Dy") {MinTF=PERIOD_M5;  MaxTF=PERIOD_H1; }
   else if(iPX=="1Dy") {MinTF=PERIOD_M5;  MaxTF=PERIOD_H1; }
   else if(iPX=="12Hr"){MinTF=PERIOD_M5;  MaxTF=PERIOD_H1; }
   else if(iPX=="8Hr") {MinTF=PERIOD_M5;  MaxTF=PERIOD_M30; }
   else if(iPX=="4Hr") {MinTF=PERIOD_M1;  MaxTF=PERIOD_M15;}
   else if(iPX=="3Hr") {MinTF=PERIOD_M1;  MaxTF=PERIOD_M15;}
   else if(iPX=="2Hr") {MinTF=PERIOD_M1;  MaxTF=PERIOD_M15;}
   else if(iPX=="1Hr") {MinTF=PERIOD_M1;  MaxTF=PERIOD_M5;}
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
void MARK(){
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   string Name = "AML";
   if(ObjectFind(Name)==-1)
      ObjectCreate(Name,OBJ_LABEL,0,0,0);
   ObjectSetText(Name,CharToStr(91),12,"Wingdings",DarkSlateGray);
	ObjectSet(Name,OBJPROP_CORNER,3);
	ObjectSet(Name,OBJPROP_XDISTANCE,3);
   ObjectSet(Name,OBJPROP_YDISTANCE,3);
   ObjectSet(Name,OBJPROP_HIDDEN,1);
   ObjectSet(Name,OBJPROP_SELECTABLE,FALSE);
}
