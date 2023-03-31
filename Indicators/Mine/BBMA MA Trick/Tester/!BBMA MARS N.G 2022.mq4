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
#property indicator_buffers 78

enum eModeMA         {_DisableAll/*Disable*/,_shEMA50/*Show EMA50*/,_shMAtr/*Show MATrend*/};
enum eModeBB         {_DisableBB/*Disable*/,_shSD1/*Show BB SD 1*/,_shSD2/*Show BB SD 2*/,_shFSD/*Show BB SD 1 & 2*/};
enum eModeLine       {_0L/*Solid*/,_1L/*Dash*/,_2L/*Dot*/,_3L/*Dash Dot*/,_4L/*Dash Dot Dot*/};




input bool     iOn               = true;           //Indicator On
input bool showmathead           = false;           //Show MATrend Header
input bool matall                = false;          //Turn OFF All MA TRICK 
input bool mars                  = false;          //Turn OFF All MA TRICK 
input double HMASpeed            = 2.0;
input eModeLine linemode         = _2L;            //Line MATrick Type    
input eModeLine linemode1        = _3L;            //Line BB Type SD 1   
input eModeLine linemode2        = _1L;            //Line BB Type SD 2     


input string                 _INFO= "--- INFO ---";//_______________________00
input bool     shInfo             = false;//Show Info
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
   
 
input string                  _BB= "--- BB SETTING ---";//_______________________00           
input eModeBB  s0ModeBB          = _shSD2;         //BB ACTIVE 
input eModeBB  s1ModeBB          = _DisableBB;     //BB TF ACUAN 01
input eModeBB  s2ModeBB          = _DisableBB;     //BB TF ACUAN 02 
input eModeBB  s3ModeBB          = _DisableBB;     //BB TF ACUAN 03 
input eModeBB  s4ModeBB          = _DisableBB;     //BB TF ACUAN 04
input eModeBB  s5ModeBB          = _DisableBB;     //BB TF ACUAN 05
   
input string           _MODEENTRY= "--- TF ENTRY ---";//_______________________00
input ENUM_MA_METHOD
               modeMA            = MODE_SMA;       //---------- MA Method ----------
input bool Entry0                = false;          //TF ENTRY
input bool Entry1                = false;          //TF KONFIRMASI 1
input bool Entry2                = true;           //TF KONFIRMASI 2

input string           _MODEBASIC= "--- SETTING TF ---";//_______________________00  
input bool tfactive              = true;           //TF ACTIVE 
input bool acuan01               = true;          //TF ACUAN 01
input bool acuan02               = true;          //TF ACUAN 02
input bool acuan03               = true;          //TF ACUAN 03
input bool acuan04               = false;          //TF ACUAN 04
input bool acuan05               = false;          //TF ACUAN 05
input bool acuan06               = false;          //TF ACUAN 06
input bool acuan07               = false;          //TF ACUAN 07

          

input string                _LWMA= "--- LWMA HiLo SETTING ---";//_______________________00 
input bool lwma510               = false;          //MODE 5/10
input bool lwma5                 = false;          //HiLo LWMA 5
input bool lwma10                = false;          //HiLo LWMA 10
input color    clLWSMA1          = clrNONE,        //LWMA 5
               clLWSMA2          = clrNONE;        //LWMA 10  
input bool lwma3                 = false;          //HiLo LWMA TF Active
input bool lwma4                 = false;          //HiLo LWMA TFX 
input color    clLWSMA30         = clrNONE,        //LWMA TF Active
               clLWSMA40         = clrNONE;        //LWMA TFX  


input string              _cENTRY= "--- COLOR TF ENTRY ---";//_______________________00             
input color    clSMA0            = clrNONE,//-------- MID
               clSMAT0           = clrNONE;//-------- MA TRICK 
input string        _ckonfirmasi1= "--- COLOR TF KONFIRMASI 1 ---";//_______________________00             
input color    clSMA1            = clrNONE,//-------- MID
               clSMAT1           = clrNONE;//-------- MA TRICK 

input string        _ckonfirmasi2= "--- COLOR TF KONFIRMASI 2 ---";//_______________________00                  
input color    clSMA2            = clrNONE,//-------- MID 
               clSMAT2           = clrNONE;//-------- MA TRICK

input string             _cACTIVE= "--- COLOR TF ACTIVE ---";//_______________________00               
input color    clSMA3            = clrNONE,//-------- MID
               clSMAT3           = clrNONE,//-------- MA TRICK
               clSDP3            = clrDodgerBlue,//-------- SD +
               clSDM3            = clrDodgerBlue;//-------- SD -  
input string              _acuan1= "--- COLOR TF ACUAN 01 ---";//_______________________00                 
input color    clSMA4            = clrNONE,//-------- MID
               clSMAT4           = clrNONE,//-------- MA TRICK
               clSDP4            = clrNONE,//-------- SD +
               clSDM4            = clrNONE;//-------- SD - 

input string              _acuan2= "--- COLOR TF ACUAN 02 ---";//_______________________00                
input color    clSMA5            = clrNONE,//-------- MID
               clSMAT5           = clrNONE,//-------- MA TRICK 
               clSDP5            = clrNONE,//-------- SD +
               clSDM5            = clrNONE;//-------- SD -  
input string              _acuan3= "--- COLOR TF ACUAN 03 ---";//_______________________00                 
input color    clSMA6            = clrNONE,//-------- MID
               clSMAT6           = clrNONE,//-------- MA TRICK
               clSDP6            = clrNONE,//-------- SD +
               clSDM6            = clrNONE;//-------- SD - 
input string              _acuan4= "--- COLOR TF ACUAN 04 ---";//_______________________00                
input color    clSMA7            = clrNONE,//-------- MID
               clSMAT7           = clrNONE,//-------- MA TRICK
               clSDP7            = clrNONE,//-------- SD +
               clSDM7            = clrNONE;//-------- SD -
input string              _acuan5= "--- COLOR TF ACUAN 05 ---";//_______________________00                
input color    clSMA8            = clrNONE,//-------- MID
               clSMAT8           = clrNONE,//-------- MA TRICK
               clSDP8            = clrNONE,//-------- SD +
               clSDM8            = clrNONE;//-------- SD -
input string              _acuan6= "--- COLOR TF ACUAN 06 ---";//_______________________00                
input color    clSMA9            = clrNONE,//-------- MID
               clSMAT9           = clrNONE;//-------- MA TRICK
input string              _acuan7= "--- COLOR TF ACUAN 07 ---";//_______________________00                
input color    clSMA10           = clrNONE,//-------- MID
               clSMAT10          = clrNONE;//-------- MA TRICK

            


string iName; 
int    iP0,iP1,iP2,iP3,iP4,iP5,iP6,iP7,iP8,iP9,iP10,iP11,iP12,
       tP0,tP1,tP2,tP3,tP4,tP5,tP6,tP7,tP8,tP9,tP10,tP11,tP12,
       lP1,lP2;
double 
SMA00[],SDP00[],SDM00[],SDP000[],SDM000[],SMAT00[],
SMA01[],SDP01[],SDM01[],SDP012[],SDM012[],SMAT01[],
SMA02[],SDP02[],SDM02[],SDP022[],SDM022[],SMAT02[],
SMA03[],SDP03[],SDM03[],SDP032[],SDM032[],SMAT03[],
SMA04[],SDP04[],SDM04[],SDP042[],SDM042[],SMAT04[],
SMA05[],SDP05[],SDM05[],SDP052[],SDM052[],SMAT05[],
SMA06[],SDP06[],SDM06[],SDP062[],SDM062[],SMAT06[],
SMA07[],SDP07[],SDM07[],SDP072[],SDM072[],SMAT07[],
SMA08[],SDP08[],SDM08[],SDP082[],SDM082[],SMAT08[],
SMA09[],SDP09[],SDM09[],SDP092[],SDM092[],SMAT09[],
SMA10[],SDP10[],SDM10[],SDP102[],SDM102[],SMAT10[],



HLWMA01[],LLWMA01[],HLWMA02[],LLWMA02[],
HLWMA03[],LLWMA03[],HLWMA04[],LLWMA04[],
sSDP03[],sSDM03[],sSDP032[],sSDM032[],
sSDP04[],sSDM04[],sSDP042[],sSDM042[],
sSDP05[],sSDM05[],sSDP052[],sSDM052[],
sSDP06[],sSDM06[],sSDP062[],sSDM062[],
sSDP07[],sSDM07[],sSDP072[],sSDM072[],
sSDP08[],sSDM08[],sSDP082[],sSDM082[];
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
     
     XBB1_enable = s1ModeBB==_shSD1,
     XBB2_enable = s1ModeBB==_shSD2,
     XBBF_enable = s1ModeBB==_shFSD,
          
     bBB1_enable = s2ModeBB==_shSD1,
     bBB2_enable = s2ModeBB==_shSD2,
     bBBF_enable = s2ModeBB==_shFSD,
     
     b2BB1_enable = s3ModeBB==_shSD1,
     b2BB2_enable = s3ModeBB==_shSD2,
     b2BBF_enable = s3ModeBB==_shFSD,
     
     b3BB1_enable = s4ModeBB==_shSD1,
     b3BB2_enable = s4ModeBB==_shSD2,
     b3BBF_enable = s4ModeBB==_shFSD,
     
     b4BB1_enable = s5ModeBB==_shSD1,
     b4BB2_enable = s5ModeBB==_shSD2,
     b4BBF_enable = s5ModeBB==_shFSD,
        
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
     

//+==================================================================+
//| Custom indicator initialization function                         |
//+==================================================================+ 
int OnInit() {
//--- code start
{
int my_acc = (int)AccountInfoInteger(ACCOUNT_LOGIN);
   //--- add as many accounts as necessary -- example-
int AccNbr[] = { 1300010838,
                 2100269645,
               };
bool is_auth = false;
for(int i=0;i<ArraySize(AccNbr);i++)
   if(AccNbr[i] == my_acc)
      is_auth = true;
 
   if(is_auth)
     {Comment("");}
   else 
     {
     Comment("Account : Not Authorized  |  EXPIRE 05.01.2023");
     datetime TrialEndDate = D'01.05.2023 23:00:00'; // <-- write here the date when you the MT4 program stops
     if (TimeCurrent() > TrialEndDate)
     {Alert("Trial period has expired!"); return(-1);}
     }  
}
//--- code end 
if(WindowExpertName()!="!BBMA MARS N.G 2022"){
      Alert("Warning !!!\n INDICATOR'S NAME HAS BEEN CHANGED '"+WindowExpertName()+"'\n PLEASE RETURN TO '"+"!BBMA MARS N.G 2022"+"'");
      ChartIndicatorDelete(0,0,WindowExpertName());}
      
   iName="!BBMA MATrick N.G 2022";   
    
   //SMA
   iP0=StrToInteger(getPer(94,0,1));     
   iP1=StrToInteger(getPer(95,0,1));
   iP2=StrToInteger(getPer(96,0,1));
   iP3=StrToInteger(getPer(97,0,1));
   iP4=StrToInteger(getPer(98,0,1));
   iP5=StrToInteger(getPer(99,0,1));
   iP6=StrToInteger(getPer(100,0,1));
   iP7=StrToInteger(getPer(101,0,1));
   iP8=StrToInteger(getPer(102,0,1));
   iP9=StrToInteger(getPer(103,0,1));
   iP10=StrToInteger(getPer(104,0,1));

   
   //MATREND
   tP0=StrToInteger(getPer(114,0,1));
   tP1=StrToInteger(getPer(115,0,1)); 
   tP2=StrToInteger(getPer(116,0,1));
   tP3=StrToInteger(getPer(117,0,1));
   tP4=StrToInteger(getPer(118,0,1));
   tP5=StrToInteger(getPer(119,0,1));
   tP6=StrToInteger(getPer(120,0,1));
   tP7=StrToInteger(getPer(121,0,1));
   tP8=StrToInteger(getPer(122,0,1));
   tP9=StrToInteger(getPer(123,0,1));
   tP10=StrToInteger(getPer(124,0,1));

      
   //LWMA   
   lP1=StrToInteger(getPer((lwma510==true)?130:95,0,1));
   lP2=StrToInteger(getPer((lwma510==true)?131:96,0,1));
   
  
   IndicatorBuffers(78);
 
   //MATREND
   
   SetIndexBuffer(77,SMAT10);SetIndexStyle(77,0,linemode,1,(matall==true)?clrNONE:getClr(124,0,true,clSMAT10));SetIndexLabel(77,"MaTrick " +getPer(124,0,0,false)+"");  //ACUAN 7
   SetIndexBuffer(76,SMAT09);SetIndexStyle(76,0,linemode,1,(matall==true)?clrNONE:getClr(123,0,true,clSMAT9)); SetIndexLabel(76,"MaTrick " +getPer(123,0,0,false)+"");  //ACUAN 6
   SetIndexBuffer(75,SMAT08);SetIndexStyle(75,0,linemode,1,(matall==true)?clrNONE:getClr(122,0,true,clSMAT8)); SetIndexLabel(75,"MaTrick " +getPer(122,0,0,false)+"");  //ACUAN 5
   SetIndexBuffer(74,SMAT07);SetIndexStyle(74,0,linemode,1,(matall==true)?clrNONE:getClr(121,0,true,clSMAT7)); SetIndexLabel(74,"MaTrick " +getPer(121,0,0,false)+"");  //ACUAN 4
   SetIndexBuffer(73,SMAT06);SetIndexStyle(73,0,linemode,1,(matall==true)?clrNONE:getClr(120,0,true,clSMAT6)); SetIndexLabel(73,"MaTrick " +getPer(120,0,0,false)+"");  //ACUAN 3
   SetIndexBuffer(72,SMAT05);SetIndexStyle(72,0,linemode,1,(matall==true)?clrNONE:getClr(119,0,true,clSMAT5)); SetIndexLabel(72,"MaTrick " +getPer(119,0,0,false)+"");  //ACUAN 2
   SetIndexBuffer(71,SMAT04);SetIndexStyle(71,0,linemode,1,(matall==true)?clrNONE:getClr(118,0,true,clSMAT4)); SetIndexLabel(71,"MaTrick " +getPer(118,0,0,false)+"");  //ACUAN 1
   SetIndexBuffer(70,SMAT03);SetIndexStyle(70,0,linemode,1,(matall==true)?clrNONE:getClr(117,0,true,clSMAT3)); SetIndexLabel(70,"MaTrick " +getPer(117,0,0,false)+"");  //ACTIVE
   SetIndexBuffer(69,SMAT02);SetIndexStyle(69,0,linemode,1,(matall==true)?clrNONE:getClr(116,0,true,clSMAT2)); SetIndexLabel(69,"MaTrick " +getPer(116,0,0,false)+"");  //TF KONFIRMASI 2
   SetIndexBuffer(68,SMAT01);SetIndexStyle(68,0,linemode,1,(matall==true)?clrNONE:getClr(115,0,true,clSMAT1)); SetIndexLabel(68,"MaTrick " +getPer(115,0,0,false)+"");  //TF KONFIRMASI 1
   SetIndexBuffer(67,SMAT00);SetIndexStyle(67,0,linemode,1,(matall==true)?clrNONE:getClr(114,0,true,clSMAT1)); SetIndexLabel(67,"MaTrick " +getPer(114,0,0,false)+"");  //TF ENTRY
     
   
   //MID BB
   SetIndexBuffer(66,SMA10); SetIndexStyle(66,0,0,1,getClr(104,0,true,clSMA10)); SetIndexLabel(66,"MidBB " +getPer(104,0,0,false)+"");   //ACUAN 7
   SetIndexBuffer(65,SMA09); SetIndexStyle(65,0,0,1,getClr(103,0,true,clSMA9));  SetIndexLabel(65,"MidBB " +getPer(103,0,0,false)+"");   //ACUAN 6
   SetIndexBuffer(64,SMA08); SetIndexStyle(64,0,0,1,getClr(102,0,true,clSMA8));  SetIndexLabel(64,"MidBB " +getPer(102,0,0,false)+"");   //ACUAN 5
   SetIndexBuffer(63,SMA07); SetIndexStyle(63,0,0,1,getClr(101,0,true,clSMA7));  SetIndexLabel(63,"MidBB " +getPer(101,0,0,false)+"");   //ACUAN 4
   SetIndexBuffer(62,SMA06); SetIndexStyle(62,0,0,1,getClr(100,0,true,clSMA6));  SetIndexLabel(62,"MidBB " +getPer(100,0,0,false)+"");   //ACUAN 3
   SetIndexBuffer(61,SMA05); SetIndexStyle(61,0,0,1,getClr(99,0,true,clSMA5));   SetIndexLabel(61,"MidBB " +getPer(99,0,0,false)+"");   //ACUAN 2
   SetIndexBuffer(60,SMA04); SetIndexStyle(60,0,0,1,getClr(98,0,true,clSMA4));   SetIndexLabel(60,"MidBB " +getPer(98,0,0,false)+"");   //ACUAN 1
   SetIndexBuffer(59,SMA03); SetIndexStyle(59,0,0,2,getClr(97,0,true,clSMA3));   SetIndexLabel(59,"MidBB " +getPer(97,0,0,false)+"");   //ACTIVE
   SetIndexBuffer(58,SMA02); SetIndexStyle(58,0,0,1,getClr(96,0,true,clSMA2));   SetIndexLabel(58,"MidBB " +getPer(96,0,0,false)+"");   //TF KONFIRMASI 2
   SetIndexBuffer(57,SMA01); SetIndexStyle(57,0,0,1,getClr(95,0,true,clSMA1));   SetIndexLabel(57,"MidBB " +getPer(95,0,0,false)+"");   //TF KONFIRMASI 1
   SetIndexBuffer(56,SMA00); SetIndexStyle(56,0,0,1,getClr(94,0,true,clSMA0));   SetIndexLabel(56,"MidBB " +getPer(94,0,0,false)+"");   //TF ENTRY


   //LWMA HIGH LOW
   SetIndexBuffer(55,LLWMA04); SetIndexStyle(55,0,0,1,getClr(105,0,false,clLWSMA40)); SetIndexLabel(55,getPer(105,0,0,false));
   SetIndexBuffer(54,HLWMA04); SetIndexStyle(54,0,0,1,getClr(105,0,false,clLWSMA40)); SetIndexLabel(54,getPer(105,0,0,false));
   SetIndexBuffer(53,LLWMA03); SetIndexStyle(53,0,0,1,getClr(104,0,false,clLWSMA30)); SetIndexLabel(53,getPer(104,0,0,false));  
   SetIndexBuffer(52,HLWMA03); SetIndexStyle(52,0,0,1,getClr(104,0,false,clLWSMA30)); SetIndexLabel(52,getPer(104,0,0,false));
  
   SetIndexBuffer(51,LLWMA02); SetIndexStyle(51,0,0,1,getClr(103,0,false,clLWSMA2)); SetIndexLabel(51,getPer(103,0,0,false));
   SetIndexBuffer(50,HLWMA02); SetIndexStyle(50,0,0,1,getClr(103,0,false,clLWSMA2)); SetIndexLabel(50,getPer(103,0,0,false));
   SetIndexBuffer(49,LLWMA01); SetIndexStyle(49,0,0,1,getClr(102,0,false,clLWSMA1)); SetIndexLabel(49,getPer(102,0,0,false));
   SetIndexBuffer(48,HLWMA01); SetIndexStyle(48,0,0,1,getClr(102,0,false,clLWSMA1)); SetIndexLabel(48,getPer(102,0,0,false));
   
   //BB TF ACTIVE
   SetIndexBuffer(47,SDP03); SetIndexStyle(47,BB1_enable?0:12,(s1ModeBB==_shFSD)?1:linemode1,2,getClr(97,0,true,clSDP3)); SetIndexLabel(47,"BB20UPR_SD 1_" +getPer(97,0,0,false)+"");
   SetIndexBuffer(46,SDM03); SetIndexStyle(46,BB1_enable?0:12,(s1ModeBB==_shFSD)?1:linemode1,2,getClr(97,0,true,clSDM3)); SetIndexLabel(46,"BB20LWR_SD 1_" +getPer(97,0,0,false)+"");
   SetIndexBuffer(45,SDP032);SetIndexStyle(45,BB2_enable?0:12,(s1ModeBB==_shFSD)?1:linemode2,2,getClr(97,0,true,clSDP3)); SetIndexLabel(45,"BB20UPR_SD 2_" +getPer(97,0,0,false)+"");
   SetIndexBuffer(44,SDM032);SetIndexStyle(44,BB2_enable?0:12,(s1ModeBB==_shFSD)?1:linemode2,2,getClr(97,0,true,clSDM3)); SetIndexLabel(44,"BB20LWR_SD 2_" +getPer(97,0,0,false)+"");
 
   SetIndexBuffer(43,sSDP03); SetIndexStyle(43,BBF_enable?0:12,linemode1,2,getClr(97,0,true,clSDP3)); SetIndexLabel(43,"BB20UPR_SD 1_" +getPer(97,0,0,false)+"");
   SetIndexBuffer(42,sSDM03); SetIndexStyle(42,BBF_enable?0:12,linemode1,2,getClr(97,0,true,clSDM3)); SetIndexLabel(42,"BB20LWR_SD 1_" +getPer(97,0,0,false)+"");
   SetIndexBuffer(41,sSDP032);SetIndexStyle(41,BBF_enable?0:12,linemode2,2,getClr(97,0,true,clSDP3)); SetIndexLabel(41,"BB20UPR_SD 2_" +getPer(97,0,0,false)+"");
   SetIndexBuffer(40,sSDM032);SetIndexStyle(40,BBF_enable?0:12,linemode2,2,getClr(97,0,true,clSDM3)); SetIndexLabel(40,"BB20LWR_SD 2_" +getPer(97,0,0,false)+"");
        
   //BB TFX
   SetIndexBuffer(39,SDP04);  SetIndexStyle(39,XBB1_enable?0:12,linemode1,1,getClr(98,0,true,clSDP4)); SetIndexLabel(39,"BB20UPR_SD 1_" +getPer(98,0,0,false)+"");
   SetIndexBuffer(38,SDM04);  SetIndexStyle(38,XBB1_enable?0:12,linemode1,1,getClr(98,0,true,clSDM4)); SetIndexLabel(38,"BB20LWR_SD 1_" +getPer(98,0,0,false)+"");
   SetIndexBuffer(37,SDP042); SetIndexStyle(37,XBB2_enable?0:12,linemode2,1,getClr(98,0,true,clSDP4)); SetIndexLabel(37,"BB20UPR_SD 2_" +getPer(98,0,0,false)+"");
   SetIndexBuffer(36,SDM042); SetIndexStyle(36,XBB2_enable?0:12,linemode2,1,getClr(98,0,true,clSDM4)); SetIndexLabel(36,"BB20LWR_SD 2_" +getPer(98,0,0,false)+"");

   SetIndexBuffer(35,sSDP04); SetIndexStyle(35,XBBF_enable?0:12,linemode1,1,getClr(98,0,true,clSDP4)); SetIndexLabel(35,"BB20UPR_SD 1_" +getPer(98,0,0,false)+"");
   SetIndexBuffer(34,sSDM04); SetIndexStyle(34,XBBF_enable?0:12,linemode1,1,getClr(98,0,true,clSDM4)); SetIndexLabel(34,"BB20LWR_SD 1_" +getPer(98,0,0,false)+"");
   SetIndexBuffer(33,sSDP042);SetIndexStyle(33,XBBF_enable?0:12,linemode2,1,getClr(98,0,true,clSDP4)); SetIndexLabel(33,"BB20UPR_SD 2_" +getPer(98,0,0,false)+"");
   SetIndexBuffer(32,sSDM042);SetIndexStyle(32,XBBF_enable?0:12,linemode2,1,getClr(98,0,true,clSDM4)); SetIndexLabel(32,"BB20LWR_SD 2_" +getPer(98,0,0,false)+"");
   
   //BB TF UPWARD
   SetIndexBuffer(31,SDP05);  SetIndexStyle(31,bBB1_enable?0:12,linemode1,1,getClr(99,0,true,clSDP5)); SetIndexLabel(31,"BB20UPR_SD 1_" +getPer(99,0,0,false)+"");
   SetIndexBuffer(30,SDM05);  SetIndexStyle(30,bBB1_enable?0:12,linemode1,1,getClr(99,0,true,clSDM5)); SetIndexLabel(30,"BB20LWR_SD 1_" +getPer(99,0,0,false)+"");
   SetIndexBuffer(29,SDP052); SetIndexStyle(29,bBB2_enable?0:12,linemode2,1,getClr(99,0,true,clSDP5)); SetIndexLabel(29,"BB20UPR_SD 2_" +getPer(99,0,0,false)+"");
   SetIndexBuffer(28,SDM052); SetIndexStyle(28,bBB2_enable?0:12,linemode2,1,getClr(99,0,true,clSDM5)); SetIndexLabel(28,"BB20LWR_SD 2_" +getPer(99,0,0,false)+"");
 
   SetIndexBuffer(27,sSDP05); SetIndexStyle(27,bBBF_enable?0:12,linemode1,1,getClr(99,0,true,clSDP5)); SetIndexLabel(27,"BB20UPR_SD 1_" +getPer(99,0,0,false)+"");
   SetIndexBuffer(26,sSDM05); SetIndexStyle(26,bBBF_enable?0:12,linemode1,1,getClr(99,0,true,clSDM5)); SetIndexLabel(26,"BB20LWR_SD 1_" +getPer(99,0,0,false)+"");
   SetIndexBuffer(25,sSDP052); SetIndexStyle(25,bBBF_enable?0:12,linemode2,1,getClr(99,0,true,clSDP5)); SetIndexLabel(25,"BB20UPR_SD 2_" +getPer(99,0,0,false)+"");
   SetIndexBuffer(24,sSDM052); SetIndexStyle(24,bBBF_enable?0:12,linemode2,1,getClr(99,0,true,clSDM5)); SetIndexLabel(24,"BB20LWR_SD 2_" +getPer(99,0,0,false)+"");
     
   //BB TF 2 UPWARD
   SetIndexBuffer(23,SDP06); SetIndexStyle(23,b2BB1_enable?0:12,linemode1,1,getClr(100,0,true,clSDP6)); SetIndexLabel(23,"BB20UPR_SD 1_" +getPer(100,0,0,false)+"");
   SetIndexBuffer(22,SDM06); SetIndexStyle(22,b2BB1_enable?0:12,linemode1,1,getClr(100,0,true,clSDP6)); SetIndexLabel(22,"BB20LWR_SD 1_" +getPer(100,0,0,false)+"");
   SetIndexBuffer(21,SDP062);SetIndexStyle(21,b2BB2_enable?0:12,linemode2,1,getClr(100,0,true,clSDP6)); SetIndexLabel(21,"BB20UPR_SD 2_" +getPer(100,0,0,false)+"");
   SetIndexBuffer(20,SDM062);SetIndexStyle(20,b2BB2_enable?0:12,linemode2,1,getClr(100,0,true,clSDP6)); SetIndexLabel(20,"BB20LWR_SD 2_" +getPer(100,0,0,false)+"");
   
   SetIndexBuffer(19,sSDP06); SetIndexStyle(19,b2BBF_enable?0:12,linemode1,1,getClr(100,0,true,clSDP6)); SetIndexLabel(19,"BB20UPR_SD 1_" +getPer(100,0,0,false)+"");
   SetIndexBuffer(18,sSDM06); SetIndexStyle(18,b2BBF_enable?0:12,linemode1,1,getClr(100,0,true,clSDM6)); SetIndexLabel(18,"BB20LWR_SD 1_" +getPer(100,0,0,false)+"");
   SetIndexBuffer(17,sSDP062);SetIndexStyle(17,b2BBF_enable?0:12,linemode2,1,getClr(100,0,true,clSDP6)); SetIndexLabel(17,"BB20UPR_SD 2_" +getPer(100,0,0,false)+"");
   SetIndexBuffer(16,sSDM062);SetIndexStyle(16,b2BBF_enable?0:12,linemode2,1,getClr(100,0,true,clSDM6)); SetIndexLabel(16,"BB20LWR_SD 2_" +getPer(100,0,0,false)+"");
   
   SetIndexBuffer(15,SDP07); SetIndexStyle(15,b3BB1_enable?0:12,linemode1,1,getClr(101,0,true,clSDP7)); SetIndexLabel(15,"BB20UPR_SD 1_" +getPer(101,0,0,false)+"");
   SetIndexBuffer(14,SDM07); SetIndexStyle(14,b3BB1_enable?0:12,linemode1,1,getClr(101,0,true,clSDP7)); SetIndexLabel(14,"BB20LWR_SD 1_" +getPer(101,0,0,false)+"");
   SetIndexBuffer(13,SDP072);SetIndexStyle(13,b3BB2_enable?0:12,linemode2,1,getClr(101,0,true,clSDP7)); SetIndexLabel(13,"BB20UPR_SD 2_" +getPer(101,0,0,false)+"");
   SetIndexBuffer(12,SDM072);SetIndexStyle(12,b3BB2_enable?0:12,linemode2,1,getClr(101,0,true,clSDP7)); SetIndexLabel(12,"BB20LWR_SD 2_" +getPer(101,0,0,false)+"");
   
   SetIndexBuffer(11,sSDP07); SetIndexStyle(11,b3BBF_enable?0:12,linemode1,1,getClr(101,0,true,clSDP7)); SetIndexLabel(11,"BB20UPR_SD 1_" +getPer(101,0,0,false)+"");
   SetIndexBuffer(10,sSDM07); SetIndexStyle(10,b3BBF_enable?0:12,linemode1,1,getClr(101,0,true,clSDM7)); SetIndexLabel(10,"BB20LWR_SD 1_" +getPer(101,0,0,false)+"");
   SetIndexBuffer(9,sSDP072);SetIndexStyle(9,b3BBF_enable?0:12,linemode2,1,getClr(101,0,true,clSDP7)); SetIndexLabel(9,"BB20UPR_SD 2_" +getPer(101,0,0,false)+"");
   SetIndexBuffer(8,sSDM072);SetIndexStyle(8,b3BBF_enable?0:12,linemode2,1,getClr(101,0,true,clSDM7)); SetIndexLabel(8,"BB20LWR_SD 2_" +getPer(101,0,0,false)+"");
   
   SetIndexBuffer(7,SDP08); SetIndexStyle(7,b4BB1_enable?0:12,linemode1,1,getClr(102,0,true,clSDP8)); SetIndexLabel(7,"BB20UPR_SD 1_" +getPer(102,0,0,false)+"");
   SetIndexBuffer(6,SDM08); SetIndexStyle(6,b4BB1_enable?0:12,linemode1,1,getClr(102,0,true,clSDP8)); SetIndexLabel(6,"BB20LWR_SD 1_" +getPer(102,0,0,false)+"");
   SetIndexBuffer(5,SDP082);SetIndexStyle(5,b4BB2_enable?0:12,linemode2,1,getClr(102,0,true,clSDP8)); SetIndexLabel(5,"BB20UPR_SD 2_" +getPer(102,0,0,false)+"");
   SetIndexBuffer(4,SDM082);SetIndexStyle(4,b4BB2_enable?0:12,linemode2,1,getClr(102,0,true,clSDP8)); SetIndexLabel(4,"BB20LWR_SD 2_" +getPer(102,0,0,false)+"");
   
   SetIndexBuffer(3,sSDP08); SetIndexStyle(3,b4BBF_enable?0:12,linemode1,1,getClr(102,0,true,clSDP8)); SetIndexLabel(3,"BB20UPR_SD 1_" +getPer(102,0,0,false)+"");
   SetIndexBuffer(2,sSDM08); SetIndexStyle(2,b4BBF_enable?0:12,linemode1,1,getClr(102,0,true,clSDM8)); SetIndexLabel(2,"BB20LWR_SD 1_" +getPer(102,0,0,false)+"");
   SetIndexBuffer(1,sSDP082);SetIndexStyle(1,b4BBF_enable?0:12,linemode2,1,getClr(102,0,true,clSDP8)); SetIndexLabel(1,"BB20UPR_SD 2_" +getPer(102,0,0,false)+"");
   SetIndexBuffer(0,sSDM082);SetIndexStyle(0,b4BBF_enable?0:12,linemode2,1,getClr(102,0,true,clSDM8)); SetIndexLabel(0,"BB20LWR_SD 2_" +getPer(102,0,0,false)+"");
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
      
   showmathead?cLabel(0,"Header1",5,1,CORNER_RIGHT_UPPER,"__MATr3ndLOgic SysT3m__  ","Calibri",9,clrWhite,0):EMPTY_VALUE;
   showmathead?cLabel(0,"Header2",4,11,CORNER_RIGHT_UPPER,"------------------40------------------","Calibri",9,clrYellowGreen,0):EMPTY_VALUE;
   showmathead?cLabel(0,"Header3",130,3,CORNER_RIGHT_UPPER,"Shown MTF >>                            ","Calibri",8,clrYellowGreen,0):EMPTY_VALUE; 
   
      
   for(int j=0; j<9; j++)
      SetIndexDrawBegin(j,DrawBegin(Bars,j<=2?iP3:j>=3&&j<=5?iP2:iP1));
        
   for(int i=0; i<MathMin(Bars-IndicatorCounted(),Bars-1); i++){
     
      //SMA/MIDBB
      SMA00[i] = Entry0?iMA(_Symbol,_Period,iP0,0,modeMA,PRICE_CLOSE,i):EMPTY_VALUE;
      SMA01[i] = Entry1?iMA(_Symbol,_Period,iP1,0,modeMA,PRICE_CLOSE,i):EMPTY_VALUE;
      SMA02[i] = Entry2?iMA(_Symbol,_Period,iP2,0,modeMA,PRICE_CLOSE,i):EMPTY_VALUE;
      
      SMA03[i] = tfactive?iMA(_Symbol,_Period,iP3,0,MODE_SMA,PRICE_CLOSE,i):EMPTY_VALUE;
      SDP03[i] = BB1_enable?SMA03[i]+getSMA(iP3,i,vDev1):EMPTY_VALUE;
      SDM03[i] = BB1_enable?SMA03[i]-getSMA(iP3,i,vDev1):EMPTY_VALUE;
      SDP032[i] = BB2_enable?SMA03[i]+getSMA(iP3,i,vDev2):EMPTY_VALUE;
      SDM032[i] = BB2_enable?SMA03[i]-getSMA(iP3,i,vDev2):EMPTY_VALUE;
      
      sSDP03[i] = BBF_enable?SMA03[i]+getSMA(iP3,i,vDev1):EMPTY_VALUE;
      sSDM03[i] = BBF_enable?SMA03[i]-getSMA(iP3,i,vDev1):EMPTY_VALUE;
      sSDP032[i] = BBF_enable?SMA03[i]+getSMA(iP3,i,vDev2):EMPTY_VALUE;
      sSDM032[i] = BBF_enable?SMA03[i]-getSMA(iP3,i,vDev2):EMPTY_VALUE;
       
      SMA04[i] = acuan01?iMA(_Symbol,_Period,iP4,0,MODE_SMA,PRICE_CLOSE,i):EMPTY_VALUE;
      SDP04[i]  = XBB1_enable?SMA04[i]+getSMA(iP4,i,vDev1):EMPTY_VALUE;
      SDM04[i]  = XBB1_enable?SMA04[i]-getSMA(iP4,i,vDev1):EMPTY_VALUE;
      SDP042[i] = XBB2_enable?SMA04[i]+getSMA(iP4,i,vDev2):EMPTY_VALUE;
      SDM042[i] = XBB2_enable?SMA04[i]-getSMA(iP4,i,vDev2):EMPTY_VALUE;
      
      sSDP04[i]  = XBBF_enable?SMA04[i]+getSMA(iP4,i,vDev1):EMPTY_VALUE;
      sSDM04[i]  = XBBF_enable?SMA04[i]-getSMA(iP4,i,vDev1):EMPTY_VALUE;
      sSDP042[i] = XBBF_enable?SMA04[i]+getSMA(iP4,i,vDev2):EMPTY_VALUE;
      sSDM042[i] = XBBF_enable?SMA04[i]-getSMA(iP4,i,vDev2):EMPTY_VALUE; 
            
      SMA05[i] = acuan02?iMA(_Symbol,_Period,iP5,0,MODE_SMA,PRICE_CLOSE,i):EMPTY_VALUE;
      SDP05[i] = bBB1_enable?SMA05[i]+getSMA(iP5,i,vDev1):EMPTY_VALUE;
      SDM05[i] = bBB1_enable?SMA05[i]-getSMA(iP5,i,vDev1):EMPTY_VALUE;
      SDP052[i] = bBB2_enable?SMA05[i]+getSMA(iP5,i,vDev2):EMPTY_VALUE;
      SDM052[i] = bBB2_enable?SMA05[i]-getSMA(iP5,i,vDev2):EMPTY_VALUE;
      
      sSDP05[i] = bBBF_enable?SMA05[i]+getSMA(iP5,i,vDev1):EMPTY_VALUE;
      sSDM05[i] = bBBF_enable?SMA05[i]-getSMA(iP5,i,vDev1):EMPTY_VALUE;
      sSDP052[i] = bBBF_enable?SMA05[i]+getSMA(iP5,i,vDev2):EMPTY_VALUE;
      sSDM052[i] = bBBF_enable?SMA05[i]-getSMA(iP5,i,vDev2):EMPTY_VALUE;
              
      SMA06[i] = acuan03?iMA(_Symbol,_Period,iP6,0,MODE_SMA,PRICE_CLOSE,i):EMPTY_VALUE;
      SDP06[i]  = b2BB1_enable?SMA06[i]+getSMA(iP6,i,vDev1):EMPTY_VALUE;
      SDM06[i]  = b2BB1_enable?SMA06[i]-getSMA(iP6,i,vDev1):EMPTY_VALUE;
      SDP062[i] = b2BB2_enable?SMA06[i]+getSMA(iP6,i,vDev2):EMPTY_VALUE;
      SDM062[i] = b2BB2_enable?SMA06[i]-getSMA(iP6,i,vDev2):EMPTY_VALUE;
      
      sSDP06[i]  = b2BBF_enable?SMA06[i]+getSMA(iP6,i,vDev1):EMPTY_VALUE;
      sSDM06[i]  = b2BBF_enable?SMA06[i]-getSMA(iP6,i,vDev1):EMPTY_VALUE;
      sSDP062[i] = b2BBF_enable?SMA06[i]+getSMA(iP6,i,vDev2):EMPTY_VALUE;
      sSDM062[i] = b2BBF_enable?SMA06[i]-getSMA(iP6,i,vDev2):EMPTY_VALUE;
      
      SMA07[i]  = acuan04?iMA(_Symbol,_Period,iP7,0,MODE_SMA,PRICE_CLOSE,i):EMPTY_VALUE;
      SDP07[i]  = b3BB1_enable?SMA07[i]+getSMA(iP7,i,vDev1):EMPTY_VALUE;
      SDM07[i]  = b3BB1_enable?SMA07[i]-getSMA(iP7,i,vDev1):EMPTY_VALUE;
      SDP072[i] = b3BB2_enable?SMA07[i]+getSMA(iP7,i,vDev2):EMPTY_VALUE;
      SDM072[i] = b3BB2_enable?SMA07[i]-getSMA(iP7,i,vDev2):EMPTY_VALUE;
      
      sSDP07[i]  = b3BBF_enable?SMA07[i]+getSMA(iP7,i,vDev1):EMPTY_VALUE;
      sSDM07[i]  = b3BBF_enable?SMA07[i]-getSMA(iP7,i,vDev1):EMPTY_VALUE;
      sSDP072[i] = b3BBF_enable?SMA07[i]+getSMA(iP7,i,vDev2):EMPTY_VALUE;
      sSDM072[i] = b3BBF_enable?SMA07[i]-getSMA(iP7,i,vDev2):EMPTY_VALUE;
      
      SMA08[i]  = acuan05?iMA(_Symbol,_Period,iP8,0,MODE_SMA,PRICE_CLOSE,i):EMPTY_VALUE;
      SDP08[i]  = b4BB1_enable?SMA08[i]+getSMA(iP8,i,vDev1):EMPTY_VALUE;
      SDM08[i]  = b4BB1_enable?SMA08[i]-getSMA(iP8,i,vDev1):EMPTY_VALUE;
      SDP082[i] = b4BB2_enable?SMA08[i]+getSMA(iP8,i,vDev2):EMPTY_VALUE;
      SDM082[i] = b4BB2_enable?SMA08[i]-getSMA(iP8,i,vDev2):EMPTY_VALUE;
      
      sSDP08[i]  = b4BBF_enable?SMA08[i]+getSMA(iP8,i,vDev1):EMPTY_VALUE;
      sSDM08[i]  = b4BBF_enable?SMA08[i]-getSMA(iP8,i,vDev1):EMPTY_VALUE;
      sSDP082[i] = b4BBF_enable?SMA08[i]+getSMA(iP8,i,vDev2):EMPTY_VALUE;
      sSDM082[i] = b4BBF_enable?SMA08[i]-getSMA(iP8,i,vDev2):EMPTY_VALUE;
            
      SMA09[i]  = acuan06?iMA(_Symbol,_Period,iP9,0,MODE_SMA,PRICE_CLOSE,i):EMPTY_VALUE;
      SMA10[i]  = acuan07?iMA(_Symbol,_Period,iP10,0,MODE_SMA,PRICE_CLOSE,i):EMPTY_VALUE;
      
            
      //MATREND
      SMAT00[i] = Entry0?  (mars?2*iMA(_Symbol,_Period,MathFloor(MathMax(2,tP0)/HMASpeed),0,MODE_LWMA,PRICE_CLOSE,i) - (iMA(_Symbol,_Period,tP0,0,MODE_LWMA,PRICE_CLOSE,i)):(3*iMA(_Symbol,_Period,tP0,0,MODE_EMA,PRICE_CLOSE,i)) - (2*iMA(_Symbol,_Period,tP0,0,MODE_SMA,PRICE_CLOSE,i))):EMPTY_VALUE;   
      SMAT01[i] = Entry1?  (mars?2*iMA(_Symbol,_Period,MathFloor(MathMax(2,tP1)/HMASpeed),0,MODE_LWMA,PRICE_CLOSE,i) - (iMA(_Symbol,_Period,tP1,0,MODE_LWMA,PRICE_CLOSE,i)):(3*iMA(_Symbol,_Period,tP1,0,MODE_EMA,PRICE_CLOSE,i)) - (2*iMA(_Symbol,_Period,tP1,0,MODE_SMA,PRICE_CLOSE,i))):EMPTY_VALUE;
      SMAT02[i] = Entry2?  (mars?2*iMA(_Symbol,_Period,MathFloor(MathMax(2,tP2)/HMASpeed),0,MODE_LWMA,PRICE_CLOSE,i) - (iMA(_Symbol,_Period,tP2,0,MODE_LWMA,PRICE_CLOSE,i)):(3*iMA(_Symbol,_Period,tP2,0,MODE_EMA,PRICE_CLOSE,i)) - (2*iMA(_Symbol,_Period,tP2,0,MODE_SMA,PRICE_CLOSE,i))):EMPTY_VALUE;
      SMAT03[i] = tfactive?(mars?2*iMA(_Symbol,_Period,MathFloor(MathMax(2,tP3)/HMASpeed),0,MODE_LWMA,PRICE_CLOSE,i) - (iMA(_Symbol,_Period,tP3,0,MODE_LWMA,PRICE_CLOSE,i)):(3*iMA(_Symbol,_Period,tP3,0,MODE_EMA,PRICE_CLOSE,i)) - (2*iMA(_Symbol,_Period,tP3,0,MODE_SMA,PRICE_CLOSE,i))):EMPTY_VALUE;
      SMAT04[i] = acuan01? (mars?2*iMA(_Symbol,_Period,MathFloor(MathMax(2,tP4)/HMASpeed),0,MODE_LWMA,PRICE_CLOSE,i) - (iMA(_Symbol,_Period,tP4,0,MODE_LWMA,PRICE_CLOSE,i)):(3*iMA(_Symbol,_Period,tP4,0,MODE_EMA,PRICE_CLOSE,i)) - (2*iMA(_Symbol,_Period,tP4,0,MODE_SMA,PRICE_CLOSE,i))):EMPTY_VALUE;
      SMAT05[i] = acuan02? (mars?2*iMA(_Symbol,_Period,MathFloor(MathMax(2,tP5)/HMASpeed),0,MODE_LWMA,PRICE_CLOSE,i) - (iMA(_Symbol,_Period,tP5,0,MODE_LWMA,PRICE_CLOSE,i)):(3*iMA(_Symbol,_Period,tP5,0,MODE_EMA,PRICE_CLOSE,i)) - (2*iMA(_Symbol,_Period,tP5,0,MODE_SMA,PRICE_CLOSE,i))):EMPTY_VALUE;
      SMAT06[i] = acuan03? (mars?2*iMA(_Symbol,_Period,MathFloor(MathMax(2,tP6)/HMASpeed),0,MODE_LWMA,PRICE_CLOSE,i) - (iMA(_Symbol,_Period,tP6,0,MODE_LWMA,PRICE_CLOSE,i)):(3*iMA(_Symbol,_Period,tP6,0,MODE_EMA,PRICE_CLOSE,i)) - (2*iMA(_Symbol,_Period,tP6,0,MODE_SMA,PRICE_CLOSE,i))):EMPTY_VALUE;
      SMAT07[i] = acuan04? (mars?2*iMA(_Symbol,_Period,MathFloor(MathMax(2,tP7)/HMASpeed),0,MODE_LWMA,PRICE_CLOSE,i) - (iMA(_Symbol,_Period,tP7,0,MODE_LWMA,PRICE_CLOSE,i)):(3*iMA(_Symbol,_Period,tP7,0,MODE_EMA,PRICE_CLOSE,i)) - (2*iMA(_Symbol,_Period,tP7,0,MODE_SMA,PRICE_CLOSE,i))):EMPTY_VALUE;
      SMAT08[i] = acuan05? (mars?2*iMA(_Symbol,_Period,MathFloor(MathMax(2,tP8)/HMASpeed),0,MODE_LWMA,PRICE_CLOSE,i) - (iMA(_Symbol,_Period,tP8,0,MODE_LWMA,PRICE_CLOSE,i)):(3*iMA(_Symbol,_Period,tP8,0,MODE_EMA,PRICE_CLOSE,i)) - (2*iMA(_Symbol,_Period,tP8,0,MODE_SMA,PRICE_CLOSE,i))):EMPTY_VALUE;
      SMAT09[i] = acuan06? (mars?2*iMA(_Symbol,_Period,MathFloor(MathMax(2,tP9)/HMASpeed),0,MODE_LWMA,PRICE_CLOSE,i) - (iMA(_Symbol,_Period,tP9,0,MODE_LWMA,PRICE_CLOSE,i)):(3*iMA(_Symbol,_Period,tP9,0,MODE_EMA,PRICE_CLOSE,i)) - (2*iMA(_Symbol,_Period,tP9,0,MODE_SMA,PRICE_CLOSE,i))):EMPTY_VALUE;
      SMAT10[i] = acuan07? (mars?2*iMA(_Symbol,_Period,MathFloor(MathMax(2,tP10)/HMASpeed),0,MODE_LWMA,PRICE_CLOSE,i) - (iMA(_Symbol,_Period,tP10,0,MODE_LWMA,PRICE_CLOSE,i)):(3*iMA(_Symbol,_Period,tP10,0,MODE_EMA,PRICE_CLOSE,i)) - (2*iMA(_Symbol,_Period,tP10,0,MODE_SMA,PRICE_CLOSE,i))):EMPTY_VALUE;
      
      

                       
      //LWMA HILO
      HLWMA01[i] = lwma5?iMA(_Symbol,_Period,lP1,0,MODE_LWMA,PRICE_HIGH,i):EMPTY_VALUE;
      LLWMA01[i] = lwma5?iMA(_Symbol,_Period,lP1,0,MODE_LWMA,PRICE_LOW,i):EMPTY_VALUE;
      HLWMA02[i] = lwma10?iMA(_Symbol,_Period,lP2,0,MODE_LWMA,PRICE_HIGH,i):EMPTY_VALUE;
      LLWMA02[i] = lwma10?iMA(_Symbol,_Period,lP2,0,MODE_LWMA,PRICE_LOW,i):EMPTY_VALUE;
      HLWMA03[i] = lwma3?iMA(_Symbol,_Period,iP3,0,MODE_LWMA,PRICE_HIGH,i):EMPTY_VALUE;
      LLWMA03[i] = lwma3?iMA(_Symbol,_Period,iP3,0,MODE_LWMA,PRICE_LOW,i):EMPTY_VALUE;
      HLWMA04[i] = lwma4?iMA(_Symbol,_Period,iP4,0,MODE_LWMA,PRICE_HIGH,i):EMPTY_VALUE;
      LLWMA04[i] = lwma4?iMA(_Symbol,_Period,iP4,0,MODE_LWMA,PRICE_LOW,i):EMPTY_VALUE;
  
    }
        
    
//+------------------------------------------------------------------+ 
   if(shInfo){
   int posX=disX+10,posY=disY+30;
      Sett(cLabel(0,"HPer1",posX,posY,CORNER_RIGHT_UPPER,getPer(95,95)+"  : "+SetCond(SMAT01,SMA01,1),"Lucida Console",10,StringToColor(SetCond(SMAT01,SMA01)))); posY+=20;
      Sett(cLabel(0,"HPer2",posX,posY,CORNER_RIGHT_UPPER,getPer(96,96)+"  : "+SetCond(SMAT02,SMA02,1),"Lucida Console",10,StringToColor(SetCond(SMAT02,SMA02)))); posY+=20;
      Sett(cLabel(0,"HPer3",posX,posY,CORNER_RIGHT_UPPER,getPer(97,97)+"  : "+SetCond(SMAT03,SMA03,1),"Lucida Console",10,StringToColor(SetCond(SMAT03,SMA03)))); posY+=20;
      Sett(cLabel(0,"HPer4",posX,posY,CORNER_RIGHT_UPPER,getPer(98,98)+"  : "+SetCond(SMAT04,SMA04,1),"Lucida Console",10,StringToColor(SetCond(SMAT04,SMA04)))); posY+=20;
      Sett(cLabel(0,"HPer5",posX,posY,CORNER_RIGHT_UPPER,getPer(99,99)+"  : "+SetCond(SMAT05,SMA05,1),"Lucida Console",10,StringToColor(SetCond(SMAT05,SMA05)))); posY+=20;
      Sett(cLabel(0,"HPer6",posX,posY,CORNER_RIGHT_UPPER,getPer(100,100)+" : "+SetCond(SMAT06,SMA06,1),"Lucida Console",10,StringToColor(SetCond(SMAT06,SMA06)))); posY+=20;
      Sett(cLabel(0,"HPer7",posX,posY,CORNER_RIGHT_UPPER,getPer(101,101)+" : "+SetCond(SMAT07,SMA07,1),"Lucida Console",10,StringToColor(SetCond(SMAT07,SMA07)))); posY+=20; 
      Sett(cLabel(0,"HPer8",posX,posY,CORNER_RIGHT_UPPER,getPer(102,102)+" : "+SetCond(SMAT08,SMA08,1),"Lucida Console",10,StringToColor(SetCond(SMAT08,SMA08)))); posY+=20;
      Sett(cLabel(0,"HPer9",posX,posY,CORNER_RIGHT_UPPER,getPer(103,103)+" : "+SetCond(SMAT09,SMA09,1),"Lucida Console",10,StringToColor(SetCond(SMAT09,SMA09)))); posY+=20;
      Sett(cLabel(0,"HPer10",posX,posY,CORNER_RIGHT_UPPER,getPer(104,104)+" : "+SetCond(SMAT10,SMA10,1),"Lucida Console",10,StringToColor(SetCond(SMAT10,SMA10)))); 
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
   if(SMAT[0]>SMA[0] && Close[0]<SMAT[0] && Close[0]<SMA[0] && SMAT[0]<SMAT[1]){sTrend="Medium Sell +"      ;cTrend=ColorToString(clMedDn); } else
   if(SMAT[0]<SMA[0] && Close[0]>SMAT[0] && Close[0]>SMA[0] && SMAT[0]>SMAT[1]){sTrend="Medium Buy +"       ;cTrend=ColorToString(clMedUp); } else
   if(SMAT[0]>SMA[0] && Close[0]<SMAT[0] && Close[0]<SMA[0] && SMAT[0]>SMAT[1]){sTrend="Medium Sell -"      ;cTrend=ColorToString(clMedDn); } else
   if(SMAT[0]<SMA[0] && Close[0]>SMAT[0] && Close[0]>SMA[0] && SMAT[0]<SMAT[1]){sTrend="Medium Buy -"       ;cTrend=ColorToString(clMedUp); } else
   if(SMAT[0]>SMA[0] && Close[0]<SMAT[0] && Close[0]>SMA[0] && SMAT[0]<SMAT[1]){sTrend="Extreme Sell"       ;cTrend=ColorToString(clExDn);  } else
   if(SMAT[0]<SMA[0] && Close[0]>SMAT[0] && Close[0]<SMA[0] && SMAT[0]>SMAT[1]){sTrend="Extreme Buy"        ;cTrend=ColorToString(clExUp);  } else
   if(SMAT[0]>SMA[0] && Close[0]<SMAT[0] && Close[0]>SMA[0] && SMAT[0]>SMAT[1]){sTrend="Koreksi Up"         ;cTrend=ColorToString(clCorDn); } else
   if(SMAT[0]<SMA[0] && Close[0]>SMAT[0] && Close[0]<SMA[0] && SMAT[0]<SMAT[1]){sTrend="Koreksi Down"       ;cTrend=ColorToString(clCorUp); } 
                    
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
          mn1=5,hr1=300,dy1=7200,wk1=50400,mh1=201600,yr1=2419200,
          mn2=10,hr2=600,dy2=14400,wk2=100800,mh2=403200,yr2=4838400,
          mn3=1,hr3=60,dy3=1440,wk3=7200,mh3=28800,yr3=345600,
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
           
           
           
      case 94: switch(_Period){
                  case  PERIOD_M1 : strPer= "";    intPer=          NULL;   clrPer=mClr?C'000,255,000':C'000,155,000';  break;/*TF Entry 1 / PERIOD 20*/
                  case  PERIOD_M5 : strPer= "";    intPer=          NULL;   clrPer=mClr?C'255,255,255':C'155,155,155';  break;  
                  case  PERIOD_M15: strPer= "M1";  intPer=            mn;   clrPer=mClr?C'255,255,255':C'155,155,155';  break;  
                  case  PERIOD_M30: strPer= "M2";  intPer=        2.5*mn;   clrPer=mClr?C'173,255,047':C'073,155,000';  break;
                  case  PERIOD_H1 : strPer= "M5";  intPer=          5*mn;   clrPer=mClr?C'238,130,238':C'221,160,221';  break;
                  case  PERIOD_H4 : strPer= "M30"; intPer=         30*mn;   clrPer=mClr?C'255,255,000':C'190,190,000';  break;
                  case  PERIOD_D1 : strPer= "H4";  intPer=          4*hr;   clrPer=mClr?C'000,255,000':C'000,070,000';  break;
                  case  PERIOD_W1 : strPer= "H12"; intPer=         12*hr;   clrPer=mClr?C'255,140,000':C'255,140,000';  break;
                  case  PERIOD_MN1: strPer= "D3";  intPer=        2.5*dy;   clrPer=mClr?C'240,230,140':C'240,230,140';  break;
               } break;
      case 95: switch(_Period){
                  case  PERIOD_M1 : strPer= "S15"; intPer=          mn/4;   clrPer=mClr?C'000,255,000':C'000,155,000';  break;/*TF Entry 1 / PERIOD 20*/
                  case  PERIOD_M5 : strPer= "M1";  intPer=            mn;   clrPer=mClr?C'255,255,255':C'155,155,155';  break;  
                  case  PERIOD_M15: strPer= "M2";  intPer=        2.5*mn;   clrPer=mClr?C'173,255,047':C'073,155,000';  break;
                  case  PERIOD_M30: strPer= "M5";  intPer=          5*mn;   clrPer=mClr?C'238,130,238':C'221,160,221';  break;
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
                  case  PERIOD_W1 : strPer= "D3";  intPer=        2.5*dy;   clrPer=mClr?C'240,230,140':C'240,230,140';  break;
                  case  PERIOD_MN1: strPer= "W2";  intPer=         15*dy;   clrPer=mClr?C'138,043,226':C'138,043,226';  break;
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
                  case  PERIOD_M1 : strPer= "M2";  intPer=        2.5*mn;   clrPer=mClr?C'173,255,047':C'073,155,000';  break;/*TFX / PERIOD 20 ACUAN 1*/
                  case  PERIOD_M5 : strPer= "M15"; intPer=         15*mn;   clrPer=mClr?C'000,255,255':C'000,255,255';  break;
                  case  PERIOD_M15: strPer= "M30"; intPer=         30*mn;   clrPer=mClr?C'255,255,000':C'190,190,000';  break;
                  case  PERIOD_M30: strPer= "H1";  intPer=            hr;   clrPer=mClr?C'255,000,000':C'125,000,000';  break;
                  case  PERIOD_H1 : strPer= "H2";  intPer=          2*hr;   clrPer=mClr?C'255,255,255':C'105,105,105';  break;
                  case  PERIOD_H4 : strPer= "H8";  intPer=          8*hr;   clrPer=mClr?C'186,085,211':C'186,085,211';  break;
                  case  PERIOD_D1 : strPer= "D3";  intPer=        2.5*dy;   clrPer=mClr?C'240,230,140':C'240,230,140';  break;
                  case  PERIOD_W1 : strPer= "W2";  intPer=         15*dy;   clrPer=mClr?C'138,043,226':C'138,043,226';  break;
                  case  PERIOD_MN1: strPer= "MN2"; intPer=       2*30*dy;   clrPer=mClr?C'174,125,011':C'150,110,035';  break;
               } break;
      case 99: switch(_Period){
                  case  PERIOD_M1 : strPer= "M5";  intPer=          5*mn;   clrPer=mClr?C'238,130,238':C'221,160,221';  break;/*TF Up / PERIOD 20 ACUAN 2*/
                  case  PERIOD_M5 : strPer= "M30"; intPer=         30*mn;   clrPer=mClr?C'255,255,000':C'190,190,000';  break;
                  case  PERIOD_M15: strPer= "H1";  intPer=            hr;   clrPer=mClr?C'255,000,000':C'125,000,000';  break;
                  case  PERIOD_M30: strPer= "H2";  intPer=          2*hr;   clrPer=mClr?C'255,255,255':C'105,105,105';  break;
                  case  PERIOD_H1 : strPer= "H4";  intPer=          4*hr;   clrPer=mClr?C'000,255,000':C'000,070,000';  break;
                  case  PERIOD_H4 : strPer= "H12"; intPer=         12*hr;   clrPer=mClr?C'255,140,000':C'255,140,000';  break;
                  case  PERIOD_D1 : strPer= "W1";  intPer=            wk;   clrPer=mClr?C'043,043,255':C'043,043,255';  break;
                  case  PERIOD_W1 : strPer= "MN1"; intPer=         30*dy;   clrPer=mClr?C'000,128,000':C'035,090,035';  break;
               } break;
      case 100: switch(_Period){
                  case  PERIOD_M1 : strPer= "M15"; intPer=         15*mn;   clrPer=mClr?C'000,255,255':C'000,255,255';  break; /*TFX Up / PERIOD 20 ACUAN 3*/
                  case  PERIOD_M5 : strPer= "H1";  intPer=            hr;   clrPer=mClr?C'255,000,000':C'125,000,000';  break;
                  case  PERIOD_M15: strPer= "H2";  intPer=          2*hr;   clrPer=mClr?C'255,255,255':C'105,105,105';  break;
                  case  PERIOD_M30: strPer= "H4";  intPer=          4*hr;   clrPer=mClr?C'000,255,000':C'000,070,000';  break;
                  case  PERIOD_H1 : strPer= "H8";  intPer=          8*hr;   clrPer=mClr?C'186,085,211':C'186,085,211';  break;
                  case  PERIOD_H4 : strPer= "D1";  intPer=            dy;   clrPer=mClr?C'175,238,238':C'175,238,238';  break;
                  case  PERIOD_D1 : strPer= "W2";  intPer=         15*dy;   clrPer=mClr?C'138,043,226':C'138,043,226';  break;
                  case  PERIOD_W1 : strPer= "MN2"; intPer=       2*30*dy;   clrPer=mClr?C'174,125,011':C'150,110,035';  break;
               } break;
      case 101: switch(_Period){
                  case  PERIOD_M1 : strPer= "M30"; intPer=         30*mn;   clrPer=mClr?C'255,255,000':C'190,190,000';  break; /*TF 2 Up / PERIOD 20 ACUAN 4*/
                  case  PERIOD_M5 : strPer= "H2";  intPer=          2*hr;   clrPer=mClr?C'255,255,255':C'105,105,105';  break;
                  case  PERIOD_M15: strPer= "H4";  intPer=          4*hr;   clrPer=mClr?C'000,255,000':C'000,070,000';  break;
                  case  PERIOD_M30: strPer= "H8";  intPer=          8*hr;   clrPer=mClr?C'186,085,211':C'186,085,211';  break;
                  case  PERIOD_H1 : strPer= "H12"; intPer=         12*hr;   clrPer=mClr?C'255,140,000':C'255,140,000';  break;
                  case  PERIOD_H4 : strPer= "D3";  intPer=        2.5*dy;   clrPer=mClr?C'240,230,140':C'240,230,140';  break;
                  case  PERIOD_D1 : strPer= "MN1"; intPer=         30*dy;   clrPer=mClr?C'000,128,000':C'035,090,035';  break;
               } break;
      case 102: switch(_Period){
                  case  PERIOD_M1 : strPer= "H1";  intPer=            hr;   clrPer=mClr?C'255,000,000':C'125,000,000';  break; /*TFF 2 Up / PERIOD 20 ACUAN 5*/
                  case  PERIOD_M5 : strPer= "H4";  intPer=          4*hr;   clrPer=mClr?C'000,255,000':C'000,070,000';  break;
                  case  PERIOD_M15: strPer= "H8";  intPer=          8*hr;   clrPer=mClr?C'186,085,211':C'186,085,211';  break;
                  case  PERIOD_M30: strPer= "H12"; intPer=         12*hr;   clrPer=mClr?C'255,140,000':C'255,140,000';  break;
                  case  PERIOD_H1 : strPer= "D1";  intPer=            dy;   clrPer=mClr?C'175,238,238':C'175,238,238';  break;
                  case  PERIOD_H4 : strPer= "W1";  intPer=            wk;   clrPer=mClr?C'043,043,255':C'043,043,255';  break;
                  case  PERIOD_D1 : strPer= "MN2"; intPer=        2*30*dy;   clrPer=mClr?C'174,125,011':C'150,110,035';  break;
               } break;
      case 103: switch(_Period){
                  case  PERIOD_M1 : strPer= "H2";  intPer=          2*hr;   clrPer=mClr?C'255,255,255':C'105,105,105';  break; /*TF 3 Up / PERIOD 20 ACUAN 6*/
                  case  PERIOD_M5 : strPer= "H8";  intPer=          8*hr;   clrPer=mClr?C'186,085,211':C'186,085,211';  break;
                  case  PERIOD_M15: strPer= "H12"; intPer=         12*hr;   clrPer=mClr?C'255,140,000':C'255,140,000';  break;
                  case  PERIOD_M30: strPer= "D1";  intPer=            dy;   clrPer=mClr?C'175,238,238':C'175,238,238';  break;
                  case  PERIOD_H1 : strPer= "D3";  intPer=        2.5*dy;   clrPer=mClr?C'240,230,140':C'240,230,140';  break;
                  case  PERIOD_H4 : strPer= "W2";  intPer=         15*dy;   clrPer=mClr?C'138,043,226':C'070,025,113';  break;
               } break;
      case 104: switch(_Period){
                  case  PERIOD_M1 : strPer= "H4";  intPer=          4*hr;   clrPer=mClr?C'000,255,000':C'000,070,000';  break; /*TFX 3 Up / PERIOD 20 ACUAN 7*/
                  case  PERIOD_M5 : strPer= "H12"; intPer=         12*hr;   clrPer=mClr?C'255,140,000':C'255,140,000';  break;
                  case  PERIOD_M15: strPer= "D1";  intPer=            dy;   clrPer=mClr?C'175,238,238':C'175,238,238';  break;
                  case  PERIOD_M30: strPer= "D3";  intPer=        2.5*dy;   clrPer=mClr?C'240,230,140':C'240,230,140';  break;
                  case  PERIOD_H1 : strPer= "W1";  intPer=            wk;   clrPer=mClr?C'043,043,255':C'043,043,255';  break;
                  case  PERIOD_H4 : strPer= "MN1"; intPer=         30*dy;   clrPer=mClr?C'000,128,000':C'035,090,035';  break;
               } break;
              
                 
                 
//==========================================================================================================================================================================                 
                 
                 
      case 114: switch(_Period){
                  case  PERIOD_M1 : strPer= "";    intPer=            NULL;   clrPer=mClr?C'000,255,000':C'000,155,000';  break;/*TF Entry 1 / PERIOD 20*/
                  case  PERIOD_M5 : strPer= "";    intPer=            NULL;   clrPer=mClr?C'255,255,255':C'155,155,155';  break;  
                  case  PERIOD_M15: strPer= "M1";  intPer=            mn*2;   clrPer=mClr?C'255,255,255':C'155,155,155';  break;  
                  case  PERIOD_M30: strPer= "M2";  intPer=        2.5*mn*2;   clrPer=mClr?C'173,255,047':C'073,155,000';  break;
                  case  PERIOD_H1 : strPer= "M5";  intPer=          5*mn*2;   clrPer=mClr?C'238,130,238':C'221,160,221';  break;
                  case  PERIOD_H4 : strPer= "M30"; intPer=         25*mn*2;   clrPer=mClr?C'255,255,000':C'190,190,000';  break;
                  case  PERIOD_D1 : strPer= "H4";  intPer=          4*hr*2;   clrPer=mClr?C'000,255,000':C'000,070,000';  break;
                  case  PERIOD_W1 : strPer= "H12"; intPer=         12*hr*2;   clrPer=mClr?C'255,140,000':C'255,140,000';  break;
                  case  PERIOD_MN1: strPer= "D3";  intPer=          2*dy*2;   clrPer=mClr?C'240,230,140':C'240,230,140';  break;
               } break;           
      case 115: switch(_Period){
                  case  PERIOD_M1 : strPer= "S15"; intPer=          mn/4*2;   clrPer=mClr?C'000,255,000':C'000,155,000';  break;/*TF Entry 1 / PERIOD 20*/
                  case  PERIOD_M5 : strPer= "M1";  intPer=            mn*2;   clrPer=mClr?C'255,255,255':C'155,155,155';  break;  
                  case  PERIOD_M15: strPer= "M2";  intPer=        2.5*mn*2;   clrPer=mClr?C'173,255,047':C'073,155,000';  break;
                  case  PERIOD_M30: strPer= "M5";  intPer=          5*mn*2;   clrPer=mClr?C'238,130,238':C'221,160,221';  break;
                  case  PERIOD_H1 : strPer= "M15"; intPer=         15*mn*2;   clrPer=mClr?C'000,255,255':C'000,255,255';  break;
                  case  PERIOD_H4 : strPer= "H1";  intPer=            hr*2;   clrPer=mClr?C'255,000,000':C'125,000,000';  break;
                  case  PERIOD_D1 : strPer= "H8";  intPer=        7.5*hr*2;   clrPer=mClr?C'186,085,211':C'186,085,211';  break;
                  case  PERIOD_W1 : strPer= "D1";  intPer=         20*hr*2;   clrPer=mClr?C'175,238,238':C'175,238,238';  break;
                  case  PERIOD_MN1: strPer= "W1";  intPer=          6*dy*2;   clrPer=mClr?C'043,043,255':C'043,043,255';  break;
               } break;
      case 116: switch(_Period){ 
                  case  PERIOD_M1 : strPer= "S30"; intPer=          mn/2*2;   clrPer=mClr?C'255,140,000':C'155,040,000';  break;/*TFX Entry / Period 20*/
                  case  PERIOD_M5 : strPer= "M2";  intPer=        2.5*mn*2;   clrPer=mClr?C'173,255,047':C'073,155,000';  break;
                  case  PERIOD_M15: strPer= "M5";  intPer=        4.5*mn*2;   clrPer=mClr?C'238,130,238':C'221,160,221';  break;
                  case  PERIOD_M30: strPer= "M15"; intPer=         15*mn*2;   clrPer=mClr?C'000,255,255':C'000,255,255';  break;
                  case  PERIOD_H1 : strPer= "M30"; intPer=         30*mn*2;   clrPer=mClr?C'255,255,000':C'190,190,000';  break;
                  case  PERIOD_H4 : strPer= "H2";  intPer=          2*hr*2;   clrPer=mClr?C'255,255,255':C'105,105,105';  break;
                  case  PERIOD_D1 : strPer= "H12"; intPer=         12*hr*2;   clrPer=mClr?C'255,140,000':C'255,140,000';  break;
                  case  PERIOD_W1 : strPer= "D3";  intPer=        2.5*dy*2;   clrPer=mClr?C'240,230,140':C'240,230,140';  break;
                  case  PERIOD_MN1: strPer= "W2";  intPer=         15*dy*2;   clrPer=mClr?C'138,043,226':C'138,043,226';  break;
               } break;
      case 117: switch(_Period){
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
 
      case 118: switch(_Period){
                  case  PERIOD_M1 : strPer= "M2";  intPer=        2.5*mn*2;   clrPer=mClr?C'173,255,047':C'073,155,000';  break;/*TFX / PERIOD 20 ACUAN 1*/
                  case  PERIOD_M5 : strPer= "M15"; intPer=         15*mn*2;   clrPer=mClr?C'000,255,255':C'000,255,255';  break;
                  case  PERIOD_M15: strPer= "M30"; intPer=         30*mn*2;   clrPer=mClr?C'255,255,000':C'190,190,000';  break;
                  case  PERIOD_M30: strPer= "H1";  intPer=            hr*2;   clrPer=mClr?C'255,000,000':C'125,000,000';  break;
                  case  PERIOD_H1 : strPer= "H2";  intPer=          2*hr*2;   clrPer=mClr?C'255,255,255':C'105,105,105';  break;
                  case  PERIOD_H4 : strPer= "H8";  intPer=          8*hr*2;   clrPer=mClr?C'186,085,211':C'186,085,211';  break;
                  case  PERIOD_D1 : strPer= "D3";  intPer=        2.5*dy*2;   clrPer=mClr?C'240,230,140':C'240,230,140';  break;
                  case  PERIOD_W1 : strPer= "W2";  intPer=         15*dy*2;   clrPer=mClr?C'138,043,226':C'138,043,226';  break;
                  case  PERIOD_MN1: strPer= "MN2";  intPer=      2*30*dy*2;   clrPer=mClr?C'174,125,011':C'150,110,035';  break;
               } break;
      case 119: switch(_Period){
                  case  PERIOD_M1 : strPer= "M5";  intPer=          5*mn*2;   clrPer=mClr?C'238,130,238':C'221,160,221';  break;/*TF Up / PERIOD 20 ACUAN 2*/
                  case  PERIOD_M5 : strPer= "M30"; intPer=         30*mn*2;   clrPer=mClr?C'255,255,000':C'190,190,000';  break;
                  case  PERIOD_M15: strPer= "H1";  intPer=            hr*2;   clrPer=mClr?C'255,000,000':C'125,000,000';  break;
                  case  PERIOD_M30: strPer= "H2";  intPer=          2*hr*2;   clrPer=mClr?C'255,255,255':C'105,105,105';  break;
                  case  PERIOD_H1 : strPer= "H4";  intPer=          4*hr*2;   clrPer=mClr?C'000,255,000':C'000,070,000';  break;
                  case  PERIOD_H4 : strPer= "H12"; intPer=         12*hr*2;   clrPer=mClr?C'255,140,000':C'255,140,000';  break;
                  case  PERIOD_D1 : strPer= "W1";  intPer=            wk*2;   clrPer=mClr?C'043,043,255':C'043,043,255';  break;
                  case  PERIOD_W1 : strPer= "MN1"; intPer=         30*dy*2;   clrPer=mClr?C'000,128,000':C'035,090,035';  break;
               } break;
      case 120: switch(_Period){
                  case  PERIOD_M1 : strPer= "M15"; intPer=         15*mn*2;   clrPer=mClr?C'000,255,255':C'000,255,255';  break; /*TFX Up / PERIOD 20 ACUAN 3*/
                  case  PERIOD_M5 : strPer= "H1";  intPer=            hr*2;   clrPer=mClr?C'255,000,000':C'125,000,000';  break;
                  case  PERIOD_M15: strPer= "H2";  intPer=          2*hr*2;   clrPer=mClr?C'255,255,255':C'105,105,105';  break;
                  case  PERIOD_M30: strPer= "H4";  intPer=          4*hr*2;   clrPer=mClr?C'000,255,000':C'000,070,000';  break;
                  case  PERIOD_H1 : strPer= "H8";  intPer=          8*hr*2;   clrPer=mClr?C'186,085,211':C'186,085,211';  break;
                  case  PERIOD_H4 : strPer= "D1";  intPer=            dy*2;   clrPer=mClr?C'175,238,238':C'175,238,238';  break;
                  case  PERIOD_D1 : strPer= "W2";  intPer=         15*dy*2;   clrPer=mClr?C'138,043,226':C'138,043,226';  break;
                  case  PERIOD_W1 : strPer= "MN2";  intPer=       2*30*dy*2;   clrPer=mClr?C'174,125,011':C'150,110,035';  break;
               } break;
      case 121: switch(_Period){
                  case  PERIOD_M1 : strPer= "M30"; intPer=         30*mn*2;   clrPer=mClr?C'255,255,000':C'190,190,000';  break; /*TF 2 Up / PERIOD 20 ACUAN 4*/
                  case  PERIOD_M5 : strPer= "H2";  intPer=          2*hr*2;   clrPer=mClr?C'255,255,255':C'105,105,105';  break;
                  case  PERIOD_M15: strPer= "H4";  intPer=          4*hr*2;   clrPer=mClr?C'000,255,000':C'000,070,000';  break;
                  case  PERIOD_M30: strPer= "H8";  intPer=          8*hr*2;   clrPer=mClr?C'186,085,211':C'186,085,211';  break;
                  case  PERIOD_H1 : strPer= "H12"; intPer=         12*hr*2;   clrPer=mClr?C'255,140,000':C'255,140,000';  break;
                  case  PERIOD_H4 : strPer= "D3";  intPer=        2.5*dy*2;   clrPer=mClr?C'240,230,140':C'240,230,140';  break;
                  case  PERIOD_D1 : strPer= "MN1";  intPer=         30*dy*2;   clrPer=mClr?C'000,128,000':C'035,090,035';  break;
               } break;
      case 122: switch(_Period){
                  case  PERIOD_M1 : strPer= "H1";  intPer=            hr*2;   clrPer=mClr?C'255,000,000':C'125,000,000';  break; /*TFF 2 Up / PERIOD 20 ACUAN 5*/
                  case  PERIOD_M5 : strPer= "H4";  intPer=          4*hr*2;   clrPer=mClr?C'000,255,000':C'000,070,000';  break;
                  case  PERIOD_M15: strPer= "H8";  intPer=          8*hr*2;   clrPer=mClr?C'186,085,211':C'186,085,211';  break;
                  case  PERIOD_M30: strPer= "H12"; intPer=         12*hr*2;   clrPer=mClr?C'255,140,000':C'255,140,000';  break;
                  case  PERIOD_H1 : strPer= "D1";  intPer=            dy*2;   clrPer=mClr?C'175,238,238':C'175,238,238';  break;
                  case  PERIOD_H4 : strPer= "W1";  intPer=            wk*2;   clrPer=mClr?C'043,043,255':C'043,043,255';  break;
                  case  PERIOD_D1 : strPer= "MN2";  intPer=       2*30*dy*2;   clrPer=mClr?C'174,125,011':C'150,110,035';  break;
               } break;
      case 123: switch(_Period){
                  case  PERIOD_M1 : strPer= "H2";  intPer=          2*hr*2;   clrPer=mClr?C'255,255,255':C'105,105,105';  break; /*TF 3 Up / PERIOD 20 ACUAN 6*/
                  case  PERIOD_M5 : strPer= "H8";  intPer=          8*hr*2;   clrPer=mClr?C'186,085,211':C'186,085,211';  break;
                  case  PERIOD_M15: strPer= "H12"; intPer=         12*hr*2;   clrPer=mClr?C'255,140,000':C'255,140,000';  break;
                  case  PERIOD_M30: strPer= "D1";  intPer=            dy*2;   clrPer=mClr?C'175,238,238':C'175,238,238';  break;
                  case  PERIOD_H1 : strPer= "D3";  intPer=        2.5*dy*2;   clrPer=mClr?C'240,230,140':C'240,230,140';  break;
                  case  PERIOD_H4 : strPer= "W2";  intPer=         15*dy*2;   clrPer=mClr?C'138,043,226':C'070,025,113';  break;
               } break;
      case 124: switch(_Period){
                  case  PERIOD_M1 : strPer= "H4";  intPer=          4*hr*2;   clrPer=mClr?C'000,255,000':C'000,070,000';  break; /*TFX 3 Up / PERIOD 20 ACUAN 7*/
                  case  PERIOD_M5 : strPer= "H12"; intPer=         12*hr*2;   clrPer=mClr?C'255,140,000':C'255,140,000';  break;
                  case  PERIOD_M15: strPer= "D1";  intPer=            dy*2;   clrPer=mClr?C'175,238,238':C'175,238,238';  break;
                  case  PERIOD_M30: strPer= "D3";  intPer=        2.5*dy*2;   clrPer=mClr?C'240,230,140':C'240,230,140';  break;
                  case  PERIOD_H1 : strPer= "W1";  intPer=            wk*2;   clrPer=mClr?C'043,043,255':C'043,043,255';  break;
                  case  PERIOD_H4 : strPer= "MN1";  intPer=         30*dy*2;   clrPer=mClr?C'000,128,000':C'035,090,035';  break;
               } break;                 
                 
                 
      
      case 130: switch(_Period){
                  case  PERIOD_M1 : strPer="1Mn";   intPer=   mn1;   clrPer=mClr?C'255,140,000':C'155,040,000';  break;/*LWMA 5*/
                  case  PERIOD_M5 : strPer="5Mn";   intPer= 5*mn1;   clrPer=mClr?C'211,211,211':C'255,255,255';  break;
                  case  PERIOD_M15: strPer="15Mn";  intPer=15*mn1;   clrPer=mClr?C'000,200,200':C'000,150,150';  break;
                  case  PERIOD_M30: strPer="30Mn";  intPer=30*mn1;   clrPer=mClr?C'000,255,255':C'065,105,225';  break;
                  case  PERIOD_H1 : strPer="1Hr";   intPer=   hr1;   clrPer=mClr?C'000,255,255':C'065,105,225';  break;
                  case  PERIOD_H4 : strPer="4Hr";   intPer= 4*hr1;   clrPer=mClr?C'255,000,000':C'125,000,000';  break;
                  case  PERIOD_D1 : strPer="1Dy";   intPer=   dy1;   clrPer=mClr?C'000,255,000':C'050,205,050';  break;
                  case  PERIOD_W1 : strPer="1Wk";   intPer=   wk1;   clrPer=mClr?C'043,043,255':C'043,043,155';  break;
                  case  PERIOD_MN1: strPer="1Mh";   intPer=   mh1;   clrPer=mClr?C'106,090,205':C'120,115,190';  break;
               } break;
      case 131: switch(_Period){ 
                  case  PERIOD_M1 : strPer= "1Mn";  intPer=   mn1*2;   clrPer=mClr?C'255,000,000':C'125,000,000';  break;
                  case  PERIOD_M5 : strPer= "5Mn";  intPer= 5*mn1*2;   clrPer=mClr?C'255,255,000':C'190,190,000';  break;/*LWMA 10*/
                  case  PERIOD_M15: strPer= "15Mn"; intPer=15*mn1*2;   clrPer=mClr?C'238,130,238':C'221,160,221';  break;
                  case  PERIOD_M30: strPer= "30Mn"; intPer=30*mn1*2;   clrPer=mClr?C'255,255,000':C'130,130,000';  break;
                  case  PERIOD_H1 : strPer= "1Hr";  intPer=   hr1*2;   clrPer=mClr?C'255,255,000':C'190,190,000';  break;
                  case  PERIOD_H4 : strPer= "4Hr";  intPer= 4*hr1*2;   clrPer=mClr?C'230,230,250':C'230,225,255';  break;
                  case  PERIOD_D1 : strPer= "1Dy";  intPer=   dy1*2;   clrPer=mClr?C'186,085,211':C'180,065,230';  break;
                  case  PERIOD_W1 : strPer= "1Wk";  intPer=   wk1*2;   clrPer=mClr?C'043,043,255':C'043,043,155';  break;
                  case  PERIOD_MN1: strPer= "1Mh";  intPer=   mn1*2;   clrPer=mClr?C'165,042,042':C'185,040,020';  break;
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