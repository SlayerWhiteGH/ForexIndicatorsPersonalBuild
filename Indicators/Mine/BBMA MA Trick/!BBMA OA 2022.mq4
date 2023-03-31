//+------------------------------------------------------------------+
//|                                        BBMA MA TRICK 2022.mq4 |
//|                                                Copyright 2022 |
//|                           https://www.facebook.com/Zhou.FanFx |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MA TRICK"
#property link      "https://www.facebook.com/Zhou.FanFx"
#property strict
#property description " "
#property description " "
#property description " "
#property description "                     --- @2022 --- "
#property indicator_chart_window
#property indicator_buffers 25

enum eModeBB         {_DisableBB/*Disable*/,_shSD1/*Show BB SD 1*/,_shSD2/*Show BB SD 2*/,_shFSD/*Show BB SD 1 & 2*/};
enum eModeLine       {_0L/*Solid*/,_1L/*Dash*/,_2L/*Dot*/,_3L/*Dash Dot*/,_4L/*Dash Dot Dot*/};


extern ENUM_BASE_CORNER   corner = CORNER_LEFT_LOWER; // Position
extern int button_x              = 0;               // X
extern int button_y              = 0;                // Y
input string             _Reguler= "--- REGULAR ---";//_______________________00

input bool tfx40                 = true;         //TFX40
input bool colormode             = false;         //Show White Background
input bool showmathead           = false;          //Show Header
input bool xlsma                 = false;          //LSMA MODE
input eModeLine linemode         = _2L;            //Line MATrick Type    
input eModeLine linemode1        = _0L;            //Line BB Type SD 1   
input eModeLine linemode2        = _0L;            //Line BB Type SD 2     
 
input string                  _BB= "--- BB SETTING ---";//_______________________00           
input eModeBB  s0ModeBB          = _shSD2;         //BB ACTIVE 

input string            _cACTIVE= "--- COLOR TF ACTIVE ---";//_______________________00               
input color    clSMA            = clrAqua,//-------- MID
               clSMAT           = clrAqua,//-------- MID MA TRICK
               clSDP            = clrDodgerBlue,//-------- SD +
               clSDM            = clrDodgerBlue;//-------- SD - 
               
input string               _cTFX= "--- COLOR TF ACTIVE ---";//_______________________00   
input color    clEMA            = clrYellow,//-------- TFX
               clEMAT           = clrYellow;//-------- TFX MA TRICK
 
input string             _cENTRY= "--- COLOR TF ACTIVE ---";//_______________________00                  
input color    cl5              = clrGray,//-------- MA 5
               cl10             = clrGray,//-------- MA 10
               clSDHW           = "70,70,70";//-------- SHADOW      


string iName, buttonId, IndicatorObjPrefix;
double 
EMA01[],EMAT01[],
SMA03[],SDP03[],SDM03[],SDP032[],SDM032[],SMAT03[],
SMA04[],SDP04[],SDM04[],SDP042[],SDM042[],SMAT04[],
HLWMA01[],LLWMA01[],HLWMA02[],LLWMA02[],
HLWMASH01[],LLWMASH01[],HLWMASH02[],LLWMASH02[],
HLWMASH03[],LLWMASH03[],HLWMASH04[],LLWMASH04[],
sSDP03[],sSDM03[],sSDP032[],sSDM032[];
double vDev1  = 1.0;//Deviation
double vDev2  = 2.0;//Deviation
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#define shMA 1
#define shD1 2
#define shD2 3
#define shMAT 4

bool BB1_enable = s0ModeBB==_shSD1,
     BB2_enable = s0ModeBB==_shSD2,
     BBF_enable = s0ModeBB==_shFSD,
        
     line0_enable = linemode==_0L,
     line1_enable = linemode==_1L,
     line2_enable = linemode==_2L,
     line3_enable = linemode==_3L,
     line4_enable = linemode==_4L,
     
     line5_enable = linemode2==_0L,
     line6_enable = linemode2==_1L,
     line7_enable = linemode2==_2L,
     line8_enable = linemode2==_3L,
     line9_enable = linemode2==_4L,
     
     line10_enable = linemode1==_0L,
     line11_enable = linemode1==_1L,
     line12_enable = linemode1==_2L,
     line13_enable = linemode1==_3L,
     line14_enable = linemode1==_4L;
     
int Handle,isOn;
string NamaFile;
void SetFile(int Mode){
   switch(Mode){
      case  0: Handle = FileOpen(NamaFile,FILE_BIN|FILE_READ);
               if(Handle>=1){
                  isOn = FileReadInteger(Handle,LONG_VALUE);
                  FileClose(Handle);
               }
               else isOn=1;
               break;
      case  1: Handle = FileOpen(NamaFile,FILE_BIN|FILE_WRITE);
               if(Handle>=1){
                  FileWriteInteger(Handle,isOn,LONG_VALUE);
                  FileClose(Handle);
               }
               break;
   }
}
//+==================================================================+
//| Custom indicator initialization function                         |
//+==================================================================+ 
int OnInit() {
//=================================================================
   bool is_auth = false;
   if(AccountName()=="MaTrick") is_auth = true;
   if(is_auth){
      Comment("Account Authorized");}  
   else{
      Comment("");
      datetime TrialEndDate = D'06.11.2023 23:00:00'; // <-- write here the date when you the MT4 program stops
      if(TimeCurrent() > TrialEndDate){
         Alert("Trial period has expired!");
         return(-1);
      }
   }  
   
   if(WindowExpertName()!="!BBMA OA 2022"){
      Alert("Warning !!!\n INDICATOR'S NAME HAS BEEN CHANGED '"+WindowExpertName()+"'\n PLEASE RETURN TO '"+"!BBMA MATrick N.G 2022 v3"+"'");
      ChartIndicatorDelete(0,0,WindowExpertName());
   }
//=================================================================   
   iName="!BBMA OA 2022";   
   NamaFile = "tmp\\OA-"+_Symbol;
   SetFile(0);
   DrawOnOff();
   
   IndicatorObjPrefix = "__" + iName + "__";   
      
 
   IndicatorBuffers(25);
   
   SetIndexBuffer(24,EMAT01); SetIndexStyle(24,isOn?0:12,2,1,clEMAT); 
   SetIndexBuffer(23,EMA01);  SetIndexStyle(23,isOn?0:12,0,2,clEMA);  
 
   //LWMA SHADOW
   SetIndexBuffer(22,LLWMASH04); SetIndexStyle(22,isOn?0:12,2,1,clSDHW); 
   SetIndexBuffer(21,HLWMASH04); SetIndexStyle(21,isOn?0:12,2,1,clSDHW); 
   SetIndexBuffer(20,LLWMASH03); SetIndexStyle(20,isOn?0:12,2,1,clSDHW); 
   SetIndexBuffer(19,HLWMASH03); SetIndexStyle(19,isOn?0:12,2,1,clSDHW);
   SetIndexBuffer(18,LLWMASH02); SetIndexStyle(18,isOn?0:12,2,1,clSDHW);
   SetIndexBuffer(17,HLWMASH02); SetIndexStyle(17,isOn?0:12,2,1,clSDHW);
   SetIndexBuffer(16,LLWMASH01); SetIndexStyle(16,isOn?0:12,2,1,clSDHW);
   SetIndexBuffer(15,HLWMASH01); SetIndexStyle(15,isOn?0:12,2,1,clSDHW);
    
   //LWMA HIGH LOW
   SetIndexBuffer(14,LLWMA02); SetIndexStyle(14,isOn?0:12,0,1,cl5);
   SetIndexBuffer(13,HLWMA02); SetIndexStyle(13,isOn?0:12,0,1,cl10); 
   SetIndexBuffer(12,LLWMA01); SetIndexStyle(12,isOn?0:12,0,1,cl5);
   SetIndexBuffer(11,HLWMA01); SetIndexStyle(11,isOn?0:12,0,1,cl10); 
   
   //MATREND
   SetIndexBuffer(10,SMAT03);SetIndexStyle(10,isOn?0:12,linemode,2,clSMAT);  
   SetIndexBuffer(9,SMA03);  SetIndexStyle(9,isOn?0:12,0,1,clSMA);  
   
   //BB TF ACTIVE
   SetIndexBuffer(8,SDP03); SetIndexStyle(8,isOn&&BB1_enable?0:12,0,1,clSDM);
   SetIndexBuffer(7,SDM03); SetIndexStyle(7,isOn&&BB1_enable?0:12,0,1,clSDM); 
   SetIndexBuffer(6,SDP032);SetIndexStyle(6,isOn&&BB2_enable?0:12,0,1,clSDM); 
   SetIndexBuffer(5,SDM032);SetIndexStyle(5,isOn&&BB2_enable?0:12,0,1,clSDM);
 
   SetIndexBuffer(4,sSDP03); SetIndexStyle(4,isOn&&BBF_enable?0:12,linemode1,1,clSDP); 
   SetIndexBuffer(3,sSDM03); SetIndexStyle(3,isOn&&BBF_enable?0:12,linemode1,1,clSDP); 
   SetIndexBuffer(2,sSDP032);SetIndexStyle(2,isOn&&BBF_enable?0:12,linemode2,1,clSDP); 
   SetIndexBuffer(1,sSDM032);SetIndexStyle(1,isOn&&BBF_enable?0:12,linemode2,1,clSDP); 
        
   return(INIT_SUCCEEDED);
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
color    clMainBG = C'15,15,15';
string strOnOff[]={"St Title"};
void DrawOnOff(){
   ENUM_BASE_CORNER Cr=corner;
   int xD=button_x,xY=button_y,
       setPosX = Cr==0||Cr==2?5:95,
       setPosY = Cr==0||Cr==2?23:23;
   Sett(cButton(0,strOnOff[0],0,setPosX+xD,setPosY+xY,50,18,corner,"PA "+(isOn?"OFF":"ON"),"Lucida Console",8,clrWhite,clMainBG,clrDodgerBlue,0,0,0,1,1));   
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
   SetFile(0);
   DrawOnOff();
   SetStyle();
   
   //showmathead?cLabel(0,"Header1",5,1,CORNER_RIGHT_UPPER,"__MATr3ndLOgic SysT3m__  ","Calibri",9,clrWhite,0):EMPTY_VALUE;
   //showmathead?cLabel(0,"Header2",4,11,CORNER_RIGHT_UPPER,"------------------40------------------","Calibri",9,clrYellowGreen,0):EMPTY_VALUE;
   //showmathead?cLabel(0,"Header3",130,3,CORNER_RIGHT_UPPER,"Shown MTF >>                            ","Calibri",8,clrYellowGreen,0):EMPTY_VALUE;
   
   showmathead?cLabel(0,"Header1",600,10,CORNER_RIGHT_UPPER,"PATIENCE | DICIPLINE | CONFIDENCE | FOCUS | GRATEFUL","Lucida Console",10,clrDarkGray,0):EMPTY_VALUE;

   showmathead?cLabel(0,"Header2",5,50,CORNER_RIGHT_LOWER,"H4 / H1  - BOS                    ","Lucida Console",8,clrSilver,0):EMPTY_VALUE;
   showmathead?cLabel(0,"Header3",5,30,CORNER_RIGHT_LOWER,"H1 / M15 - RAID SH/SMS + BOS + RTO","Lucida Console",8,clrSilver,0):EMPTY_VALUE;
   showmathead?cLabel(0,"Header4",5,10,CORNER_RIGHT_LOWER,"M5 / M1  - BOS                    ","Lucida Console",8,clrSilver,0):EMPTY_VALUE;
   
   showmathead?cLabel(0,"Header5",5,30,CORNER_RIGHT_UPPER,"London  Open  KZ 13.00 - 15.00","Lucida Console",8,clrBlack,0):EMPTY_VALUE;
   showmathead?cLabel(0,"Header6",5,50,CORNER_RIGHT_UPPER,"NewYork Open  KZ 18.00 - 20.00","Lucida Console",8,clrBlack,0):EMPTY_VALUE;
   showmathead?cLabel(0,"Header7",5,70,CORNER_RIGHT_UPPER,"London  Close KZ 22.00 - 24.00","Lucida Console",8,clrBlack,0):EMPTY_VALUE;
   
   for(int i=0; i<MathMin(Bars-IndicatorCounted(),Bars-1); i++){
      //SMA/MIDBB
      SMA03[i] = iMA(_Symbol,_Period,20,0,MODE_SMA,PRICE_CLOSE,i);
      SDP03[i] = BB1_enable?SMA03[i]+getSMA(20,i,vDev1):EMPTY_VALUE;
      SDM03[i] = BB1_enable?SMA03[i]-getSMA(20,i,vDev1):EMPTY_VALUE;
      SDP032[i] = BB2_enable?SMA03[i]+getSMA(20,i,vDev2):EMPTY_VALUE;
      SDM032[i] = BB2_enable?SMA03[i]-getSMA(20,i,vDev2):EMPTY_VALUE;
      
      sSDP03[i] = BBF_enable?SMA03[i]+getSMA(20,i,vDev1):EMPTY_VALUE;
      sSDM03[i] = BBF_enable?SMA03[i]-getSMA(20,i,vDev1):EMPTY_VALUE;
      sSDP032[i] = BBF_enable?SMA03[i]+getSMA(20,i,vDev2):EMPTY_VALUE;
      sSDM032[i] = BBF_enable?SMA03[i]-getSMA(20,i,vDev2):EMPTY_VALUE;
      
      //MATREND      
      SMAT03[i] = (3*iMA(_Symbol,_Period,40,0,(xlsma==true)?MODE_LWMA:MODE_EMA,PRICE_CLOSE,i)) - (2*iMA(_Symbol,_Period,40,0,MODE_SMA,PRICE_CLOSE,i));

      EMA01[i] = iMA(_Symbol,_Period,(tfx40==true)?40:50,0,(tfx40==true)?MODE_SMA:MODE_EMA,PRICE_CLOSE,i);
      EMAT01[i]= (3*iMA(_Symbol,_Period,(tfx40==true)?80:100,0,(xlsma==true)?MODE_LWMA:MODE_EMA,PRICE_CLOSE,i)) - (2*iMA(_Symbol,_Period,(tfx40==true)?80:100,0,MODE_SMA,PRICE_CLOSE,i));
      
      
      //LWMA HILO
      HLWMA01[i] = iMA(_Symbol,_Period,5,0,MODE_LWMA,PRICE_LOW,i);
      LLWMA01[i] = iMA(_Symbol,_Period,10,0,MODE_LWMA,PRICE_LOW,i);
      HLWMA02[i] = iMA(_Symbol,_Period,5,0,MODE_LWMA,PRICE_HIGH,i);
      LLWMA02[i] = iMA(_Symbol,_Period,10,0,MODE_LWMA,PRICE_HIGH,i);
      
      HLWMASH01[i] = iMA(_Symbol,_Period,6,0,MODE_LWMA,PRICE_HIGH,i);
      HLWMASH02[i] = iMA(_Symbol,_Period,7,0,MODE_LWMA,PRICE_HIGH,i);
      HLWMASH03[i] = iMA(_Symbol,_Period,8,0,MODE_LWMA,PRICE_HIGH,i);
      HLWMASH04[i] = iMA(_Symbol,_Period,9,0,MODE_LWMA,PRICE_HIGH,i);
      
      LLWMASH01[i] = iMA(_Symbol,_Period,6,0,MODE_LWMA,PRICE_LOW,i);
      LLWMASH02[i] = iMA(_Symbol,_Period,7,0,MODE_LWMA,PRICE_LOW,i);
      LLWMASH03[i] = iMA(_Symbol,_Period,8,0,MODE_LWMA,PRICE_LOW,i);
      LLWMASH04[i] = iMA(_Symbol,_Period,9,0,MODE_LWMA,PRICE_LOW,i);
      
   }
   
   return(rates_total);
}
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
void SetStyle(){
  
   SetIndexStyle(24,isOn?0:12,2,1,clEMAT); 
   SetIndexStyle(23,isOn?0:12,0,2,clEMA); 
  
   //LWMA SHADOW
   SetIndexStyle(22,isOn?0:12,2,1,clSDHW); 
   SetIndexStyle(21,isOn?0:12,2,1,clSDHW); 
   SetIndexStyle(20,isOn?0:12,2,1,clSDHW); 
   SetIndexStyle(19,isOn?0:12,2,1,clSDHW);
   SetIndexStyle(18,isOn?0:12,2,1,clSDHW);
   SetIndexStyle(17,isOn?0:12,2,1,clSDHW);
   SetIndexStyle(16,isOn?0:12,2,1,clSDHW);
   SetIndexStyle(15,isOn?0:12,2,1,clSDHW);
    
   //LWMA HIGH LOW
   SetIndexStyle(14,isOn?0:12,0,1,cl5);
   SetIndexStyle(13,isOn?0:12,0,1,cl10); 
   SetIndexStyle(12,isOn?0:12,0,1,cl5);
   SetIndexStyle(11,isOn?0:12,0,1,cl10); 
   
   //MATREND
   SetIndexStyle(10,isOn?0:12,linemode,1,clSMAT); 
   SetIndexStyle(9,isOn?0:12,0,2,clSMA);  
   
   //BB TF ACTIVE
   SetIndexStyle(8,isOn&&BB1_enable?0:12,0,1,clSDM);
   SetIndexStyle(7,isOn&&BB1_enable?0:12,0,1,clSDM); 
   SetIndexStyle(6,isOn&&BB2_enable?0:12,0,1,clSDM); 
   SetIndexStyle(5,isOn&&BB2_enable?0:12,0,1,clSDM);
 
   SetIndexStyle(4,isOn&&BBF_enable?0:12,linemode1,1,clSDP); 
   SetIndexStyle(3,isOn&&BBF_enable?0:12,linemode1,1,clSDP); 
   SetIndexStyle(2,isOn&&BBF_enable?0:12,linemode2,1,clSDP); 
   SetIndexStyle(1,isOn&&BBF_enable?0:12,linemode2,1,clSDP); 
   
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
void OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam){
   if(id==CHARTEVENT_OBJECT_CLICK){      
      if(sparam==iName+strOnOff[0]){
         if(Selected(strOnOff[0])){
            ObjectSetInteger(0,iName+strOnOff[0],OBJPROP_STATE,0);
            SetFile(0);
            isOn = isOn==0?1:0;
            DrawOnOff();
            SetStyle();
            SetFile(1);
         }
      }
   }
   ChartRedraw();
}
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

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
               const ENUM_BASE_CORNER  corn=CORNER_LEFT_UPPER, // chart corner for anchoring 
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
   ObjectSetInteger(chart_ID,Name,OBJPROP_CORNER,corn); 
   ObjectSetString(chart_ID,Name,OBJPROP_TEXT,text); 
   ObjectSetString(chart_ID,Name,OBJPROP_FONT,font); 
   ObjectSetInteger(chart_ID,Name,OBJPROP_FONTSIZE,font_size); 
   ObjectSetDouble(chart_ID,Name,OBJPROP_ANGLE,angle); 
   ObjectSetInteger(chart_ID,Name,OBJPROP_ANCHOR,corn==CORNER_LEFT_UPPER?ANCHOR_LEFT_UPPER:
                                                 corn==CORNER_RIGHT_UPPER?ANCHOR_RIGHT_UPPER:
                                                 corn==CORNER_LEFT_LOWER?ANCHOR_LEFT_LOWER:ANCHOR_RIGHT_LOWER);  
   ObjectSetInteger(chart_ID,Name,OBJPROP_COLOR,clr); 
   ObjectSetInteger(chart_ID,Name,OBJPROP_BACK,back); 
   ObjectSetInteger(chart_ID,Name,OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(chart_ID,Name,OBJPROP_SELECTED,selection); 
   ObjectSetInteger(chart_ID,Name,OBJPROP_HIDDEN,hidden);
   ObjectSetInteger(chart_ID,Name,OBJPROP_ZORDER,z_order); 
   ObjectSetString(chart_ID,Name,OBJPROP_TOOLTIP,"\n");  
   return(true); 
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
bool Selected(string Name){return((ObjectGetInteger(0,iName+Name,OBJPROP_STATE)==true)?true:false);}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
bool cButton(const long chart_ID,const string name,const int sub_window,const int x,const int y,
             const int width,const int height,const ENUM_BASE_CORNER corners,const string text,
             const string font="Arial",const int font_size=10,const color clr=clrBlack,const color back_clr=C'236,233,216',
             const color border_clr=clrNONE,const bool state=false,const bool back=false,
             const bool selection=false,const bool hidden=true,const long z_order=False,const string tool_tip="\n"){
   ResetLastError();
   string Name=iName+name;
   if(ObjectFind(Name)==WRONG_VALUE)
      ObjectCreate(chart_ID,Name,OBJ_BUTTON,sub_window!=0?WindowFind(iName):0,0,0);
   ObjectSetInteger(chart_ID,Name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(chart_ID,Name,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(chart_ID,Name,OBJPROP_XSIZE,width);
   ObjectSetInteger(chart_ID,Name,OBJPROP_YSIZE,height);
   ObjectSetInteger(chart_ID,Name,OBJPROP_CORNER,corners);
   ObjectSetString(chart_ID,Name,OBJPROP_TEXT,text);
   ObjectSetString(chart_ID,Name,OBJPROP_FONT,font);
   ObjectSetInteger(chart_ID,Name,OBJPROP_FONTSIZE,font_size);
   ObjectSetInteger(chart_ID,Name,OBJPROP_COLOR,clr);
   ObjectSetInteger(chart_ID,Name,OBJPROP_BGCOLOR,back_clr);
   ObjectSetInteger(chart_ID,Name,OBJPROP_BORDER_COLOR,border_clr);
   ObjectSetInteger(chart_ID,Name,OBJPROP_BACK,back);
   ObjectSetInteger(chart_ID,Name,OBJPROP_STATE,state);
   ObjectSetInteger(chart_ID,Name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,Name,OBJPROP_SELECTED,selection);
   ObjectSetInteger(chart_ID,Name,OBJPROP_HIDDEN,hidden);
   ObjectSetInteger(chart_ID,Name,OBJPROP_ZORDER,z_order);
   ObjectSetString(chart_ID,Name,OBJPROP_TOOLTIP,tool_tip);
   return(true);
}