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
#property indicator_buffers 50

enum eModeMA         {_DisableAll/*Disable*/,_shEMA50/*Show EMA50*/,_shMAtr/*Show MATrend*/};
enum eModeBB         {_DisableBB/*Disable*/,_shSD1/*Show BB SD 1*/,_shSD2/*Show BB SD 2*/,_shFSD/*Show BB SD 1 & 2*/};
enum eModeLine       {_0L/*Solid*/,_1L/*Dash*/,_2L/*Dot*/,_3L/*Dash Dot*/,_4L/*Dash Dot Dot*/};


extern ENUM_BASE_CORNER   corner = CORNER_LEFT_LOWER; // Position
extern int button_x              = 0;               // X
extern int button_y              = 0;                // Y
input string                 _Reguler= "--- REGULAR ---";//_______________________00

input bool colormode             = true;          //Show White Background
input bool showmathead           = false;          //Show MATrend Header
input bool xlsma                 = false;          //LSMA MODE
input eModeLine linemode         = _4L;            //Line MATrick Type    
input eModeLine linemode1        = _3L;            //Line BB Type SD 1   
input eModeLine linemode2        = _0L;            //Line BB Type SD 2     
input ENUM_MA_METHOD
               modeMA            = MODE_SMA;       //---------- MA Method ----------
 
input string                  _BB= "--- BB SETTING ---";//_______________________00           
input eModeBB  s0ModeBB          = _shSD2;         //BB TFX ENTRY
input eModeBB  s1ModeBB          = _shSD2;     //BB ACTIVE 
input eModeBB  s2ModeBB          = _DisableBB;     //BB TF ACUAN 01 
input eModeBB  s3ModeBB          = _DisableBB;     //BB TF ACUAN 02 

   
input string           _MODEENTRY= "--- TF ENTRY ---";//_______________________00

input bool Entry1                = false;          //TF ENTRY
input bool Entry2                = true;           //TFX ENTRY

input string           _MODEBASIC= "--- SETTING TF ---";//_______________________00  
input bool tfactive              = true;           //TF ACTIVE 
input bool acuan01               = false;          //TF ACUAN 01
input bool acuan02               = false;          //TF ACUAN 02


          
input string                _LWMA= "--- LWMA HiLo SETTING ---";//_______________________00 
input bool lwma5                 = false;          //HiLo LWMA 5
input bool lwma10                = false;          //HiLo LWMA 10
input color    clLWSMA1          = clrNONE,        //LWMA 5
               clLWSMA2          = clrNONE;        //LWMA 10  
input bool lwma3                 = false;          //HiLo LWMA TF Active
input bool lwma4                 = false;          //HiLo LWMA TFX 
input color    clLWSMA30         = clrNONE,        //LWMA TF Active
               clLWSMA40         = clrNONE;        //LWMA TFX  



input string        _ckonfirmasi1= "--- COLOR TF Entry ---";//_______________________00             
input color    clSMA1            = clrNONE,//-------- MID
               clSMAT1           = clrNONE;//-------- MA TRICK 

input string        _ckonfirmasi2= "--- COLOR TFX Entry ---";//_______________________00                  
input color    clSMA2            = clrNONE,//-------- MID 
               clSMAT2           = clrNONE,//-------- MA TRICK
               clSDP2            = clrNONE,//-------- SD +
               clSDM2            = clrNONE;//-------- SD -  

input string             _cACTIVE= "--- COLOR TF ACTIVE ---";//_______________________00               
input color    clSMA3            = clrNONE,//-------- MID
               clSMAT3           = clrNONE,//-------- MA TRICK
               clSDP3            = C'43,43,255',//-------- SD +
               clSDM3            = C'43,43,255';//-------- SD -  
               
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

            


string iName, buttonId, IndicatorObjPrefix;
int    iP0,iP1,iP2,iP3,iP4,iP5,iP6,iP7,iP8,iP9,iP10,iP11,iP12,
       tP0,tP1,tP2,tP3,tP4,tP5,tP6,tP7,tP8,tP9,tP10,tP11,tP12,
       lP1,lP2,mP1,mP2;
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
EMA01[],

HLWMA01[],LLWMA01[],HLWMA02[],LLWMA02[],
HLWMA03[],LLWMA03[],HLWMA04[],LLWMA04[],
sSDP02[],sSDM02[],sSDP022[],sSDM022[],
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

bool BB1_enable = s0ModeBB==_shSD1, //BB TFX ENTRY
     BB2_enable = s0ModeBB==_shSD2,
     BBF_enable = s0ModeBB==_shFSD,
     
     XBB1_enable = s1ModeBB==_shSD1, //BB TF Active
     XBB2_enable = s1ModeBB==_shSD2, 
     XBBF_enable = s1ModeBB==_shFSD, 
          
     b1BB1_enable = s2ModeBB==_shSD1, //BB TF ACUAN 01 
     b1BB2_enable = s2ModeBB==_shSD2,
     b1BBF_enable = s2ModeBB==_shFSD,
     
     b2BB1_enable = s3ModeBB==_shSD1, //BB TF ACUAN 02
     b2BB2_enable = s3ModeBB==_shSD2,
     b2BBF_enable = s3ModeBB==_shFSD,
        
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
      Comment("Account : Not Authorized | 15.11.2023");
      datetime TrialEndDate = D'15.11.2023 23:00:00'; // <-- write here the date when you the MT4 program stops
      if(TimeCurrent() > TrialEndDate){
         Alert("Trial period has expired!");
         return(-1);
      }
   }  
   
   if(WindowExpertName()!="!BBMA KG N.G 2022"){
      Alert("Warning !!!\n INDICATOR'S NAME HAS BEEN CHANGED '"+WindowExpertName()+"'\n PLEASE RETURN TO '"+"!BBMA KG N.G 2022"+"'");
      ChartIndicatorDelete(0,0,WindowExpertName());
   }
//=================================================================   
   iName="!BBMA KG N.G 2022";   
   NamaFile = "tmp\\MATrick KG-"+_Symbol;
   SetFile(0);
   DrawOnOff();
   
   IndicatorObjPrefix = "__" + iName + "__";   
   //SMA    
   iP1=StrToInteger(getPer(95,0,1));
   iP2=StrToInteger(getPer(96,0,1));
   iP3=StrToInteger(getPer(97,0,1));
   iP4=StrToInteger(getPer(98,0,1));
   iP5=StrToInteger(getPer(99,0,1));

   
   //MATREND
   tP1=StrToInteger(getPer(101,0,1)); 
   tP2=StrToInteger(getPer(102,0,1));
   tP3=StrToInteger(getPer(103,0,1));
   tP4=StrToInteger(getPer(104,0,1));
   tP5=StrToInteger(getPer(105,0,1));

      
   //LWMA   
   lP1=StrToInteger(getPer(125,0,1));
   lP2=StrToInteger(getPer(126,0,1));   
  
   IndicatorBuffers(50);
 
   SetIndexBuffer(49,SDP02);  SetIndexStyle(49,isOn&&BB1_enable?0:12,linemode1,1,getClr(96,0,(colormode==false?true:false),clSDP2)); SetIndexLabel(49,"BB20UPR_SD 1_" +getPer(96,0,0,false)+"");
   SetIndexBuffer(48,SDM02);  SetIndexStyle(48,isOn&&BB1_enable?0:12,linemode1,1,getClr(96,0,(colormode==false?true:false),clSDM2)); SetIndexLabel(48,"BB20LWR_SD 1_" +getPer(96,0,0,false)+"");
   SetIndexBuffer(47,SDP022); SetIndexStyle(47,isOn&&BB2_enable?0:12,linemode2,1,getClr(96,0,(colormode==false?true:false),clSDP2)); SetIndexLabel(47,"BB20UPR_SD 2_" +getPer(96,0,0,false)+"");
   SetIndexBuffer(46,SDM022); SetIndexStyle(46,isOn&&BB2_enable?0:12,linemode2,1,getClr(96,0,(colormode==false?true:false),clSDM2)); SetIndexLabel(45,"BB20LWR_SD 2_" +getPer(96,0,0,false)+"");
 
   SetIndexBuffer(45,sSDP02); SetIndexStyle(45,isOn&&BBF_enable?0:12,linemode1,1,getClr(96,0,(colormode==false?true:false),clSDP2)); SetIndexLabel(45,"BB20UPR_SD 1_" +getPer(96,0,0,false)+"");
   SetIndexBuffer(44,sSDM02); SetIndexStyle(44,isOn&&BBF_enable?0:12,linemode1,1,getClr(96,0,(colormode==false?true:false),clSDM2)); SetIndexLabel(44,"BB20LWR_SD 1_" +getPer(96,0,0,false)+"");
   SetIndexBuffer(43,sSDP022); SetIndexStyle(43,isOn&&BBF_enable?0:12,linemode2,1,getClr(96,0,(colormode==false?true:false),clSDP2)); SetIndexLabel(43,"BB20UPR_SD 2_" +getPer(96,0,0,false)+"");
   SetIndexBuffer(42,sSDM022); SetIndexStyle(42,isOn&&BBF_enable?0:12,linemode2,1,getClr(96,0,(colormode==false?true:false),clSDM2)); SetIndexLabel(42,"BB20LWR_SD 2_" +getPer(96,0,0,false)+"");
 
   SetIndexBuffer(41,SMAT05);SetIndexStyle(41,isOn?0:12,linemode,1,getClr(105,0,(colormode==false?true:false),clSMAT5)); SetIndexLabel(41,"MaTrick " +getPer(105,0,0,false)+"");  //ACUAN 2
   SetIndexBuffer(40,SMAT04);SetIndexStyle(40,isOn?0:12,linemode,1,getClr(104,0,(colormode==false?true:false),clSMAT4)); SetIndexLabel(40,"MaTrick " +getPer(104,0,0,false)+"");  //ACUAN 1
   SetIndexBuffer(39,SMAT03);SetIndexStyle(39,isOn?0:12,linemode,1,getClr(103,0,(colormode==false?true:false),clSMAT3)); SetIndexLabel(39,"MaTrick " +getPer(103,0,0,false)+"");  //ACTIVE
   SetIndexBuffer(38,SMAT02);SetIndexStyle(38,isOn?0:12,linemode,1,getClr(102,0,(colormode==false?true:false),clSMAT2)); SetIndexLabel(38,"MaTrick " +getPer(102,0,0,false)+"");  //TF KONFIRMASI 2
   SetIndexBuffer(37,SMAT01);SetIndexStyle(37,isOn?0:12,linemode,1,getClr(101,0,(colormode==false?true:false),clSMAT1)); SetIndexLabel(37,"MaTrick " +getPer(101,0,0,false)+"");  //TF KONFIRMASI 1
   
   //MID BB
   SetIndexBuffer(36,SMA05); SetIndexStyle(36,isOn?0:12,0,1,getClr(99,0,(colormode==false?true:false),clSMA5));   SetIndexLabel(36,"MidBB " +getPer(99,0,0,false)+"");   //ACUAN 2
   SetIndexBuffer(35,SMA04); SetIndexStyle(35,isOn?0:12,0,1,getClr(98,0,(colormode==false?true:false),clSMA4));   SetIndexLabel(35,"MidBB " +getPer(98,0,0,false)+"");   //ACUAN 1
   SetIndexBuffer(34,SMA03); SetIndexStyle(34,isOn?0:12,0,1,getClr(97,0,(colormode==false?true:false),clSMA3));   SetIndexLabel(34,"MidBB " +getPer(97,0,0,false)+"");   //ACTIVE
   SetIndexBuffer(33,SMA02); SetIndexStyle(33,isOn?0:12,0,1,getClr(96,0,(colormode==false?true:false),clSMA2));   SetIndexLabel(33,"MidBB " +getPer(96,0,0,false)+"");   //TF KONFIRMASI 2
   SetIndexBuffer(32,SMA01); SetIndexStyle(32,isOn?0:12,0,1,getClr(95,0,(colormode==false?true:false),clSMA1));   SetIndexLabel(32,"MidBB " +getPer(95,0,0,false)+"");   //TF KONFIRMASI 1

   //LWMA HIGH LOW
   SetIndexBuffer(31,LLWMA04); SetIndexStyle(31,isOn?0:12,0,2,getClr(102,0,(colormode==false?true:false),clLWSMA40)); SetIndexLabel(31,getPer(98,0,0,false));
   SetIndexBuffer(30,HLWMA04); SetIndexStyle(30,isOn?0:12,0,2,getClr(101,0,(colormode==false?true:false),clLWSMA40)); SetIndexLabel(30,getPer(98,0,0,false));
   SetIndexBuffer(29,LLWMA03); SetIndexStyle(29,isOn?0:12,0,2,getClr(102,0,(colormode==false?true:false),clLWSMA30)); SetIndexLabel(29,getPer(97,0,0,false));  
   SetIndexBuffer(28,HLWMA03); SetIndexStyle(28,isOn?0:12,0,2,getClr(101,0,(colormode==false?true:false),clLWSMA30)); SetIndexLabel(28,getPer(97,0,0,false));

   SetIndexBuffer(27,LLWMA02); SetIndexStyle(27,isOn?0:12,0,1,getClr(102,0,(colormode==false?true:false),clLWSMA2)); SetIndexLabel(27,getPer(96,0,0,false));
   SetIndexBuffer(26,HLWMA02); SetIndexStyle(26,isOn?0:12,0,1,getClr(101,0,(colormode==false?true:false),clLWSMA1)); SetIndexLabel(26,getPer(96,0,0,false));
   SetIndexBuffer(25,LLWMA01); SetIndexStyle(25,isOn?0:12,0,1,getClr(102,0,(colormode==false?true:false),clLWSMA2)); SetIndexLabel(25,getPer(95,0,0,false));
   SetIndexBuffer(24,HLWMA01); SetIndexStyle(24,isOn?0:12,0,1,getClr(101,0,(colormode==false?true:false),clLWSMA1)); SetIndexLabel(24,getPer(95,0,0,false));
   
   //BB TF ACTIVE
   SetIndexBuffer(23,SDP03); SetIndexStyle(23,isOn&&XBB1_enable?0:12,linemode1,(clSDM3==C'43,43,255'?2:1),getClr(97,0,(colormode==false?true:false),clSDP3)); SetIndexLabel(23,"BB20UPR_SD 1_" +getPer(97,0,0,false)+"");
   SetIndexBuffer(22,SDM03); SetIndexStyle(22,isOn&&XBB1_enable?0:12,linemode1,(clSDM3==C'43,43,255'?2:1),getClr(97,0,(colormode==false?true:false),clSDM3)); SetIndexLabel(22,"BB20LWR_SD 1_" +getPer(97,0,0,false)+"");
   SetIndexBuffer(21,SDP032);SetIndexStyle(21,isOn&&XBB2_enable?0:12,linemode2,(clSDM3==C'43,43,255'?2:1),getClr(97,0,(colormode==false?true:false),clSDP3)); SetIndexLabel(21,"BB20UPR_SD 2_" +getPer(97,0,0,false)+"");
   SetIndexBuffer(20,SDM032);SetIndexStyle(20,isOn&&XBB2_enable?0:12,linemode2,(clSDM3==C'43,43,255'?2:1),getClr(97,0,(colormode==false?true:false),clSDM3)); SetIndexLabel(20,"BB20LWR_SD 2_" +getPer(97,0,0,false)+"");
 
   SetIndexBuffer(19,sSDP03); SetIndexStyle(19,isOn&&XBBF_enable?0:12,linemode1,(clSDM3==C'43,43,255'?2:1),getClr(97,0,(colormode==false?true:false),clSDP3)); SetIndexLabel(19,"BB20UPR_SD 1_" +getPer(97,0,0,false)+"");
   SetIndexBuffer(18,sSDM03); SetIndexStyle(18,isOn&&XBBF_enable?0:12,linemode1,(clSDM3==C'43,43,255'?2:1),getClr(97,0,(colormode==false?true:false),clSDM3)); SetIndexLabel(18,"BB20LWR_SD 1_" +getPer(97,0,0,false)+"");
   SetIndexBuffer(17,sSDP032);SetIndexStyle(17,isOn&&XBBF_enable?0:12,linemode2,(clSDM3==C'43,43,255'?2:1),getClr(97,0,(colormode==false?true:false),clSDP3)); SetIndexLabel(17,"BB20UPR_SD 2_" +getPer(97,0,0,false)+"");
   SetIndexBuffer(16,sSDM032);SetIndexStyle(16,isOn&&XBBF_enable?0:12,linemode2,(clSDM3==C'43,43,255'?2:1),getClr(97,0,(colormode==false?true:false),clSDM3)); SetIndexLabel(16,"BB20LWR_SD 2_" +getPer(97,0,0,false)+"");
        
   //BB TFX
   SetIndexBuffer(15,SDP04);  SetIndexStyle(15,isOn&&b1BB1_enable?0:12,linemode1,1,getClr(98,0,(colormode==false?true:false),clSDP4)); SetIndexLabel(15,"BB20UPR_SD 1_" +getPer(98,0,0,false)+"");
   SetIndexBuffer(14,SDM04);  SetIndexStyle(14,isOn&&b1BB1_enable?0:12,linemode1,1,getClr(98,0,(colormode==false?true:false),clSDM4)); SetIndexLabel(14,"BB20LWR_SD 1_" +getPer(98,0,0,false)+"");
   SetIndexBuffer(13,SDP042); SetIndexStyle(13,isOn&&b1BB2_enable?0:12,linemode2,1,getClr(98,0,(colormode==false?true:false),clSDP4)); SetIndexLabel(13,"BB20UPR_SD 2_" +getPer(98,0,0,false)+"");
   SetIndexBuffer(12,SDM042); SetIndexStyle(12,isOn&&b1BB2_enable?0:12,linemode2,1,getClr(98,0,(colormode==false?true:false),clSDM4)); SetIndexLabel(12,"BB20LWR_SD 2_" +getPer(98,0,0,false)+"");

   SetIndexBuffer(11,sSDP04); SetIndexStyle(11,isOn&&b1BBF_enable?0:12,linemode1,1,getClr(98,0,(colormode==false?true:false),clSDP4)); SetIndexLabel(11,"BB20UPR_SD 1_" +getPer(98,0,0,false)+"");
   SetIndexBuffer(10,sSDM04); SetIndexStyle(10,isOn&&b1BBF_enable?0:12,linemode1,1,getClr(98,0,(colormode==false?true:false),clSDM4)); SetIndexLabel(10,"BB20LWR_SD 1_" +getPer(98,0,0,false)+"");
   SetIndexBuffer(9,sSDP042);SetIndexStyle(9,isOn&&b1BBF_enable?0:12,linemode2,1,getClr(98,0,(colormode==false?true:false),clSDP4)); SetIndexLabel(9,"BB20UPR_SD 2_" +getPer(98,0,0,false)+"");
   SetIndexBuffer(8,sSDM042);SetIndexStyle(8,isOn&&b1BBF_enable?0:12,linemode2,1,getClr(98,0,(colormode==false?true:false),clSDM4)); SetIndexLabel(8,"BB20LWR_SD 2_" +getPer(98,0,0,false)+"");
   
   //BB TF UPWARD
   SetIndexBuffer(7,SDP05);  SetIndexStyle(7,isOn&&b2BB1_enable?0:12,linemode1,1,getClr(99,0,(colormode==false?true:false),clSDP5)); SetIndexLabel(7,"BB20UPR_SD 1_" +getPer(99,0,0,false)+"");
   SetIndexBuffer(6,SDM05);  SetIndexStyle(6,isOn&&b2BB1_enable?0:12,linemode1,1,getClr(99,0,(colormode==false?true:false),clSDM5)); SetIndexLabel(6,"BB20LWR_SD 1_" +getPer(99,0,0,false)+"");
   SetIndexBuffer(5,SDP052); SetIndexStyle(5,isOn&&b2BB2_enable?0:12,linemode2,1,getClr(99,0,(colormode==false?true:false),clSDP5)); SetIndexLabel(5,"BB20UPR_SD 2_" +getPer(99,0,0,false)+"");
   SetIndexBuffer(4,SDM052); SetIndexStyle(4,isOn&&b2BB2_enable?0:12,linemode2,1,getClr(99,0,(colormode==false?true:false),clSDM5)); SetIndexLabel(4,"BB20LWR_SD 2_" +getPer(99,0,0,false)+"");
 
   SetIndexBuffer(3,sSDP05); SetIndexStyle(3,isOn&&b2BBF_enable?0:12,linemode1,1,getClr(99,0,(colormode==false?true:false),clSDP5)); SetIndexLabel(3,"BB20UPR_SD 1_" +getPer(99,0,0,false)+"");
   SetIndexBuffer(2,sSDM05); SetIndexStyle(2,isOn&&b2BBF_enable?0:12,linemode1,1,getClr(99,0,(colormode==false?true:false),clSDM5)); SetIndexLabel(2,"BB20LWR_SD 1_" +getPer(99,0,0,false)+"");
   SetIndexBuffer(1,sSDP052); SetIndexStyle(1,isOn&&b2BBF_enable?0:12,linemode2,1,getClr(99,0,(colormode==false?true:false),clSDP5)); SetIndexLabel(1,"BB20UPR_SD 2_" +getPer(99,0,0,false)+"");
   SetIndexBuffer(0,sSDM052); SetIndexStyle(0,isOn&&b2BBF_enable?0:12,linemode2,1,getClr(99,0,(colormode==false?true:false),clSDM5)); SetIndexLabel(0,"BB20LWR_SD 2_" +getPer(99,0,0,false)+"");
     

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
   Sett(cButton(0,strOnOff[0],0,setPosX+xD,setPosY+xY,90,18,corner,"BBMA KG "+(isOn?"On":"Off"),"Verdana Bold",8,clrGold,clMainBG,clrDarkGreen,0,0,0,1,1));   
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
   
   showmathead?cLabel(0,"Header1",5,1,CORNER_RIGHT_UPPER,"__MATr3ndLOgic SysT3m__  ","Calibri",9,clrWhite,0):EMPTY_VALUE;
   showmathead?cLabel(0,"Header2",4,11,CORNER_RIGHT_UPPER,"------------------40------------------","Calibri",9,clrYellowGreen,0):EMPTY_VALUE;
   showmathead?cLabel(0,"Header3",130,3,CORNER_RIGHT_UPPER,"Shown MTF >>                            ","Calibri",8,clrYellowGreen,0):EMPTY_VALUE; 
   
   for(int i=0; i<MathMin(Bars-IndicatorCounted(),Bars-1); i++){
      //SMA/MIDBB
      SMA01[i]   = Entry1?iMA(_Symbol,_Period,iP1,0,modeMA,PRICE_CLOSE,i):EMPTY_VALUE;
      
      SMA02[i]   = Entry2?iMA(_Symbol,_Period,iP2,0,modeMA,PRICE_CLOSE,i):EMPTY_VALUE;
      SDP02[i]   = BB1_enable?SMA02[i]+getSMA(iP2,i,vDev1):EMPTY_VALUE;
      SDM02[i]   = BB1_enable?SMA02[i]-getSMA(iP2,i,vDev1):EMPTY_VALUE;
      SDP022[i]  = BB2_enable?SMA02[i]+getSMA(iP2,i,vDev2):EMPTY_VALUE;
      SDM022[i]  = BB2_enable?SMA02[i]-getSMA(iP2,i,vDev2):EMPTY_VALUE;
      
      sSDP02[i]  = BBF_enable?SMA02[i]+getSMA(iP2,i,vDev1):EMPTY_VALUE;
      sSDM02[i]  = BBF_enable?SMA02[i]-getSMA(iP2,i,vDev1):EMPTY_VALUE;
      sSDP022[i] = BBF_enable?SMA02[i]+getSMA(iP2,i,vDev2):EMPTY_VALUE;
      sSDM022[i] = BBF_enable?SMA02[i]-getSMA(iP2,i,vDev2):EMPTY_VALUE;
      
      SMA03[i]   = tfactive?iMA(_Symbol,_Period,iP3,0,modeMA,PRICE_CLOSE,i):EMPTY_VALUE;
      SDP03[i]   = XBB1_enable?SMA03[i]+getSMA(iP3,i,vDev1):EMPTY_VALUE;
      SDM03[i]   = XBB1_enable?SMA03[i]-getSMA(iP3,i,vDev1):EMPTY_VALUE;
      SDP032[i]  = XBB2_enable?SMA03[i]+getSMA(iP3,i,vDev2):EMPTY_VALUE;
      SDM032[i]  = XBB2_enable?SMA03[i]-getSMA(iP3,i,vDev2):EMPTY_VALUE;
      
      sSDP03[i]  = XBBF_enable?SMA03[i]+getSMA(iP3,i,vDev1):EMPTY_VALUE;
      sSDM03[i]  = XBBF_enable?SMA03[i]-getSMA(iP3,i,vDev1):EMPTY_VALUE;
      sSDP032[i] = XBBF_enable?SMA03[i]+getSMA(iP3,i,vDev2):EMPTY_VALUE;
      sSDM032[i] = XBBF_enable?SMA03[i]-getSMA(iP3,i,vDev2):EMPTY_VALUE;
      
      SMA04[i]   = acuan01?iMA(_Symbol,_Period,iP4,0,modeMA,PRICE_CLOSE,i):EMPTY_VALUE;
      SDP04[i]   = b1BB1_enable?SMA04[i]+getSMA(iP4,i,vDev1):EMPTY_VALUE;
      SDM04[i]   = b1BB1_enable?SMA04[i]-getSMA(iP4,i,vDev1):EMPTY_VALUE;
      SDP042[i]  = b1BB2_enable?SMA04[i]+getSMA(iP4,i,vDev2):EMPTY_VALUE;
      SDM042[i]  = b1BB2_enable?SMA04[i]-getSMA(iP4,i,vDev2):EMPTY_VALUE;
      
      sSDP04[i]  = b1BBF_enable?SMA04[i]+getSMA(iP4,i,vDev1):EMPTY_VALUE;
      sSDM04[i]  = b1BBF_enable?SMA04[i]-getSMA(iP4,i,vDev1):EMPTY_VALUE;
      sSDP042[i] = b1BBF_enable?SMA04[i]+getSMA(iP4,i,vDev2):EMPTY_VALUE;
      sSDM042[i] = b1BBF_enable?SMA04[i]-getSMA(iP4,i,vDev2):EMPTY_VALUE; 
         
      SMA05[i]   = acuan02?iMA(_Symbol,_Period,iP5,0,modeMA,PRICE_CLOSE,i):EMPTY_VALUE;
      SDP05[i]   = b2BB1_enable?SMA05[i]+getSMA(iP5,i,vDev1):EMPTY_VALUE;
      SDM05[i]   = b2BB1_enable?SMA05[i]-getSMA(iP5,i,vDev1):EMPTY_VALUE;
      SDP052[i]  = b2BB2_enable?SMA05[i]+getSMA(iP5,i,vDev2):EMPTY_VALUE;
      SDM052[i]  = b2BB2_enable?SMA05[i]-getSMA(iP5,i,vDev2):EMPTY_VALUE;
      
      sSDP05[i]  = b2BBF_enable?SMA05[i]+getSMA(iP5,i,vDev1):EMPTY_VALUE;
      sSDM05[i]  = b2BBF_enable?SMA05[i]-getSMA(iP5,i,vDev1):EMPTY_VALUE;
      sSDP052[i] = b2BBF_enable?SMA05[i]+getSMA(iP5,i,vDev2):EMPTY_VALUE;
      sSDM052[i] = b2BBF_enable?SMA05[i]-getSMA(iP5,i,vDev2):EMPTY_VALUE;
           
      
      //MATREND 
      SMAT01[i] = Entry1?  (3*iMA(_Symbol,_Period,tP1,0,(xlsma==true)?MODE_LWMA:MODE_EMA,PRICE_CLOSE,i)) - (2*iMA(_Symbol,_Period,tP1,0,MODE_SMA,PRICE_CLOSE,i)):EMPTY_VALUE; 
      SMAT02[i] = Entry2?  (3*iMA(_Symbol,_Period,tP2,0,(xlsma==true)?MODE_LWMA:MODE_EMA,PRICE_CLOSE,i)) - (2*iMA(_Symbol,_Period,tP2,0,MODE_SMA,PRICE_CLOSE,i)):EMPTY_VALUE; 
      SMAT03[i] = tfactive?(3*iMA(_Symbol,_Period,tP3,0,(xlsma==true)?MODE_LWMA:MODE_EMA,PRICE_CLOSE,i)) - (2*iMA(_Symbol,_Period,tP3,0,MODE_SMA,PRICE_CLOSE,i)):EMPTY_VALUE; 
      SMAT04[i] = acuan01? (3*iMA(_Symbol,_Period,tP4,0,(xlsma==true)?MODE_LWMA:MODE_EMA,PRICE_CLOSE,i)) - (2*iMA(_Symbol,_Period,tP4,0,MODE_SMA,PRICE_CLOSE,i)):EMPTY_VALUE; 
      SMAT05[i] = acuan02? (3*iMA(_Symbol,_Period,tP5,0,(xlsma==true)?MODE_LWMA:MODE_EMA,PRICE_CLOSE,i)) - (2*iMA(_Symbol,_Period,tP5,0,MODE_SMA,PRICE_CLOSE,i)):EMPTY_VALUE; 

      
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
   
   return(rates_total);
}
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
void SetStyle(){

   //BB TFX ENTRY 
   SetIndexStyle(49,isOn&&BB1_enable?0:12,linemode1,1,getClr(96,0,(colormode==false?true:false),clSDP2));
   SetIndexStyle(48,isOn&&BB1_enable?0:12,linemode1,1,getClr(96,0,(colormode==false?true:false),clSDM2));
   SetIndexStyle(47,isOn&&BB2_enable?0:12,linemode2,1,getClr(96,0,(colormode==false?true:false),clSDP2));
   SetIndexStyle(46,isOn&&BB2_enable?0:12,linemode2,1,getClr(96,0,(colormode==false?true:false),clSDM2));
   
   SetIndexStyle(45,isOn&&BBF_enable?0:12,linemode1,1,getClr(96,0,(colormode==false?true:false),clSDP2));
   SetIndexStyle(44,isOn&&BBF_enable?0:12,linemode1,1,getClr(96,0,(colormode==false?true:false),clSDM2));
   SetIndexStyle(43,isOn&&BBF_enable?0:12,linemode2,1,getClr(96,0,(colormode==false?true:false),clSDP2));
   SetIndexStyle(42,isOn&&BBF_enable?0:12,linemode2,1,getClr(96,0,(colormode==false?true:false),clSDM2));

   //MATREND
   SetIndexStyle(41,isOn?0:12,linemode,1,getClr(105,0,(colormode==false?true:false),clSMAT5));
   SetIndexStyle(40,isOn?0:12,linemode,1,getClr(104,0,(colormode==false?true:false),clSMAT4));
   SetIndexStyle(39,isOn?0:12,linemode,1,getClr(103,0,(colormode==false?true:false),clSMAT3));
   SetIndexStyle(38,isOn?0:12,linemode,1,getClr(102,0,(colormode==false?true:false),clSMAT2));
   SetIndexStyle(37,isOn?0:12,linemode,1,getClr(101,0,(colormode==false?true:false),clSMAT1));

   //MID BB
   SetIndexStyle(36,isOn?0:12,0,1,getClr(99,0,(colormode==false?true:false),clSMA5));
   SetIndexStyle(35,isOn?0:12,0,1,getClr(98,0,(colormode==false?true:false),clSMA4));
   SetIndexStyle(34,isOn?0:12,0,1,getClr(97,0,(colormode==false?true:false),clSMA3));
   SetIndexStyle(33,isOn?0:12,0,1,getClr(96,0,(colormode==false?true:false),clSMA2));
   SetIndexStyle(32,isOn?0:12,0,1,getClr(95,0,(colormode==false?true:false),clSMA1));
   
   //LWMA HIGH LOW
   SetIndexStyle(31,isOn?0:12,0,2,getClr(102,0,(colormode==false?true:false),clLWSMA40));
   SetIndexStyle(30,isOn?0:12,0,2,getClr(101,0,(colormode==false?true:false),clLWSMA40));
   SetIndexStyle(29,isOn?0:12,0,2,getClr(102,0,(colormode==false?true:false),clLWSMA30));
   SetIndexStyle(28,isOn?0:12,0,2,getClr(101,0,(colormode==false?true:false),clLWSMA30));
   
   SetIndexStyle(27,isOn?0:12,0,1,getClr(102,0,(colormode==false?true:false),clLWSMA2));
   SetIndexStyle(26,isOn?0:12,0,1,getClr(101,0,(colormode==false?true:false),clLWSMA1));
   SetIndexStyle(25,isOn?0:12,0,1,getClr(102,0,(colormode==false?true:false),clLWSMA2));
   SetIndexStyle(24,isOn?0:12,0,1,getClr(101,0,(colormode==false?true:false),clLWSMA1));
   
   //BB TF ACTIVE   
   SetIndexStyle(23,isOn&&XBB1_enable?0:12,linemode1,(clSDM3==C'43,43,255'?2:1),getClr(97,0,(colormode==false?true:false),clSDP3));
   SetIndexStyle(22,isOn&&XBB1_enable?0:12,linemode1,(clSDM3==C'43,43,255'?2:1),getClr(97,0,(colormode==false?true:false),clSDM3));
   SetIndexStyle(21,isOn&&XBB2_enable?0:12,linemode2,(clSDM3==C'43,43,255'?2:1),getClr(97,0,(colormode==false?true:false),clSDP3));
   SetIndexStyle(20,isOn&&XBB2_enable?0:12,linemode2,(clSDM3==C'43,43,255'?2:1),getClr(97,0,(colormode==false?true:false),clSDM3));
   
   SetIndexStyle(19,isOn&&XBBF_enable?0:12,linemode1,(clSDM3==C'43,43,255'?2:1),getClr(97,0,(colormode==false?true:false),clSDP3));
   SetIndexStyle(18,isOn&&XBBF_enable?0:12,linemode1,(clSDM3==C'43,43,255'?2:1),getClr(97,0,(colormode==false?true:false),clSDM3));
   SetIndexStyle(17,isOn&&XBBF_enable?0:12,linemode2,(clSDM3==C'43,43,255'?2:1),getClr(97,0,(colormode==false?true:false),clSDP3));
   SetIndexStyle(16,isOn&&XBBF_enable?0:12,linemode2,(clSDM3==C'43,43,255'?2:1),getClr(97,0,(colormode==false?true:false),clSDM3));
   
   //BB TFX
   SetIndexStyle(15,isOn&&b1BB1_enable?0:12,linemode1,1,getClr(98,0,(colormode==false?true:false),clSDP4));
   SetIndexStyle(14,isOn&&b1BB1_enable?0:12,linemode1,1,getClr(98,0,(colormode==false?true:false),clSDM4));
   SetIndexStyle(13,isOn&&b1BB2_enable?0:12,linemode2,1,getClr(98,0,(colormode==false?true:false),clSDP4));
   SetIndexStyle(12,isOn&&b1BB2_enable?0:12,linemode2,1,getClr(98,0,(colormode==false?true:false),clSDM4));
   
   SetIndexStyle(11,isOn&&b1BBF_enable?0:12,linemode1,1,getClr(98,0,(colormode==false?true:false),clSDP4));
   SetIndexStyle(10,isOn&&b1BBF_enable?0:12,linemode1,1,getClr(98,0,(colormode==false?true:false),clSDM4));
   SetIndexStyle(9,isOn&&b1BBF_enable?0:12,linemode2,1,getClr(98,0,(colormode==false?true:false),clSDP4));
   SetIndexStyle(8,isOn&&b1BBF_enable?0:12,linemode2,1,getClr(98,0,(colormode==false?true:false),clSDM4));
   
   //BB TF UPWARD
   SetIndexStyle(7,isOn&&b2BB1_enable?0:12,linemode1,1,getClr(99,0,(colormode==false?true:false),clSDP5));
   SetIndexStyle(6,isOn&&b2BB1_enable?0:12,linemode1,1,getClr(99,0,(colormode==false?true:false),clSDM5));
   SetIndexStyle(5,isOn&&b2BB2_enable?0:12,linemode2,1,getClr(99,0,(colormode==false?true:false),clSDP5));
   SetIndexStyle(4,isOn&&b2BB2_enable?0:12,linemode2,1,getClr(99,0,(colormode==false?true:false),clSDM5));
   
   SetIndexStyle(3,isOn&&b2BBF_enable?0:12,linemode1,1,getClr(99,0,(colormode==false?true:false),clSDP5));
   SetIndexStyle(2,isOn&&b2BBF_enable?0:12,linemode1,1,getClr(99,0,(colormode==false?true:false),clSDM5));
   SetIndexStyle(1,isOn&&b2BBF_enable?0:12,linemode2,1,getClr(99,0,(colormode==false?true:false),clSDP5));
   SetIndexStyle(0,isOn&&b2BBF_enable?0:12,linemode2,1,getClr(99,0,(colormode==false?true:false),clSDM5));
   
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
color  getClr(int enumPer,int manPer,bool clrLight=true,color inpClr=clrNONE){
   return(inpClr==clrNONE||inpClr==2147483647?StringToColor(getPer(enumPer,manPer,2,clrLight)):inpClr);
}
string getPer(int enumPer,int manPer,int modeRes=0,bool mClr=true){
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
   string strPer="";
   int    mn=1,hr=60,dy=1440,wk=7200,mh=28800,yr=345600,intPer=0;
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
                  case  PERIOD_M1 : strPer=    "";  intPer= NULL;   clrPer=mClr?clrNONE:clrNONE;                break;/*TF Entry*/
                  case  PERIOD_M5 : strPer=    "";  intPer= NULL;   clrPer=mClr?clrNONE:clrNONE;                break;
                  case  PERIOD_M15: strPer=    "";  intPer= NULL;   clrPer=mClr?clrNONE:clrNONE;                break;
                  case  PERIOD_M30: strPer=    "";  intPer= NULL;   clrPer=mClr?clrNONE:clrNONE;                break;
                  case  PERIOD_H1 : strPer= "4Hr";  intPer= 4*hr;   clrPer=mClr?clrRoyalBlue:clrBlue;           break;
                  case  PERIOD_H4 : strPer= "8Hr";  intPer= 8*hr;   clrPer=mClr?clrGoldenrod:clrSienna;         break;
                  case  PERIOD_D1 : strPer= "1Dy";  intPer=   dy;   clrPer=mClr?clrLime:clrGreen;               break;
                  case  PERIOD_W1 : strPer= "1Wk";  intPer=   wk;   clrPer=mClr?clrMagenta:clrPurple;           break;
                  case  PERIOD_MN1: strPer= "1Mh";  intPer=   mh;   clrPer=mClr?clrAqua:clrDodgerBlue;          break;
               } break;
      case 96: switch(_Period){
                  case  PERIOD_M1 : strPer=    "";  intPer= NULL;   clrPer=mClr?clrNONE:clrNONE;                break;/*TFX Entry*/
                  case  PERIOD_M5 : strPer=    "";  intPer= NULL;   clrPer=mClr?clrNONE:clrNONE;                break;
                  case  PERIOD_M15: strPer= "1Hr";  intPer=   hr;   clrPer=mClr?clrRed:clrMaroon;               break;
                  case  PERIOD_M30: strPer= "4Hr";  intPer= 4*hr;   clrPer=mClr?clrRoyalBlue:clrBlue;           break;
                  case  PERIOD_H1 : strPer= "8Hr";  intPer= 8*hr;   clrPer=mClr?clrGoldenrod:clrSienna;         break;
                  case  PERIOD_H4 : strPer= "1Dy";  intPer=   dy;   clrPer=mClr?clrLime:clrGreen;               break;
                  case  PERIOD_D1 : strPer= "1Wk";  intPer=   wk;   clrPer=mClr?clrMagenta:clrPurple;           break;
                  case  PERIOD_W1 : strPer= "1Mh";  intPer=   mh;   clrPer=mClr?clrAqua:clrDodgerBlue;          break;
               } break;
      case 97: switch(_Period){
                  case  PERIOD_M1 : strPer= "1Hr";  intPer=   hr;   clrPer=mClr?clrRed:clrMaroon;               break;/*TF Active*/
                  case  PERIOD_M5 : strPer= "1Hr";  intPer=   hr;   clrPer=mClr?clrRed:clrMaroon;               break;
                  case  PERIOD_M15: strPer= "4Hr";  intPer= 4*hr;   clrPer=mClr?clrRoyalBlue:clrBlue;           break;
                  case  PERIOD_M30: strPer= "1Dy";  intPer=   dy;   clrPer=mClr?clrLime:clrGreen;               break;
                  case  PERIOD_H1 : strPer= "1Dy";  intPer=   dy;   clrPer=mClr?clrLime:clrGreen;               break;
                  case  PERIOD_H4 : strPer= "1Wk";  intPer=   wk;   clrPer=mClr?clrMagenta:clrPurple;           break;
                  case  PERIOD_D1 : strPer= "1Mh";  intPer=   mh;   clrPer=mClr?clrAqua:clrDodgerBlue;          break;
                  case  PERIOD_W1 : strPer= "1Mh";  intPer=   mh;   clrPer=mClr?clrAqua:clrDodgerBlue;          break;
                  case  PERIOD_MN1: strPer= "1Mh";  intPer=   mh;   clrPer=mClr?clrAqua:clrDodgerBlue;          break;
               } break;
      case 98: switch(_Period){
                  case  PERIOD_M1 : strPer= "4Hr";  intPer= 4*hr;   clrPer=mClr?clrRoyalBlue:clrBlue;           break;/*TFX*/
                  case  PERIOD_M5 : strPer= "8Hr";  intPer= 4*hr;   clrPer=mClr?clrRoyalBlue:clrBlue;           break;
                  case  PERIOD_M15: strPer= "8Hr";  intPer= 8*hr;   clrPer=mClr?clrGoldenrod:clrSienna;         break;
                  case  PERIOD_M30: strPer= "1Wk";  intPer=   wk;   clrPer=mClr?clrMagenta:clrPurple;           break;
                  case  PERIOD_H1 : strPer= "1Wk";  intPer=   wk;   clrPer=mClr?clrMagenta:clrPurple;           break;
                  case  PERIOD_H4 : strPer= "1Mh";  intPer=   mh;   clrPer=mClr?clrAqua:clrDodgerBlue;          break;
               } break;
      case 99: switch(_Period){
                  case  PERIOD_M1 : strPer= "8Hr";  intPer= 8*hr;   clrPer=mClr?clrGoldenrod:clrSienna;         break;/*TF Up*/
                  case  PERIOD_M5 : strPer= "8Hr";  intPer= 8*hr;   clrPer=mClr?clrGoldenrod:clrSienna;         break;
                  case  PERIOD_M15: strPer= "1Dy";  intPer=   dy;   clrPer=mClr?clrLime:clrGreen;               break;
                  case  PERIOD_M30: strPer= "1Mh";  intPer=   mh;   clrPer=mClr?clrAqua:clrDodgerBlue;          break;
                  case  PERIOD_H1 : strPer= "1Mh";  intPer=   mh;   clrPer=mClr?clrAqua:clrDodgerBlue;          break;
               } break;      
               
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
      case 101: switch(_Period){
                  case  PERIOD_M1 : strPer=    "";  intPer=   NULL;   clrPer=mClr?clrNONE:clrNONE;                break;/*TF Entry*/
                  case  PERIOD_M5 : strPer=    "";  intPer=   NULL;   clrPer=mClr?clrNONE:clrNONE;                break;
                  case  PERIOD_M15: strPer=    "";  intPer=   NULL;   clrPer=mClr?clrNONE:clrNONE;                break;
                  case  PERIOD_M30: strPer=    "";  intPer=   NULL;   clrPer=mClr?clrNONE:clrNONE;                break;
                  case  PERIOD_H1 : strPer= "4Hr";  intPer= 4*hr*2;   clrPer=mClr?clrRoyalBlue:clrBlue;           break;
                  case  PERIOD_H4 : strPer= "8Hr";  intPer= 8*hr*2;   clrPer=mClr?clrGoldenrod:clrSienna;         break;
                  case  PERIOD_D1 : strPer= "1Dy";  intPer=   dy*2;   clrPer=mClr?clrLime:clrGreen;               break;
                  case  PERIOD_W1 : strPer= "1Wk";  intPer=   wk*2;   clrPer=mClr?clrMagenta:clrPurple;           break;
                  case  PERIOD_MN1: strPer= "1Mh";  intPer=   mh*2;   clrPer=mClr?clrAqua:clrDodgerBlue;          break;
               } break;
      case 102: switch(_Period){
                  case  PERIOD_M1 : strPer=    "";  intPer=   NULL;   clrPer=mClr?clrNONE:clrNONE;                break;/*TFX Entry*/
                  case  PERIOD_M5 : strPer=    "";  intPer=   NULL;   clrPer=mClr?clrNONE:clrNONE;                break;
                  case  PERIOD_M15: strPer= "1Hr";  intPer=   hr*2;   clrPer=mClr?clrRed:clrMaroon;               break;
                  case  PERIOD_M30: strPer= "4Hr";  intPer= 4*hr*2;   clrPer=mClr?clrRoyalBlue:clrBlue;           break;
                  case  PERIOD_H1 : strPer= "8Hr";  intPer= 8*hr*2;   clrPer=mClr?clrGoldenrod:clrSienna;         break;
                  case  PERIOD_H4 : strPer= "1Dy";  intPer=   dy*2;   clrPer=mClr?clrLime:clrGreen;               break;
                  case  PERIOD_D1 : strPer= "1Wk";  intPer=   wk*2;   clrPer=mClr?clrMagenta:clrPurple;           break;
                  case  PERIOD_W1 : strPer= "1Mh";  intPer=   mh*2;   clrPer=mClr?clrAqua:clrDodgerBlue;          break;
               } break;
      case 103: switch(_Period){
                  case  PERIOD_M1 : strPer= "1Hr";  intPer=   hr*2;   clrPer=mClr?clrRed:clrMaroon;               break;/*TF Active*/
                  case  PERIOD_M5 : strPer= "1Hr";  intPer=   hr*2;   clrPer=mClr?clrRed:clrMaroon;               break;
                  case  PERIOD_M15: strPer= "4Hr";  intPer= 4*hr*2;   clrPer=mClr?clrRoyalBlue:clrBlue;           break;
                  case  PERIOD_M30: strPer= "1Dy";  intPer=   dy*2;   clrPer=mClr?clrLime:clrGreen;               break;
                  case  PERIOD_H1 : strPer= "1Dy";  intPer=   dy*2;   clrPer=mClr?clrLime:clrGreen;               break;
                  case  PERIOD_H4 : strPer= "1Wk";  intPer=   wk*2;   clrPer=mClr?clrMagenta:clrPurple;           break;
                  case  PERIOD_D1 : strPer= "1Mh";  intPer=   mh*2;   clrPer=mClr?clrAqua:clrDodgerBlue;          break;
                  case  PERIOD_W1 : strPer= "1Mh";  intPer=   mh*2;   clrPer=mClr?clrAqua:clrDodgerBlue;          break;
                  case  PERIOD_MN1: strPer= "1Mh";  intPer=   mh*2;   clrPer=mClr?clrAqua:clrDodgerBlue;          break;
               } break;
      case 104: switch(_Period){
                  case  PERIOD_M1 : strPer= "4Hr";  intPer= 4*hr*2;   clrPer=mClr?clrRoyalBlue:clrBlue;           break;/*TFX*/
                  case  PERIOD_M5 : strPer= "8Hr";  intPer= 4*hr*2;   clrPer=mClr?clrRoyalBlue:clrBlue;           break;
                  case  PERIOD_M15: strPer= "8Hr";  intPer= 8*hr*2;   clrPer=mClr?clrGoldenrod:clrSienna;         break;
                  case  PERIOD_M30: strPer= "1Wk";  intPer=   wk*2;   clrPer=mClr?clrMagenta:clrPurple;           break;
                  case  PERIOD_H1 : strPer= "1Wk";  intPer=   wk*2;   clrPer=mClr?clrMagenta:clrPurple;           break;
                  case  PERIOD_H4 : strPer= "1Mh";  intPer=   mh*2;   clrPer=mClr?clrAqua:clrDodgerBlue;          break;
               } break;
      case 105: switch(_Period){
                  case  PERIOD_M1 : strPer= "8Hr";  intPer= 8*hr*2;   clrPer=mClr?clrGoldenrod:clrSienna;         break;/*TF Up*/
                  case  PERIOD_M5 : strPer= "8Hr";  intPer= 8*hr*2;   clrPer=mClr?clrGoldenrod:clrSienna;         break;
                  case  PERIOD_M15: strPer= "1Dy";  intPer=   dy*2;   clrPer=mClr?clrLime:clrGreen;               break;
                  case  PERIOD_M30: strPer= "1Mh";  intPer=   mh*2;   clrPer=mClr?clrAqua:clrDodgerBlue;          break;
                  case  PERIOD_H1 : strPer= "1Mh";  intPer=   mh*2;   clrPer=mClr?clrAqua:clrDodgerBlue;          break;
               } break;      
                 
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------                
      
      case 125: switch(_Period){
                  case  PERIOD_M1 : strPer=    "";  intPer=EMPTY_VALUE; clrPer=mClr?clrNONE:clrNONE;            break;/*TF Entry*/
                  case  PERIOD_M5 : strPer= "30M";  intPer=   30;   clrPer=mClr?C'173,255,047':C'073,155,000';  break;
                  case  PERIOD_M15: strPer= "1Hr";  intPer=   hr;   clrPer=mClr?C'238,130,238':C'255,000,255';  break;
                  case  PERIOD_M30: strPer= "4Hr";  intPer= 4*hr;   clrPer=mClr?C'000,255,255':C'000,155,255';  break;
                  case  PERIOD_H1 : strPer= "8Hr";  intPer= 8*hr;   clrPer=mClr?C'255,255,000':C'100,100,000';  break;
                  case  PERIOD_H4 : strPer= "1Dy";  intPer=   dy;   clrPer=mClr?C'000,255,000':C'000,100,000';  break;
                  case  PERIOD_D1 : strPer= "1Wk";  intPer=   wk;   clrPer=mClr?C'255,000,255':C'120,000,120';  break;
                  case  PERIOD_W1 : strPer= "1Mh";  intPer=   mh;   clrPer=mClr?C'000,255,255':C'000,120,120';  break;
                  case  PERIOD_MN1: strPer= "4Mh";  intPer= 4*mh;   clrPer=mClr?C'255,069,000':C'132,036,000';  break;
               } break;
      case 126: switch(_Period){ 
                  case  PERIOD_M1 : strPer= "30M";  intPer=   30;   clrPer=mClr?C'173,255,047':C'073,155,000';  break;/*TFX Entry*/
                  case  PERIOD_M5 : strPer= "1Hr";  intPer=   hr;   clrPer=mClr?C'238,130,238':C'255,000,255';  break;
                  case  PERIOD_M15: strPer= "4Hr";  intPer= 4*hr;   clrPer=mClr?C'000,255,255':C'000,155,255';  break;
                  case  PERIOD_M30: strPer= "8Hr";  intPer= 8*hr;   clrPer=mClr?C'255,255,000':C'100,100,000';  break;
                  case  PERIOD_H1 : strPer= "1Dy";  intPer=   dy;   clrPer=mClr?C'000,255,000':C'000,100,000';  break;
                  case  PERIOD_H4 : strPer= "1Wk";  intPer=   wk;   clrPer=mClr?C'255,000,255':C'120,000,120';  break;
                  case  PERIOD_D1 : strPer= "1Mh";  intPer=   mh;   clrPer=mClr?C'000,255,255':C'000,120,120';  break;
                  case  PERIOD_W1 : strPer= "4Mh";  intPer= 4*mh;   clrPer=mClr?C'255,069,000':C'132,036,000';  break;
                  case  PERIOD_MN1: strPer= "1Yr";  intPer=   yr;   clrPer=mClr?C'255,250,250':C'192,192,192';  break;
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