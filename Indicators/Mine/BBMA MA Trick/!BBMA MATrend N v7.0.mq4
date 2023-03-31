//+------------------------------------------------------------------+
//|                                         BBMA MATrend 2020.mq4 |
//|                                                Copyright 2020 |
//|                           https://www.facebook.com/Zhou.FanFx |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MATrend"
#property link      "https://www.facebook.com/Zhou.FanFx"
#property strict
#property description " "
#property description " "
#property description " "
#property description "                     --- @2020 --- "

#property indicator_chart_window
#property indicator_buffers 118

enum eModeMA         {_DisableAll/*Disable*/,_shEMA50/*Show EMA50*/,_shMAtr/*Show MATrend*/};
enum eModeBB         {_DisableBB/*Disable*/,_shSD1/*Show BB SD 1*/,_shSD2/*Show BB SD 2*/,_shFSD/*Show BB SD 1 & 2*/};

input bool     iOn               = true;//Indicator On
input bool tfmat                 = false;          //Simple Version
input bool xlsma                 = false;          //LSMA MODE
input bool matall                = false;          //Turn OFF All MATrend             
 
input string                  _BB= "--- BB SETTING ---";//_______________________00         
input eModeBB  s1ModeBB          = _shSD2;         //BB ACTIVE 
input eModeBB  s1ModeBBX         = _DisableBB;     //BB TFX
input eModeBB  s2ModeBB          = _DisableBB;     //BB TF UPWARD 
input eModeBB  s3ModeBB          = _DisableBB;     //BB TF 2 UPWARD 
   
input string               _ENTRY= "--- TF ENTRY ---";//_______________________00
input eModeBB  ts1ModeBB         = _DisableBB;     //BB MAT ENTRY  
input bool Entry1                = false;          //MID ENTRY
input bool midonly               = false;          //---- MID Only 
input bool matonly               = false;          //---- MATrend Only
 
input eModeBB  ts2ModeBB         = _DisableBB;     //BB MAT TFX  
input eModeMA  slModeMA          = _DisableAll;    //TFX ENTRY
input bool midonly1              = false;          //---- MID Only 
input bool matonly1              = false;          //---- MATrend Only 
input ENUM_MA_METHOD
               modeMA            = MODE_SMA;       //---------- MA Method ----------


input string              _ACTIVE= "--- TF ACTIVE ---";//_______________________00              
input bool matact                = true;           //MID ACTIVE
input bool midonlyact            = false;          //---- MID Only 
input bool matonlyact            = false;          //---- MATrend Only 
input eModeMA  s2ModeMA          = _shMAtr;        //TFX ACTIVE
input bool midonly2              = false;          //---- MID Only 
input bool matonly2              = false;          //---- MATrend Only 
              
input string              _UPWARD= "--- TF UPWARD ---";//_______________________00                
input bool mat1                  = false;          //MID UPWARD
input bool midonly3              = false;          //---- MID Only 
input bool matonly3              = false;          //---- MATrend Only 
input eModeMA  s3ModeMA          = _DisableAll;    //TFX UPWARD

               
input string             _2UPWARD= "--- TF 2 UPWARD ---";//_______________________00
input bool mat2                  = false;          //MID 2 UPWARD

input string                _LWMA= "--- LWMA HiLo SETTING ---";//_______________________00 
input bool lwma510               = false;          //MODE 5/10
input bool lwma5                 = false;          //HiLo LWMA 5
input bool lwma10                = false;          //HiLo LWMA 10
input color    clLWSMA1          = clrNONE,        //LWMA 5
               clLWSMA2          = clrNONE;        //LWMA 10  
input bool lwmatfa               = false;          //HiLo LWMA TF ACTIVE 
input bool lwmatfx               = false;          //HiLo LWMA TFX 
input bool lwmatfup              = false;          //HiLo LWMA UPWARD 

input string               _cENTRY= "--- TF ENTRY ---";//_______________________00             
input color    clSMA1            = clrNONE,//-------- MID
               clSMAT1           = clrNONE,//-------- MAT 
               clSMAT1U          = clrNONE,//-------- MAT +
               clSMAT1D          = clrNONE,//-------- MAT -
               clSDP1            = clrNONE,//-------- SD +
               clSDM1            = clrNONE;//-------- SD - 

input string             _cxENTRY= "--- TFX ENTRY ---";//_______________________00                  
input color    clSMA2            = clrNONE,//-------- MID 
               clSMAT2           = clrNONE,//-------- MAT
               clSMAT2U          = clrNONE,//-------- MAT +
               clSMAT2D          = clrNONE,//-------- MAT -
               clSDP2            = clrNONE,//-------- SD +
               clSDM2            = clrNONE;//-------- SD - 

input string             _cACTIVE= "--- TF ACTIVE ---";//_______________________00               
input color    clSMA3            = clrNONE,//-------- MID
               clSMAT3           = clrNONE,//-------- MAT
               clSMAT3U          = clrNONE,//-------- MAT +
               clSMAT3D          = clrNONE,//-------- MAT -
               clLWSMA3          = clrNONE,//-------- LWMA
               clSDP3            = clrNONE,//-------- SD +
               clSDM3            = clrNONE;//-------- SD -  
input string             _cxACTIVE= "--- TFX ACTIVE ---";//_______________________00                 
input color    clSMA4            = clrNONE,//-------- MID
               clSMAT4           = clrNONE,//-------- MAT
               clSMAT4U          = clrNONE,//-------- MAT +
               clSMAT4D          = clrNONE,//-------- MAT -
               clLWSMA4          = clrNONE,//-------- LWMA
               clSDP4            = clrNONE,//-------- SD +
               clSDM4            = clrNONE;//-------- SD - 

input string             _cUPWARD= "--- TF UPWARD ---";//_______________________00                
input color    clSMA5            = clrNONE,//-------- MID
               clSMAT5           = clrNONE,//-------- MAT
               clSMAT5U          = clrNONE,//-------- MAT +
               clSMAT5D          = clrNONE,//-------- MAT -
               clLWSMA5          = clrNONE,//-------- LWMA 
               clSDP5            = clrNONE,//-------- SD +
               clSDM5            = clrNONE;//-------- SD -  
input string            _cxUPWARD= "--- TF UPWARD ---";//_______________________00                 
input color    clSMA6            = clrNONE,//-------- MID
               clSMAT6           = clrNONE,//-------- MAT
               clSMAT6U          = clrNONE,//-------- MAT +
               clSMAT6D          = clrNONE;//-------- MAT -
input string            _c2UPWARD= "--- TF 2 UPWARD ---";//_______________________00                
input color    clSMA7            = clrNONE,//-------- MID
               clSMAT7           = clrNONE,//-------- MAT
               clSMAT7U          = clrNONE,//-------- MAT +
               clSMAT7D          = clrNONE,//-------- MAT -
               clSDP7            = clrNONE,//-------- SD +
               clSDM7            = clrNONE;//-------- SD - 
                            
                                             
               

input string                 _INFO= "--- INFO ---";//_______________________00
input bool     shInfo             = True;//Show Info
static color   clStrUp            = clrLime,//Strong Up Color
               clStrDn            = clrRed,//Strong Down Color
               clMedUp            = clrGreen,//Medium Up Color
               clMedDn            = C'180,000,000',//Medium Down Color
               clCorUp            = clrDarkGreen,//Correction Up Color
               clCorDn            = clrMaroon,//Correction Down Color
               clExUp             = clrDeepPink,//Extreme Buy Color
               clExDn             = clrSpringGreen;//Extreme Sell Color
input int      disX               = 0,//Horizontal Distance
               disY               = 0;//Vertical Distance


string iName; 
int    iP1,iP2,iP3,iP4,iP5,iP6,iP7,
       eP1,eP2,eP3,eP4,eP5,eP6,eP7,
       tP1,tP2,tP3,tP4,tP5,tP6,tP7,
       lP1,lP2,lP3,lP4,lP5;
double 
SMA01[],SDP01[],SDM01[],SDP012[],SDM012[],SMAT01[],
SMA02[],SDP02[],SDM02[],SDP022[],SDM022[],SMAT02[],
SMA03[],SDP03[],SDM03[],SDP032[],SDM032[],SMAT03[],
SMA04[],SDP04[],SDM04[],SDP042[],SDM042[],SMAT04[],
SMA05[],SDP05[],SDM05[],SDP052[],SDM052[],SMAT05[],
SMA06[],SDP06[],SDM06[],SDP062[],SDM062[],SMAT06[],
SMA07[],SDP07[],SDM07[],SDP072[],SDM072[],SMAT07[],

SDP01T[],SDM01T[],SDP012T[],SDM012T[],
SDP02T[],SDM02T[],SDP022T[],SDM022T[],
sSDP01T[],sSDM01T[],sSDP012T[],sSDM012T[],
sSDP02T[],sSDM02T[],sSDP022T[],sSDM022T[],

EMA01[],EMA02[],EMA03[],EMA04[],EMA05[],EMA06[],EMA07[],
EMAT01[],EMAT02[],EMAT03[],EMAT04[],EMAT05[],EMAT06[],EMAT07[],

SMAT01U[],SMAT01D[],SMAT01P[],SMAT01C[],
SMAT02U[],SMAT02D[],SMAT02P[],SMAT02C[],
SMAT03U[],SMAT03D[],SMAT03P[],SMAT03C[],
SMAT04U[],SMAT04D[],SMAT04P[],SMAT04C[],
SMAT05U[],SMAT05D[],SMAT05P[],SMAT05C[],
SMAT06U[],SMAT06D[],SMAT06P[],SMAT06C[],
SMAT07U[],SMAT07D[],SMAT07P[],SMAT07C[],
EMAT01U[],EMAT01D[],EMAT01P[],EMAT01C[],
EMAT02U[],EMAT02D[],EMAT02P[],EMAT02C[],
EMAT03U[],EMAT03D[],EMAT03P[],EMAT03C[],

HLWMA01[],LLWMA01[],HLWMA02[],LLWMA02[],HLWMA03[],LLWMA03[],HLWMA04[],LLWMA04[],HLWMA05[],LLWMA05[],
sSDP03[],sSDM03[],sSDP032[],sSDM032[],
sSDP04[],sSDM04[],sSDP042[],sSDM042[],
sSDP05[],sSDM05[],sSDP052[],sSDM052[],
sSDP07[],sSDM07[],sSDP072[],sSDM072[],
xSMAT03[];
double vDev1  = 1.0;//Deviation
double vDev2  = 2.0;//Deviation
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#define shMA 1
#define shD1 2
#define shD2 3
#define shMAT 4

bool EMA50_enable = slModeMA==_shEMA50,
     MAtren_enable = slModeMA==_shMAtr,
     eEMA50_enable = s2ModeMA==_shEMA50,
     eMAtren_enable = s2ModeMA==_shMAtr,
     eeEMA50_enable = s3ModeMA==_shEMA50,
     eeMAtren_enable = s3ModeMA==_shMAtr,
     BB1_enable = s1ModeBB==_shSD1,
     BB2_enable = s1ModeBB==_shSD2,
     BBF_enable = s1ModeBB==_shFSD,
     
     BBT1_enable = ts1ModeBB==_shSD1,
     BBT2_enable = ts1ModeBB==_shSD2,
     BBFT_enable = ts1ModeBB==_shFSD,
     
     BBTT1_enable = ts2ModeBB==_shSD1,
     BBTT2_enable = ts2ModeBB==_shSD2,
     BBFTT_enable = ts2ModeBB==_shFSD,
     
     bBB1_enable = s2ModeBB==_shSD1,
     bBB2_enable = s2ModeBB==_shSD2,
     bBBF_enable = s2ModeBB==_shFSD,
     
     bbBB1_enable = s3ModeBB==_shSD1,
     bbBB2_enable = s3ModeBB==_shSD2,
     bbBBF_enable = s3ModeBB==_shFSD,
     
     XBB1_enable = s1ModeBBX==_shSD1,
     XBB2_enable = s1ModeBBX==_shSD2,
     XBBF_enable = s1ModeBBX==_shFSD;
//+==================================================================+
//| Custom indicator initialization function                         |
//+==================================================================+ 
int OnInit() {
//--- code start
{
int my_acc = (int)AccountInfoInteger(ACCOUNT_LOGIN);
   //--- add as many accounts as necessary -- example-
int AccNbr[] = { 159535,     //Tickmill 1
                 3059506,    //Tickmill 2
                 463022,     //FBS
                 280445666,  //Nielson
                 58902,      //Rege
               };
bool is_auth = false;
for(int i=0;i<ArraySize(AccNbr);i++)
   if(AccNbr[i] == my_acc)
      is_auth = true;
 
   if(is_auth)
     {Comment("Account : Authorized");}
   else 
     {
     Comment("Account : Not Authorized   |   EXPIRE 01.12.2023");
     datetime TrialEndDate = D'01.12.2023 23:00:00'; // <-- write here the date when you the MT4 program stops
     if (TimeCurrent() > TrialEndDate)
     {Alert("Trial period has expired!"); return(-1);}
     }  
}
//--- code end 
if(WindowExpertName()!="!BBMA MATrend N v7.0"){
      Alert("Warning !!!\n INDICATOR'S NAME HAS BEEN CHANGED'"+WindowExpertName()+"'\n PLEASE RETURN TO '"+"!BBMA MATrend N v7.0"+"'");
      ChartIndicatorDelete(0,0,WindowExpertName());}
      
   iName="!BBMA MATrend N v7.0";   
    
   //SMA      
   iP1=StrToInteger(getPer(95,0,1));
   iP2=StrToInteger(getPer(96,0,1));
   iP3=StrToInteger(getPer(97,0,1));
   iP4=StrToInteger(getPer(98,0,1));
   iP5=StrToInteger(getPer(99,0,1));
   iP6=StrToInteger(getPer(100,0,1));
   iP7=StrToInteger(getPer(101,0,1));
   
   //MATREND
   tP1=StrToInteger(getPer((tfmat==true)?95:102,0,1));
   tP2=StrToInteger(getPer((tfmat==true)?96:103,0,1));
   tP3=StrToInteger(getPer((tfmat==true)?97:104,0,1));
   tP4=StrToInteger(getPer((tfmat==true)?98:105,0,1));
   tP5=StrToInteger(getPer((tfmat==true)?99:106,0,1));
   tP6=StrToInteger(getPer((tfmat==true)?100:107,0,1));
   tP7=StrToInteger(getPer((tfmat==true)?101:108,0,1));
   
   //EMA50
   eP1=StrToInteger(getPer((tfmat==true)?96:110,0,1));
   eP2=StrToInteger(getPer((tfmat==true)?98:111,0,1));
   eP3=StrToInteger(getPer((tfmat==true)?100:112,0,1));
   
   //LWMA   
   lP1=StrToInteger(getPer(115,0,1));
   lP2=StrToInteger(getPer(116,0,1));
   lP3=StrToInteger(getPer(97,0,1));
   lP4=StrToInteger(getPer(98,0,1));
   lP5=StrToInteger(getPer(99,0,1));

   
  
   IndicatorBuffers(118);
   
   //BB TFX ENTRY
   SetIndexBuffer(117,SDP02T); SetIndexStyle(117,BBTT1_enable?0:12,2,1,getClr(103,0,false,clSDP2));
   SetIndexBuffer(116,SDM02T); SetIndexStyle(116,BBTT1_enable?0:12,2,1,getClr(103,0,false,clSDM2));
   SetIndexBuffer(115,SDP022T);SetIndexStyle(115,BBTT2_enable?0:12,0,1,getClr(103,0,false,clSDP2));
   SetIndexBuffer(114,SDM022T);SetIndexStyle(114,BBTT2_enable?0:12,0,1,getClr(103,0,false,clSDM2));
  
   SetIndexBuffer(113,sSDP02T); SetIndexStyle(113,BBFTT_enable?0:12,2,1,getClr(103,0,false,clSDP2));
   SetIndexBuffer(112,sSDM02T); SetIndexStyle(112,BBFTT_enable?0:12,2,1,getClr(103,0,false,clSDM2));
   SetIndexBuffer(111,sSDP022T);SetIndexStyle(111,BBFTT_enable?0:12,0,1,getClr(103,0,false,clSDP2));
   SetIndexBuffer(110,sSDM022T);SetIndexStyle(110,BBFTT_enable?0:12,0,1,getClr(103,0,false,clSDM2));
   
   //BB TF ENTRY
   SetIndexBuffer(109,SDP01T); SetIndexStyle(109,BBT1_enable?0:12,2,1,getClr(102,0,false,clSDP1));
   SetIndexBuffer(108,SDM01T); SetIndexStyle(108,BBT1_enable?0:12,2,1,getClr(102,0,false,clSDM1));
   SetIndexBuffer(107,SDP012T);SetIndexStyle(107,BBT2_enable?0:12,0,1,getClr(102,0,false,clSDP1));
   SetIndexBuffer(106,SDM012T);SetIndexStyle(106,BBT2_enable?0:12,0,1,getClr(102,0,false,clSDM1));
  
   SetIndexBuffer(105,sSDP01T); SetIndexStyle(105,BBFT_enable?0:12,2,1,getClr(102,0,false,clSDP1));
   SetIndexBuffer(104,sSDM01T); SetIndexStyle(104,BBFT_enable?0:12,2,1,getClr(102,0,false,clSDM1));
   SetIndexBuffer(103,sSDP012T);SetIndexStyle(103,BBFT_enable?0:12,0,1,getClr(102,0,false,clSDP1));
   SetIndexBuffer(102,sSDM012T);SetIndexStyle(102,BBFT_enable?0:12,0,1,getClr(102,0,false,clSDM1));
   
   //MATREND EMA50
   SetIndexBuffer(101,EMAT03D); SetIndexStyle(101,eeEMA50_enable?0:12,2,1,(matall==true)?clrNONE:(midonly3==true)?clrNONE:getClr(107,0,false,clSMAT6D)); //TFX UPWARD
   SetIndexBuffer(100,EMAT03U); SetIndexStyle(100,eeEMA50_enable?0:12,2,1,(matall==true)?clrNONE:(midonly3==true)?clrNONE:getClr(107,0,true,clSMAT6U)); //TFX UPWARD
   SetIndexBuffer(99,EMAT03P); SetIndexStyle(99,eeEMA50_enable?0:12,2,1,clrNONE); //TFX UPWARD
   SetIndexBuffer(98,EMAT03C); SetIndexStyle(98,eeEMA50_enable?0:12,2,1,clrNONE); //TFX UPWARD
   
   SetIndexBuffer(97,EMAT02D); SetIndexStyle(97, eEMA50_enable?0:12,2,1,(matall==true)?clrNONE:(midonly2==true)?clrNONE:getClr(105,0,false,clSMAT4D));  //TFX ACTIVE
   SetIndexBuffer(96,EMAT02U); SetIndexStyle(96, eEMA50_enable?0:12,2,1,(matall==true)?clrNONE:(midonly2==true)?clrNONE:getClr(105,0,true,clSMAT4U));  //TFX ACTIVE
   SetIndexBuffer(95,EMAT02P); SetIndexStyle(95, eEMA50_enable?0:12,2,1,clrNONE);  //TFX ACTIVE
   SetIndexBuffer(94,EMAT02C); SetIndexStyle(94, eEMA50_enable?0:12,2,1,clrNONE);  //TFX ACTIVE
 
   SetIndexBuffer(93,EMAT01D); SetIndexStyle(93,  EMA50_enable?0:12,2,1,(matall==true)?clrNONE:(midonly1==true)?clrNONE:getClr(103,0,false,clSMAT2D));  //TFX ENTRY
   SetIndexBuffer(92,EMAT01U); SetIndexStyle(92,  EMA50_enable?0:12,2,1,(matall==true)?clrNONE:(midonly1==true)?clrNONE:getClr(103,0,true,clSMAT2U));  //TFX ENTRY
   SetIndexBuffer(91,EMAT01P); SetIndexStyle(91,  EMA50_enable?0:12,2,1,clrNONE);  //TFX ENTRY
   SetIndexBuffer(90,EMAT01C); SetIndexStyle(90,  EMA50_enable?0:12,2,1,clrNONE);  //TFX ENTRY
   
   
   //MATREND TFX COLOR
   SetIndexBuffer(89,SMAT06D);SetIndexStyle(89,eeMAtren_enable?0:12,2,1,(matall==true)?clrNONE:(midonly3==true)?clrNONE:getClr(107,0,false,clSMAT6D));     //TFX UPWARD
   SetIndexBuffer(88,SMAT06U);SetIndexStyle(88,eeMAtren_enable?0:12,2,1,(matall==true)?clrNONE:(midonly3==true)?clrNONE:getClr(107,0,true,clSMAT6U));     //TFX UPWARD
   SetIndexBuffer(87,SMAT06P);SetIndexStyle(87,eeMAtren_enable?0:12,2,1,clrNONE);     //TFX UPWARD
   SetIndexBuffer(86,SMAT06C);SetIndexStyle(86,eeMAtren_enable?0:12,2,1,clrNONE);     //TFX UPWARD
  
   SetIndexBuffer(85,SMAT04D);SetIndexStyle(85,eMAtren_enable? 0:12,2,1,(matall==true)?clrNONE:(midonly2==true)?clrNONE:getClr(105,0,false,clSMAT4D));      //TFX ACTIVE
   SetIndexBuffer(84,SMAT04U);SetIndexStyle(84,eMAtren_enable? 0:12,2,1,(matall==true)?clrNONE:(midonly2==true)?clrNONE:getClr(105,0,true,clSMAT4U));      //TFX ACTIVE
   SetIndexBuffer(83,SMAT04P);SetIndexStyle(83,eMAtren_enable? 0:12,2,1,clrNONE);      //TFX ACTIVE
   SetIndexBuffer(82,SMAT04C);SetIndexStyle(82,eMAtren_enable? 0:12,2,1,clrNONE);      //TFX ACTIVE
   
   SetIndexBuffer(81,SMAT02D);SetIndexStyle(81,MAtren_enable?  0:12,(ts2ModeBB==_DisableBB)?2:0,1,(matall==true)?clrNONE:(midonly1==true)?clrNONE:getClr(103,0,false,clSMAT2D));        //TFX ENTRY
   SetIndexBuffer(80,SMAT02U);SetIndexStyle(80,MAtren_enable?  0:12,(ts2ModeBB==_DisableBB)?2:0,1,(matall==true)?clrNONE:(midonly1==true)?clrNONE:getClr(103,0,true,clSMAT2U));        //TFX ENTRY
   SetIndexBuffer(79,SMAT02P);SetIndexStyle(79,MAtren_enable?  0:12,(ts2ModeBB==_DisableBB)?2:0,1,clrNONE);        //TFX ENTRY
   SetIndexBuffer(78,SMAT02C);SetIndexStyle(78,MAtren_enable?  0:12,(ts2ModeBB==_DisableBB)?2:0,1,clrNONE);        //TFX ENTRY
   
   
   //MATREND COLOR
   SetIndexBuffer(77,SMAT07D);SetIndexStyle(77,0,2,1,(matall==true)?clrNONE:getClr(108,0,false,clSMAT7D)); //2 UPWARD
   SetIndexBuffer(76,SMAT07U);SetIndexStyle(76,0,2,1,(matall==true)?clrNONE:getClr(108,0,true,clSMAT7U)); //2 UPWARD
   SetIndexBuffer(75,SMAT07P);SetIndexStyle(75,0,2,1,clrNONE); //2 UPWARD
   SetIndexBuffer(74,SMAT07C);SetIndexStyle(74,0,2,1,clrNONE); //2 UPWARD
   
   SetIndexBuffer(73,SMAT05D);SetIndexStyle(73,0,2,1,(matall==true)?clrNONE:(midonly3==true)?clrNONE:getClr(106,0,false,clSMAT5D)); //UPWARD
   SetIndexBuffer(72,SMAT05U);SetIndexStyle(72,0,2,1,(matall==true)?clrNONE:(midonly3==true)?clrNONE:getClr(106,0,true,clSMAT5U)); //UPWARD
   SetIndexBuffer(71,SMAT05P);SetIndexStyle(71,0,2,1,clrNONE); //UPWARD
   SetIndexBuffer(70,SMAT05C);SetIndexStyle(70,0,2,1,clrNONE); //UPWARD
  
   SetIndexBuffer(69,SMAT03D);SetIndexStyle(69,0,2,1,(matall==true)?clrNONE:(midonlyact==true)?clrNONE:getClr(104,0,false,clSMAT3D)); //ACTIVE
   SetIndexBuffer(68,SMAT03U);SetIndexStyle(68,0,2,1,(matall==true)?clrNONE:(midonlyact==true)?clrNONE:getClr(104,0,true,clSMAT3U)); //ACTIVE
   SetIndexBuffer(67,SMAT03P);SetIndexStyle(67,0,2,1,clrNONE); //ACTIVE
   SetIndexBuffer(66,SMAT03C);SetIndexStyle(66,0,2,1,clrNONE); //ACTIVE
   
   SetIndexBuffer(65,SMAT01D);SetIndexStyle(65,0,(ts1ModeBB==_DisableBB)?2:0,1,(matall==true)?clrNONE:(midonly==true)?clrNONE:getClr(102,0,false,clSMAT1D)); //ENTRY
   SetIndexBuffer(64,SMAT01U);SetIndexStyle(64,0,(ts1ModeBB==_DisableBB)?2:0,1,(matall==true)?clrNONE:(midonly==true)?clrNONE:getClr(102,0,true,clSMAT1U)); //ENTRY
   SetIndexBuffer(63,SMAT01P);SetIndexStyle(63,0,(ts1ModeBB==_DisableBB)?2:0,1,clrNONE); //ENTRY
   SetIndexBuffer(62,SMAT01C);SetIndexStyle(62,0,(ts1ModeBB==_DisableBB)?2:0,1,clrNONE); //ENTRY
   
   //MATREND
   SetIndexBuffer(61,SMAT07);SetIndexStyle(61,0,2,1,(matall==true)?clrNONE:getClr(108,0,true,clSMAT7)); //2 UPWARD
   SetIndexBuffer(60,SMAT05);SetIndexStyle(60,0,2,1,(matall==true)?clrNONE:(midonly3==true)?clrNONE:getClr(106,0,true,clSMAT5)); //UPWARD
   SetIndexBuffer(59,SMAT03);SetIndexStyle(59,0,2,1,(matall==true)?clrNONE:(midonlyact==true)?clrNONE:getClr(104,0,true,clSMAT3)); //ACTIVE
   SetIndexBuffer(58,SMAT01);SetIndexStyle(58,0,(ts1ModeBB==_DisableBB)?2:0,1,(matall==true)?clrNONE:(midonly==true)?clrNONE:getClr(102,0,true,clSMAT1)); //ENTRY
   
   //MATREND TFX
   SetIndexBuffer(57,SMAT06);SetIndexStyle(57,eeMAtren_enable?0:12,2,1,(matall==true)?clrNONE:(midonly3==true)?clrNONE:getClr(107,0,true,clSMAT6));     //TFX UPWARD
   SetIndexBuffer(56,SMAT04);SetIndexStyle(56,eMAtren_enable? 0:12,2,1,(matall==true)?clrNONE:(midonly2==true)?clrNONE:getClr(105,0,true,clSMAT4));      //TFX ACTIVE
   SetIndexBuffer(55,SMAT02);SetIndexStyle(55,MAtren_enable?  0:12,(ts2ModeBB==_DisableBB)?2:0,1,(matall==true)?clrNONE:(midonly1==true)?clrNONE:getClr(103,0,true,clSMAT2));        //TFX ENTRY
   
   //MATREND EMA50
   SetIndexBuffer(54,EMAT03); SetIndexStyle(54,eeEMA50_enable?0:12,2,1,(matall==true)?clrNONE:(midonly3==true)?clrNONE:getClr(107,0,true,clSMAT6)); //TFX UPWARD
   SetIndexBuffer(53,EMAT02); SetIndexStyle(53, eEMA50_enable?0:12,2,1,(matall==true)?clrNONE:(midonly2==true)?clrNONE:getClr(105,0,true,clSMAT4));  //TFX ACTIVE
   SetIndexBuffer(52,EMAT01); SetIndexStyle(52,  EMA50_enable?0:12,2,1,(matall==true)?clrNONE:(midonly1==true)?clrNONE:getClr(103,0,true,clSMAT2));  //TFX ENTRY
   
   //MID BB
   SetIndexBuffer(51,SMA01); SetIndexStyle(51,0,0,1,(matonly==true)?clrNONE:getClr(95,0,true,clSMA1));
   SetIndexBuffer(50,SMA03); SetIndexStyle(50,0,0,2,(lwmatfa==true)?clrNONE:(matonlyact==true)?clrNONE:getClr(97,0,true,clSMA3));
   SetIndexBuffer(49,SMA05); SetIndexStyle(49,0,0,1,(lwmatfup==true)?clrNONE:getClr(99,0,true,clSMA5));
   SetIndexBuffer(48,SMA07); SetIndexStyle(48,0,0,1,getClr(101,0,true,clSMA7));
      
   //EMA50
   SetIndexBuffer(47,EMA03);  SetIndexStyle(47,eeEMA50_enable?0:12,0,1,getClr(112,0,true,clSMA6)); //TF UPWARD
   SetIndexBuffer(46,EMA02);  SetIndexStyle(46, eEMA50_enable?0:12,0,2,getClr(111,0,true,clSMA4)); //TF ACTIVE
   SetIndexBuffer(45,EMA01);  SetIndexStyle(45,  EMA50_enable?0:12,0,1,getClr(110,0,true,clSMA2)); //TF ENTRY 
   
   //MA TFX
   SetIndexBuffer(44,SMA06); SetIndexStyle(44,eeMAtren_enable?0:12,0,1,getClr(100,0,true,clSMA6)); 
   SetIndexBuffer(43,SMA04); SetIndexStyle(43,eMAtren_enable?0:12,0,2,(matonly2==true)?clrNONE:getClr(98,0,true,clSMA4));
   SetIndexBuffer(42,SMA02); SetIndexStyle(42,MAtren_enable?0:12,0,1,(matonly1==true)?clrNONE:getClr(96,0,true,clSMA2)); 

   //LWMA HIGH LOW
   SetIndexBuffer(41,LLWMA05); SetIndexStyle(41,0,0,1,getClr(99,0,true,clLWSMA5));  
   SetIndexBuffer(40,HLWMA05); SetIndexStyle(40,0,0,1,getClr(99,0,true,clLWSMA5));
   SetIndexBuffer(39,LLWMA04); SetIndexStyle(39,0,0,1,getClr(98,0,true,clLWSMA4));  
   SetIndexBuffer(38,HLWMA04); SetIndexStyle(38,0,0,1,getClr(98,0,true,clLWSMA4));
   SetIndexBuffer(37,LLWMA03); SetIndexStyle(37,0,0,1,getClr(97,0,true,clLWSMA3));  
   SetIndexBuffer(36,HLWMA03); SetIndexStyle(36,0,0,1,getClr(97,0,true,clLWSMA3));
   SetIndexBuffer(35,LLWMA02); SetIndexStyle(35,0,0,1,getClr(103,0,false,clLWSMA2));  
   SetIndexBuffer(34,HLWMA02); SetIndexStyle(34,0,0,1,getClr(103,0,false,clLWSMA2));
   SetIndexBuffer(33,LLWMA01); SetIndexStyle(33,0,0,1,getClr(102,0,false,clLWSMA1));  
   SetIndexBuffer(32,HLWMA01); SetIndexStyle(32,0,0,1,getClr(102,0,false,clLWSMA1));
   
   //BB TF ACTIVE
   SetIndexBuffer(31,SDP03); SetIndexStyle(31,BB1_enable?0:12,(s1ModeBB==_shFSD)?1:1,1,getClr(104,0,false,clSDP3));
   SetIndexBuffer(30,SDM03); SetIndexStyle(30,BB1_enable?0:12,(s1ModeBB==_shFSD)?1:1,1,getClr(104,0,false,clSDM3));
   SetIndexBuffer(29,SDP032);SetIndexStyle(29,BB2_enable?0:12,(s1ModeBB==_shFSD)?1:0,2,getClr(104,0,false,clSDP3));
   SetIndexBuffer(28,SDM032);SetIndexStyle(28,BB2_enable?0:12,(s1ModeBB==_shFSD)?1:0,2,getClr(104,0,false,clSDM3));
  
   SetIndexBuffer(27,sSDP03); SetIndexStyle(27,BBF_enable?0:12,1,1,getClr(104,0,false,clSDP3));
   SetIndexBuffer(26,sSDM03); SetIndexStyle(26,BBF_enable?0:12,1,1,getClr(104,0,false,clSDM3));
   SetIndexBuffer(25,sSDP032);SetIndexStyle(25,BBF_enable?0:12,0,2,getClr(104,0,false,clSDP3));
   SetIndexBuffer(24,sSDM032);SetIndexStyle(24,BBF_enable?0:12,0,2,getClr(104,0,false,clSDM3));
        
   //BB TFX
   SetIndexBuffer(23,SDP04);  SetIndexStyle(23,XBB1_enable?0:12,1,1,getClr(105,0,false,clSDP4));
   SetIndexBuffer(22,SDM04);  SetIndexStyle(22,XBB1_enable?0:12,1,1,getClr(105,0,false,clSDM4));
   SetIndexBuffer(21,SDP042); SetIndexStyle(21,XBB2_enable?0:12,0,1,getClr(105,0,false,clSDP4));
   SetIndexBuffer(20,SDM042); SetIndexStyle(20,XBB2_enable?0:12,0,1,getClr(105,0,false,clSDM4));
 
   SetIndexBuffer(19,sSDP04); SetIndexStyle(19,XBBF_enable?0:12,1,1,getClr(105,0,false,clSDP4));
   SetIndexBuffer(18,sSDM04); SetIndexStyle(18,XBBF_enable?0:12,1,1,getClr(105,0,false,clSDM4));
   SetIndexBuffer(17,sSDP042);SetIndexStyle(17,XBBF_enable?0:12,0,1,getClr(105,0,false,clSDP4));
   SetIndexBuffer(16,sSDM042);SetIndexStyle(16,XBBF_enable?0:12,0,1,getClr(105,0,false,clSDM4));
   
   //BB TF UPWARD
   SetIndexBuffer(15,SDP05);  SetIndexStyle(15,bBB1_enable?0:12,1,1,getClr(106,0,false,clSDP5));
   SetIndexBuffer(14,SDM05);  SetIndexStyle(14,bBB1_enable?0:12,1,1,getClr(106,0,false,clSDM5));
   SetIndexBuffer(13,SDP052); SetIndexStyle(13,bBB2_enable?0:12,0,1,getClr(106,0,false,clSDP5));
   SetIndexBuffer(12,SDM052); SetIndexStyle(12,bBB2_enable?0:12,0,1,getClr(106,0,false,clSDM5));
 
   SetIndexBuffer(11,sSDP05); SetIndexStyle(11,bBBF_enable?0:12,1,1,getClr(106,0,false,clSDP5));
   SetIndexBuffer(10,sSDM05); SetIndexStyle(10,bBBF_enable?0:12,1,1,getClr(106,0,false,clSDM5));
   SetIndexBuffer(9,sSDP052); SetIndexStyle(9,bBBF_enable?0:12,0,1,getClr(106,0,false,clSDP5));
   SetIndexBuffer(8,sSDM052); SetIndexStyle(8,bBBF_enable?0:12,0,1,getClr(106,0,false,clSDM5));
     
   //BB TF 2 UPWARD
   SetIndexBuffer(7,SDP07); SetIndexStyle(7,bbBB1_enable?0:12,1,1,getClr(108,0,false,clSDP7));
   SetIndexBuffer(6,SDM07); SetIndexStyle(6,bbBB1_enable?0:12,1,1,getClr(108,0,false,clSDP7));
   SetIndexBuffer(5,SDP072);SetIndexStyle(5,bbBB2_enable?0:12,0,1,getClr(108,0,false,clSDP7));
   SetIndexBuffer(4,SDM072);SetIndexStyle(4,bbBB2_enable?0:12,0,1,getClr(108,0,false,clSDP7));
   
   SetIndexBuffer(3,sSDP07); SetIndexStyle(3,bbBBF_enable?0:12,1,1,getClr(108,0,false,clSDP7));
   SetIndexBuffer(2,sSDM07); SetIndexStyle(2,bbBBF_enable?0:12,1,1,getClr(108,0,false,clSDM7));
   SetIndexBuffer(1,sSDP072);SetIndexStyle(1,bbBBF_enable?0:12,0,1,getClr(108,0,false,clSDP7));
   SetIndexBuffer(0,sSDM072);SetIndexStyle(0,bbBBF_enable?0:12,0,1,getClr(108,0,false,clSDM7));
     
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
      SMA01[i] = Entry1?iMA(_Symbol,_Period,iP1,0,modeMA,PRICE_CLOSE,i):EMPTY_VALUE;
      
      SMA03[i] = matact?iMA(_Symbol,_Period,iP3,0,MODE_SMA,PRICE_CLOSE,i):EMPTY_VALUE;
      SDP03[i] = BB1_enable?SMA03[i]+getSMA(iP3,i,vDev1):EMPTY_VALUE;
      SDM03[i] = BB1_enable?SMA03[i]-getSMA(iP3,i,vDev1):EMPTY_VALUE;
      SDP032[i] = BB2_enable?SMA03[i]+getSMA(iP3,i,vDev2):EMPTY_VALUE;
      SDM032[i] = BB2_enable?SMA03[i]-getSMA(iP3,i,vDev2):EMPTY_VALUE;
      
      sSDP03[i] = BBF_enable?SMA03[i]+getSMA(iP3,i,vDev1):EMPTY_VALUE;
      sSDM03[i] = BBF_enable?SMA03[i]-getSMA(iP3,i,vDev1):EMPTY_VALUE;
      sSDP032[i] = BBF_enable?SMA03[i]+getSMA(iP3,i,vDev2):EMPTY_VALUE;
      sSDM032[i] = BBF_enable?SMA03[i]-getSMA(iP3,i,vDev2):EMPTY_VALUE;
            
      SMA05[i] = mat1?iMA(_Symbol,_Period,iP5,0,MODE_SMA,PRICE_CLOSE,i):EMPTY_VALUE;
      SDP05[i] = bBB1_enable?SMA05[i]+getSMA(iP5,i,vDev1):EMPTY_VALUE;
      SDM05[i] = bBB1_enable?SMA05[i]-getSMA(iP5,i,vDev1):EMPTY_VALUE;
      SDP052[i] = bBB2_enable?SMA05[i]+getSMA(iP5,i,vDev2):EMPTY_VALUE;
      SDM052[i] = bBB2_enable?SMA05[i]-getSMA(iP5,i,vDev2):EMPTY_VALUE;
      
      sSDP05[i] = bBBF_enable?SMA05[i]+getSMA(iP5,i,vDev1):EMPTY_VALUE;
      sSDM05[i] = bBBF_enable?SMA05[i]-getSMA(iP5,i,vDev1):EMPTY_VALUE;
      sSDP052[i] = bBBF_enable?SMA05[i]+getSMA(iP5,i,vDev2):EMPTY_VALUE;
      sSDM052[i] = bBBF_enable?SMA05[i]-getSMA(iP5,i,vDev2):EMPTY_VALUE;
            
      SMA07[i]  = mat2?iMA(_Symbol,_Period,iP7,0,MODE_SMA,PRICE_CLOSE,i):EMPTY_VALUE;
      SDP07[i]  = bbBB1_enable?SMA07[i]+getSMA(iP7,i,vDev1):EMPTY_VALUE;
      SDM07[i]  = bbBB1_enable?SMA07[i]-getSMA(iP7,i,vDev1):EMPTY_VALUE;
      SDP072[i] = bbBB2_enable?SMA07[i]+getSMA(iP7,i,vDev2):EMPTY_VALUE;
      SDM072[i] = bbBB2_enable?SMA07[i]-getSMA(iP7,i,vDev2):EMPTY_VALUE;
      
      sSDP07[i]  = bbBBF_enable?SMA07[i]+getSMA(iP7,i,vDev1):EMPTY_VALUE;
      sSDM07[i]  = bbBBF_enable?SMA07[i]-getSMA(iP7,i,vDev1):EMPTY_VALUE;
      sSDP072[i] = bbBBF_enable?SMA07[i]+getSMA(iP7,i,vDev2):EMPTY_VALUE;
      sSDM072[i] = bbBBF_enable?SMA07[i]-getSMA(iP7,i,vDev2):EMPTY_VALUE;

      
      //TFX 
      SMA02[i] = MAtren_enable?iMA(_Symbol,_Period,iP2,0,modeMA,PRICE_CLOSE,i):EMPTY_VALUE;
      
      SMA04[i] = eMAtren_enable?iMA(_Symbol,_Period,iP4,0,MODE_SMA,PRICE_CLOSE,i):EMPTY_VALUE;
      SDP04[i]  = XBB1_enable?SMA04[i]+getSMA(iP4,i,vDev1):EMPTY_VALUE;
      SDM04[i]  = XBB1_enable?SMA04[i]-getSMA(iP4,i,vDev1):EMPTY_VALUE;
      SDP042[i] = XBB2_enable?SMA04[i]+getSMA(iP4,i,vDev2):EMPTY_VALUE;
      SDM042[i] = XBB2_enable?SMA04[i]-getSMA(iP4,i,vDev2):EMPTY_VALUE;
      
      sSDP04[i]  = XBBF_enable?SMA04[i]+getSMA(iP4,i,vDev1):EMPTY_VALUE;
      sSDM04[i]  = XBBF_enable?SMA04[i]-getSMA(iP4,i,vDev1):EMPTY_VALUE;
      sSDP042[i] = XBBF_enable?SMA04[i]+getSMA(iP4,i,vDev2):EMPTY_VALUE;
      sSDM042[i] = XBBF_enable?SMA04[i]-getSMA(iP4,i,vDev2):EMPTY_VALUE;
      
      SMA06[i] = eeMAtren_enable?iMA(_Symbol,_Period,iP6,0,MODE_SMA,PRICE_CLOSE,i):EMPTY_VALUE;
      
      
      //MATREND
      SMAT01C[i] = Entry1?(3*iMA(_Symbol,_Period,tP1,0,(xlsma==true)?MODE_LWMA:MODE_EMA,PRICE_CLOSE,i)) - (2*iMA(_Symbol,_Period,tP1,0,MODE_SMA,PRICE_CLOSE,i)):EMPTY_VALUE;
      SDP01T[i] = BBT1_enable?SMAT01C[i]+getSMA(tP1,i,vDev1):EMPTY_VALUE;
      SDM01T[i] = BBT1_enable?SMAT01C[i]-getSMA(tP1,i,vDev1):EMPTY_VALUE;
      SDP012T[i] = BBT2_enable?SMAT01C[i]+getSMA(tP1,i,vDev2):EMPTY_VALUE;
      SDM012T[i] = BBT2_enable?SMAT01C[i]-getSMA(tP1,i,vDev2):EMPTY_VALUE;
      
      sSDP01T[i] = BBFT_enable?SMAT01C[i]+getSMA(tP1,i,vDev1):EMPTY_VALUE;
      sSDM01T[i] = BBFT_enable?SMAT01C[i]-getSMA(tP1,i,vDev1):EMPTY_VALUE;
      sSDP012T[i] = BBFT_enable?SMAT01C[i]+getSMA(tP1,i,vDev2):EMPTY_VALUE;
      sSDM012T[i] = BBFT_enable?SMAT01C[i]-getSMA(tP1,i,vDev2):EMPTY_VALUE;
      
           
      SMAT03C[i] = matact?(3*iMA(_Symbol,_Period,tP3,0,(xlsma==true)?MODE_LWMA:MODE_EMA,PRICE_CLOSE,i)) - (2*iMA(_Symbol,_Period,tP3,0,MODE_SMA,PRICE_CLOSE,i)):EMPTY_VALUE;
      SMAT05C[i] = mat1?  (3*iMA(_Symbol,_Period,tP5,0,(xlsma==true)?MODE_LWMA:MODE_EMA,PRICE_CLOSE,i)) - (2*iMA(_Symbol,_Period,tP5,0,MODE_SMA,PRICE_CLOSE,i)):EMPTY_VALUE;
      SMAT07C[i] = mat2?  (3*iMA(_Symbol,_Period,tP7,0,(xlsma==true)?MODE_LWMA:MODE_EMA,PRICE_CLOSE,i)) - (2*iMA(_Symbol,_Period,tP7,0,MODE_SMA,PRICE_CLOSE,i)):EMPTY_VALUE;
      
      SMAT01P[i] = Entry1?(3*iMA(_Symbol,_Period,tP1,0,(xlsma==true)?MODE_LWMA:MODE_EMA,PRICE_CLOSE,i+1)) - (2*iMA(_Symbol,_Period,tP1,0,MODE_SMA,PRICE_CLOSE,i+1)):EMPTY_VALUE;     
      SMAT03P[i] = matact?(3*iMA(_Symbol,_Period,tP3,0,(xlsma==true)?MODE_LWMA:MODE_EMA,PRICE_CLOSE,i+1)) - (2*iMA(_Symbol,_Period,tP3,0,MODE_SMA,PRICE_CLOSE,i+1)):EMPTY_VALUE;
      SMAT05P[i] = mat1?  (3*iMA(_Symbol,_Period,tP5,0,(xlsma==true)?MODE_LWMA:MODE_EMA,PRICE_CLOSE,i+1)) - (2*iMA(_Symbol,_Period,tP5,0,MODE_SMA,PRICE_CLOSE,i+1)):EMPTY_VALUE;
      SMAT07P[i] = mat2?  (3*iMA(_Symbol,_Period,tP7,0,(xlsma==true)?MODE_LWMA:MODE_EMA,PRICE_CLOSE,i+1)) - (2*iMA(_Symbol,_Period,tP7,0,MODE_SMA,PRICE_CLOSE,i+1)):EMPTY_VALUE;
      
      SMAT01[i]  = Entry1?SMAT01C[i]:EMPTY_VALUE;
      SMAT01U[i] = Entry1?SMAT01C[i]:EMPTY_VALUE;
      SMAT01D[i] = Entry1?SMAT01C[i]:EMPTY_VALUE;
       
      SMAT03[i]  = matact?SMAT03C[i]:EMPTY_VALUE;
      SMAT03U[i] = matact?SMAT03C[i]:EMPTY_VALUE;
      SMAT03D[i] = matact?SMAT03C[i]:EMPTY_VALUE;
      
      SMAT05[i]  = mat1?SMAT05C[i]:EMPTY_VALUE;
      SMAT05U[i] = mat1?SMAT05C[i]:EMPTY_VALUE;
      SMAT05D[i] = mat1?SMAT05C[i]:EMPTY_VALUE;
      
      SMAT07[i]  = mat2?SMAT07C[i]:EMPTY_VALUE;
      SMAT07U[i] = mat2?SMAT07C[i]:EMPTY_VALUE;
      SMAT07D[i] = mat2?SMAT07C[i]:EMPTY_VALUE;
      
      (SMAT01C[i]<SMAT01P[i])? (SMAT01U[i] = EMPTY_VALUE):(SMAT01D[i] = EMPTY_VALUE);
      (SMAT03C[i]<SMAT03P[i])? (SMAT03U[i] = EMPTY_VALUE):(SMAT03D[i] = EMPTY_VALUE);
      (SMAT05C[i]<SMAT05P[i])? (SMAT05U[i] = EMPTY_VALUE):(SMAT05D[i] = EMPTY_VALUE);
      (SMAT07C[i]<SMAT07P[i])? (SMAT07U[i] = EMPTY_VALUE):(SMAT07D[i] = EMPTY_VALUE);  
           
       
      //MATREND TFX
      SMAT02C[i] = MAtren_enable?(3*iMA(_Symbol,_Period,tP2,0,(xlsma==true)?MODE_LWMA:MODE_EMA,PRICE_CLOSE,i)) - (2*iMA(_Symbol,_Period,tP2,0,MODE_SMA,PRICE_CLOSE,i)):EMPTY_VALUE;
      SDP02T[i] = BBTT1_enable?SMAT02C[i]+getSMA(tP2,i,vDev1):EMPTY_VALUE;
      SDM02T[i] = BBTT1_enable?SMAT02C[i]-getSMA(tP2,i,vDev1):EMPTY_VALUE;
      SDP022T[i] = BBTT2_enable?SMAT02C[i]+getSMA(tP2,i,vDev2):EMPTY_VALUE;
      SDM022T[i] = BBTT2_enable?SMAT02C[i]-getSMA(tP2,i,vDev2):EMPTY_VALUE;
      
      sSDP02T[i] = BBFTT_enable?SMAT02C[i]+getSMA(tP2,i,vDev1):EMPTY_VALUE;
      sSDM02T[i] = BBFTT_enable?SMAT02C[i]-getSMA(tP2,i,vDev1):EMPTY_VALUE;
      sSDP022T[i] = BBFTT_enable?SMAT02C[i]+getSMA(tP2,i,vDev2):EMPTY_VALUE;
      sSDM022T[i] = BBFTT_enable?SMAT02C[i]-getSMA(tP2,i,vDev2):EMPTY_VALUE;
      
      SMAT04C[i] = eMAtren_enable?(3*iMA(_Symbol,_Period,tP4,0,(xlsma==true)?MODE_LWMA:MODE_EMA,PRICE_CLOSE,i)) - (2*iMA(_Symbol,_Period,tP4,0,MODE_SMA,PRICE_CLOSE,i)):EMPTY_VALUE;
      SMAT06C[i] = eeMAtren_enable?(3*iMA(_Symbol,_Period,tP6,0,(xlsma==true)?MODE_LWMA:MODE_EMA,PRICE_CLOSE,i)) - (2*iMA(_Symbol,_Period,tP6,0,MODE_SMA,PRICE_CLOSE,i)):EMPTY_VALUE; 
      
      SMAT02P[i] = MAtren_enable?(3*iMA(_Symbol,_Period,tP2,0,(xlsma==true)?MODE_LWMA:MODE_EMA,PRICE_CLOSE,i+1)) - (2*iMA(_Symbol,_Period,tP2,0,MODE_SMA,PRICE_CLOSE,i+1)):EMPTY_VALUE;
      SMAT04P[i] = eMAtren_enable?(3*iMA(_Symbol,_Period,tP4,0,(xlsma==true)?MODE_LWMA:MODE_EMA,PRICE_CLOSE,i+1)) - (2*iMA(_Symbol,_Period,tP4,0,MODE_SMA,PRICE_CLOSE,i+1)):EMPTY_VALUE;
      SMAT06P[i] = eeMAtren_enable?(3*iMA(_Symbol,_Period,tP6,0,(xlsma==true)?MODE_LWMA:MODE_EMA,PRICE_CLOSE,i+1)) - (2*iMA(_Symbol,_Period,tP6,0,MODE_SMA,PRICE_CLOSE,i+1)):EMPTY_VALUE; 

      SMAT02[i]  = MAtren_enable?SMAT02C[i]:EMPTY_VALUE;
      SMAT02U[i] = MAtren_enable?SMAT02C[i]:EMPTY_VALUE;
      SMAT02D[i] = MAtren_enable?SMAT02C[i]:EMPTY_VALUE;
       
      SMAT04[i]  = eMAtren_enable?SMAT04C[i]:EMPTY_VALUE;
      SMAT04U[i] = eMAtren_enable?SMAT04C[i]:EMPTY_VALUE;
      SMAT04D[i] = eMAtren_enable?SMAT04C[i]:EMPTY_VALUE;
      
      SMAT06[i]  = eeMAtren_enable?SMAT06C[i]:EMPTY_VALUE;
      SMAT06U[i] = eeMAtren_enable?SMAT06C[i]:EMPTY_VALUE;
      SMAT06D[i] = eeMAtren_enable?SMAT06C[i]:EMPTY_VALUE;
      
      (SMAT02C[i]<SMAT02P[i])? (SMAT02U[i] = EMPTY_VALUE):(SMAT02D[i] = EMPTY_VALUE);
      (SMAT04C[i]<SMAT04P[i])? (SMAT04U[i] = EMPTY_VALUE):(SMAT04D[i] = EMPTY_VALUE);
      (SMAT06C[i]<SMAT06P[i])? (SMAT06U[i] = EMPTY_VALUE):(SMAT06D[i] = EMPTY_VALUE);
      
      //EMA50
      EMA01[i] = EMA50_enable?iMA(_Symbol,_Period,eP1,0,MODE_EMA,PRICE_CLOSE,i):EMPTY_VALUE;
      EMA02[i] = eEMA50_enable?iMA(_Symbol,_Period,eP2,0,MODE_EMA,PRICE_CLOSE,i):EMPTY_VALUE;
      EMA03[i] = eeEMA50_enable?iMA(_Symbol,_Period,eP3,0,MODE_EMA,PRICE_CLOSE,i):EMPTY_VALUE;
      
      //MATREND EMA50
      EMAT01C[i] = EMA50_enable?(3*iMA(_Symbol,_Period,tP2,0,(xlsma==true)?MODE_LWMA:MODE_EMA,PRICE_CLOSE,i)) - (2*iMA(_Symbol,_Period,tP2,0,MODE_SMA,PRICE_CLOSE,i)):EMPTY_VALUE;
      EMAT02C[i] = eEMA50_enable?(3*iMA(_Symbol,_Period,tP4,0,(xlsma==true)?MODE_LWMA:MODE_EMA,PRICE_CLOSE,i)) - (2*iMA(_Symbol,_Period,tP4,0,MODE_SMA,PRICE_CLOSE,i)):EMPTY_VALUE;
      EMAT03C[i] = eeEMA50_enable?(3*iMA(_Symbol,_Period,tP6,0,(xlsma==true)?MODE_LWMA:MODE_EMA,PRICE_CLOSE,i)) - (2*iMA(_Symbol,_Period,tP6,0,MODE_SMA,PRICE_CLOSE,i)):EMPTY_VALUE;
      
      EMAT01P[i] = EMA50_enable?(3*iMA(_Symbol,_Period,tP2,0,(xlsma==true)?MODE_LWMA:MODE_EMA,PRICE_CLOSE,i+1)) - (2*iMA(_Symbol,_Period,tP2,0,MODE_SMA,PRICE_CLOSE,i+1)):EMPTY_VALUE;
      EMAT02P[i] = eEMA50_enable?(3*iMA(_Symbol,_Period,tP4,0,(xlsma==true)?MODE_LWMA:MODE_EMA,PRICE_CLOSE,i+1)) - (2*iMA(_Symbol,_Period,tP4,0,MODE_SMA,PRICE_CLOSE,i+1)):EMPTY_VALUE;
      EMAT03P[i] = eeEMA50_enable?(3*iMA(_Symbol,_Period,tP6,0,(xlsma==true)?MODE_LWMA:MODE_EMA,PRICE_CLOSE,i+1)) - (2*iMA(_Symbol,_Period,tP6,0,MODE_SMA,PRICE_CLOSE,i+1)):EMPTY_VALUE;

      EMAT01[i]  = EMA50_enable?EMAT01C[i]:EMPTY_VALUE;
      EMAT01U[i] = EMA50_enable?EMAT01C[i]:EMPTY_VALUE;
      EMAT01D[i] = EMA50_enable?EMAT01C[i]:EMPTY_VALUE;
       
      EMAT02[i]  = eEMA50_enable?EMAT02C[i]:EMPTY_VALUE;
      EMAT02U[i] = eEMA50_enable?EMAT02C[i]:EMPTY_VALUE;
      EMAT02D[i] = eEMA50_enable?EMAT02C[i]:EMPTY_VALUE;
      
      EMAT03[i]  = eeEMA50_enable?EMAT03C[i]:EMPTY_VALUE;
      EMAT03U[i] = eeEMA50_enable?EMAT03C[i]:EMPTY_VALUE;
      EMAT03D[i] = eeEMA50_enable?EMAT03C[i]:EMPTY_VALUE;
      
      (EMAT01C[i]<EMAT01P[i])? (EMAT01U[i] = EMPTY_VALUE):(EMAT01D[i] = EMPTY_VALUE);
      (EMAT02C[i]<EMAT02P[i])? (EMAT02U[i] = EMPTY_VALUE):(EMAT02D[i] = EMPTY_VALUE);
      (EMAT03C[i]<EMAT03P[i])? (EMAT03U[i] = EMPTY_VALUE):(EMAT03D[i] = EMPTY_VALUE);
            
      //LWMA HILO
      HLWMA01[i] = lwma5?iMA(_Symbol,_Period,(lwma510==true)?lP1:iP1,0,MODE_LWMA,PRICE_HIGH,i):EMPTY_VALUE;
      LLWMA01[i] = lwma5?iMA(_Symbol,_Period,(lwma510==true)?lP1:iP1,0,MODE_LWMA,PRICE_LOW,i):EMPTY_VALUE;
      HLWMA02[i] = lwma10?iMA(_Symbol,_Period,(lwma510==true)?lP2:iP2,0,MODE_LWMA,PRICE_HIGH,i):EMPTY_VALUE;
      LLWMA02[i] = lwma10?iMA(_Symbol,_Period,(lwma510==true)?lP2:iP2,0,MODE_LWMA,PRICE_LOW,i):EMPTY_VALUE;
      HLWMA03[i] = lwmatfa?iMA(_Symbol,_Period,iP3,0,MODE_LWMA,PRICE_HIGH,i):EMPTY_VALUE;
      LLWMA03[i] = lwmatfa?iMA(_Symbol,_Period,iP3,0,MODE_LWMA,PRICE_LOW,i):EMPTY_VALUE;
      HLWMA04[i] = lwmatfx?iMA(_Symbol,_Period,iP4,0,MODE_LWMA,PRICE_HIGH,i):EMPTY_VALUE;
      LLWMA04[i] = lwmatfx?iMA(_Symbol,_Period,iP4,0,MODE_LWMA,PRICE_LOW,i):EMPTY_VALUE;
      HLWMA05[i] = lwmatfup?iMA(_Symbol,_Period,iP5,0,MODE_LWMA,PRICE_HIGH,i):EMPTY_VALUE;
      LLWMA05[i] = lwmatfup?iMA(_Symbol,_Period,iP5,0,MODE_LWMA,PRICE_LOW,i):EMPTY_VALUE;

    }
    
   
    
    
//+------------------------------------------------------------------+ 
   if(shInfo){
   int posX=disX+10,posY=disY+30;
      Sett(cLabel(0,"HPer1",posX,posY,CORNER_RIGHT_UPPER,getPer(95,0)+"  : "+SetCond(SMAT01,SMA01,1),"Lucida Console",10,StringToColor(SetCond(SMAT01,SMA01)))); posY+=20;
      Sett(cLabel(0,"HPer2",posX,posY,CORNER_RIGHT_UPPER,getPer(96,0)+"  : "+SetCond(SMAT02,SMA02,1),"Lucida Console",10,StringToColor(SetCond(SMAT02,SMA02)))); posY+=20;
      Sett(cLabel(0,"HPer3",posX,posY,CORNER_RIGHT_UPPER,getPer(110,0)+" : "+SetCond(EMAT01,EMA01,1),"Lucida Console",10,StringToColor(SetCond(EMAT01,EMA01)))); posY+=20;
      Sett(cLabel(0,"HPer4",posX,posY,CORNER_RIGHT_UPPER,getPer(97,0)+"  : "+SetCond(SMAT03,SMA03,1),"Lucida Console",10,StringToColor(SetCond(SMAT03,SMA03)))); posY+=20;
      Sett(cLabel(0,"HPer5",posX,posY,CORNER_RIGHT_UPPER,getPer(98,0)+"  : "+SetCond(SMAT04,SMA04,1),"Lucida Console",10,StringToColor(SetCond(SMAT04,SMA04)))); posY+=20;
      Sett(cLabel(0,"HPer6",posX,posY,CORNER_RIGHT_UPPER,getPer(111,0)+" : "+SetCond(EMAT02,EMA02,1),"Lucida Console",10,StringToColor(SetCond(EMAT02,EMA02)))); posY+=20;
      Sett(cLabel(0,"HPer7",posX,posY,CORNER_RIGHT_UPPER,getPer(99,0)+"  : "+SetCond(SMAT05,SMA05,1),"Lucida Console",10,StringToColor(SetCond(SMAT05,SMA05)))); posY+=20;
      Sett(cLabel(0,"HPer8",posX,posY,CORNER_RIGHT_UPPER,getPer(100,0)+" : "+SetCond(SMAT06,SMA06,1),"Lucida Console",10,StringToColor(SetCond(SMAT06,SMA06)))); posY+=20;
      Sett(cLabel(0,"HPer9",posX,posY,CORNER_RIGHT_UPPER,getPer(112,0)+" : "+SetCond(EMAT03,EMA03,1),"Lucida Console",10,StringToColor(SetCond(EMAT03,EMA03)))); posY+=20;
      Sett(cLabel(0,"HPer10",posX,posY,CORNER_RIGHT_UPPER,getPer(101,0)+" : "+SetCond(SMAT07,SMA07,1),"Lucida Console",10,StringToColor(SetCond(SMAT07,SMA07)))); 
   }
   return(rates_total);
}
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
string SetCond(double &SMAT[], double &SMA[],int Mode=2)
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{
   string sTrend="DISABLE",cTrend="clrNone";
   if(SMAT[0]>SMA[0] && Close[0]>SMAT[0] && SMAT[0]>SMAT[1]){sTrend="Strong Buy +";cTrend=ColorToString(clStrUp);  } else
   if(SMAT[0]<SMA[0] && Close[0]<SMAT[0] && SMAT[0]<SMAT[1]){sTrend="Strong Sell +";cTrend=ColorToString(clStrDn); } else
   if(SMAT[0]>SMA[0] && Close[0]>SMAT[0] && SMAT[0]<SMAT[1]){sTrend="Strong Buy -";cTrend=ColorToString(clStrUp);  } else
   if(SMAT[0]<SMA[0] && Close[0]<SMAT[0] && SMAT[0]>SMAT[1]){sTrend="Strong Sell -";cTrend=ColorToString(clStrDn); } else
   if(SMAT[0]>SMA[0] && Close[0]<SMAT[0] && Close[0]<SMA[0] && SMAT[0]<SMAT[1]){sTrend="Medium Sell +";cTrend=ColorToString(clMedDn); } else
   if(SMAT[0]<SMA[0] && Close[0]>SMAT[0] && Close[0]>SMA[0] && SMAT[0]>SMAT[1]){sTrend="Medium Buy +";cTrend=ColorToString(clMedUp);  } else
   if(SMAT[0]>SMA[0] && Close[0]<SMAT[0] && Close[0]<SMA[0] && SMAT[0]>SMAT[1]){sTrend="Medium Sell -";cTrend=ColorToString(clMedDn); } else
   if(SMAT[0]<SMA[0] && Close[0]>SMAT[0] && Close[0]>SMA[0] && SMAT[0]<SMAT[1]){sTrend="Medium Buy -";cTrend=ColorToString(clMedUp);  } else
   if(SMAT[0]>SMA[0] && Close[0]<SMAT[0] && Close[0]>SMA[0] && SMAT[0]<SMAT[1]){sTrend="Extreme Sell";cTrend=ColorToString(clExDn);   } else
   if(SMAT[0]<SMA[0] && Close[0]>SMAT[0] && Close[0]<SMA[0] && SMAT[0]>SMAT[1]){sTrend="Extreme Buy";cTrend=ColorToString(clExUp);    } else
   if(SMAT[0]>SMA[0] && Close[0]<SMAT[0] && Close[0]>SMA[0] && SMAT[0]>SMAT[1]){sTrend="Koreksi Up";cTrend=ColorToString(clCorDn);    } else
   if(SMAT[0]<SMA[0] && Close[0]>SMAT[0] && Close[0]<SMA[0] && SMAT[0]<SMAT[1]){sTrend="Koreksi Down";cTrend=ColorToString(clCorUp);  } 
                    
if(Mode==1) return(sTrend);
else return(cTrend);
} 
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
color  getClr(int enumPer,int manPer,bool clrLight=true,color inpClr=clrNONE){
   return(inpClr==clrNONE||inpClr==2147483647?StringToColor(getPer(enumPer,manPer,2,clrLight)):inpClr);
}
string getPer(int enumPer,int manPer,int modeRes=0,bool mClr=true){
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
   string strPer="";
   int    mn=20,hr=1200,dy=28800,wk=201600,mh=806400,yr=9676800,
          mn4=40,hr4=2400,dy4=57600,wk4=403200,mh4=1612800,yr4=19353600,
          mn5=50,hr5=3000,dy5=72000,wk5=504000,mh5=2016000,yr5=24192000,
          mn1=5,hr1=300,dy1=7200,wk1=50400,mh1=201600,yr1=2419200,
          mn2=10,hr2=600,dy2=14400,wk2=100800,mh2=403200,yr2=4838400,
          mn8=80,hr8=4800,dy8=33600,wk8=235200,mh8=940800,yr8=11289600,
          intPer=0;
   color clrPer=clrNONE;
   switch(enumPer){
      case  0: strPer= IntegerToString(manPer);  intPer=manPer;   clrPer=mClr?C'250,250,250':C'100,100,100';  break;
      case  1: strPer= "1Mn";  intPer=   mn;   clrPer=mClr?C'211,211,211':C'255,255,255';  break;/*1 Minute*/
      case  2: strPer= "5Mn";  intPer= 5*mn;   clrPer=mClr?C'238,130,238':C'221,160,221';  break;/*5 Minute*/
      case  3: strPer= "8Mn";  intPer= 8*mn;   clrPer=mClr?C'238,130,238':C'221,160,221';  break;/*5 Minute*/
      case  4: strPer= "15Mn"; intPer=15*mn;   clrPer=mClr?C'238,130,238':C'221,160,221';  break;/*5 Minute*/
      case  5: strPer= "30Mn"; intPer=30*mn;   clrPer=mClr?C'255,255,000':C'190,190,000';  break;/*15 Minute*/
      case  6: strPer= "1Hr";  intPer=   hr;   clrPer=mClr?C'255,000,000':C'125,000,000';  break;/*1 Hours*/
      case  7: strPer= "2Hr";  intPer= 2*hr;   clrPer=mClr?C'230,230,250':C'230,225,255';  break;/*2 Hours*/
      case  8: strPer= "4Hr";  intPer= 4*hr;   clrPer=mClr?C'000,255,000':C'050,205,050';  break;/*4 Hours*/
      case  9: strPer= "1Dy";  intPer=   dy;   clrPer=mClr?C'175,238,238':C'190,225,225';  break;/*1 Day*/
      case 10: strPer= "2Dy";  intPer= 2*dy;   clrPer=mClr?C'000,200,000':C'000,170,000';  break;/*2 Day*/      
      case 11: strPer= "1Wk";  intPer=   wk;   clrPer=mClr?C'106,090,205':C'120,115,190';  break;/*1 Week*/
      case 12: strPer= "2Wk";  intPer= 2*wk;   clrPer=mClr?C'165,042,042':C'185,040,020';  break;/*2 Week*/
      case 13: strPer= "1Mh";  intPer=   mh;   clrPer=mClr?C'000,128,000':C'035,090,035';  break;/*1 Month*/
      case 14: strPer= "4Mh";  intPer= 4*mh;   clrPer=mClr?C'174,125,011':C'150,110,035';  break;/*4 Month*/
      case 15: strPer= "1Yr";  intPer=   yr;   clrPer=mClr?C'255,250,250':C'192,192,192';  break;/*1 Year*/      
           
      case 95: switch(_Period){
                  case  PERIOD_M1 : strPer= "S15"; intPer=          NULL;   clrPer=mClr?C'186,085,211':C'186,085,211';  break;/*TF Entry 1 / PERIOD 20*/
                  case  PERIOD_M5 : strPer= "M1";  intPer=            mn;   clrPer=mClr?C'255,255,255':C'155,155,155';  break;  
                  case  PERIOD_M15: strPer= "M2";  intPer=        2.5*mn;   clrPer=mClr?C'173,255,047':C'073,155,000';  break;
                  case  PERIOD_M30: strPer= "M5";  intPer=          5*mn;   clrPer=mClr?C'165,042,042':C'165,042,042';  break;
                  case  PERIOD_H1 : strPer= "M15"; intPer=         15*mn;   clrPer=mClr?C'000,200,200':C'000,150,150';  break;
                  case  PERIOD_H4 : strPer= "H1";  intPer=            hr;   clrPer=mClr?C'255,000,000':C'125,000,000';  break;
                  case  PERIOD_D1 : strPer= "H8";  intPer=          8*hr;   clrPer=mClr?C'186,085,211':C'186,085,211';  break;
                  case  PERIOD_W1 : strPer= "D1";  intPer=            dy;   clrPer=mClr?C'175,238,238':C'175,238,238';  break;
                  case  PERIOD_MN1: strPer= "W1";  intPer=            wk;   clrPer=mClr?C'043,043,255':C'043,043,255';  break;
               } break;
      case 96: switch(_Period){ 
                  case  PERIOD_M1 : strPer= "S30"; intPer=          mn/2;   clrPer=mClr?C'255,140,000':C'155,040,000';  break;/*TFX Entry / Period 20*/
                  case  PERIOD_M5 : strPer= "M2";  intPer=        2.5*mn;   clrPer=mClr?C'173,255,047':C'073,155,000';  break;
                  case  PERIOD_M15: strPer= "M5";  intPer=          5*mn;   clrPer=mClr?C'238,130,238':C'221,160,221';  break;
                  case  PERIOD_M30: strPer= "M15"; intPer=         15*mn;   clrPer=mClr?C'000,255,255':C'000,255,255';  break;
                  case  PERIOD_H1 : strPer= "M30"; intPer=         30*mn;   clrPer=mClr?C'255,255,000':C'190,190,000';  break;
                  case  PERIOD_H4 : strPer= "H2";  intPer=          2*hr;   clrPer=mClr?C'255,255,255':C'105,105,105';  break;
                  case  PERIOD_D1 : strPer= "H12"; intPer=         12*hr;   clrPer=mClr?C'255,140,000':C'255,140,000';  break;
                  case  PERIOD_W1 : strPer= "D3";  intPer=        2.5*dy;   clrPer=mClr?C'255,020,147':C'255,020,147';  break;
                  case  PERIOD_MN1: strPer= "W2";  intPer=         15*dy;   clrPer=mClr?C'238,130,238':C'238,130,238';  break;
               } break;
      case 97: switch(_Period){
                  case  PERIOD_M1 : strPer= "M1";  intPer=            mn;   clrPer=mClr?C'255,255,255':C'155,155,155';  break;/*TF Active / PERIOD 20*/
                  case  PERIOD_M5 : strPer= "M5";  intPer=          5*mn;   clrPer=mClr?C'238,130,238':C'221,160,221';  break;
                  case  PERIOD_M15: strPer= "M15"; intPer=         15*mn;   clrPer=mClr?C'000,255,255':C'000,255,255';  break;
                  case  PERIOD_M30: strPer= "M30"; intPer=         30*mn;   clrPer=mClr?C'255,255,000':C'190,190,000';  break;
                  case  PERIOD_H1 : strPer= "H1";  intPer=            hr;   clrPer=mClr?C'255,000,000':C'125,000,000';  break;
                  case  PERIOD_H4 : strPer= "H4";  intPer=          4*hr;   clrPer=mClr?C'000,255,000':C'000,070,000';  break;
                  case  PERIOD_D1 : strPer= "D1";  intPer=            dy;   clrPer=mClr?C'175,238,238':C'175,238,238';  break;
                  case  PERIOD_W1 : strPer= "W1";  intPer=            wk;   clrPer=mClr?C'043,043,255':C'043,043,255';  break;
                  case  PERIOD_MN1: strPer= "MN1"; intPer=         30*dy;   clrPer=mClr?C'000,128,000':C'000,128,000';  break;
               } break;
               
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
      case 98: switch(_Period){
                  case  PERIOD_M1 : strPer= "M2";  intPer=        2.5*mn;   clrPer=mClr?C'173,255,047':C'073,155,000';  break;/*TFX / PERIOD 20 ACUAN 1/ EMA 50*/
                  case  PERIOD_M5 : strPer= "M15"; intPer=          NULL;   clrPer=mClr?C'000,200,200':C'000,150,150';  break;
                  case  PERIOD_M15: strPer= "M30"; intPer=         30*mn;   clrPer=mClr?C'255,255,000':C'190,190,000';  break;
                  case  PERIOD_M30: strPer= "H1";  intPer=            hr;   clrPer=mClr?C'255,000,000':C'125,000,000';  break;
                  case  PERIOD_H1 : strPer= "H2";  intPer=          2*hr;   clrPer=mClr?C'255,255,255':C'105,105,105';  break;
                  case  PERIOD_H4 : strPer= "H8";  intPer=          8*hr;   clrPer=mClr?C'186,085,211':C'186,085,211';  break;
                  case  PERIOD_D1 : strPer= "D3";  intPer=        2.5*dy;   clrPer=mClr?C'255,020,147':C'255,020,147';  break;
                  case  PERIOD_W1 : strPer= "W2";  intPer=         15*dy;   clrPer=mClr?C'238,130,238':C'238,130,238';  break;
                  case  PERIOD_MN1: strPer= "MN2"; intPer=       2*30*dy;   clrPer=mClr?C'174,125,011':C'150,110,035';  break;
               } break;
      case 99: switch(_Period){
                  case  PERIOD_M1 : strPer= "M5";  intPer=          5*mn;   clrPer=mClr?C'238,130,238':C'221,160,221';  break;/*TF Up / PERIOD 20 ACUAN 2*/
                  case  PERIOD_M5 : strPer= "M15"; intPer=         15*mn;   clrPer=mClr?C'000,200,200':C'000,150,150';  break;
                  case  PERIOD_M15: strPer= "H1";  intPer=            hr;   clrPer=mClr?C'255,000,000':C'125,000,000';  break;
                  case  PERIOD_M30: strPer= "H2";  intPer=          2*hr;   clrPer=mClr?C'255,255,255':C'105,105,105';  break;
                  case  PERIOD_H1 : strPer= "H4";  intPer=          4*hr;   clrPer=mClr?C'000,255,000':C'000,070,000';  break;
                  case  PERIOD_H4 : strPer= "H12"; intPer=         12*hr;   clrPer=mClr?C'255,140,000':C'255,140,000';  break;
                  case  PERIOD_D1 : strPer= "W1";  intPer=            wk;   clrPer=mClr?C'043,043,255':C'043,043,255';  break;
                  case  PERIOD_W1 : strPer= "MN1"; intPer=         30*dy;   clrPer=mClr?C'000,128,000':C'035,090,035';  break;
               } break;
      case 100: switch(_Period){
                  case  PERIOD_M1 : strPer= "M15"; intPer=         15*mn;   clrPer=mClr?C'000,200,200':C'000,150,150';  break; /*TFX Up / PERIOD 20 ACUAN 3*/
                  case  PERIOD_M5 : strPer= "M30"; intPer=         30*mn;   clrPer=mClr?C'255,255,000':C'190,190,000';  break;
                  case  PERIOD_M15: strPer= "H2";  intPer=          2*hr;   clrPer=mClr?C'255,255,255':C'105,105,105';  break;
                  case  PERIOD_M30: strPer= "H4";  intPer=          4*hr;   clrPer=mClr?C'000,255,000':C'000,070,000';  break;
                  case  PERIOD_H1 : strPer= "H8";  intPer=          8*hr;   clrPer=mClr?C'186,085,211':C'186,085,211';  break;
                  case  PERIOD_H4 : strPer= "D1";  intPer=            dy;   clrPer=mClr?C'175,238,238':C'175,238,238';  break;
                  case  PERIOD_D1 : strPer= "W2";  intPer=         15*dy;   clrPer=mClr?C'238,130,238':C'238,130,238';  break;
                  case  PERIOD_W1 : strPer= "MN2"; intPer=       2*30*dy;   clrPer=mClr?C'174,125,011':C'150,110,035';  break;
               } break;
      case 101: switch(_Period){
                  case  PERIOD_M1 : strPer= "M15"; intPer=         15*mn;   clrPer=mClr?C'000,200,200':C'000,150,150';  break; /*TF 2 Up / PERIOD 20 ACUAN 4*/
                  case  PERIOD_M5 : strPer= "H1";  intPer=            hr;   clrPer=mClr?C'255,000,000':C'125,000,000';  break;
                  case  PERIOD_M15: strPer= "H4";  intPer=          4*hr;   clrPer=mClr?C'000,255,000':C'000,070,000';  break;
                  case  PERIOD_M30: strPer= "H8";  intPer=          8*hr;   clrPer=mClr?C'186,085,211':C'186,085,211';  break;
                  case  PERIOD_H1 : strPer= "H12"; intPer=         12*hr;   clrPer=mClr?C'255,140,000':C'255,140,000';  break;
                  case  PERIOD_H4 : strPer= "D3";  intPer=        2.5*dy;   clrPer=mClr?C'255,020,147':C'255,020,147';  break;
                  case  PERIOD_D1 : strPer= "MN1"; intPer=         30*dy;   clrPer=mClr?C'000,128,000':C'035,090,035';  break;
               } break;
               
               
               
                 
      case 102: switch(_Period){
                  case  PERIOD_M1 : strPer= "S15"; intPer=            NULL;   clrPer=mClr?C'000,255,000':C'000,155,000';  break;/*TF Entry 1 / PERIOD 20*/
                  case  PERIOD_M5 : strPer= "M1";  intPer=            mn*2;   clrPer=mClr?C'255,255,255':C'155,155,155';  break;  
                  case  PERIOD_M15: strPer= "M2";  intPer=        2.5*mn*2;   clrPer=mClr?C'173,255,047':C'073,155,000';  break;
                  case  PERIOD_M30: strPer= "M5";  intPer=          5*mn*2;   clrPer=mClr?C'165,042,042':C'165,042,042';  break;
                  case  PERIOD_H1 : strPer= "M15"; intPer=         15*mn*2;   clrPer=mClr?C'000,200,200':C'000,150,150';  break;
                  case  PERIOD_H4 : strPer= "H1";  intPer=            hr*2;   clrPer=mClr?C'255,000,000':C'125,000,000';  break;
                  case  PERIOD_D1 : strPer= "H8";  intPer=          8*hr*2;   clrPer=mClr?C'186,085,211':C'186,085,211';  break;
                  case  PERIOD_W1 : strPer= "D1";  intPer=            dy*2;   clrPer=mClr?C'175,238,238':C'175,238,238';  break;
                  case  PERIOD_MN1: strPer= "W1";  intPer=            wk*2;   clrPer=mClr?C'043,043,255':C'043,043,255';  break;
               } break;
      case 103: switch(_Period){ 
                  case  PERIOD_M1 : strPer= "S30"; intPer=              mn;   clrPer=mClr?C'255,140,000':C'155,040,000';  break;/*TFX Entry / Period 20*/
                  case  PERIOD_M5 : strPer= "M2";  intPer=        2.5*mn*2;   clrPer=mClr?C'173,255,047':C'073,155,000';  break;
                  case  PERIOD_M15: strPer= "M5";  intPer=          5*mn*2;   clrPer=mClr?C'238,130,238':C'221,160,221';  break;
                  case  PERIOD_M30: strPer= "M15"; intPer=         15*mn*2;   clrPer=mClr?C'000,255,255':C'000,255,255';  break;
                  case  PERIOD_H1 : strPer= "M30"; intPer=         30*mn*2;   clrPer=mClr?C'255,255,000':C'190,190,000';  break;
                  case  PERIOD_H4 : strPer= "H2";  intPer=          2*hr*2;   clrPer=mClr?C'255,255,255':C'105,105,105';  break;
                  case  PERIOD_D1 : strPer= "H12"; intPer=         12*hr*2;   clrPer=mClr?C'255,140,000':C'255,140,000';  break;
                  case  PERIOD_W1 : strPer= "D3";  intPer=        2.5*dy*2;   clrPer=mClr?C'255,020,147':C'255,020,147';  break;
                  case  PERIOD_MN1: strPer= "W2";  intPer=         15*dy*2;   clrPer=mClr?C'238,130,238':C'238,130,238';  break;
               } break;
      case 104: switch(_Period){
                  case  PERIOD_M1 : strPer= "M1";  intPer=            mn*2;   clrPer=mClr?C'255,255,255':C'155,155,155';  break;/*TF Active / PERIOD 20*/
                  case  PERIOD_M5 : strPer= "M5";  intPer=          5*mn*2;   clrPer=mClr?C'238,130,238':C'221,160,221';  break;
                  case  PERIOD_M15: strPer= "M15"; intPer=         15*mn*2;   clrPer=mClr?C'000,255,255':C'000,255,255';  break;
                  case  PERIOD_M30: strPer= "M30"; intPer=         30*mn*2;   clrPer=mClr?C'255,255,000':C'190,190,000';  break;
                  case  PERIOD_H1 : strPer= "H1";  intPer=            hr*2;   clrPer=mClr?C'255,000,000':C'125,000,000';  break;
                  case  PERIOD_H4 : strPer= "H4";  intPer=          4*hr*2;   clrPer=mClr?C'000,255,000':C'000,070,000';  break;
                  case  PERIOD_D1 : strPer= "D1";  intPer=            dy*2;   clrPer=mClr?C'175,238,238':C'175,238,238';  break;
                  case  PERIOD_W1 : strPer= "W1";  intPer=            wk*2;   clrPer=mClr?C'043,043,255':C'043,043,255';  break;
                  case  PERIOD_MN1: strPer= "MN1"; intPer=         30*dy*2;   clrPer=mClr?C'000,128,000':C'000,128,000';  break;
               } break;
               
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
      case 105: switch(_Period){
                  case  PERIOD_M1 : strPer= "M2";  intPer=        2.5*mn*2;   clrPer=mClr?C'173,255,047':C'073,155,000';  break;/*TFX / PERIOD 20 ACUAN 1/ EMA 50*/
                  case  PERIOD_M5 : strPer= "M15"; intPer=          NULL;   clrPer=mClr?C'000,200,200':C'000,150,150';  break;
                  case  PERIOD_M15: strPer= "M30"; intPer=         30*mn*2;   clrPer=mClr?C'255,255,000':C'190,190,000';  break;
                  case  PERIOD_M30: strPer= "H1";  intPer=            hr*2;   clrPer=mClr?C'255,000,000':C'125,000,000';  break;
                  case  PERIOD_H1 : strPer= "H2";  intPer=          2*hr*2;   clrPer=mClr?C'255,255,255':C'105,105,105';  break;
                  case  PERIOD_H4 : strPer= "H8";  intPer=          8*hr*2;   clrPer=mClr?C'186,085,211':C'186,085,211';  break;
                  case  PERIOD_D1 : strPer= "D3";  intPer=        2.5*dy*2;   clrPer=mClr?C'255,020,147':C'255,020,147';  break;
                  case  PERIOD_W1 : strPer= "W2";  intPer=         15*dy*2;   clrPer=mClr?C'238,130,238':C'238,130,238';  break;
                  case  PERIOD_MN1: strPer= "MN2"; intPer=       2*30*dy*2;   clrPer=mClr?C'174,125,011':C'150,110,035';  break;
               } break;
      case 106: switch(_Period){
                  case  PERIOD_M1 : strPer= "M5";  intPer=          5*mn*2;   clrPer=mClr?C'238,130,238':C'221,160,221';  break;/*TF Up / PERIOD 20 ACUAN 2*/
                  case  PERIOD_M5 : strPer= "M15"; intPer=         15*mn*2;   clrPer=mClr?C'000,200,200':C'000,150,150';  break;
                  case  PERIOD_M15: strPer= "H1";  intPer=            hr*2;   clrPer=mClr?C'255,000,000':C'125,000,000';  break;
                  case  PERIOD_M30: strPer= "H2";  intPer=          2*hr*2;   clrPer=mClr?C'255,255,255':C'105,105,105';  break;
                  case  PERIOD_H1 : strPer= "H4";  intPer=          4*hr*2;   clrPer=mClr?C'000,255,000':C'000,070,000';  break;
                  case  PERIOD_H4 : strPer= "H12"; intPer=         12*hr*2;   clrPer=mClr?C'255,140,000':C'255,140,000';  break;
                  case  PERIOD_D1 : strPer= "W1";  intPer=            wk*2;   clrPer=mClr?C'043,043,255':C'043,043,255';  break;
                  case  PERIOD_W1 : strPer= "MN1"; intPer=         30*dy*2;   clrPer=mClr?C'000,128,000':C'035,090,035';  break;
               } break;
      case 107: switch(_Period){
                  case  PERIOD_M1 : strPer= "M15"; intPer=         15*mn*2;   clrPer=mClr?C'000,200,200':C'000,150,150';  break; /*TFX Up / PERIOD 20 ACUAN 3*/
                  case  PERIOD_M5 : strPer= "M30"; intPer=         30*mn*2;   clrPer=mClr?C'255,255,000':C'190,190,000';  break;
                  case  PERIOD_M15: strPer= "H2";  intPer=          2*hr*2;   clrPer=mClr?C'255,255,255':C'105,105,105';  break;
                  case  PERIOD_M30: strPer= "H4";  intPer=          4*hr*2;   clrPer=mClr?C'000,255,000':C'000,070,000';  break;
                  case  PERIOD_H1 : strPer= "H8";  intPer=          8*hr*2;   clrPer=mClr?C'186,085,211':C'186,085,211';  break;
                  case  PERIOD_H4 : strPer= "D1";  intPer=            dy*2;   clrPer=mClr?C'175,238,238':C'175,238,238';  break;
                  case  PERIOD_D1 : strPer= "W2";  intPer=         15*dy*2;   clrPer=mClr?C'238,130,238':C'238,130,238';  break;
                  case  PERIOD_W1 : strPer= "MN2"; intPer=       2*30*dy*2;   clrPer=mClr?C'174,125,011':C'150,110,035';  break;
               } break;
      case 108: switch(_Period){
                  case  PERIOD_M1 : strPer= "M15"; intPer=         15*mn*2;   clrPer=mClr?C'000,200,200':C'000,150,150';  break; /*TF 2 Up / PERIOD 20 ACUAN 4*/
                  case  PERIOD_M5 : strPer= "H1";  intPer=            hr*2;   clrPer=mClr?C'255,000,000':C'125,000,000';  break;
                  case  PERIOD_M15: strPer= "H4";  intPer=          4*hr*2;   clrPer=mClr?C'000,255,000':C'000,070,000';  break;
                  case  PERIOD_M30: strPer= "H8";  intPer=          8*hr*2;   clrPer=mClr?C'186,085,211':C'186,085,211';  break;
                  case  PERIOD_H1 : strPer= "H12"; intPer=         12*hr*2;   clrPer=mClr?C'255,140,000':C'255,140,000';  break;
                  case  PERIOD_H4 : strPer= "D3";  intPer=        2.5*dy*2;   clrPer=mClr?C'255,020,147':C'255,020,147';  break;
                  case  PERIOD_D1 : strPer= "MN1"; intPer=         30*dy*2;   clrPer=mClr?C'000,128,000':C'035,090,035';  break;
               } break;
               

               
      case 110: switch(_Period){
                  case  PERIOD_M1 : strPer= "EMA50 15Sc"; intPer=  mn5/4;   clrPer=mClr?C'000,200,000':C'000,170,000';  break;/*TF Entry / EMA50*/
                  case  PERIOD_M5 : strPer= "EMA50 1Mn";  intPer=    mn5;   clrPer=mClr?C'000,206,209':C'000,206,209';  break;
                  case  PERIOD_M15: strPer= "EMA50 5Mn";  intPer=  5*mn5;   clrPer=mClr?C'000,200,000':C'000,170,000';  break;
                  case  PERIOD_M30: strPer= "EMA50 5Mn";  intPer=  5*mn5;   clrPer=mClr?C'000,255,255':C'065,105,225';  break;
                  case  PERIOD_H1 : strPer= "EMA50 15Mn"; intPer= 15*mn5;   clrPer=mClr?C'255,255,000':C'190,190,000';  break;
                  case  PERIOD_H4 : strPer= "EMA50 1Hr";  intPer=    hr5;   clrPer=mClr?C'230,230,250':C'230,225,255';  break;
                  case  PERIOD_D1 : strPer= "EMA50 4Hr";  intPer=  4*hr5;   clrPer=mClr?C'186,085,211':C'180,065,230';  break;
                  case  PERIOD_W1 : strPer= "EMA50 Dy";   intPer=    dy5;   clrPer=mClr?C'000,200,000':C'000,170,000';  break;
                  case  PERIOD_MN1: strPer= "EMA50 Wk";   intPer=    wk5;   clrPer=mClr?C'165,042,042':C'185,040,020';  break;
               } break;  
      case 111: switch(_Period){
                  case  PERIOD_M1 : strPer= "EMA50 1Mn"; intPer=   mn5;   clrPer=mClr?C'000,206,209':C'000,206,209';  break;/*TF Active / EMA50*/
                  case  PERIOD_M5 : strPer= "EMA50 5Mn"; intPer= 5*mn5;   clrPer=mClr?C'000,200,000':C'000,170,000';  break;
                  case  PERIOD_M15: strPer= "EMA50 15Mn";intPer=15*mn5;   clrPer=mClr?C'255,255,000':C'190,190,000';  break;
                  case  PERIOD_M30: strPer= "EMA50 30Mn";intPer=30*mn5;   clrPer=mClr?C'255,000,000':C'125,000,000';  break;
                  case  PERIOD_H1 : strPer= "EMA50 1Hr"; intPer=   hr5;   clrPer=mClr?C'230,230,250':C'230,225,255';  break;
                  case  PERIOD_H4 : strPer= "EMA50 4Hr"; intPer= 4*hr5;   clrPer=mClr?C'186,085,211':C'180,065,230';  break;
                  case  PERIOD_D1 : strPer= "EMA50 1Dy"; intPer=   dy5;   clrPer=mClr?C'000,200,000':C'000,170,000';  break;
                  case  PERIOD_W1 : strPer= "EMA50 1Wk"; intPer=   wk5;   clrPer=mClr?C'165,042,042':C'185,040,020';  break;
                  case  PERIOD_MN1: strPer= "EMA50 1Mh"; intPer=   mh5;   clrPer=mClr?C'174,125,011':C'150,110,035';  break;
               } break;  
      case 112: switch(_Period){
                  case  PERIOD_M1 : strPer= "EMA50 5Mn";  intPer= 5*mn5;   clrPer=mClr?C'000,200,000':C'000,170,000';  break;/*TF Up / EMA50*/
                  case  PERIOD_M5 : strPer= "EMA50 15Mn"; intPer=15*mn5;   clrPer=mClr?C'255,255,000':C'190,190,000';  break;
                  case  PERIOD_M15: strPer= "EMA50 1Hr";  intPer=   hr5;   clrPer=mClr?C'230,230,250':C'230,225,255';  break;
                  case  PERIOD_M30: strPer= "EMA50 1Hr";  intPer=   hr5;   clrPer=mClr?C'230,230,250':C'230,225,255';  break;
                  case  PERIOD_H1 : strPer= "EMA50 4Hr";  intPer= 4*hr5;   clrPer=mClr?C'186,085,211':C'180,065,230';  break;
                  case  PERIOD_H4 : strPer= "EMA50 1Dy";  intPer=   dy5;   clrPer=mClr?C'000,200,000':C'000,170,000';  break;
                  case  PERIOD_D1 : strPer= "EMA50 1Wk";  intPer=   wk5;   clrPer=mClr?C'165,042,042':C'185,040,020';  break;
                  case  PERIOD_W1 : strPer= "EMA50 1Mh";  intPer=   mh5;   clrPer=mClr?C'174,125,011':C'150,110,035';  break;
                  case  PERIOD_MN1: strPer= "EMA50 4Mh";  intPer= 4*mh5;   clrPer=mClr?C'255,250,250':C'192,192,192';  break;
               } break;
      
      case 115: switch(_Period){
                  case  PERIOD_M1 : strPer="1Mn";   intPer=   mn1;   clrPer=mClr?C'255,000,000':C'125,000,000';  break;/*LWMA 5*/
                  case  PERIOD_M5 : strPer="5Mn";   intPer= 5*mn1;   clrPer=mClr?C'211,211,211':C'255,255,255';  break;
                  case  PERIOD_M15: strPer="15Mn";  intPer=15*mn1;   clrPer=mClr?C'238,130,238':C'221,160,221';  break;
                  case  PERIOD_M30: strPer="30Mn";  intPer=30*mn1;   clrPer=mClr?C'000,255,255':C'065,105,225';  break;
                  case  PERIOD_H1 : strPer="1Hr";   intPer=   hr1;   clrPer=mClr?C'000,255,255':C'065,105,225';  break;
                  case  PERIOD_H4 : strPer="4Hr";   intPer= 4*hr1;   clrPer=mClr?C'255,000,000':C'125,000,000';  break;
                  case  PERIOD_D1 : strPer="1Dy";   intPer=   dy1;   clrPer=mClr?C'000,255,000':C'050,205,050';  break;
                  case  PERIOD_W1 : strPer="1Wk";   intPer=   wk1;   clrPer=mClr?C'175,238,238':C'190,225,225';  break;
                  case  PERIOD_MN1: strPer="1Mh";   intPer=   mh1;   clrPer=mClr?C'106,090,205':C'120,115,190';  break;
               } break;
      case 116: switch(_Period){ 
                  case  PERIOD_M1 : strPer= "1Mn";  intPer=   mn2;   clrPer=mClr?C'255,000,000':C'125,000,000';  break;
                  case  PERIOD_M5 : strPer= "5Mn";  intPer= 5*mn2;   clrPer=mClr?C'255,255,000':C'190,190,000';  break;/*LWMA 10*/
                  case  PERIOD_M15: strPer= "15Mn"; intPer=15*mn2;   clrPer=mClr?C'238,130,238':C'221,160,221';  break;
                  case  PERIOD_M30: strPer= "30Mn"; intPer=30*mn2;   clrPer=mClr?C'000,255,255':C'065,105,225';  break;
                  case  PERIOD_H1 : strPer= "1Hr";  intPer=   hr2;   clrPer=mClr?C'255,255,000':C'190,190,000';  break;
                  case  PERIOD_H4 : strPer= "4Hr";  intPer= 4*hr2;   clrPer=mClr?C'230,230,250':C'230,225,255';  break;
                  case  PERIOD_D1 : strPer= "1Dy";  intPer=   dy2;   clrPer=mClr?C'186,085,211':C'180,065,230';  break;
                  case  PERIOD_W1 : strPer= "1Wk";  intPer=   wk2;   clrPer=mClr?C'000,200,000':C'000,170,000';  break;
                  case  PERIOD_MN1: strPer= "1Mh";  intPer=   mn2;   clrPer=mClr?C'165,042,042':C'185,040,020';  break;
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
   else if(iPX=="2Wk") {MinTF=PERIOD_M5;  MaxTF=PERIOD_MN1;}
   else if(iPX=="1Wk") {MinTF=PERIOD_M5;  MaxTF=PERIOD_MN1;}
   else if(iPX=="2Dy") {MinTF=PERIOD_M5;  MaxTF=PERIOD_W1; }
   else if(iPX=="1Dy") {MinTF=PERIOD_M5;  MaxTF=PERIOD_W1; }
   else if(iPX=="4Hr") {MinTF=PERIOD_M5;  MaxTF=PERIOD_D1; }
   else if(iPX=="2Hr") {MinTF=PERIOD_M5;  MaxTF=PERIOD_H4; }
   else if(iPX=="1Hr") {MinTF=PERIOD_M1;  MaxTF=PERIOD_H4; }
   else if(iPX=="15Mn"){MinTF=PERIOD_M1;  MaxTF=PERIOD_H1; }
   else if(iPX=="8Mn") {MinTF=PERIOD_M1;  MaxTF=PERIOD_M15; }
   else if(iPX=="5Mn") {MinTF=PERIOD_M1;  MaxTF=PERIOD_M15;}
   else if(iPX=="2Mn") {MinTF=PERIOD_M1;  MaxTF=PERIOD_M15; }
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