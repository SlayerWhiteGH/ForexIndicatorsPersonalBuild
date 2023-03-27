//+==================================================================+
//|                                              !@ dKG_SMA BySu.mq4 |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                   http://ammeu-lord.blogspot.com |
//+==================================================================+
#property copyright "Copyright 2015, KGForexWorld.com"
#property link      "http://ammeu-lord.blogspot.com"

#property indicator_chart_window
#property indicator_buffers 12
#define Nama_Indi "KGMA_ALL_PERIOD"

extern bool    Indicator_On      = True;
extern int     Candle_Bars       = 225;
extern string  _                 = " === Set Buffer === ";
extern bool    Show_Line         = True;
extern int     SMA_Widht         = 2;
extern string  __                = " === Set Color ==== ";
extern color   MA_UpClr_1H       = 0,
               MA_DnClr_1H       = 0,
               MA_UpClr_4H       = 0,
               MA_DnClr_4H       = 0,
               MA_UpClr_8H       = 0,
               MA_DnClr_8H       = 0,
               MA_UpClr_1D       = 0,
               MA_DnClr_1D       = 0,
               MA_UpClr_1W       = 0,
               MA_DnClr_1W       = 0,
               MA_UpClr_MH       = 0,
               MA_DnClr_MH       = 0;
extern string  ___               = " === Set Trend Info ==== ";
extern bool    Show_Info         = True;
extern int     Pojok_Teks        = 1,
               XDistance         = 0,
               YDistance         = 0;
extern color   StrongUp_Color    = Lime,
               WeakUp_Color      = Green,
               StrongDn_Color    = Red,
               WeakDn_Color      = C'180,000,000',
               Sideway_Color     = Silver;
extern string  ____              = " === Set Deviation Line ==== ";
extern int     ExtLine_Dist      = 1,
               ExtLine_Long      = 0,
               Price_ID_Dist     = 0;
extern bool    Show_All_Id       = False,
               Show_All_Price    = False,
               Show_All_ExtLine  = False;
               

int		CBar;
double   MAU_1H[], MAU_4H[], MAU_8H[], MAU_1D[], MAU_1W[], MAU_MH[],
         MAD_1H[], MAD_4H[], MAD_8H[], MAD_1D[], MAD_1W[], MAD_MH[];
//+==================================================================+
//| Custom indicator initialization function                         |
//+==================================================================+
int init(){
   gDEC();
   if(GlobalVariableCheck("CBar")) CBar = GlobalVariableGet("CBar");
	else	                                 GlobalVariableSet("CBar",0);
	
	SetIndexBuffer(0, MAU_MH); SetIndexBuffer(1, MAD_MH);
	SetIndexBuffer(2, MAU_1W); SetIndexBuffer(3, MAD_1W);
	SetIndexBuffer(4, MAU_1D); SetIndexBuffer(5, MAD_1D);
	SetIndexBuffer(6, MAU_8H); SetIndexBuffer(7, MAD_8H);
	SetIndexBuffer(8, MAU_4H); SetIndexBuffer(9, MAD_4H);
	SetIndexBuffer(10,MAU_1H); SetIndexBuffer(11,MAD_1H);
	
   return(0);
}
//+==================================================================+
//| Custom indicator deinitialization function                       |
//+==================================================================+
int deinit(){
   int obj_total=ObjectsTotal();
	for(int i=obj_total; i>=0; i--){
		string name	= ObjectName(i);
		if(StringFind(name, Nama_Indi, 0) != -1)
			ObjectDelete(name);
	}
   return(0);
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
int L(bool Option){
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   if(Option && Show_Line) return(0);
   else                    return(12);
}
//+==================================================================+
//| Custom indicator iteration function                              |
//+==================================================================+
int start(){
   MARK();
   if(!Indicator_On) return(0); 
   
   SetIndexStyle(0, L(LimitTF("1MH")),0,SMA_Widht,sCLR(0,"1MH",MA_UpClr_MH));//SMA_MH);
	SetIndexStyle(1, L(LimitTF("1MH")),0,SMA_Widht,sCLR(1,"1MH",MA_DnClr_MH));//SMA_MH);
	SetIndexStyle(2, L(LimitTF("1W")), 0,SMA_Widht,sCLR(0,"1W", MA_UpClr_1W));//SMA_1W);
	SetIndexStyle(3, L(LimitTF("1W")), 0,SMA_Widht,sCLR(1,"1W", MA_DnClr_1W));//SMA_1W);
	SetIndexStyle(4, L(LimitTF("1D")), 0,SMA_Widht,sCLR(0,"1D", MA_UpClr_1D));//SMA_1D);
	SetIndexStyle(5, L(LimitTF("1D")), 0,SMA_Widht,sCLR(1,"1D", MA_DnClr_1D));//SMA_1D);
	SetIndexStyle(6, L(LimitTF("8H")), 0,SMA_Widht,sCLR(0,"8H", MA_UpClr_8H));//SMA_8H);
	SetIndexStyle(7, L(LimitTF("8H")), 0,SMA_Widht,sCLR(1,"8H", MA_DnClr_8H));//SMA_8H);
	SetIndexStyle(8, L(LimitTF("4H")), 0,SMA_Widht,sCLR(0,"4H", MA_UpClr_4H));//SMA_4H);
	SetIndexStyle(9, L(LimitTF("4H")), 0,SMA_Widht,sCLR(1,"4H", MA_DnClr_4H));//SMA_4H);
	SetIndexStyle(10,L(LimitTF("1H")), 0,SMA_Widht,sCLR(0,"1H", MA_UpClr_1H));//SMA_1H);
   SetIndexStyle(11,L(LimitTF("1H")), 0,SMA_Widht,sCLR(1,"1H", MA_DnClr_1H));//SMA_1H);
   
   int counted_bars=IndicatorCounted();
   if(counted_bars < 0) return(-1);
   if(counted_bars > 0) counted_bars--;
     
   int limit = Bars - counted_bars;
   if((CBar != 0) && (limit >= CBar)) limit = CBar;
   if(Candle_Bars != 0) limit = Candle_Bars;
   else limit = Bars-1440;
   for(int i=limit; i>=0; i--){
      MAU_1H[i] = iMA(NULL,0,CalcPer("1H"),0,MODE_SMA,PRICE_CLOSE,i);
      MAU_4H[i] = iMA(NULL,0,CalcPer("4H"),0,MODE_SMA,PRICE_CLOSE,i);
      MAU_8H[i] = iMA(NULL,0,CalcPer("8H"),0,MODE_SMA,PRICE_CLOSE,i);
      MAU_1D[i] = iMA(NULL,0,CalcPer("1D"),0,MODE_SMA,PRICE_CLOSE,i);
      MAU_1W[i] = iMA(NULL,0,CalcPer("1W"),0,MODE_SMA,PRICE_CLOSE,i);
      MAU_MH[i] = iMA(NULL,0,CalcPer("1MH"),0,MODE_SMA,PRICE_CLOSE,i);
      
      MAD_1H[i] = SetNRP(MAU_1H,i);
      MAD_4H[i] = SetNRP(MAU_4H,i);
      MAD_8H[i] = SetNRP(MAU_8H,i);
      MAD_1D[i] = SetNRP(MAU_1D,i);
      MAD_1W[i] = SetNRP(MAU_1W,i);
      MAD_MH[i] = SetNRP(MAU_MH,i);
            
      //Set_TL(LimitTF("1H") && SetNRP(MAU_1H[i],MAU_1H[i+1]),"SMA 1H", "SMA","1H", sCLR(1,"1H",MA_DnClr_4H), SMA_Widht,0,i);
      //Set_TL(LimitTF("4H") && SetNRP(MAU_4H[i],MAU_4H[i+1]),"SMA 4H", "SMA","4H", sCLR(1,"4H",MA_DnClr_4H), SMA_Widht,0,i);
      //Set_TL(LimitTF("8H") && SetNRP(MAU_8H[i],MAU_8H[i+1]),"SMA 8H", "SMA","8H", sCLR(1,"8H",MA_DnClr_8H), SMA_Widht,0,i);
      //Set_TL(LimitTF("1D") && SetNRP(MAU_1D[i],MAU_1D[i+1]),"SMA 1D", "SMA","1D", sCLR(1,"1D",MA_DnClr_1D), SMA_Widht,0,i);
      //Set_TL(LimitTF("1W") && SetNRP(MAU_1W[i],MAU_1W[i+1]),"SMA 1W", "SMA","1W", sCLR(1,"1W",MA_DnClr_1W), SMA_Widht,0,i);
      //Set_TL(LimitTF("1MH")&& SetNRP(MAU_MH[i],MAU_MH[i+1]),"SMA 1MH","SMA","1MH",sCLR(1,"1MH",MA_UpClr_MH),SMA_Widht,0,i);
   }
   for(int l=1; l<=3; l++){
      int x1=4,ix=4;
      if(Show_All_Price) ix=14;
      SET_LABEL(Show_All_Id,Show_All_Price,Show_All_ExtLine,"18H SD"+l,"8H", l,sCLR(0,"8H",MA_UpClr_8H), 0,4);
      x1 = x1+ix;
      SET_LABEL(Show_All_Id,Show_All_Price,Show_All_ExtLine,"1DY SD"+l,"1D", l,sCLR(0,"1D",MA_UpClr_1D), 0,x1);
      x1 = x1+ix;
      SET_LABEL(Show_All_Id,Show_All_Price,Show_All_ExtLine,"1WK SD"+l,"1W", l,sCLR(0,"1W",MA_UpClr_1W), 0,x1);
      x1 = x1+ix;
      SET_LABEL(Show_All_Id,Show_All_Price,Show_All_ExtLine,"1MH SD"+l,"1MH",l,sCLR(0,"1MH",MA_UpClr_MH),0,x1);
   }
   double y=20, x2=8.0*StringLen("NK[Jual]");
   //
   x1=5;
   if(Pojok_Teks==2 || Pojok_Teks==4){x1=9*StringLen("1Mh-1Wk"); x2=5;}
   SearchTrend(MAU_1W[0],MAU_MH[0]);
   SetText(LimitTF("1W"),"Trend_MHvs1W",sTrend,x1,y,cTrend);
   SetText(LimitTF("1W"),"Tf_MHvs1W","MH-1W",x2,y,sCLR(0,"1MH",MA_UpClr_MH));
   y+=15;
   //
   SearchTrend(MAU_1D[0],MAU_1W[0]);
   SetText(LimitTF("1D"),"Trend_1Wvs1D",sTrend,x1,y,cTrend);
   SetText(LimitTF("1D"),"Tf_1Wvs1D","1W-1D",x2,y,sCLR(0,"1W",MA_UpClr_1W));
   y+=20;
   //
   SearchTrend(MAU_4H[0],MAU_8H[0]);
   SetText(LimitTF("4H"),"Trend_8Hvs4H",sTrend,x1,y,cTrend);
   SetText(LimitTF("4H"),"Tf_8Hs4H","8H-4H",x2,y,sCLR(0,"8H",MA_UpClr_8H));
   y+=15;
   //
   SearchTrend(MAU_1H[0],MAU_4H[0]);
   SetText(LimitTF("1H"),"Trend_4Hvs1H",sTrend,x1,y,cTrend);
   SetText(LimitTF("1H"),"Tf_4Hs1H","4H-1H",x2,y,sCLR(0,"4H",MA_UpClr_4H));
   
   return(0);
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
string Str2UC(string Txt) {
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   string Result=Txt;   
   for (int j=StringLen(Txt)-1; j>=0; j--) {
      int i = StringGetChar(Result,j);
      if ((i>'`' && i<'{') || (i >'ß' && i<256)){Result=StringSetChar(Result,j,i-32);}
      else{if (i>-33 && i<0) Result=StringSetChar(Result,j,i+224);}
   }
   return(Result);
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
int CalcPer(string Per){
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   int per;
   Per = Str2UC(Per);
   
        if(Per=="4Y" ) {per=MathCeil(4*345600/Period());}
   else if(Per=="1Y" ) {per=MathCeil(345600/Period());  } 
   else if(Per=="4MH") {per=MathCeil(4*28800/Period()); } 
   else if(Per=="1MH") {per=MathCeil(28800/Period());   } 
   else if(Per=="1W" ) {per=MathCeil(7200/Period());    } 
   else if(Per=="1D" ) {per=MathCeil(1440/Period());    } 
   else if(Per=="16H") {per=MathCeil(960/Period());     } 
   else if(Per=="12H") {per=MathCeil(720/Period());     } 
   else if(Per=="8H" ) {per=MathCeil(480/Period());     } 
   else if(Per=="6H" ) {per=MathCeil((60*6)/Period());  } 
   else if(Per=="4H" ) {per=MathCeil(240/Period());     } 
   else if(Per=="3H" ) {per=MathCeil((60*3)/Period());  } 
   else if(Per=="1H" ) {per=MathCeil((60)/Period());  }
	else {
      if (StrToInteger (Per)>0) per=StrToInteger(Per);
      else                      return(0);
   }
   
   return(per);
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
bool LimitTF(string Per){
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   int MinTF, MaxTF;
   
        if(Per=="1MH") {MinTF=PERIOD_M1; MaxTF=PERIOD_D1; }
   else if(Per=="1W")  {MinTF=PERIOD_M1; MaxTF=PERIOD_D1; }
   else if(Per=="1D")  {MinTF=PERIOD_M1; MaxTF=PERIOD_H4; }
   else if(Per=="8H")  {MinTF=PERIOD_M1; MaxTF=PERIOD_H4; }
   else if(Per=="4H")  {MinTF=PERIOD_M1; MaxTF=PERIOD_H1; }
   else if(Per=="1H")  {MinTF=PERIOD_M1; MaxTF=PERIOD_M30;}
   else                {MinTF=PERIOD_M1; MaxTF=PERIOD_MN1;}
   
   if(Per!="" && (Period()<MinTF  || Period()> MaxTF)) return(False);
   if(Per!="" && (Period()>=MinTF || Period()<=MaxTF)) return(True);
                                                       return(0);
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
color sCLR(int Mode, string Per, color Clr){
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   Per = Str2UC(Per);
   color cMA=0,cBB=0;
   if(Clr==0){
           if(Per=="1MH") {cMA=Aqua;      cBB=DodgerBlue;}
      else if(Per=="1W" ) {cMA=Magenta;   cBB=Purple;}
      else if(Per=="1D" ) {cMA=Lime;      cBB=Green;}
      else if(Per=="8H" ) {cMA=Goldenrod; cBB=Sienna;}
      else if(Per=="4H" ) {cMA=RoyalBlue; cBB=Blue;}
      else if(Per=="1H" ) {cMA=Red;       cBB=Maroon;}
      else{
         if(StrToInteger(Per)> 0) cMA=C'194,130,010';
	      else                     return(0); 
      }
   }
   else return(Clr);
   
        if(Mode==0) return(cMA);
   else if(Mode==1) return(cBB);
                    return(0);
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
double GetBuffer(string Mode, int Per, int SD, int Shift=0){
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   double MA = iMA(NULL,0,Per,0,MODE_SMA,PRICE_CLOSE,Shift),
          DP = iBands(NULL,0,Per,SD,0,PRICE_CLOSE,MODE_UPPER,Shift),
          DM = iBands(NULL,0,Per,SD,0,PRICE_CLOSE,MODE_LOWER,Shift),
          MS = iMA(NULL,0,1,0,MODE_SMA,PRICE_CLOSE,Shift+Per);
   
   if(Mode=="SMA") return(MA); else
   if(Mode=="SDP") return(DP); else
   if(Mode=="SDM") return(DM); else
   if(Mode=="MAS") return(MS);
                   return(0);
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
double SetDev(int Per, int SD, int Shift=0){
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   if(GetBuffer("SMA",Per,Shift)>GetBuffer("MAS",Per,Shift)) return(GetBuffer("SDP",Per,SD,Shift)); else
   if(GetBuffer("SMA",Per,Shift)<GetBuffer("MAS",Per,Shift)) return(GetBuffer("SDM",Per,SD,Shift));
                                                             return(0);  
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
double SetNRP(double &Val[], int Shift){
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   if(Val[Shift]<Val[Shift+1]) return(Val[Shift]);
   else                        return(EMPTY_VALUE);      
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
string sTrend;
color  cTrend;
void SearchTrend(double Val1, double Val2){
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   if(Val1>Val2 && Close[0]>Val1){sTrend="NK [Beli]";   cTrend=StrongUp_Color; } else
   if(Val1>Val2 && Close[0]<Val1){sTrend="NL [Jual]";  cTrend=WeakDn_Color; } else
   if(Val1<Val2 && Close[0]<Val1){sTrend="TK [Jual]";  cTrend=StrongDn_Color; } else
   if(Val1<Val2 && Close[0]>Val1){sTrend="TL [Beli]"; cTrend=WeakUp_Color; }
   else                          {sTrend="SW [Wait]";     cTrend=Sideway_Color;}
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
void SetText(bool Option, string Nama, string Text, int Xd, int Yd, color Clr, int Width=8, string Font="Verdana"){
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	if(Option && Show_Info && ObjectFind(Nama_Indi+Nama)==-1)
		ObjectCreate(Nama_Indi+Nama,OBJ_LABEL,0,0,0);
   ObjectSetText(Nama_Indi+Nama,Text,Width,Font,Clr);
	ObjectSet(Nama_Indi+Nama,OBJPROP_CORNER,Pojok_Teks);
	ObjectSet(Nama_Indi+Nama,OBJPROP_XDISTANCE,XDistance+Xd);
	ObjectSet(Nama_Indi+Nama,OBJPROP_YDISTANCE,YDistance+Yd);
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
void SET_LABEL(bool Option1, bool Option2, bool Option3, string Nm, string Per, int SD, color Clr, int Style=2, int x=0, bool Back=FALSE){
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   string Txt;
   double Prc, iSDP = GetBuffer("SDP",CalcPer(Per),SD,0), iSDM = GetBuffer("SDM",CalcPer(Per),SD,0);
          
        if(GetBuffer("SMA",CalcPer(Per),1,0)>GetBuffer("MAS",CalcPer(Per),1,0)) {Txt="  +"+SD; Prc=iSDP;}
   else if(GetBuffer("SMA",CalcPer(Per),1,0)<GetBuffer("MAS",CalcPer(Per),1,0)) {Txt="  -"+SD; Prc=iSDM;}
   
   datetime 
      oTm = Time[0]+(Period()*60*(ExtLine_Dist+x)),
      cTm = Time[0]+(Period()*60*(ExtLine_Dist+ExtLine_Long+2+x)),
      tTm = Time[0]+(Period()*60*(ExtLine_Dist+ExtLine_Long+Price_ID_Dist+x));
   
   if(Option2 && Show_All_Price && LimitTF(Per) && ObjectFind(Nama_Indi+"/"+Nm+" Id:")==-1)
      ObjectCreate(Nama_Indi+"/"+Nm+" Id:",OBJ_ARROW,0,0,0);
   ObjectSet(Nama_Indi+"/"+Nm+" Id:",OBJPROP_TIME1,tTm);
	ObjectSet(Nama_Indi+"/"+Nm+" Id:",OBJPROP_PRICE1,Prc);
   ObjectSet(Nama_Indi+"/"+Nm+" Id:",OBJPROP_COLOR,Clr);
	ObjectSet(Nama_Indi+"/"+Nm+" Id:",OBJPROP_ARROWCODE,SYMBOL_RIGHTPRICE);
   
   if(Option1 && Show_All_Id && LimitTF(Per) && ObjectFind(Nama_Indi+"/"+Nm+" Price:")==-1)
	     ObjectCreate(Nama_Indi+"/"+Nm+" Prc:",OBJ_TEXT,0,0,0);
   ObjectSet(Nama_Indi+"/"+Nm+" Prc:",OBJPROP_TIME1,tTm);
	ObjectSet(Nama_Indi+"/"+Nm+" Prc:",OBJPROP_PRICE1,Prc);
   ObjectSetText(Nama_Indi+"/"+Nm+" Prc:",Txt,6,"Verdana",Clr);
  
   Nm = StringConcatenate(Nama_Indi+"/"+Nm+" ExtLine:");
   if(Option3 && Show_All_ExtLine && LimitTF(Per) && ObjectFind(Nm)==-1)
      ObjectCreate(Nm,OBJ_TREND,0,0,0,0,0);
   ObjectSet(Nm,OBJPROP_TIME1,oTm);
   ObjectSet(Nm,OBJPROP_PRICE1,Prc);
   ObjectSet(Nm,OBJPROP_TIME2,cTm);
   ObjectSet(Nm,OBJPROP_PRICE2,Prc);
   ObjectSet(Nm,OBJPROP_STYLE,Style);
	ObjectSet(Nm,OBJPROP_WIDTH,1);
	ObjectSet(Nm,OBJPROP_COLOR,Clr);
	ObjectSet(Nm,OBJPROP_RAY,false);
	ObjectSet(Nm,OBJPROP_BACK,Back);
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
void Set_TL(bool Option, string Nm, string Type, string Per, color Clr, int Widht, int Style, int Shift){
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   double   ValNow = GetBuffer(Type,CalcPer(Per),1,Shift),
            ValAft = GetBuffer(Type,CalcPer(Per),1,Shift+1);
   datetime oTm    = Time[Shift],
            cTm    = Time[Shift+1];
   
   Nm = Nama_Indi+"/Line/"+Nm+"-"+Shift;
   if(Option && LimitTF(Per) && ObjectFind(Nm)==-1)
      ObjectCreate(Nm,OBJ_TREND,0,0,0,0,0);
   ObjectSet(Nm,OBJPROP_TIME1,oTm);
   ObjectSet(Nm,OBJPROP_PRICE1,ValNow);
   ObjectSet(Nm,OBJPROP_TIME2,cTm);
   ObjectSet(Nm,OBJPROP_PRICE2,ValAft);
   ObjectSet(Nm,OBJPROP_STYLE,Style);
	ObjectSet(Nm,OBJPROP_WIDTH,Widht);
	ObjectSet(Nm,OBJPROP_COLOR,Clr);
	ObjectSet(Nm,OBJPROP_RAY,false);
	ObjectSet(Nm,OBJPROP_BACK,False);
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
int gDEC(){
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   string charl[256]; int itm;
   for (itm = 0; itm < 256; itm++) charl[itm] = CharToStr(itm);
   int TradeMark=StrToInteger(charl[67]+charl[111]+charl[112]+charl[121]+
      charl[32]+charl[82]+charl[105]+charl[103]+charl[104]+charl[116]+charl[32]+
      charl[169]+charl[32]+charl[75]+charl[97]+charl[122]+charl[97]+charl[111]+
      charl[111]+charl[32]+charl[50]+charl[48]+charl[49]+charl[49]+charl[32]);
   return(TradeMark);
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
void MARK(){
   ObjectCreate("AML", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("AML", "[", 12, "Wingdings", DarkSlateGray);
   ObjectSet("AML", OBJPROP_CORNER, 3);
   ObjectSet("AML", OBJPROP_XDISTANCE, 3);
	ObjectSet("AML", OBJPROP_YDISTANCE, 3);
}