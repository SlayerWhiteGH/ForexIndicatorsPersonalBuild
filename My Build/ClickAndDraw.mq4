//+------------------------------------------------------------------+
//|                                              mn ClickAndDraw.mq4 |
//+------------------------------------------------------------------+
#property copyright "WHITE"
#property strict
#property indicator_chart_window

enum KEYS_ON_KEYBOARD {
  _A/*A*/,  _B/*B*/,  _C/*C*/,  _D/*D*/,  _E/*E*/,
  _F/*F*/,  _G/*G*/,  _H/*H*/,  _I/*I*/,  _J/*J*/,
  _K/*K*/,  _L/*L*/,  _M/*M*/,  _N/*N*/,  _O/*O*/,
  _P/*P*/,  _Q/*Q*/,  _R/*R*/,  _S/*S*/,  _T/*T*/,
  _U/*U*/,  _V/*V*/,  _W/*W*/,  _X/*X*/,  _Y/*Y*/,  _Z/*Z*/
};

input KEYS_ON_KEYBOARD TrendlineKey = _Q;
input KEYS_ON_KEYBOARD RectangleKey = _W;

extern int   mWid = 1;
extern color mCol = clrRed;
extern bool  mDeleteOnExit = false;

int mCnt = 0;
datetime mTime = 0, mTime2 = 0;
double mPrice = 0, mPrice2 = 0;

bool mDrawTrendline = false;
bool mDrawRectangle = false;

//+------------------------------------------------------------------+
int init()
  {
   
   return(0);
  }

//+------------------------------------------------------------------+
int deinit()
 {
  string mObj;
  if(mDeleteOnExit)
    {
     for(int i = ObjectsTotal() - 1; i >= 0; i--)
      {
        mObj = ObjectName(i);
        if(StringSubstr(mObj, 0, 2) == "m.")
          ObjectDelete(mObj);
      }
    }
    
    return(0);
 }

//+------------------------------------------------------------------+
int start()
 {

   return(0);
 }
 
//+------------------------------------------------------------------+
void OnChartEvent(const int id,         // Event ID 
                  const long& lparam,   // Parameter of type long event 
                  const double& dparam, // Parameter of type double event 
                  const string& sparam)  // Parameter of type string events 
  {
    if (id == CHARTEVENT_KEYDOWN) {
      int trendlineKey = TrendlineKey == _A ? 65
                      : TrendlineKey == _B ? 66
                      : TrendlineKey == _C ? 67
                      : TrendlineKey == _D ? 68
                      : TrendlineKey == _E ? 69
                      : TrendlineKey == _F ? 70
                      : TrendlineKey == _G ? 71
                      : TrendlineKey == _H ? 72
                      : TrendlineKey == _I ? 73
                      : TrendlineKey == _J ? 74
                      : TrendlineKey == _K ? 75
                      : TrendlineKey == _L ? 76
                      : TrendlineKey == _M ? 77
                      : TrendlineKey == _N ? 78
                      : TrendlineKey == _O ? 79
                      : TrendlineKey == _P ? 80
                      : TrendlineKey == _Q ? 81
                      : TrendlineKey == _R ? 82
                      : TrendlineKey == _S ? 83
                      : TrendlineKey == _T ? 84
                      : TrendlineKey == _U ? 85
                      : TrendlineKey == _V ? 86
                      : TrendlineKey == _W ? 87
                      : TrendlineKey == _X ? 88
                      : TrendlineKey == _Y ? 89
                      : 90;

      int rectangleKey = RectangleKey == _A ? 65
                        : RectangleKey == _B ? 66
                        : RectangleKey == _C ? 67
                        : RectangleKey == _D ? 68
                        : RectangleKey == _E ? 69
                        : RectangleKey == _F ? 70
                        : RectangleKey == _G ? 71
                        : RectangleKey == _H ? 72
                        : RectangleKey == _I ? 73
                        : RectangleKey == _J ? 74
                        : RectangleKey == _K ? 75
                        : RectangleKey == _L ? 76
                        : RectangleKey == _M ? 77
                        : RectangleKey == _N ? 78
                        : RectangleKey == _O ? 79
                        : RectangleKey == _P ? 80
                        : RectangleKey == _Q ? 81
                        : RectangleKey == _R ? 82
                        : RectangleKey == _S ? 83
                        : RectangleKey == _T ? 84
                        : RectangleKey == _U ? 85
                        : RectangleKey == _V ? 86
                        : RectangleKey == _W ? 87
                        : RectangleKey == _X ? 88
                        : RectangleKey == _Y ? 89
                        : 90;
      
      if (lparam == trendlineKey) {
        mDrawTrendline = !mDrawTrendline;
        if (mDrawRectangle) mDrawRectangle = false;

      }

      if (lparam == rectangleKey) {
        mDrawRectangle = !mDrawRectangle;
        if (mDrawTrendline) mDrawTrendline = false;

      }
    }
    
    if(id == CHARTEVENT_CLICK && (mDrawTrendline || mDrawRectangle))
      {
      long mX = lparam;
      double mP = dparam;
      int win = 0;
      if(mCnt == 0)
        {
          ChartXYToTimePrice(0, mX, mP, win, mTime, mPrice);
          mCnt++;
        }
      else
        {
          ChartXYToTimePrice(0, mX, mP, win, mTime2, mPrice2);
          mCnt = 0;
        }

      if(mPrice > 0 && mPrice2 > 0)
        {
          if(mDrawTrendline) 
            {
              ObjectCreate("m.Data"+IntegerToString(TimeLocal()), OBJ_TREND, 0, mTime, mPrice, mTime2, mPrice2);
              ObjectSet("m.Data"+IntegerToString(TimeLocal()), OBJPROP_COLOR, mCol);
              ObjectSet("m.Data"+IntegerToString(TimeLocal()), OBJPROP_WIDTH, mWid);
              ObjectSet("m.Data"+IntegerToString(TimeLocal()), OBJPROP_RAY, false);
            }
          if(mDrawRectangle) 
            {
              ObjectCreate("m.DataR"+IntegerToString(TimeLocal()), OBJ_RECTANGLE, 0, mTime, mPrice, mTime2, mPrice2);
              ObjectSet("m.DataR"+IntegerToString(TimeLocal()), OBJPROP_COLOR, mCol);
              ObjectSet("m.DataR"+IntegerToString(TimeLocal()), OBJPROP_BACK, true);
            }
          
          mPrice = 0; mPrice2 = 0;
        }
    }
  else if (id == CHARTEVENT_CLICK && !mDrawRectangle && !mDrawTrendline) {
    mPrice = 0;
    mPrice2 = 0;
  }

     
  return;
  } 
  
