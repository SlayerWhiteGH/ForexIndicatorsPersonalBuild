//+------------------------------------------------------------------+
//|                                       Asian Session Level SD.mq4 |
//|                                                   Copyright 2023 |
//|                                                        W H I T E |
//+------------------------------------------------------------------+

#property copyright "Copyright 2023, W H I T E"
#property link      "W H I T E"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_plots   1

extern int HourTime        = 5;        //Hour Time
extern int MinuteTime      = 0;        //Minute Time
input color ColorLine      = clrSilver;  //Clr Line

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
int OnInit()
{
    return(INIT_SUCCEEDED);
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
    datetime last_bar_time = Time[rates_total-1];
    datetime current_time = TimeCurrent();
    
    // Check if the timeframe is valid
    bool is_valid_timeframe = false;
    ENUM_TIMEFRAMES timeframe = Period();
    switch(timeframe)
    {
        case PERIOD_M1:
        case PERIOD_M5:
        case PERIOD_M15:
        case PERIOD_M30:
            is_valid_timeframe = true;
            break;
        default:
            is_valid_timeframe = false;
            break;
    }
   //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    if (!is_valid_timeframe) {
        // Remove all objects if the timeframe is not valid
        for(int i = 0; i < ObjectsTotal(); i++) {
            string objName = ObjectName(i);
            if (StringFind(objName, "Separator ") == 0) {
                ObjectDelete(objName);
            }
        }
        return(rates_total);
    }
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    // jika waktu sekarang lebih dari jam HourTime, tambahkan 1 hari untuk membuat garis vertikal pada hari berikutnya
    if (TimeHour(current_time) >= HourTime && TimeMinute(current_time) >= MinuteTime) {
        last_bar_time = TimeCurrent() + PeriodSeconds() - TimeSeconds(current_time);
    }
    
    for (int i = 0; i < rates_total; i++) {
        if (TimeHour(time[i]) == HourTime && TimeMinute(time[i]) == MinuteTime) {
            ObjectCreate("Separator " + TimeToString(time[i], TIME_DATE|TIME_MINUTES), OBJ_VLINE, 0, time[i], 0);
            ObjectSet("Separator " + TimeToString(time[i], TIME_DATE|TIME_MINUTES), OBJPROP_COLOR, ColorLine);
            ObjectSet("Separator " + TimeToString(time[i], TIME_DATE|TIME_MINUTES), OBJPROP_WIDTH, 1);
            ObjectSet("Separator " + TimeToString(time[i], TIME_DATE|TIME_MINUTES), OBJPROP_STYLE, STYLE_DOT); 
            ObjectSet("Separator " + TimeToString(time[i], TIME_DATE|TIME_MINUTES), OBJPROP_SELECTABLE, FALSE);
            ObjectSet("Separator " + TimeToString(time[i], TIME_DATE|TIME_MINUTES), OBJPROP_HIDDEN, TRUE);
            ObjectSet("Separator " + TimeToString(time[i], TIME_DATE|TIME_MINUTES), OBJPROP_BACK, TRUE);
        }
    }
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
    // Buat objek garis vertikal pada setiap jam 8.30 malam setiap hari
    datetime startTime = D'20:30:00';
    datetime curTime = TimeLocal();
    datetime lineTime = TimeGMT() + startTime - curTime;
    int lineHandle = ObjectCreate("8.30 AM", OBJ_VLINE, 0, lineTime, 0);

        if (lineHandle == INVALID_HANDLE)
        {
            Print("Gagal membuat objek garis vertikal!");
            return INIT_FAILED;
        }

        ObjectSet("8.30 AM", OBJPROP_COLOR, clrLime);
        ObjectSet("8.30 AM", OBJPROP_WIDTH, 1);
        ObjectSet("8.30 AM", OBJPROP_STYLE, STYLE_DOT);
        ObjectSet("8.30 AM", OBJPROP_SELECTABLE, FALSE);
        ObjectSet("8.30 AM", OBJPROP_HIDDEN, TRUE);
        ObjectSet("8.30 AM", OBJPROP_BACK, TRUE);
        
    
    
    return(rates_total);
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
void OnDeinit(const int reason)
{
    for(int i = 0; i < ObjectsTotal(); i++) {
        string objName = ObjectName(i);
        if (StringFind(objName, "Separator ") == 0) {
            ObjectDelete(objName);
        }
    }
}