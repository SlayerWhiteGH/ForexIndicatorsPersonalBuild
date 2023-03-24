//+-------------------------------------------------------------------------------------------------+
//                                                                                    ICT Tools.mq4 |
// Copyright (C) 2018 X-Ray
//
// This program is free software: you can modify it and/or redistribute it only among ICT Mentorship
// Members. Usage, including commercial, is permited only by ICT Mentorship Members. 
//    
// Disclaimer of Warranty.
// THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.  EXCEPT WHEN
// OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES PROVIDE THE PROGRAM
// "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED
// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE ENTIRE
// RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU.  SHOULD THE PROGRAM PROVE
// DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION.
//
// Limitation of Liability.
// IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING WILL ANY COPYRIGHT HOLDER,
// OR ANY OTHER PARTY WHO MODIFIES AND/OR CONVEYS THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU
// FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF
// THE USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
// RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO
// OPERATE WITH ANY OTHER PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGES.
//
//
// README
//
// How to use this indicator and customize it to your liking:
//
// Note: I suggest that you edit the parameters into the code then compile it. This way you don't have
// to modify any parameter when you load the indicator into your chart. Personally, I have created a
// DEFAULT.TPL template file in MT4 with this indicator loaded. This allows me to have the indicator
// pre-loaded on any new chart I open. 
//
// Important:
// You need to set the broker Server Time difference with NY and with London in the section
// USER MODIFIABLE VARIABLES SECTION. All time related objects are created with these settings. 
//
// From version 2.0 there is a backtesting mode available. When active, the Backtesting mode allows
// setting a date in the past and then the chart will scroll automatically to move the candle
// representing that date to the right edge of the chart. This way you don't see future candles and you
// can practice all concepts thought by Michael. Then you can move forward by one candle of the current
// timeframe by pressing the key F for forward. If you need to go scroll left to see more past candles,
// you can use the key B for backward. You can use the mouse with the risk of scrolling accidentally to
// the right allowing you to see future candles. You can zoom in or out, change timeframe and the
// indicator will always scroll the chart automatically to move the target date candle on the right edge.
// However, you need to have enough historical data to fill the whole chart with older candle than the
// target date set. Please take note that sometime you won't be able to zoom out to the maximum level
// because there is not enough historical data. It's also possible the indicator will zoom in
// automatically after you moved to a higher timeframe again because there is not enough historical data. 
// The backtesting target date is saved into a global variable. This is to allow loading the indicator of
// different pairs and they will all be sync with the latest backtesting target date you will have updating
// by pressing F. If you want to start a new backtesting session from a different date, then you have to
// manually delete the global variable. To do so, go to Tool -> Global Variables (or press F3), then click
// on the row for the Variable GV_BacktestingTargetDate and press the Delete button. Then set a new target
// date in the variable userspecifiedtargetdate . 
//
// How to use the backtesting mode:
//   Step 1: Set the desired date to beging the testing in the variable userspecifiedtargetdate
//   Step 2: To turn the backtesting mode ON, set the variable Backtesting_Mode to true.
//   Then use it with the following keys:
//     key B to scroll the chart to the specified target date. 
//     key F to move the chart to the right by one candle on the current time frame.
//     key B to move or scroll back in time. Once you need to go back to the current target date, press B
//   If you want to start again with a new target date, delete the global variable GV_BacktestingTargetDate
//   as per the instruction from the above paragraph. 
//
// Drawing PD Array lines:
//   When backtesting mode is NOT active: 
//      Step 1- click on the desired candle to draw from, press one of O, H, L, C, M key to draw the line
//              from Open, High, Low, Close, Mean Threshold respectively. A line in the color defined by
//              the variable TrendLineInitialStateColor.  
//      Step 2- click one of the following key to define the PD Array type. 
//              key 1 : Mitigation Block
//              key 2 : Bullish Breaker
//              key 3 : Liquidity Void
//              key 4 : Fair Value Gap
//              key 5 : Bullish Orderblock
//              key 6 : Rejection Block
//              key 7 : Old Low/High
//              the line will then automatically be colored as the Premium color defined by variables
//              PDAPremiumLineColor_... or as the Discount color defined by variable PDADiscountLineColor_...
//              based on the current price. 
//   When backtesting mode is active: 
//      Step 1- click on the desired candle to draw from, press one of O, H, L, C, M key to draw the line
//              from Open, High, Low, Close, Mean Threshold respectively. A line in the color defined by
//              the variable TrendLineInitialStateColor.
//      Step 2- Press the key P to set the line as Premium or the key D to set the line as Discount  
//      Step 3- click one of the following key to define the PD Array type. 
//              key 1 : Mitigation Block
//              key 2 : Bullish Breaker
//              key 3 : Liquidity Void
//              key 4 : Fair Value Gap
//              key 5 : Bullish Orderblock
//              key 6 : Rejection Block
//              key 7 : Old Low/High
//
//
// Keys assignment: 
//   You can reassign keyboard key to specific function in the section called "KEY ASSIGNMENT SECTION"
//   starting from line 270. To reassign a key, change the value in the column identified
//   by "Assign the key you prefer in this column".
//   
//   You can only KEY_x where x equals A-Z or 0-9. If you don't want to assign a function to a key, they
//   put NAx where x equals 1-9. 
//
//
// Customizing colors:
//   You can customize the color for all objects drawn by this indicator in the section called
//   "COLOR CUSTOMIZATION SECTION" from line 420.
//
// To get the complete list of functionalities available, please read the description in the section
// called KEY ASSIGNMENT SECTION.
//
// You can also review other variables you can adjust to your liking in the section USER MODIFIABLE VARIABLES SECTION. 
//
// From Version 2.11 there is a function to save the historical price data to csv files. The files will be created in
// the exact same format as if you will export the data to a csv file from the Tools -> History Center (F2). 
// This allows to import the saved data through the History Center.
// This function can be turned off by setting the variable "SaveHistoryPriceActive" to false. When active, the
// price history will be saved once a day at the time specified by the variable "HourToSaveHistory". Please note the 
// time defined by "HourToSaveHistory" uses your local computer time. 
// The files are created into the directory MQL4\Files. You can get to this folder from the MT4 main menu by selecting
// File -> Open Data Folder. 
// The list of pairs to save their history is defined into the code. Do a search on "List of Pairs to save history" to find
// the section to update. You can list up to 20 pairs to save the price history. 
// Here is the current setting:
//   Pair[0]="AUDUSD";
//     Pair[1]="EURUSD";
//     Pair[2]="GBPUSD";
//     Pair[3]="NZDUSD";
//     Pair[4]="USDCAD";
//     Pair[5]="USDCHF";
//     Pair[6]="USDJPY";
//     Pair[7]="";
//     Pair[8]="";
//     Pair[9]="";
//     Pair[10]="";
//     Pair[11]="";
//     Pair[12]="";
//     Pair[13]="";
//     Pair[14]="";
//     Pair[15]="";
//     Pair[16]="";
//     Pair[17]="";
//     Pair[18]="";
//     Pair[19]="";

//+------------------------------------------------------------------------------------------------------------------+




#property copyright "Copyright 2018, Xray"
#property version   "2.23"
#property strict
#property indicator_chart_window
#property description "Important:"
#property description "Before using this indicator you need to set your broker MT4 Server Time Difference with New York, London and Tokyo."
#property description " "
#property description "This indicator contains ICT proprietary information. Distrubution is restricted to ICT Mentorship members."

// Version history:
//  1.01: Fixed pips value for chart scale with brokers with fractional pips
//        Fixed anchor position of Time objects so they align to the right
//  1.02: Fixed pips value for spread and scale for Gold with brokers with fractional pips
//  1.03: Fixed division by zero in scale function during chart initialization when the price scale is not yet set 
//  1.04: Fixed Date and Time that wasn't updating real time. The time was stuck at when the indicator was started. 
//  1.05: Added Equity KillZone.
//  1.06: Added Set visibility of selected object to current timeframe and lower only.
//  1.07: Added Switch between Regular Fib and Reward to Risk ratio Fib
//  1.08: Added option to show or hide the trade level lines
//  1.09: Simplified and fix bug for detected fractional pip brokers
//  1.10: Added option to show or hide bid and ask price lines along with trade levels. 
//  1.11: Added option to show or hide Fibonacci retracements. 
//  1.12: Added a 3rd Fibonacci retracement setting (25%, 50% & 75%)
//        Added pip range info text over Equity open time KZ
//  1.13: Added Asia High/Lo and Asia Open/Close to CBDR function
//  1.14: Added Autoscroll ON/OFF with A key and Timeframe down with 8, Timeframe up with 9
//  1.15: Added FVG rectangle. 
//        - 1st press on key N draw FVG representing the difference between high and lows of preceding and subsequent
//          candles to the one clicked.
//        - 2nd press on Key N draw what is left of the FVG based on candles on the right side of the one clicked. 
//        - 3rd press on Key N remove the FVG rectangle. 
//  1.16: Kill Zones can now be draw as rectangle around candles or as a thin line at the bottom of the chart by pressing key K. 
//        Also added the KillZone range in pips above KillZone rectangles when pressing Key I. 
//  1.17: Added CME KillZone at the bottom of the chart. 
//        Also fixed a bug where a Kill Zone at the bottom of the chart will not appear if the begining date was inside the visible chart
//        but it's end date was outside of the chart to the right.
//  1.18: Corrected a problem that sometime cause the wrong price to be displayed when hovering over a trend line. This problem happened sometime
//        when zooming out or changing the chart scale. 
//  2.00: Major rework: 
//          - Reorganize the code to make it easier to customize key assignment and objects color
//          - Added a Backtesting mode. When in that mode, still has to press P or D to set Premium or Discount when drawing a PD Array trendline
//            When not in Backtesting mode, the PD Array line will be set automatically to Premium or Discount based on current price. 
//          - Added function to cycle through different line style
//          - Added function to cycle through different line thickness
//          - Added function to toggle a line from Trendline to Horizontal line
//          - Added a setting to allow drawing all new PD Array line as Trendline or Horizontal line. 
//          - Added function to shrink the length of an object. 
//          - Added function to toggle weekly opening projection line from 0:00 GMT, 0:00 NY. 
//          - Added function to toggle daily projection line from 0:00 GMT, 0:00 NY and CME open.
//          - Added function to show ADR and AWR
//  2.02: Corrected pips Day Range, ADR and AWR values for brokers that don't use fractional pips. Now Sunday candles are
//        excluded from the ADR and AWR calculation. 
//  2.10: Added Profit and Loss values for current chart pair at the top of the chart.
//  2.11: Added a function to save the price history to csv files.
//        In the Profit and Loss information: 
//           - Corrected calculation of Lost in Pending Sell Orders
//           - Corrected calculation of Profit and Loss when the pair Quote currency was different than the account currency. 
//           - Added Buy and Sell Lots for active orders. Also added the Net lots between Buy and Sell Orders. 
//  2.12: - Changed the Price Label behavior. Now pressing the 'P' key will toggle between:
//           - first press = Price Lable anchor to the right of the last click object
//           - second press = Price Lable anchor to the left of the last click object    
//           - third press = Price Lable anchor to the current time.
//        - When toggeling Show/Hide object information with the 'I' key, the selection is now propagated (upon the next tick) to all charts that have
//          this indicator loaded. The actual setting when closing MT4 is saved so when reopening MT4 the charts will show the objects description 
//          if it was selected. 
//        - Added an option to toggle the Fix Scale option. Search for 'Key_Toggle_Fix_Scale' for more information. This option is currently assigned 
//          to the semicolumn key. 
//        - Added an option to draw a horizontal line at the price midpoint (equilibrium) of a rectangle. This option is currently assigned to the 
//          dot '.' key. You must first click on a rectangle then press the '.' key to draw the line.
//  2.13: - Rework how the date/time in different time zone is handled to be more robust and flexible. Now broker Server Time in any time zone is
//          now supported. From version 2.13 and up, all Kill Zone begin and end time is entered as local time for each Kill Zone. You also need
//          to correctly set the first three variables (ServerTimeDiffWithNY, ServerTimeDiffWithLondon and ServerTimeDiffWithTokyo). Read below for
//          more information and an expample on how to set these variables. 
//        - Also fixed the CBDR and Daily and Weekly projection line calculation to support any Server Time zone. 
//  2.14: Rework the Period separator lines to handle any Server Time zone. Added new feature to the Period Separator lines:
//        Pressing the Period Separator key will now toggle between these settings:
//         - Show vertical lines for midnight in London
//         - Show vertical lines for midnight in New Work
//         - Show vertical lines for True Day
//  2.15: - Fix the Open Profit/Loss and ADR, AWR values that stopped getting updated after changing Timeframe.
//        - Added the Open Orders average price as requested. 
//        - Optimize the Kill Zones rectangles drawing function. Kill Zones rectangles are now being updated with the latest price when the
//          current time is within the begining and the end of any Kill Zones. Before this update only the Equity KZ rectangles were updating line. 
//        - Now the pips value will show the correct value for any symbols. It was showing 100 times more for USDJPY for example. 
//  2.16: - Fix a bug with the OpenOrderPriceAvg calculation when there is no active order.  
//        - The Kill Zones rectangles are now drawn properly as the current time enter and leave a Kill Zone time range. 
//  2.17: - The KZ Rectangles and KZ Line are now draw on all active charts with this indicator loaded. When removing the KZ from one chart
//          it removed the KZ on all other active charts.
//        - Added the CME Futures Session separator line as an additional feature to the existing Period Separation function. The CME Futures begin time is
//          set to 17h00 Chicago and the Session end is set to 16h00 Chicago. When the CME Futures Session period separator lines are active, opening and
//          closing projection lines are also drawn. 
//        - All objects drawn by this indicator are not listed by default in the Objects List Window. To list the objects, click on the List All button. 
//  2.18: - Fix the Chart Fix Scale toggle. In previous version when changing timeframe, you had to press twice the key to deactivate the Fix Scale option.
//          Now it's toggeling properly between active/inactive when a single key press.
//        - Fix a bug when opening a chart for the first time on which there is not yet any bars while the KZ rectangles is active. Added Bars>0 to the condition.
//  2.19: - Now support Hi DPI screen with Windows resolution scaling. 
//  2.20: - Added a user defined variable to select how many Std Dev to see with CBDR. 
//  2.22: - Changed default colors so from this version the indicator works well on white background charts
//        - Corrected the period CME separators so they don't show up on Daily chart
//        - Added a new logic to draw OHLC lines. It's now possible to select the old way for manually selecting the PD array element with the P or D followed by
//          number from 1 to 7. Now there is a new logic enabled by default that draw the lines with specific color, thicness and style based on which time
//          frame the line is drawn from. The variable name to enable/disable this logic is UsePDALineSetup.
//        - Corrected logic to draw maximum KZ rectangles according to variable DaystoGoBack. 
//        - Added logic to draw a maximum of period separation lines according to the value defined in variable MaximumPSLines. This should improve responsivness of the charts. 
//  2.23: - Changed the order in which the rectangles are drawn. Before, the 1st press on 'r' key was creating a rectangle from high to low, now it' the body 1st. 
//        - Change the object title for drawing Open, High, Low, Close, Mean Threshold and Rectangle Equilibrium lines with the O,H,L,C,., keys to put the price into the title. 
//          Now the default tooltip popup window is shown when the mouse cursor is over these lines so the text written into the Description field will appear on the tooltip
//          windows when moving the mouse over these lines. 


//==================================================================================================
// Do not change the section below. This section is to map the ASCII code to variables called KEY_x
#define KEY_0 48
#define KEY_1 49
#define KEY_2 50
#define KEY_3 51
#define KEY_4 52
#define KEY_5 53
#define KEY_6 54
#define KEY_7 55
#define KEY_8 56
#define KEY_9 57
#define KEY_A 65
#define KEY_B 66  
#define KEY_C 67
#define KEY_D 68
#define KEY_E 69
#define KEY_F 70
#define KEY_G 71
#define KEY_H 72
#define KEY_I 73
#define KEY_J 74
#define KEY_K 75
#define KEY_L 76
#define KEY_M 77
#define KEY_N 78
#define KEY_O 79
#define KEY_P 80
#define KEY_Q 81
#define KEY_R 82
#define KEY_S 83
#define KEY_T 84
#define KEY_U 85
#define KEY_V 86
#define KEY_W 87
#define KEY_X 88
#define KEY_Y 89
#define KEY_Z 90
#define KEY_SEMICOLUMN 186
#define KEY_DOT 190
#define NA1 1000  // Dummy key to allow a function to not have a keyboard key assigned
#define NA2 1001  // Dummy key to allow a function to not have a keyboard key assigned
#define NA3 1002  // Dummy key to allow a function to not have a keyboard key assigned
#define NA4 1003  // Dummy key to allow a function to not have a keyboard key assigned
#define NA5 1004  // Dummy key to allow a function to not have a keyboard key assigned
#define NA6 1005  // Dummy key to allow a function to not have a keyboard key assigned
#define NA7 1006  // Dummy key to allow a function to not have a keyboard key assigned
#define NA8 1007  // Dummy key to allow a function to not have a keyboard key assigned
#define NA9 1008  // Dummy key to allow a function to not have a keyboard key assigned
// End of the section to define ASCII codes to variables
// -----------------------------------------------------------------------------------------------


//========================================================================================================================
// KEY ASSIGNMENT SECTION
//
// You can reassign the keyboard key you prefer to every functionalities available in this section. 
// A key must be unique to a #define (or function) otherwise multiple functions will be executed when pressing a key. 
// A key must be defined for each #define otherwise the code won't compile. 
// If you don't want to assign a key to a function replace KEY_x by NA1 to NA9. 
//
// Note: Keys A, B, D, F and P are reserveed for Backtesting. Key P and D can also be used when NOT in backtesting but their
//       assigment when not in backtesting mode will not work when in backting mode.  
// 
//
// Do not change the first 2 columns
//
//  No change         No change                          Assign the key you prefer in this column
//  |                 |                                  |
//  v                 v                                  v
#define Key_Draw_Line_From_Open                          KEY_O  // To draw a line from the Open price of last clicked candle
#define Key_Draw_Line_From_Close                         KEY_C  // To draw a line from the Close price of last clicked candle
#define Key_Draw_Line_From_High                          KEY_H  // To draw a line from the High price of last clicked candle
#define Key_Draw_Line_From_Low                           KEY_L  // To draw a line from the Low price of last clicked candle
#define Key_Draw_Line_From_Mean_Threshold                KEY_M  // To draw a line from the Mean Threshold price of last clicked candle
#define Key_Define_Line_As_Mitigation_Block              KEY_1  // To define the PD Array line as: Mitigation Block
#define Key_Define_Line_As_Bullish_Breaker               KEY_2  // To define the PD Array line as: Bullish Breaker
#define Key_Define_Line_As_Liquidity_Void                KEY_3  // To define the PD Array line as: Liquidity Void
#define Key_Define_Line_As_Fair_Value_Gap                KEY_4  // To define the PD Array line as: Fair Value Gap
#define Key_Define_Line_As_Order_Block                   KEY_5  // To define the PD Array line as: Order Block
#define Key_Define_Line_As_Rejection_Block               KEY_6  // To define the PD Array line as: Rejection Block
#define Key_Define_Line_As_Old_Low_High                  KEY_7  // To define the PD Array line as: Old Low / High
#define Key_Draw_Rectangle_From_FVG                      KEY_G  // To draw a FVG rectangle. Pressing on this key will toggle between:
//                                                                   - Draw rectangle from previous cande high/low and next cangle high/low
//                                                                   - Draw rectangle from the unclosed gap from previous candle high/low up to current price
//                                                                   - Remove the rectangle
#define Key_Draw_Rectangle_From_Candle                   KEY_R  // 
#define Key_Extend_Last_Object_Clicked                   KEY_E  // To extend the last clicked object
#define Key_Shrink_Last_Object_Clicked                   NA1    // To shrink the last clicked object
#define Key_Change_Line_Type_Of_Last_Object_Clicked      NA2    // To change the Line Type of the last object clicked
#define Key_Change_Line_Thickness_Of_Last_Object_Clicked NA3    // To change the Line Thickness of the last object clicked
#define Key_Convert_Trendline_To_Horizontal_Line         KEY_U  // To convert a Trendline to a Horizontal line and vice versa
#define Key_Create_Price_Label                           KEY_P  // To create a Left Price Label at the price level of the last object clicked
#define Key_Daily_Projection_Lines                       KEY_Q  // To create daily opening prijection lines. Pressing this key will toggle between:
//                                                                   - Projection from 0 GMT
//                                                                   - Projection from midnight New York
//                                                                   - Projection from CME Open
//                                                                   - Remove the projection lines
#define Key_Weekly_Projection_Lines                      KEY_W  // To create weekly opening projection lines. Pressing the key will toggle between:
//                                                                   - Midnight London
//                                                                   - Midnight New York
#define Key_Show_Period_Separators                       KEY_Z  // To Show/Hide the period separator lines
#define Key_Show_KillZones                               KEY_K  // To show the Kill Zones. Pressing this key will toggle between:
//                                                                   - Show Kill Zones with Rectangles around candles
//                                                                   - Show Kill Zones with a thin line at the bottom of the chart
//                                                                   - Remove the Kill Zones
#define Key_Show_CBDR                                    KEY_J  // To show the CBDR. Pressing this key will toggle between:
//                                                                   - CBDR from Hi to Low
//                                                                   - CBDR from Open to Close
//                                                                   - CBDR + Asia from High to Low
//                                                                   - CBDR + Asia from Open to Close
//                                                                   Note: You can see which one is active on the top left corner. 
//                                                                         Move your mouse over the CBDR horizontal lines and you will see the STD dev with associated price. 
#define Key_Show_Equity_Opening_Hours                    KEY_Y  // To Show/Hide the NY Stock Exchange Opening Time 
#define Key_Show_Object_Info                             KEY_I  // To Show/Hide information like pips range above Kill Zone or CBDR rectangles
#define Key_Show_Chart_Price_Scale                       KEY_S  // To Show/Hide the chart price scale in pips visible at the top right corner
#define Key_Show_Server_And_Local_Time                   KEY_T  // To Show/Hide the Local and Server Time at the top of the chart
#define Key_LastObject_Visibility                        KEY_V  // To set the visibility of last clicked object to current timeframe and lower only
#define Key_Toggle_Fib_Levels                            KEY_X  // To change Fibonacci Retracement levels. Pressing this key will toggle between:
//                                                                   - Regular Fib level
//                                                                   - Reward to Risk ratio. Start the fib from your entry price up to your stoploss price
//                                                                   - Simple 0%, 25%, 50%, 75%, 100% levels
#define Key_Show_Fib_Retracement                         KEY_0  // To Show/Hide all Fibonacci retracements on the current chart
#define Key_Create_Screenshot                            KEY_N  // Create Screenshot of current chart. 
//                                                                   Note: The files are saved in your MT4 installation folder under MQL4/Files. 
//                                                                         You can get to the MT4 installation folder by going to File - Open Data Folder in the MT4 menu.
#define Key_Change_Timeframe_Down                        KEY_8  // To change the current chart one Timeframe down
#define Key_Change_Timeframe_Up                          KEY_9  // To change the current chart one Timeframe up
#define Key_Toggle_Fix_Scale                             KEY_SEMICOLUMN  // To toggle between vertical Fix Scale and normal (automatic) vertical scale:
//                                                                            Fix Scale locks the current chart price scale. This option is available when right clicking on 
//                                                                            a chart -> Properties -> Common tab -> Scale fix.
//                                                                            When Scale fix option is not selected, the price scale will automatically resize to fit the
//                                                                            lowest and highest price within the chart window.
#define Key_Rectangle_MidPoint_Line                      KEY_DOT  // To draw a horizontal line at the price midpoint (equilibrium) of the selected rectangle
//
//                                                       Note: the keys assigned to the 3 functions below can not be reassigned. 
//      Key_Set_Chart_Auto_Scroll                        KEY_A  // When Backtesting NOT active: To toggle ON/OFF the Chart Auto Scroll
//      Key_Show_Trade_Level_Lines                       KEY_B  // When Backtesting NOT active: To Show/Hide the Trade level lines on the chart
//      Key_Show_ADR                                     KEY_D  // When Backtesting NOT active: To Show/Hide Average Daily and Weekly range with current day and week range 
// End of KEY ASSIGNMENT SECTION. 
//----------------------------------------------------------------------------------


//========================================================================================================================
// Backtesting mode section, hardcoded key assigment:
// Because there is a limited number of keys available to assign to functions, some keys will behave differently 
// depending if backtesting mode is active or not. 
// You can not reassign these keys. 
// 
// When the Backtesting mode is NOT active: 
#define Key_Set_Chart_Auto_Scroll                        KEY_A  // When Backtesting NOT active: To toggle ON/OFF the Chart Auto Scroll
#define Key_Show_Trade_Level_Lines                       KEY_B  // When Backtesting NOT active: To Show/Hide the Trade level lines on the chart
#define Key_Show_ADR                                     KEY_D  // When Backtesting NOT active: To toggle between:
//                                                                      - Show/Hide Average Daily and Weekly range with current day and week range 
//                                                                      - Show/Hide Profit and Loss of the pair of active chart
//
// When the Backtesting mode is active:
#define Key_Backtesting_Scroll_To_Target_Date            KEY_A  // When Backtesting active: Scroll the most right candle on the chart to the chart right edge
#define Key_Backtesting_Scroll_Backward                  KEY_B  // When Backtesting active: Scroll the chart backward (scroll to the left)
#define Key_Backtesting_Scroll_Forward                   KEY_F  // When Backtesting active: Scroll the chart forward (to the right) by one candle and set the backtesting target date to that new candle
// End of the section Backtesting mode, hardcoded key assigment. 
//----------------------------------------------------------------------------------


//========================================================================================================================
// USER MODIFIABLE VARIABLES SECTION
//
// Variables that you can adjust to your preference.
//
// IMPORTANT: Make sure the first three variables are set properly (ServerTimeDiffWithNY, ServerTimeDiffWithLondon and ServerTimeDiffWithTokyo). 
//            To get the current server time, look at the current time from the MT4 Market Watch panel (Ctrl+M) then calculate the
//            time difference for each cities. You enter a positive value for cities that are ahead for the Server Time and a negative value for
//            cities that are behind the Server Time. 
//            For example if your broker Server Time is 15h00 while
//               - it's 10h00 in NY, you will put -5 for ServerTimeDiffWithNY
//               - it's 15h00 in London, you will put 0 for ServerTimeDiffWithLondon
//               - it's midnight in Tokyo, you will put 9 for ServerTimeDiffWithTokyo
//            When we change the time due to Daylight Saving Time, you just need to change these values and everything will be fine but
//            anything new draw to the chart will use the new setting (I mean, the code doesn't differentiate the days before or after DST).
//  Values to use with ActiveTrades
extern int ServerTimeDiffWithNY = -6;  // Server Time difference with New York local time
extern int ServerTimeDiffWithLondon = -1; // Server Time difference with London local time
extern int ServerTimeDiffWithTokyo = 8; // Server Time difference with Tokyo local time

/*  Values to use with Oanda
extern int ServerTimeDiffWithNY = -7;  // Server Time difference with New York local time
extern int ServerTimeDiffWithLondon = -2; // Server Time difference with London local time
extern int ServerTimeDiffWithTokyo = 7; // Server Time difference with Tokyo local time
*/
//
extern bool Backtesting_Mode=false;    // Backtesting mode active when true
//                                          true  = Backtesting mode active
//                                          false = Backtesting mode inactive
//                                          Note: When in Backtesting mode, need to mannually set if a PD Array line is a Premimum or Discount when creating it. 
extern datetime userspecifiedtargetdate = D'2017.10.09 03:15';  // Begin Backtesting test from this date.
//                                                                 Make sure there is a candle at this date. If you set that date to a Saturday for which there is 
//                                                                 no candle, the Backtesting won't be able to move the chart to that date. 
//                                                                 Make sure you have enough history in MT4 to fill the entire chart with candles when the candle 
//                                                                 representing this Backtesting start date is align to the right edge of the chart. If you don't 
//                                                                 have enough data, the Backtesting won't work as intended as you will see more recent candles than
//                                                                 the date you selected. 
//
extern int NumberOfDaysToExtend = 10; // Number of days to extend objects
extern int NumberOfDaysToShrink = 1;  // Number of days to shrink objects
//
extern bool PD_Array_Draw_Horizontal_Line=false;  // Line Type for new PD Array lines:
//                                                  true  = new PD Array lines will be drawn with an Horizontal Line
//                                                  false = new PD Arrat lines will be drawn with a Trendline
//
extern bool SaveHistoryPriceActive=true;  // To save historical price data to csv file compatible with the History Center to import back this data. 
//                                           Set it to true to save the price history once a day
//                                           Set it to false to not save the price history
extern int HourToSaveHistory=17;          // Local time (hour) at which the price history will be save to files. 
//
// Variables for KillZones 
extern int DaystoGoBack = 45; // Max days to go back to draw KZ rectangles
extern int MaximumPSLines = 50;  // Maximum number of Period Separator lines to draw
extern int KZLineThickness = 4; // Thickness of KZ line (in pixel)
extern bool ShowCMEKZ = true;  // Show CME Kill Zone in the KZ line at the bottom of the chart
extern bool WeeklyProjectionLineGMTOnly=false;  // Set to true to show weekly projection lines only from London midnight. Set to false to toggle projection 
//                                                 lines from midnight London, midnight NY and no line.
extern int TrueDayStart=0; // True Day begin at midnight NY local time
extern int TrueDayEnd=15; // True Day end at 15h NY local time
extern int pagestogoback = 2; // Max pages to draw object at minimum zoom
extern float RetinaScaling = 100; // Hi DPI display scaling factor for text
//                                   Note: Put the value that you see under the "Customize your display" setting page from the slider bar called "Change the size of text, apps and other items:". The value must be between 100 and above 
//                                   The Display setting page is accessible from Windows start - Settings - System - Display.
extern int NumberOfStdDevToShow = 5; // Number of Std Dev to show

//========================================================================================================================
// COLOR CUSTOMIZATION SECTION
// You can customize the color of any object that can be created by this indicator in this section.
//
// Note: the color is either set as a predefined word or in RGB format. 
//       For predefined word: 
//            - Open the Properties window of any object from your chart\
//            - In the Common tab, click on the down arrow of the Style box
//            - Move your mouse over any color for few seconds to see the color "Name".
//            - You can replace the color with this color "Name"
//       For RGB color style: 
//            - You need to change only the value of the 3 numbers from the string C'xx,xx,xx'. 
//            - You can get RGB values from the site: http://www.color-hex.com/
//
//                                    Change only this column
//                                       |
// For Zill Zones:                       v
extern color LondonOpenColor           = C'224,243,245'; // Color for KZ rectangle: London Open
extern color LondonCloseColor          = C'216,237,243'; // Color for KZ rectangle: London Close
extern color NYOpenColor               = C'213,253,213'; // Color for KZ rectangle: New York
extern color AsiaOpenColor             = LavenderBlush;  // Color for KZ rectangle: Asia
extern color EquityOpenColor           = LavenderBlush;  // Color for KZ rectangle: NY Stock Exchange Opening hours
extern color LondonOpenKZLineColor     = DodgerBlue;     // Color for KZ line: London Open
extern color LondonCloseKZLineColor    = Blue;           // Color for KZ line: London Close
extern color NYOpenKZLineColor         = Green;          // Color for KZ line: New York
extern color AsiaOpenKZLineColor       = Red;            // Color for KZ line: Asia
extern color CMEOpenKZLineColor        = LightBlue;      // Color for KZ line: CME Open time
extern color CBDRColor                 = WhiteSmoke;     // Color for Central Bank Dealer Range rectangle
extern color CBDRColorLine             = DarkGray;       // Color for Central Bank Dealer Range rectangle
extern color DailyProjectionLineColor  = C'73,73,73';    // Color for Price Projection Lines: Daily open price projection lines
extern color WeeklyProjectionLineColor = C'73,73,73';    // Color for Price Projection Lines: Weekly open price projection lines
extern color PriceScaleColor           = Gray; // Color for the Price (pips) scale visible on the top right corner
extern color SpreadandTimeFontColor    = Gray; // Color for the Spread, Local and Server Time text visible at the top of the chart
extern color ADR_Font_Color            = Gray; // Color for the ADR, AWR font
extern color MondayTDBeginColor        = C'112,112,112'; // Color for Period Separator line: Monday True Day Begin
extern color Tue_Fri_TDBeginColor      = C'73,73,73';    // Color for Period Separator line: Tuesday to Friday True Day Begin
extern color Mon_Thr_TDEndColor        = C'120,73,73';   // Color for Period Separator line: Monday to Thursday True Day End
extern color Friday_TDEnd              = C'160,99,99';   // Color for Period Separator line: Friday True Day End
extern color CMEDayBeginSunday         = DarkSeaGreen;   // Color for Period Separator line: CME Futures Day begin 1st day of week
extern color CMEDayBeginMon_Thr        = LightGreen;     // Color for Period Separator line: CME Futures Day begin Monday to Thursday
extern color CMEDayEndFriday           = DarkGray;       // Color for Period Separator line: CME Futures Day End Last day of week
extern color CMEDayEndMon_Thr          = LightGray;      // Color for Period Separator line: CME Futures Day begin Monday to Thursday
extern color MonthlyPSColor            = C'0,120,120';   // Color for Period Separator line: Monthly lines
extern color QuarterlyPSColor          = C'100,0,100';   // Color for Period Separator line: Quarterly lines
extern color YearlyPSColor             = C'100,100,0';   // Color for Period Separator line: Yearly lines
extern color FVG_RectangleColor        = Linen;          // Color for the FVG rectangles
extern color CandleRectangleColor      = Lavender;       // Color for Drawing rectangle from candles
extern color TrendLineInitialStateColor= C'80,80,80';    // Initial color of trendline before defining the type of PD Array
extern color PDAPremiumLineColor_M1    = C'100,0,0';     // Color for Premium Array line for M1 TF
extern color PDAPremiumLineColor_M5    = C'100,0,0';     // Color for Premium Array line for M5 TF
extern color PDAPremiumLineColor_M15   = C'100,0,0';     // Color for Premium Array line for M15 TF
extern color PDAPremiumLineColor_M30   = C'100,0,0';     // Color for Premium Array line for M30 TF
extern color PDAPremiumLineColor_H1    = C'100,0,0';     // Color for Premium Array line for H1 TF
extern color PDAPremiumLineColor_H4    = C'125,0,0';     // Color for Premium Array line for H4 TF
extern color PDAPremiumLineColor_D1    = C'150,0,0';     // Color for Premium Array line for D1 TF
extern color PDAPremiumLineColor_W1    = C'175,0,0';     // Color for Premium Array line for W1 TF
extern color PDAPremiumLineColor_MN    = C'200,0,0';     // Color for Premium Array line for MN TF
extern color PDADiscountLineColor_M1   = C'0,80,0';      // Color for Discount Array line for M1 TF
extern color PDADiscountLineColor_M5   = C'0,80,0';      // Color for Discount Array line for M5 TF
extern color PDADiscountLineColor_M15  = C'0,80,0';      // Color for Discount Array line for M15 TF
extern color PDADiscountLineColor_M30  = C'0,80,0';      // Color for Discount Array line for M30 TF
extern color PDADiscountLineColor_H1   = C'0,80,0';      // Color for Discount Array line for H1 TF
extern color PDADiscountLineColor_H4   = C'0,100,0';     // Color for Discount Array line for H4 TF
extern color PDADiscountLineColor_D1   = C'0,120,0';     // Color for Discount Array line for D1 TF
extern color PDADiscountLineColor_W1   = C'0,140,0';     // Color for Discount Array line for W1 TF
extern color PDADiscountLineColor_MN   = C'0,160,0';     // Color for Discount Array line for MN TF
extern bool  UsePDALineSetup           = False;          // Set to true to manually set the PD array value for lines, set to False to use predefined line style as below
extern color LineColor_Monthly         = DimGray;        // Color for lines drawn on Monthly chart
extern int   LineThickness_Monthly     = 3;              // Thickness of lines drawns on Monthly chart
extern int   LineStyle_Monthly         = 0;              // Style of lines drawns on Monthly chart
extern color LineColor_Weekly          = Red;            // Color for lines drawn on Weekly chart
extern int   LineThickness_Weekly      = 2;              // Thickness of lines drawns on Weekly chart
extern int   LineStyle_Weekly          = 0;              // Style of lines drawns on Weekly chart
extern color LineColor_Daily           = Blue;           // Color for lines drawn on Daily chart
extern int   LineThickness_Daily       = 1;              // Thickness of lines drawns on Daily chart
extern int   LineStyle_Daily           = 0;              // Style of lines drawns on Daily chart
extern color LineColor_Hourly          = DeepSkyBlue;    // Color for lines drawn on Hourly chart
extern int   LineThickness_Hourly      = 1;              // Thickness of lines drawns on Hourly chart
extern int   LineStyle_Hourly          = 0;              // Style of lines drawns on Hourly chart

// End of COLOR CUSTOMIZATION SECTION
//----------------------------------------------------------------------------------





// Variables for KillZones
// Please note that in order to optimize the KZ calculation to make it faster and less CPU intensive, 
// a Kill Zone can't overlap with another Kill Zone
int LondonOpenBegin = 6;      // London local hour for London Open KZ begin
int LondonOpenEnd = 10;       // London local hour for London Open KZ end
int LondonCloseBegin = 15;    // London local hour for London Close KZ begin
int LondonCloseEnd = 19;      // London local hour for London Close KZ end
int NYOpenBegin = 7;          // NY local hour for the NY KZ begin
int NYOpenEnd = 10;           // NY local hour for the NY KZ end
int AsiaOpenBegin = 9;        // Tokyo local hour for the Asia KZ begin
int AsiaOpenEnd = 14;         // Tokyo local hour for the Asia KZ end
int CBDRBegin = 14;           // NY local hour for the CBDR KZ begin
int CBDREnd = 20;             // NY local hour for the CBDR KZ end
int EquityBeginHour = 9;      // NY local hour for the NY Stock Exchange open at 9h30 so 9 for the hour
int EquityBeginMinutes = 30;  // NY local minutes for the NY Stock Exchange open at 9h30 so 30 for the minutes
int EquityEnd = 16;           // NY local hour the NY Stock Exchange close
int CMEOpenHour = 8;          // NY local hour for the Opening of CME Open Outcry (Note: local hour is in Chicago using NY for simplicity)
int CMEOpenMinutes = 15;      // NY local minutes for the Opening of CME Open Outcry (Note: the official Open Outcry is 7:20 in Chicago but using 8:15 NY for simplicity)
int CMEFuturesDayBeginHour = 18; // NY local hour for CME Futures New Day begining hour which is 17h00 Chicago so 18h New York
int CMEFuturesDayEndHour = 17;   // NY local hour for CME Futures end of day hour which is 16h00 Chicago so 17h New York
int CMEFuturesDayDuration = 23;  // CME Future day duration in hours;
// Other Time variable
int MidnightNY = 0;           // NY local hour for midnight at NY
int MidnightLondon = 0;       // London local hour for midnight at London

// Variables to convert Local Time to Server Time
int ServerTime, ServerTimeDayOffset;

// Variables for KillZone with time converted in ServerTime
int ServerLondonOpenBegin;             // Server hour for London Open KZ begin
int ServerLondonOpenBeginDayOffset;    // Server day offest for London Open KZ begin
int ServerLondonOpenEnd;               // Server hour for London Open KZ end
int ServerLondonOpenEndDayOffset;      // Server day offest for London Open KZ end
int ServerLondonCloseBegin;            // Server hour for London Close KZ begin
int ServerLondonCloseBeginDayOffset;   // Server day offest for London Close KZ begin
int ServerLondonCloseEnd;              // Server hour for London Close KZ end
int ServerLondonCloseEndDayOffset;     // Server day offest for London Close KZ end
int ServerNYOpenBegin;                 // Server hour for the NY KZ begin
int ServerNYOpenBeginDayOffset;        // Server day offest for the NY KZ begin
int ServerNYOpenEnd;                   // Server hour for the NY KZ end
int ServerNYOpenEndDayOffset;          // Server day offest for the NY KZ end
int ServerAsiaOpenBegin;               // Server hour for the Asia KZ begin
int ServerAsiaOpenBeginDayOffset;      // Server day offest for the Asia KZ begin
int ServerAsiaOpenEnd;                 // Server hour for the Asia KZ end
int ServerAsiaOpenEndDayOffset;        // Server day offest for the Asia KZ end
int ServerCBDRBegin;                   // Server hour for the CBDR KZ begin
int ServerCBDRBeginDayOffset;          // Server day offest for the CBDR KZ begin
int ServerCBDREnd;                     // Server hour for the CBDR KZ end
int ServerCBDREndDayOffset;            // Server day offest for the CBDR KZ end
int ServerEquityBeginHour;             // Server hour for the NY Stock Exchange open
int ServerEquityBeginHourDayOffset;    // Server day offest for the NY Stock Exchange open
int ServerEquityEnd;                   // Server hour the NY Stock Exchange close
int ServerEquityEndDayOffset;          // Server day offest for the NY Stock Exchange end
int ServerCMEOpenHour;                 // Server hour the CME Open
int ServerMidnightNY;                  // Server hour for midnight at NY
int ServerMidnightNYDayOffset;         // Server day offset for midnight at NY
int ServerMidnightLondon;              // Server hour for midnight at London
int ServerMidnightLondonDayOffset;     // Server day offset for midnight at London
int ServerTrueDayStart;                // Server hour for TrueDay Start
int ServerTrueDayStartDayOffset;       // Server day offset for TrueDay Start
int ServerTrueDayEnd;                  // Server hour for TrueDay End
int ServerTrueDayEndDayOffset;         // Server day offset for TrueDay End
int ServerCMEFuturesDayBeginHour;           // Server CME Futures Day begin hour
int ServerCMEFuturesDayBeginHourDayOffset;  // Server day offset for CME Futures Day begin hour
int ServerCMEFuturesDayEndHour;             // Server CME Futures Day end hour
int ServerCMEFuturesDayEndHourDayOffset;    // Server day offset for CME Futures Day end hour


// Variables for Backtesting mode
bool BacktestingFirstPass = true;
int targetbarno = 0;
datetime targetdate = 0;
int PreviousZoomLevel = 0;
string gv_BacktestingTargetDate="GV_BacktestingTargetDate";
string gv_PreviousPeriod="GV_PreviousPeriod";
int targetdateInNumber =0;

static bool KEY_P_pressed = false;
static bool KEY_D_pressed = false;

// To hide all objects drawn by this indicator into the Object List Window. To list the objects, click the list all button. 
bool ObjectNotListed=true;

// Variables for PD Array
double SelectedBarOpen =0;
double SelectedBarHigh =0;
double SelectedBarLow =0;
double SelectedBarClose =0; 
double SelectedBarMeanThreshold =0;
double SelectedBarFVGhigh =0, SelectedBarFVGlow =0, SelectedBarFVGhignRemaining =0, SelectedBarFVGlowRemaining =0;
int SelectedBarNumber =0, LastSelectedBarNumberForRectangle=0;
int BullishLineColor =0;
int BearishLineColor =0;
datetime dt =0;
int  window =0;
string LastObjectName;
int PDArrayLineVisibility;

// variables for KillZones
int LondonOpenDuration, LondonCloseDuration, NYOpenDuration, AsiaOpenDuration, CBDRDuration, CBDRandAsiaDuration;
int LondonOpenKZno=0, LondonCloseKZno=0, NYOpenKZno=0, AsiaOpenKZno=0;
bool DrawKillZones_FirstPass=true;
bool DrawKillZonesRectanglesActive=false;
bool DrawKillZonesLineActive=false;
string GV_ShowKZ="GV_ShowKZ";
string GV_ShowObjDescription="GV_ShowObjDescription";
int ShowObjDescription, ShowCBDR;
// Variables for Equity KillZone
string GV_ShowEquityKZ="GV_ShowEquityKZ";
double EquityDuration;
bool DrawEquityKillZone_FirstPass=true;
int EquityKZno=0;
bool DrawKillZonesEquityActive=false;

// Variable to set the default size for Price Labels
int Price_Labels_Default_Size = 2;
int PriceLableSwitch=0;
string LastPriceLabelCreated;

// Variables for Spread, Price scale and Date/Time
bool FractionalPip=false; // Set to true in init if broker uses fractional pips
int FractionalPipDivider=1;  // To convert price to pip properly depending if broker uses fractional pips or not
int font_size = 8;   // Set font size for Time, Scale, ADR, AWR. 
string font_face = "Arial";  // Set font type for Time, Scale, ADR, AWR
bool DrawAsBackground = false; //DrawTextAsBackground: if true, the text will be drawn as background.
bool selection=false;          // highlight to move
// Variables specific for Spread
ENUM_BASE_CORNER spread_corner = CORNER_LEFT_UPPER;
int spread_x = 260;
int spread_y = 0;
// Variables specific for Date/Time
ENUM_BASE_CORNER time_corner = CORNER_RIGHT_UPPER;
int time_x = 20;
int time_y = 3;
string DOWintext[7];  // To transform the day of week from integer to text
bool show_timeprev=true;
string show_time="show_time";
// Variables specific for Price Scale
bool show_scaleprev=true;
string show_scale="show_scale";


// Last object clicked
string lastobjclicked;

// Variables for Period Separators and Open Price projection
int counterPS=0;
int YearlyPSLine=0;
int QuarterlyPsLine=0;
int MonthlyPSLine=0;
int EveryMondayPSLine=0;
int DailyPSLine=0;
int DailyOpenPriceLineLength;  // Lenght of Daily Open Price Projection line
int WeeklyOpenPriceLineLength;  // Lenght of Weekly Open Price Projection line
int PSLastLineDrawMonth;
int PSLastLineDrawQuarter;
bool period_separators_FirstPass=true;
// Global variable for Period Separators
string GV_ShowPeriodSeparators="GV_ShowPeriodSeparators";

// Current Chart Zoom level and previous Zoom level
int ZoomLevel = 0;
int ZoomLevelPrev = 0;

// variable for Price Projection
int DailyProjectionLineState=0, WeeklyProjectionLineState=0;

// Variables for swith between regular Fib and R:R Fib
int ShowFibRR;

// variable to show Trade Levels Lines and Price lines
bool ShowPriceLines=1;

// variables to show or hide the Fibonacci retracements
int ShowFibo=OBJ_ALL_PERIODS, ShowFiboPrev=OBJ_NO_PERIODS;

// variable to switch between FVG settings
int ShowFVG=0;

// variable to switch between candle rectangle type
int CandleRectangleType=0;

// Variables for ADR, AWR
int ADRDisplayCorner=0;               
int ADR_x_StartingPosition=360;
int ADR_y_StartingPosition=0;
double range_day[6], ADR[5], AWR[5];
double OpenOrderProfitTotal=0, OpenOrderProfitInPercentage=0;
double OpenOrderWorstLoss=0, OpenOrderBestProfit=0;
string OpenOrderProfitInDollarText, OpenOrderWorstLossText, OpenOrderProfitInPercentageText, OpenOrderBestProfitText;
string OpenOrderBestNetProfitText, OpenOrderWorstLossInDollarText, OpenOrderWorstLossInPercentageText;
string OpenOrderBestProfitInDollarText, OpenOrderBestProfitInPercentageText, PendingOrderBestProfitInDollarText, PendingOrderWorstLossInDollerText;
string PendingOrderWorstLossInPercentageText, PendingOrderBestProfitInPercentageText;
double PendingOrderProfitTotal=0, PendingOrderWorstLoss=0, PendingOrderBestProfit=0;
double BuyLots=0, SellLots=0, PendingBuyLots=0, PendingSellLots=0, OpenOrderPriceTotal=0, OpenOrderPriceQty=0, OpenOrderPriceAvg=0; 
int ChartWidthPrevious=0;
int PnLTextXPosition=0, PnLTextYPosition=0;

// variable for saving history price data to files
int FileHandle;
int iPair;
string Pair[20];
int iperiod;
int period[9];
int LastSaveHistoryUpdateDay;

// variable for Rectangle Price Equilibrium (midpoint) Line
color RectangleMidPointLineColor;

//====================================================
//
// Custom indicator initialization function           
//
//====================================================
int OnInit()
  {
   // Convert Retina from percentage to factor number
   RetinaScaling=RetinaScaling/100;
   
   // To display price chart in the background
   ChartSetInteger(0,CHART_FOREGROUND,0);
    
   // Determine if broker uses fractional pip
   if((int)MarketInfo("EURUSD",MODE_DIGITS)==5) FractionalPip=true;  // if total digit in EURUSD price=5 broker use fractional pip
   if(FractionalPip) FractionalPipDivider=10; 
   
   // To convert all local time to Server time
   ConvertLocalTimetoServerTime();
   
   //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   // For KillZones
   // Calculate duration in hours for each KillZone
   LondonOpenDuration = LondonOpenEnd - LondonOpenBegin;
   LondonCloseDuration = LondonCloseEnd - LondonCloseBegin;
   NYOpenDuration = NYOpenEnd - NYOpenBegin;
   AsiaOpenDuration = AsiaOpenEnd - AsiaOpenBegin;
   CBDRDuration = CBDREnd - CBDRBegin;
   // Calculate duration in hours for CBDR + Asia
   CBDRandAsiaDuration = 24+(AsiaOpenEnd-(ServerTimeDiffWithTokyo))-(CBDRBegin-(ServerTimeDiffWithNY));
   EquityDuration = EquityEnd - EquityBeginHour - ((double)EquityBeginMinutes/(double)60);
   // end for KillZones
   //--------------------------------------------------------

   //++++++++++++++++++++++++++++++++++++++++++++++++++++++++   
   // For Spread
   ObjectCreate("Spread", OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0,"Spread", OBJPROP_CORNER, spread_corner);
   ObjectSetInteger(0,"Spread", OBJPROP_XDISTANCE, (int)(spread_x*RetinaScaling));
   ObjectSetInteger(0,"Spread", OBJPROP_YDISTANCE, (int)(spread_y*RetinaScaling));
   ObjectSetInteger(0,"Spread", OBJPROP_BACK, DrawAsBackground);
   ObjectSetInteger(0,"Spread",OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(0,"Spread",OBJPROP_SELECTED,selection); 
   ObjectSetInteger(0,"Spread",OBJPROP_HIDDEN,ObjectNotListed);
   // end for Spread
   //--------------------------------------------------------
   
   //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   // For Price Scale
   GlobalVariableTemp(show_scale);
   // End For Price Scale
   //---------------------------------------------------------
   
   //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   // For Date/Time
   GlobalVariableTemp(show_time);
   // End For Date/Time
   //---------------------------------------------------------

   //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   // For Daily and Weekly Open Price Projection
   DailyOpenPriceLineLength=(TrueDayEnd-TrueDayStart)*3600;
   WeeklyOpenPriceLineLength=(60*60*24*4) + (TrueDayEnd*60*60);  // 4 days + hours until TrueDayEnd
   // End For Daily and Weekly Open Price Projection
   //---------------------------------------------------------

   //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   // For Backtesting mode, detect chart changes like TimeFrame
   // of zoom changes. 
   if(Backtesting_Mode)
     {
      if(UninitializeReason() == REASON_CHARTCHANGE) 
  	     {   // To detect the Chart was change ie TimeFrame was changed
         BacktestingShiftToTargetDate();
	   	return(INIT_SUCCEEDED);
        }  // end if REASON_CHARTCHANGE
      PreviousZoomLevel = BacktestingZoomLevel();
      ChartSetInteger(0,CHART_SHIFT,0,0);
      ChartSetInteger(0,CHART_AUTOSCROLL,0,0);
      if(GlobalVariableGet(gv_BacktestingTargetDate)==0)
        {
         GlobalVariableSet(gv_BacktestingTargetDate,userspecifiedtargetdate);
        }
     }
   //---------------------------------------------------------

   //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   // Create temporary global variables to save the state to show ADR or AWR and Open Profit/Loss
   GlobalVariableTemp(StringConcatenate("GV_ShowADRState_",SymbolInfoString("0",SYMBOL_DESCRIPTION)));
   //---------------------------------------------------------
     
   //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   // For saving price history data to files
   // List of Pairs to save history
   // 
   // You can update the list below
   // Note: There is a maximum of 20 pairs.
   Pair[0]="AUDUSD";
   Pair[1]="EURUSD";
   Pair[2]="GBPUSD";
   Pair[3]="NZDUSD";
   Pair[4]="USDCAD";
   Pair[5]="USDCHF";
   Pair[6]="USDJPY";
   Pair[7]="";
   Pair[8]="";
   Pair[9]="";
   Pair[10]="";
   Pair[11]="";
   Pair[12]="";
   Pair[13]="";
   Pair[14]="";
   Pair[15]="";
   Pair[16]="";
   Pair[17]="";
   Pair[18]="";
   Pair[19]="";
   
   // Don't change the period list below. 
   period[0]=1;
   period[1]=5;
   period[2]=15;
   period[3]=30;
   period[4]=60;
   period[5]=240;
   period[6]=1440;
   period[7]=10080;
   period[8]=43200;
   //---------------------------------------------------------
   
   return(INIT_SUCCEEDED);
  } // End int OnInit()
//============================================================  


//===========================================================
//
// Custom indicator iteration function 
//
//===========================================================
int start()
 {
  spread();  // Show the spread information
  DrawKillZonesRectangles();  // Draw the Kill Zones rectangles if required
  DrawKillZonesEquity();   // Draw the Equity Kill Zone rectangles if required

  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++   
  // Draw Period Separator Lines
  if(GlobalVariableGet(GV_ShowPeriodSeparators)==1 || GlobalVariableGet(GV_ShowPeriodSeparators)==2 || GlobalVariableGet(GV_ShowPeriodSeparators)==3 || GlobalVariableGet(GV_ShowPeriodSeparators)==4)
    {
     period_separators();
    }
  // End Draw KillZone when current time is during a killzone
  //-------------------------------------------------------------   

  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++   
  // Update Date and Time value
  if(GlobalVariableGet(show_time)==true)
    {
     server_localdatetime();
    }
  else   // Remove the Date and Time information from the chart
    {
     ObjectDelete(0,"ServerTimeTitle");
     ObjectDelete(0,"ServerTime");
     ObjectDelete(0,"LocalTimeTitle");
     ObjectDelete(0,"LocalTime");
    }               
  // End Update Date and Time value
  //-------------------------------------------------------------   
  ADRCalculation();
  PnLCalculation();

  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++   
  // Call the save history price data to files at the time
  // specified by HourToSaveHistory everyday (it will run only
  // once a day
  if(TimeHour(TimeLocal())==HourToSaveHistory && LastSaveHistoryUpdateDay!=TimeDay(TimeLocal()) && SaveHistoryPriceActive==true)
    {
     save_history();
     LastSaveHistoryUpdateDay=TimeDay(TimeLocal());
    }
  //-------------------------------------------------------------   
  return(0);
 } // end int start()
//===========================================================

//===========================================================
//
// Custom indicator deinitialization function 
//
//===========================================================
void OnDeinit(const int reason)
  {
  	if (UninitializeReason() == REASON_CHARTCHANGE) // To detect the Chart changes ie TimeFrame was changed
  	  {
      if(Backtesting_Mode)
        {
         GlobalVariableSet(gv_PreviousPeriod,ChartPeriod(0));
         return;
        }
      if(GlobalVariableGet(GV_ShowKZ)==1)
        {
         RemoveKillZonesRectangles();
        }
      if(GlobalVariableGet(GV_ShowKZ)==2)
        {
         RemoveKillZonesLine();
        }
      if(GlobalVariableGet(GV_ShowEquityKZ)==1)
        {
         RemoveKillZonesEquity();
        }
      if(GlobalVariableGet(GV_ShowPeriodSeparators)>0)
        {
         RemovePeriodSeparators();
        }
	  }
	else
	  {
      // To remove the CBDR objects
      RemoveCBDR();
      // To remove the KillZones objects
      RemoveKillZonesRectangles();
      RemoveKillZonesLine();
      // To remove the Equity KillZone objects
      RemoveKillZonesEquity();
      // To remove Spread object
      ObjectDelete("Spread");
      // To remove Price Scale objects
      ObjectDelete(0,"scaleVline");
      ObjectDelete(0,"scaleH1line");
      ObjectDelete(0,"scaleH2line");
      ObjectDelete(0,"scaletext");
      // To remove Date/Time
      ObjectDelete("ServerTime");
      ObjectDelete("LocalTime");
      ObjectDelete("ServerTimeTitle");
      ObjectDelete("LocalTimeTitle");
      for(int i=0; i<Bars-1; i++)
        {
         // To remove Daily Open Price Projection lines
         ObjectDelete(0,"TrueDayOpenPrice"+IntegerToString(i));
         // To remove Weekly Open Price Projection lines
         ObjectDelete(0,"WeeklyOpenPrice"+IntegerToString(i));
         // To remove Period Separators lines
        }
      if(GlobalVariableGet(GV_ShowPeriodSeparators)>0)
        {
         RemovePeriodSeparators();
        }
      // To erease the last Comment
      Comment("");      
      // Set back the chart to not show the object description
      ChartSetInteger(0,CHART_SHOW_OBJECT_DESCR,0,0);
      if(Backtesting_Mode)
        {
         GlobalVariableDel(gv_PreviousPeriod);
        }
      // To remove ADR objects
      ADRRemove();
      // To remove PnL objects
      PnLRemove();
 	  }
  }
//===========================================================


//++++++++++++++++++++++++++++++++++
// ChartEvent function           
//++++++++++++++++++++++++++++++++++
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
   int DaysToExtend = NumberOfDaysToExtend * 24 * 60 * 60;  // To get # of days in seconds, MQL4 Time is in seconds
   
   if(id==CHARTEVENT_OBJECT_CLICK) // object has been clicked
     {
      Comment("Last object clicked: ",sparam);
      lastobjclicked = sparam;
     }

   if(id==CHARTEVENT_CLICK)  // If this is an event of a mouse click on the chart
     {
      //--- Prepare variables
      int      x     =(int)lparam;
      int      y     =(int)dparam;
      double   price =0;
      if(ChartXYToTimePrice(0,x,y,window,dt,price))  // Convert the X and Y coordinates in terms of date/time
        {
        dt = dt;
        }
      else
        Comment("ChartXYToTimePrice return error code: ",GetLastError());
      for(int i=Bars-2; i>=0; i--) 
        { 
         if(Time[i] == dt) 
           {
            SelectedBarOpen = Open[i];
            SelectedBarHigh = High[i];
            SelectedBarLow = Low[i];
            SelectedBarClose = Close[i]; 
            SelectedBarMeanThreshold = ((Close[i]-Open[i])/2)+Open[i];
            SelectedBarNumber = i;
            if(SelectedBarClose-SelectedBarOpen>0 && i>=1)  //This is a up candle
              {
               SelectedBarFVGhigh = Low[i-1];
               SelectedBarFVGlow = High[i+1];
               SelectedBarFVGhignRemaining = MathMin(Low[iLowest(NULL,0,MODE_LOW,i-1,0)],Low[i-1]);
               if(SelectedBarFVGhignRemaining < SelectedBarFVGlow) SelectedBarFVGhignRemaining = SelectedBarFVGlow;
               SelectedBarFVGlowRemaining = SelectedBarFVGlow;
              }
            if(SelectedBarClose-SelectedBarOpen<0 && i>=1)  // This is a down candle
              {
               SelectedBarFVGhigh = Low[i+1];
               SelectedBarFVGlow = High[i-1];
               SelectedBarFVGhignRemaining = SelectedBarFVGhigh;
               SelectedBarFVGlowRemaining = MathMax(High[iHighest(NULL,0,MODE_HIGH,i-1,0)],High[i-1]);
               if(SelectedBarFVGlowRemaining > SelectedBarFVGhigh) SelectedBarFVGlowRemaining = SelectedBarFVGhigh;
              }
           } 
        }
     }
   if(id==CHARTEVENT_KEYDOWN) // If this is an event of a keyboard key press
     {
      // Comment(lparam);  // Uncomment this line to show the code for the last key pressed
      int CurrentChartTimeFrame = ChartPeriod(0);  // To get Time Frame of current chart
      string CTF, CTF_ScreenShot;  // Current Time Frame string
      switch(CurrentChartTimeFrame)   // To set color according to Time Frame and creat a TF string
        {
         case 1:
           {
            CTF = "M1";
            CTF_ScreenShot = " TF9 M1";
            BearishLineColor = PDAPremiumLineColor_M1;
            BullishLineColor = PDADiscountLineColor_M1;
            PDArrayLineVisibility = OBJ_PERIOD_M1;
           }
         break;
         case 5:
           {
            CTF = "M5";
            CTF_ScreenShot = " TF8 M5";
            BearishLineColor = PDAPremiumLineColor_M5;
            BullishLineColor = PDADiscountLineColor_M5;
            PDArrayLineVisibility = OBJ_PERIOD_M1|OBJ_PERIOD_M5;
           }
         break;
         case 15:
           {
            CTF = "M15";
            CTF_ScreenShot = " TF7 M15";
            BearishLineColor = PDAPremiumLineColor_M15;
            BullishLineColor = PDADiscountLineColor_M15;
            PDArrayLineVisibility = OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15;
           }
         break;
         case 30:
           {
            CTF = "M30";
            CTF_ScreenShot = " TF6 M30";
            BearishLineColor = PDAPremiumLineColor_M30;
            BullishLineColor = PDADiscountLineColor_M30;
            PDArrayLineVisibility = OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30;
           }
         break;
         case 60: 
           {
            CTF = "H1";
            CTF_ScreenShot = " TF5 H1";
            BearishLineColor = PDAPremiumLineColor_H1;
            BullishLineColor = PDADiscountLineColor_H1;
            PDArrayLineVisibility = OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1;
           }
         break;
         case 240:
           {
            CTF = "H4";
            CTF_ScreenShot = " TF4 H4";
            BearishLineColor = PDAPremiumLineColor_H4;
            BullishLineColor = PDADiscountLineColor_H4;
            PDArrayLineVisibility = OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1|OBJ_PERIOD_H4;
           } 
         break;
         case 1440:
           {
            CTF = "D1";
            CTF_ScreenShot = " TF3 D1";
            BearishLineColor = PDAPremiumLineColor_D1;
            BullishLineColor = PDADiscountLineColor_D1;
            PDArrayLineVisibility = OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1|OBJ_PERIOD_H4|OBJ_PERIOD_D1;
           } 
         break;
         case 10080:
           {
            CTF = "W1";
            CTF_ScreenShot = " TF2 W1";
            BearishLineColor = PDAPremiumLineColor_W1;
            BullishLineColor = PDADiscountLineColor_W1;
            PDArrayLineVisibility = OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1|OBJ_PERIOD_H4|OBJ_PERIOD_D1|OBJ_PERIOD_W1;
           } 
         break;
         case 43200:
           {
            CTF = "MN";
            CTF_ScreenShot = " TF1 MN";
            BearishLineColor = PDAPremiumLineColor_MN;
            BullishLineColor = PDADiscountLineColor_MN;
            PDArrayLineVisibility = OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1|OBJ_PERIOD_H4|OBJ_PERIOD_D1|OBJ_PERIOD_W1|OBJ_PERIOD_MN1;
           } 
         break;
        }

      switch(int(lparam))
        {
         case Key_Draw_Line_From_Open:  // create Trendline from Open Price
           {
            if (ObjectFind(0,DoubleToString(SelectedBarOpen,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Open @ "+TimeToString(dt)) == 0)
             {
              ObjectDelete(0,DoubleToString(SelectedBarOpen,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Open @ "+TimeToString(dt));
             }
            else
             {
              if(PD_Array_Draw_Horizontal_Line)
                {
                 ObjectCreate(0,DoubleToString(SelectedBarOpen,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Open @ "+TimeToString(dt),OBJ_HLINE,0,NULL,SelectedBarOpen);
                }
              else
                {
                 ObjectCreate(0,DoubleToString(SelectedBarOpen,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Open @ "+TimeToString(dt),OBJ_TREND,0,dt,SelectedBarOpen,TimeCurrent()+DaysToExtend,SelectedBarOpen);
                }
              if (UsePDALineSetup)
                {
                 ObjectSetInteger(0,DoubleToString(SelectedBarOpen,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Open @ "+TimeToString(dt),OBJPROP_COLOR,TrendLineInitialStateColor);
                 //--- set line display style 
                 ObjectSetInteger(0,DoubleToString(SelectedBarOpen,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Open @ "+TimeToString(dt),OBJPROP_STYLE,STYLE_DASH); 
                 //--- set line width 
                 ObjectSetInteger(0,DoubleToString(SelectedBarOpen,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Open @ "+TimeToString(dt),OBJPROP_WIDTH,1);
                }
              else
                {
                 ObjectSetInteger(0,DoubleToString(SelectedBarOpen,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Open @ "+TimeToString(dt),OBJPROP_COLOR,TrendLineInitialStateColor);
                 if(CTF=="MN") ObjectSetInteger(0,DoubleToString(SelectedBarOpen,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Open @ "+TimeToString(dt),OBJPROP_COLOR,LineColor_Monthly);
                 if(CTF=="W1") ObjectSetInteger(0,DoubleToString(SelectedBarOpen,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Open @ "+TimeToString(dt),OBJPROP_COLOR,LineColor_Weekly);
                 if(CTF=="D1") ObjectSetInteger(0,DoubleToString(SelectedBarOpen,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Open @ "+TimeToString(dt),OBJPROP_COLOR,LineColor_Daily);
                 if(CTF=="H1") ObjectSetInteger(0,DoubleToString(SelectedBarOpen,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Open @ "+TimeToString(dt),OBJPROP_COLOR,LineColor_Hourly);                
                 //--- set line display style 
                 ObjectSetInteger(0,DoubleToString(SelectedBarOpen,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Open @ "+TimeToString(dt),OBJPROP_STYLE,STYLE_DASH); 
                 if(CTF=="MN") ObjectSetInteger(0,DoubleToString(SelectedBarOpen,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Open @ "+TimeToString(dt),OBJPROP_STYLE,LineStyle_Monthly);
                 if(CTF=="W1") ObjectSetInteger(0,DoubleToString(SelectedBarOpen,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Open @ "+TimeToString(dt),OBJPROP_STYLE,LineStyle_Weekly);
                 if(CTF=="D1") ObjectSetInteger(0,DoubleToString(SelectedBarOpen,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Open @ "+TimeToString(dt),OBJPROP_STYLE,LineStyle_Daily);
                 if(CTF=="H1") ObjectSetInteger(0,DoubleToString(SelectedBarOpen,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Open @ "+TimeToString(dt),OBJPROP_STYLE,LineStyle_Hourly);                
                 //--- set line width 
                 ObjectSetInteger(0,DoubleToString(SelectedBarOpen,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Open @ "+TimeToString(dt),OBJPROP_WIDTH,1);
                 if(CTF=="MN") ObjectSetInteger(0,DoubleToString(SelectedBarOpen,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Open @ "+TimeToString(dt),OBJPROP_WIDTH,LineThickness_Monthly);
                 if(CTF=="W1") ObjectSetInteger(0,DoubleToString(SelectedBarOpen,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Open @ "+TimeToString(dt),OBJPROP_WIDTH,LineThickness_Weekly);
                 if(CTF=="D1") ObjectSetInteger(0,DoubleToString(SelectedBarOpen,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Open @ "+TimeToString(dt),OBJPROP_WIDTH,LineThickness_Daily);
                 if(CTF=="H1") ObjectSetInteger(0,DoubleToString(SelectedBarOpen,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Open @ "+TimeToString(dt),OBJPROP_WIDTH,LineThickness_Hourly);                
                } 
              //--- display in the foreground (false) or background (true) 
              ObjectSetInteger(0,DoubleToString(SelectedBarOpen,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Open @ "+TimeToString(dt),OBJPROP_BACK,true); 
              //--- enable (true) or disable (false) the mode of continuation of the line's display to the right 
              ObjectSetInteger(0,DoubleToString(SelectedBarOpen,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Open @ "+TimeToString(dt),OBJPROP_RAY_RIGHT,false); 
              //--- hide (true) or display (false) graphical object name in the object list 
              ObjectSetInteger(0,DoubleToString(SelectedBarOpen,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Open @ "+TimeToString(dt),OBJPROP_HIDDEN,ObjectNotListed);
              ObjectSetInteger(0,DoubleToString(SelectedBarOpen,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Open @ "+TimeToString(dt),OBJPROP_TIMEFRAMES,PDArrayLineVisibility);
             }
            LastObjectName =  (DoubleToString(SelectedBarOpen,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Open @ "+TimeToString(dt));
           }
         break;
         case Key_Draw_Line_From_High:  // create Trendline from High Price
           {
            if (ObjectFind(0,DoubleToString(SelectedBarHigh,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" High @ "+TimeToString(dt)) == 0)
             {
              ObjectDelete(0,DoubleToString(SelectedBarHigh,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" High @ "+TimeToString(dt));
             }
           else
             {
              if(PD_Array_Draw_Horizontal_Line)
                {
                 ObjectCreate(0,DoubleToString(SelectedBarHigh,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" High @ "+TimeToString(dt),OBJ_HLINE,0,NULL,SelectedBarHigh);
                }
              else
                {
                 ObjectCreate(0,DoubleToString(SelectedBarHigh,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" High @ "+TimeToString(dt),OBJ_TREND,0,dt,SelectedBarHigh,TimeCurrent()+DaysToExtend,SelectedBarHigh);
                }
              if (UsePDALineSetup)
                {
                 ObjectSetInteger(0,DoubleToString(SelectedBarHigh,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" High @ "+TimeToString(dt),OBJPROP_COLOR,TrendLineInitialStateColor); 
                 //--- set line display style 
                 ObjectSetInteger(0,DoubleToString(SelectedBarHigh,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" High @ "+TimeToString(dt),OBJPROP_STYLE,STYLE_DOT); 
                 //--- set line width 
                 ObjectSetInteger(0,DoubleToString(SelectedBarHigh,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" High @ "+TimeToString(dt),OBJPROP_WIDTH,1); 
                }
              else
                {
                 ObjectSetInteger(0,DoubleToString(SelectedBarHigh,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" High @ "+TimeToString(dt),OBJPROP_COLOR,TrendLineInitialStateColor);
                 if(CTF=="MN") ObjectSetInteger(0,DoubleToString(SelectedBarHigh,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" High @ "+TimeToString(dt),OBJPROP_COLOR,LineColor_Monthly);
                 if(CTF=="W1") ObjectSetInteger(0,DoubleToString(SelectedBarHigh,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" High @ "+TimeToString(dt),OBJPROP_COLOR,LineColor_Weekly);
                 if(CTF=="D1") ObjectSetInteger(0,DoubleToString(SelectedBarHigh,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" High @ "+TimeToString(dt),OBJPROP_COLOR,LineColor_Daily);
                 if(CTF=="H1") ObjectSetInteger(0,DoubleToString(SelectedBarHigh,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" High @ "+TimeToString(dt),OBJPROP_COLOR,LineColor_Hourly);                
                 //--- set line display style 
                 ObjectSetInteger(0,DoubleToString(SelectedBarHigh,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" High @ "+TimeToString(dt),OBJPROP_STYLE,STYLE_DASH); 
                 if(CTF=="MN") ObjectSetInteger(0,DoubleToString(SelectedBarHigh,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" High @ "+TimeToString(dt),OBJPROP_STYLE,LineStyle_Monthly);
                 if(CTF=="W1") ObjectSetInteger(0,DoubleToString(SelectedBarHigh,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" High @ "+TimeToString(dt),OBJPROP_STYLE,LineStyle_Weekly);
                 if(CTF=="D1") ObjectSetInteger(0,DoubleToString(SelectedBarHigh,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" High @ "+TimeToString(dt),OBJPROP_STYLE,LineStyle_Daily);
                 if(CTF=="H1") ObjectSetInteger(0,DoubleToString(SelectedBarHigh,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" High @ "+TimeToString(dt),OBJPROP_STYLE,LineStyle_Hourly);                
                 //--- set line width 
                 ObjectSetInteger(0,DoubleToString(SelectedBarHigh,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" High @ "+TimeToString(dt),OBJPROP_WIDTH,1);
                 if(CTF=="MN") ObjectSetInteger(0,DoubleToString(SelectedBarHigh,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" High @ "+TimeToString(dt),OBJPROP_WIDTH,LineThickness_Monthly);
                 if(CTF=="W1") ObjectSetInteger(0,DoubleToString(SelectedBarHigh,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" High @ "+TimeToString(dt),OBJPROP_WIDTH,LineThickness_Weekly);
                 if(CTF=="D1") ObjectSetInteger(0,DoubleToString(SelectedBarHigh,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" High @ "+TimeToString(dt),OBJPROP_WIDTH,LineThickness_Daily);
                 if(CTF=="H1") ObjectSetInteger(0,DoubleToString(SelectedBarHigh,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" High @ "+TimeToString(dt),OBJPROP_WIDTH,LineThickness_Hourly);                
                } 
              //--- display in the foreground (false) or background (true) 
              ObjectSetInteger(0,DoubleToString(SelectedBarHigh,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" High @ "+TimeToString(dt),OBJPROP_BACK,true); 
              //--- enable (true) or disable (false) the mode of continuation of the line's display to the right 
              ObjectSetInteger(0,DoubleToString(SelectedBarHigh,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" High @ "+TimeToString(dt),OBJPROP_RAY_RIGHT,false); 
              //--- hide (true) or display (false) graphical object name in the object list 
              ObjectSetInteger(0,DoubleToString(SelectedBarHigh,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" High @ "+TimeToString(dt),OBJPROP_HIDDEN,ObjectNotListed); 
              ObjectSetInteger(0,DoubleToString(SelectedBarHigh,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" High @ "+TimeToString(dt),OBJPROP_TIMEFRAMES,PDArrayLineVisibility);
             }
            LastObjectName =  (DoubleToString(SelectedBarHigh,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" High @ "+TimeToString(dt));
           }
         break;
         case Key_Draw_Line_From_Low:  // create Trendline from Low Price
           {
           if (ObjectFind(0,DoubleToString(SelectedBarLow,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Low @ "+TimeToString(dt)) == 0)
             {
              ObjectDelete(0,DoubleToString(SelectedBarLow,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Low @ "+TimeToString(dt));
             }
           else
             {
              if(PD_Array_Draw_Horizontal_Line)
                {
                 ObjectCreate(0,DoubleToString(SelectedBarLow,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Low @ "+TimeToString(dt),OBJ_HLINE,0,NULL,SelectedBarLow);
                }
              else
                {
                 ObjectCreate(0,DoubleToString(SelectedBarLow,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Low @ "+TimeToString(dt),OBJ_TREND,0,dt,SelectedBarLow,TimeCurrent()+DaysToExtend,SelectedBarLow);
                }
              if (UsePDALineSetup)
                {
                 ObjectSetInteger(0,DoubleToString(SelectedBarLow,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Low @ "+TimeToString(dt),OBJPROP_COLOR,TrendLineInitialStateColor); 
                 //--- set line display style 
                 ObjectSetInteger(0,DoubleToString(SelectedBarLow,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Low @ "+TimeToString(dt),OBJPROP_STYLE,STYLE_DOT); 
                 //--- set line width 
                 ObjectSetInteger(0,DoubleToString(SelectedBarLow,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Low @ "+TimeToString(dt),OBJPROP_WIDTH,1); 
                }
              else
                {
                 ObjectSetInteger(0,DoubleToString(SelectedBarLow,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Low @ "+TimeToString(dt),OBJPROP_COLOR,TrendLineInitialStateColor);
                 if(CTF=="MN") ObjectSetInteger(0,DoubleToString(SelectedBarLow,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Low @ "+TimeToString(dt),OBJPROP_COLOR,LineColor_Monthly);
                 if(CTF=="W1") ObjectSetInteger(0,DoubleToString(SelectedBarLow,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Low @ "+TimeToString(dt),OBJPROP_COLOR,LineColor_Weekly);
                 if(CTF=="D1") ObjectSetInteger(0,DoubleToString(SelectedBarLow,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Low @ "+TimeToString(dt),OBJPROP_COLOR,LineColor_Daily);
                 if(CTF=="H1") ObjectSetInteger(0,DoubleToString(SelectedBarLow,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Low @ "+TimeToString(dt),OBJPROP_COLOR,LineColor_Hourly);                
                 //--- set line display style 
                 ObjectSetInteger(0,DoubleToString(SelectedBarLow,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Low @ "+TimeToString(dt),OBJPROP_STYLE,STYLE_DASH); 
                 if(CTF=="MN") ObjectSetInteger(0,DoubleToString(SelectedBarLow,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Low @ "+TimeToString(dt),OBJPROP_STYLE,LineStyle_Monthly);
                 if(CTF=="W1") ObjectSetInteger(0,DoubleToString(SelectedBarLow,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Low @ "+TimeToString(dt),OBJPROP_STYLE,LineStyle_Weekly);
                 if(CTF=="D1") ObjectSetInteger(0,DoubleToString(SelectedBarLow,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Low @ "+TimeToString(dt),OBJPROP_STYLE,LineStyle_Daily);
                 if(CTF=="H1") ObjectSetInteger(0,DoubleToString(SelectedBarLow,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Low @ "+TimeToString(dt),OBJPROP_STYLE,LineStyle_Hourly);                
                 //--- set line width 
                 ObjectSetInteger(0,DoubleToString(SelectedBarLow,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Low @ "+TimeToString(dt),OBJPROP_WIDTH,1);
                 if(CTF=="MN") ObjectSetInteger(0,DoubleToString(SelectedBarLow,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Low @ "+TimeToString(dt),OBJPROP_WIDTH,LineThickness_Monthly);
                 if(CTF=="W1") ObjectSetInteger(0,DoubleToString(SelectedBarLow,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Low @ "+TimeToString(dt),OBJPROP_WIDTH,LineThickness_Weekly);
                 if(CTF=="D1") ObjectSetInteger(0,DoubleToString(SelectedBarLow,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Low @ "+TimeToString(dt),OBJPROP_WIDTH,LineThickness_Daily);
                 if(CTF=="H1") ObjectSetInteger(0,DoubleToString(SelectedBarLow,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Low @ "+TimeToString(dt),OBJPROP_WIDTH,LineThickness_Hourly);                
                } 
              //--- display in the foreground (false) or background (true) 
              ObjectSetInteger(0,DoubleToString(SelectedBarLow,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Low @ "+TimeToString(dt),OBJPROP_BACK,true); 
              //--- enable (true) or disable (false) the mode of continuation of the line's display to the right 
              ObjectSetInteger(0,DoubleToString(SelectedBarLow,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Low @ "+TimeToString(dt),OBJPROP_RAY_RIGHT,false); 
              //--- hide (true) or display (false) graphical object name in the object list 
              ObjectSetInteger(0,DoubleToString(SelectedBarLow,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Low @ "+TimeToString(dt),OBJPROP_HIDDEN,ObjectNotListed); 
              ObjectSetInteger(0,DoubleToString(SelectedBarLow,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Low @ "+TimeToString(dt),OBJPROP_TIMEFRAMES,PDArrayLineVisibility);
             }
            LastObjectName =  (DoubleToString(SelectedBarLow,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Low @ "+TimeToString(dt));
           }
         break;
         case Key_Draw_Line_From_Close:  // create Trendline from Low Price
           {
           if (ObjectFind(0,DoubleToString(SelectedBarClose,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Close @ "+TimeToString(dt)) == 0)
             {
              ObjectDelete(0,DoubleToString(SelectedBarClose,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Close @ "+TimeToString(dt));
             }
           else
             {
              if(PD_Array_Draw_Horizontal_Line)
                {
                 ObjectCreate(0,DoubleToString(SelectedBarClose,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Close @ "+TimeToString(dt),OBJ_HLINE,0,NULL,SelectedBarClose);
                }
              else
                {
                 ObjectCreate(0,DoubleToString(SelectedBarClose,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Close @ "+TimeToString(dt),OBJ_TREND,0,dt,SelectedBarClose,TimeCurrent()+DaysToExtend,SelectedBarClose);
                }
              if (UsePDALineSetup)
                {
                 ObjectSetInteger(0,DoubleToString(SelectedBarClose,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Close @ "+TimeToString(dt),OBJPROP_COLOR,TrendLineInitialStateColor); 
                 //--- set line display style 
                 ObjectSetInteger(0,DoubleToString(SelectedBarClose,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Close @ "+TimeToString(dt),OBJPROP_STYLE,STYLE_DASH); 
                 //--- set line width 
                 ObjectSetInteger(0,DoubleToString(SelectedBarClose,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Close @ "+TimeToString(dt),OBJPROP_WIDTH,1); 
                }
              else
                {
                 ObjectSetInteger(0,DoubleToString(SelectedBarClose,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Close @ "+TimeToString(dt),OBJPROP_COLOR,TrendLineInitialStateColor);
                 if(CTF=="MN") ObjectSetInteger(0,DoubleToString(SelectedBarClose,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Close @ "+TimeToString(dt),OBJPROP_COLOR,LineColor_Monthly);
                 if(CTF=="W1") ObjectSetInteger(0,DoubleToString(SelectedBarClose,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Close @ "+TimeToString(dt),OBJPROP_COLOR,LineColor_Weekly);
                 if(CTF=="D1") ObjectSetInteger(0,DoubleToString(SelectedBarClose,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Close @ "+TimeToString(dt),OBJPROP_COLOR,LineColor_Daily);
                 if(CTF=="H1") ObjectSetInteger(0,DoubleToString(SelectedBarClose,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Close @ "+TimeToString(dt),OBJPROP_COLOR,LineColor_Hourly);                
                 //--- set line display style 
                 ObjectSetInteger(0,DoubleToString(SelectedBarClose,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Close @ "+TimeToString(dt),OBJPROP_STYLE,STYLE_DASH); 
                 if(CTF=="MN") ObjectSetInteger(0,DoubleToString(SelectedBarClose,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Close @ "+TimeToString(dt),OBJPROP_STYLE,LineStyle_Monthly);
                 if(CTF=="W1") ObjectSetInteger(0,DoubleToString(SelectedBarClose,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Close @ "+TimeToString(dt),OBJPROP_STYLE,LineStyle_Weekly);
                 if(CTF=="D1") ObjectSetInteger(0,DoubleToString(SelectedBarClose,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Close @ "+TimeToString(dt),OBJPROP_STYLE,LineStyle_Daily);
                 if(CTF=="H1") ObjectSetInteger(0,DoubleToString(SelectedBarClose,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Close @ "+TimeToString(dt),OBJPROP_STYLE,LineStyle_Hourly);                
                 //--- set line width 
                 ObjectSetInteger(0,DoubleToString(SelectedBarClose,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Close @ "+TimeToString(dt),OBJPROP_WIDTH,1);
                 if(CTF=="MN") ObjectSetInteger(0,DoubleToString(SelectedBarClose,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Close @ "+TimeToString(dt),OBJPROP_WIDTH,LineThickness_Monthly);
                 if(CTF=="W1") ObjectSetInteger(0,DoubleToString(SelectedBarClose,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Close @ "+TimeToString(dt),OBJPROP_WIDTH,LineThickness_Weekly);
                 if(CTF=="D1") ObjectSetInteger(0,DoubleToString(SelectedBarClose,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Close @ "+TimeToString(dt),OBJPROP_WIDTH,LineThickness_Daily);
                 if(CTF=="H1") ObjectSetInteger(0,DoubleToString(SelectedBarClose,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Close @ "+TimeToString(dt),OBJPROP_WIDTH,LineThickness_Hourly);                
                } 
              //--- display in the foreground (false) or background (true) 
              ObjectSetInteger(0,DoubleToString(SelectedBarClose,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Close @ "+TimeToString(dt),OBJPROP_BACK,true); 
              //--- enable (true) or disable (false) the mode of continuation of the line's display to the right 
              ObjectSetInteger(0,DoubleToString(SelectedBarClose,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Close @ "+TimeToString(dt),OBJPROP_RAY_RIGHT,false); 
              //--- hide (true) or display (false) graphical object name in the object list 
              ObjectSetInteger(0,DoubleToString(SelectedBarClose,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Close @ "+TimeToString(dt),OBJPROP_HIDDEN,ObjectNotListed); 
              ObjectSetInteger(0,DoubleToString(SelectedBarClose,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Close @ "+TimeToString(dt),OBJPROP_TIMEFRAMES,PDArrayLineVisibility);
             }
            LastObjectName =  (DoubleToString(SelectedBarClose,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Close @ "+TimeToString(dt));
           }
         break;
         case Key_Draw_Line_From_Mean_Threshold:  // create Trendline from Mean Threshold
           {
           if (ObjectFind(0,DoubleToString(SelectedBarMeanThreshold,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Mean Threshold @ "+TimeToString(dt)) == 0)
             {
              ObjectDelete(0,DoubleToString(SelectedBarMeanThreshold,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Mean Threshold @ "+TimeToString(dt));
             }
           else
             {
              if(PD_Array_Draw_Horizontal_Line)
                {
                 ObjectCreate(0,DoubleToString(SelectedBarMeanThreshold,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Mean Threshold @ "+TimeToString(dt),OBJ_HLINE,0,NULL,SelectedBarMeanThreshold);
                }
              else
                {
                 ObjectCreate(0,DoubleToString(SelectedBarMeanThreshold,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Mean Threshold @ "+TimeToString(dt),OBJ_TREND,0,dt,SelectedBarMeanThreshold,TimeCurrent()+DaysToExtend,SelectedBarMeanThreshold);
                }
              if (UsePDALineSetup)
                {
                 ObjectSetInteger(0,DoubleToString(SelectedBarMeanThreshold,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Mean Threshold @ "+TimeToString(dt),OBJPROP_COLOR,TrendLineInitialStateColor); 
                 //--- set line display style 
                 ObjectSetInteger(0,DoubleToString(SelectedBarMeanThreshold,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Mean Threshold @ "+TimeToString(dt),OBJPROP_STYLE,STYLE_SOLID); 
                 //--- set line width 
                 ObjectSetInteger(0,DoubleToString(SelectedBarMeanThreshold,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Mean Threshold @ "+TimeToString(dt),OBJPROP_WIDTH,1); 
                }
              else
                {
                 ObjectSetInteger(0,DoubleToString(SelectedBarMeanThreshold,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Mean Threshold @ "+TimeToString(dt),OBJPROP_COLOR,TrendLineInitialStateColor);
                 if(CTF=="MN") ObjectSetInteger(0,DoubleToString(SelectedBarMeanThreshold,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Mean Threshold @ "+TimeToString(dt),OBJPROP_COLOR,LineColor_Monthly);
                 if(CTF=="W1") ObjectSetInteger(0,DoubleToString(SelectedBarMeanThreshold,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Mean Threshold @ "+TimeToString(dt),OBJPROP_COLOR,LineColor_Weekly);
                 if(CTF=="D1") ObjectSetInteger(0,DoubleToString(SelectedBarMeanThreshold,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Mean Threshold @ "+TimeToString(dt),OBJPROP_COLOR,LineColor_Daily);
                 if(CTF=="H1") ObjectSetInteger(0,DoubleToString(SelectedBarMeanThreshold,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Mean Threshold @ "+TimeToString(dt),OBJPROP_COLOR,LineColor_Hourly);                
                 //--- set line display style 
                 ObjectSetInteger(0,DoubleToString(SelectedBarMeanThreshold,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Mean Threshold @ "+TimeToString(dt),OBJPROP_STYLE,STYLE_DASH); 
                 if(CTF=="MN") ObjectSetInteger(0,DoubleToString(SelectedBarMeanThreshold,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Mean Threshold @ "+TimeToString(dt),OBJPROP_STYLE,LineStyle_Monthly);
                 if(CTF=="W1") ObjectSetInteger(0,DoubleToString(SelectedBarMeanThreshold,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Mean Threshold @ "+TimeToString(dt),OBJPROP_STYLE,LineStyle_Weekly);
                 if(CTF=="D1") ObjectSetInteger(0,DoubleToString(SelectedBarMeanThreshold,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Mean Threshold @ "+TimeToString(dt),OBJPROP_STYLE,LineStyle_Daily);
                 if(CTF=="H1") ObjectSetInteger(0,DoubleToString(SelectedBarMeanThreshold,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Mean Threshold @ "+TimeToString(dt),OBJPROP_STYLE,LineStyle_Hourly);                
                 //--- set line width 
                 ObjectSetInteger(0,DoubleToString(SelectedBarMeanThreshold,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Mean Threshold @ "+TimeToString(dt),OBJPROP_WIDTH,1);
                 if(CTF=="MN") ObjectSetInteger(0,DoubleToString(SelectedBarMeanThreshold,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Mean Threshold @ "+TimeToString(dt),OBJPROP_WIDTH,LineThickness_Monthly);
                 if(CTF=="W1") ObjectSetInteger(0,DoubleToString(SelectedBarMeanThreshold,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Mean Threshold @ "+TimeToString(dt),OBJPROP_WIDTH,LineThickness_Weekly);
                 if(CTF=="D1") ObjectSetInteger(0,DoubleToString(SelectedBarMeanThreshold,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Mean Threshold @ "+TimeToString(dt),OBJPROP_WIDTH,LineThickness_Daily);
                 if(CTF=="H1") ObjectSetInteger(0,DoubleToString(SelectedBarMeanThreshold,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Mean Threshold @ "+TimeToString(dt),OBJPROP_WIDTH,LineThickness_Hourly);                
                } 
              //--- display in the foreground (false) or background (true) 
              ObjectSetInteger(0,DoubleToString(SelectedBarMeanThreshold,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Mean Threshold @ "+TimeToString(dt),OBJPROP_BACK,true); 
              //--- enable (true) or disable (false) the mode of continuation of the line's display to the right 
              ObjectSetInteger(0,DoubleToString(SelectedBarMeanThreshold,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Mean Threshold @ "+TimeToString(dt),OBJPROP_RAY_RIGHT,false); 
              //--- hide (true) or display (false) graphical object name in the object list 
              ObjectSetInteger(0,DoubleToString(SelectedBarMeanThreshold,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Mean Threshold @ "+TimeToString(dt),OBJPROP_HIDDEN,ObjectNotListed); 
              ObjectSetInteger(0,DoubleToString(SelectedBarMeanThreshold,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Mean Threshold @ "+TimeToString(dt),OBJPROP_TIMEFRAMES,PDArrayLineVisibility);
             }
            LastObjectName =  (DoubleToString(SelectedBarMeanThreshold,(int)MarketInfo(NULL,MODE_DIGITS))+" : "+CTF+" Mean Threshold @ "+TimeToString(dt));
           }
         break;
         case Key_Draw_Rectangle_From_FVG:  // create FVG rectangle
           {
            switch(ShowFVG)
              {
               case 0:
                 {
                  ShowFVG++;
                  ObjectCreate(0,CTF+" FVG @ "+TimeToString(dt),OBJ_RECTANGLE,0,dt,SelectedBarFVGhigh,TimeCurrent()+DaysToExtend,SelectedBarFVGlow);
                  ObjectSetString(0,CTF+" FVG @ "+TimeToString(dt),OBJPROP_TEXT,"FVG High: "+DoubleToString(SelectedBarFVGhigh,(int)MarketInfo("0",MODE_DIGITS))+"   FVG Low: "+DoubleToString(SelectedBarFVGlow,(int)MarketInfo("0",MODE_DIGITS)));
                  ObjectSetInteger(0,CTF+" FVG @ "+TimeToString(dt),OBJPROP_COLOR,FVG_RectangleColor); 
                  //--- set line display style 
                  ObjectSetInteger(0,CTF+" FVG @ "+TimeToString(dt),OBJPROP_STYLE,STYLE_SOLID); 
                  //--- set line width 
                  ObjectSetInteger(0,CTF+" FVG @ "+TimeToString(dt),OBJPROP_WIDTH,1); 
                  //--- display in the foreground (false) or background (true) 
                  ObjectSetInteger(0,CTF+" FVG @ "+TimeToString(dt),OBJPROP_BACK,true); 
                  //--- hide (true) or display (false) graphical object name in the object list 
                  ObjectSetInteger(0,CTF+" FVG @ "+TimeToString(dt),OBJPROP_HIDDEN,ObjectNotListed); 
                  ObjectSetInteger(0,CTF+" FVG @ "+TimeToString(dt),OBJPROP_TIMEFRAMES,PDArrayLineVisibility);
                  LastObjectName =  (CTF+" FVG @ "+TimeToString(dt));
                 }
               break;
               case 1:
                 {
                  ShowFVG++;
                  ObjectDelete(0,CTF+" FVG @ "+TimeToString(dt));
                  ObjectCreate(0,CTF+" FVG @ "+TimeToString(dt),OBJ_RECTANGLE,0,dt,SelectedBarFVGhignRemaining,TimeCurrent()+DaysToExtend,SelectedBarFVGlowRemaining);
                  ObjectSetString(0,CTF+" FVG @ "+TimeToString(dt),OBJPROP_TEXT,"FVG High: "+DoubleToString(SelectedBarFVGhignRemaining,(int)MarketInfo("0",MODE_DIGITS))+"   FVG Low: "+DoubleToString(SelectedBarFVGlowRemaining,(int)MarketInfo("0",MODE_DIGITS)));
                  ObjectSetInteger(0,CTF+" FVG @ "+TimeToString(dt),OBJPROP_COLOR,FVG_RectangleColor); 
                  //--- set line display style 
                  ObjectSetInteger(0,CTF+" FVG @ "+TimeToString(dt),OBJPROP_STYLE,STYLE_SOLID); 
                  //--- set line width 
                  ObjectSetInteger(0,CTF+" FVG @ "+TimeToString(dt),OBJPROP_WIDTH,1); 
                  //--- display in the foreground (false) or background (true) 
                  ObjectSetInteger(0,CTF+" FVG @ "+TimeToString(dt),OBJPROP_BACK,true); 
                  //--- enable (true) or disable (false) the mode of continuation of the line's display to the right 
                  ObjectSetInteger(0,CTF+" FVG @ "+TimeToString(dt),OBJPROP_HIDDEN,ObjectNotListed); 
                  ObjectSetInteger(0,CTF+" FVG @ "+TimeToString(dt),OBJPROP_TIMEFRAMES,PDArrayLineVisibility);
                  LastObjectName =  (CTF+" FVG @ "+TimeToString(dt));
                 }
               break;
               case 2:
                 {
                  ShowFVG=0;
                  ObjectDelete(0,CTF+" FVG @ "+TimeToString(dt));
                 }
               break;
              }               
           }
         break;
         case Key_Draw_Rectangle_From_Candle:  // create a rectangle from selected candle price
           {
            if(LastSelectedBarNumberForRectangle!=SelectedBarNumber)
              {
               LastSelectedBarNumberForRectangle=SelectedBarNumber;
               CandleRectangleType=0;
              }
            switch(CandleRectangleType)
              {
               case 0:  // The candle boddy
                 {
                  CandleRectangleType++;
                  if(SelectedBarOpen<SelectedBarClose)
                    {
                     ObjectCreate(0,CTF+" Rectangle @ "+TimeToString(dt),OBJ_RECTANGLE,0,dt,SelectedBarClose,TimeCurrent()+DaysToExtend,SelectedBarOpen);
                     ObjectSetString(0,CTF+" Rectangle @ "+TimeToString(dt),OBJPROP_TEXT,"Rectangle High: "+DoubleToString(SelectedBarClose,(int)MarketInfo("0",MODE_DIGITS))+"   Rectangle Low: "+DoubleToString(SelectedBarOpen,(int)MarketInfo("0",MODE_DIGITS)));
                    }
                  else
                    {
                     ObjectCreate(0,CTF+" Rectangle @ "+TimeToString(dt),OBJ_RECTANGLE,0,dt,SelectedBarOpen,TimeCurrent()+DaysToExtend,SelectedBarClose);
                     ObjectSetString(0,CTF+" Rectangle @ "+TimeToString(dt),OBJPROP_TEXT,"Rectangle High: "+DoubleToString(SelectedBarOpen,(int)MarketInfo("0",MODE_DIGITS))+"   Rectangle Low: "+DoubleToString(SelectedBarClose,(int)MarketInfo("0",MODE_DIGITS)));
                    }
                  ObjectSetInteger(0,CTF+" Rectangle @ "+TimeToString(dt),OBJPROP_COLOR,CandleRectangleColor); 
                  //--- set line display style 
                  ObjectSetInteger(0,CTF+" Rectangle @ "+TimeToString(dt),OBJPROP_STYLE,STYLE_SOLID); 
                  //--- set line width 
                  ObjectSetInteger(0,CTF+" Rectangle @ "+TimeToString(dt),OBJPROP_WIDTH,1); 
                  //--- display in the foreground (false) or background (true) 
                  ObjectSetInteger(0,CTF+" Rectangle @ "+TimeToString(dt),OBJPROP_BACK,true); 
                  //--- enable (true) or disable (false) the mode of continuation of the line's display to the right 
                  ObjectSetInteger(0,CTF+" Rectangle @ "+TimeToString(dt),OBJPROP_HIDDEN,ObjectNotListed); 
                  ObjectSetInteger(0,CTF+" Rectangle @ "+TimeToString(dt),OBJPROP_TIMEFRAMES,PDArrayLineVisibility);
                  LastObjectName =  (CTF+" Rectangle @ "+TimeToString(dt));
                 }
               break;
               case 1:  // from Low to High
                 {
                  CandleRectangleType++;
                  ObjectDelete(0,CTF+" Rectangle @ "+TimeToString(dt));
                  ObjectCreate(0,CTF+" Rectangle @ "+TimeToString(dt),OBJ_RECTANGLE,0,dt,SelectedBarHigh,TimeCurrent()+DaysToExtend,SelectedBarLow);
                  ObjectSetString(0,CTF+" Rectangle @ "+TimeToString(dt),OBJPROP_TEXT,"Rectangle High: "+DoubleToString(SelectedBarHigh,(int)MarketInfo("0",MODE_DIGITS))+"   Rectangle Low: "+DoubleToString(SelectedBarLow,(int)MarketInfo("0",MODE_DIGITS)));
                  ObjectSetInteger(0,CTF+" Rectangle @ "+TimeToString(dt),OBJPROP_COLOR,CandleRectangleColor); 
                  //--- set line display style 
                  ObjectSetInteger(0,CTF+" Rectangle @ "+TimeToString(dt),OBJPROP_STYLE,STYLE_SOLID); 
                  //--- set line width 
                  ObjectSetInteger(0,CTF+" Rectangle @ "+TimeToString(dt),OBJPROP_WIDTH,1); 
                  //--- display in the foreground (false) or background (true) 
                  ObjectSetInteger(0,CTF+" Rectangle @ "+TimeToString(dt),OBJPROP_BACK,true); 
                  //--- hide (true) or display (false) graphical object name in the object list 
                  ObjectSetInteger(0,CTF+" Rectangle @ "+TimeToString(dt),OBJPROP_HIDDEN,ObjectNotListed); 
                  ObjectSetInteger(0,CTF+" Rectangle @ "+TimeToString(dt),OBJPROP_TIMEFRAMES,PDArrayLineVisibility);
                  LastObjectName =  (CTF+" Rectangle @ "+TimeToString(dt));
                 }
               break;
               case 2:  // The upper wick only: close to high for up candles, open to high for down candles
                 {
                  CandleRectangleType++;
                  ObjectDelete(0,CTF+" Rectangle @ "+TimeToString(dt));
                  if(SelectedBarOpen<SelectedBarClose)
                    {
                     ObjectCreate(0,CTF+" Rectangle @ "+TimeToString(dt),OBJ_RECTANGLE,0,dt,SelectedBarHigh,TimeCurrent()+DaysToExtend,SelectedBarClose);
                     ObjectSetString(0,CTF+" Rectangle @ "+TimeToString(dt),OBJPROP_TEXT,"Rectangle High: "+DoubleToString(SelectedBarHigh,(int)MarketInfo("0",MODE_DIGITS))+"   Rectangle Low: "+DoubleToString(SelectedBarClose,(int)MarketInfo("0",MODE_DIGITS)));
                    }
                  else
                    {
                     ObjectCreate(0,CTF+" Rectangle @ "+TimeToString(dt),OBJ_RECTANGLE,0,dt,SelectedBarHigh,TimeCurrent()+DaysToExtend,SelectedBarOpen);
                     ObjectSetString(0,CTF+" Rectangle @ "+TimeToString(dt),OBJPROP_TEXT,"Rectangle High: "+DoubleToString(SelectedBarHigh,(int)MarketInfo("0",MODE_DIGITS))+"   Rectangle Low: "+DoubleToString(SelectedBarOpen,(int)MarketInfo("0",MODE_DIGITS)));
                    }
                  ObjectSetInteger(0,CTF+" Rectangle @ "+TimeToString(dt),OBJPROP_COLOR,CandleRectangleColor); 
                  //--- set line display style 
                  ObjectSetInteger(0,CTF+" Rectangle @ "+TimeToString(dt),OBJPROP_STYLE,STYLE_SOLID); 
                  //--- set line width 
                  ObjectSetInteger(0,CTF+" Rectangle @ "+TimeToString(dt),OBJPROP_WIDTH,1); 
                  //--- display in the foreground (false) or background (true) 
                  ObjectSetInteger(0,CTF+" Rectangle @ "+TimeToString(dt),OBJPROP_BACK,true); 
                  //--- enable (true) or disable (false) the mode of continuation of the line's display to the right 
                  ObjectSetInteger(0,CTF+" Rectangle @ "+TimeToString(dt),OBJPROP_HIDDEN,ObjectNotListed); 
                  ObjectSetInteger(0,CTF+" Rectangle @ "+TimeToString(dt),OBJPROP_TIMEFRAMES,PDArrayLineVisibility);
                  LastObjectName =  (CTF+" Rectangle @ "+TimeToString(dt));
                 }
               break;
               case 3:  // The lower wick only: open to low for up candles, close to low for down candles
                 {
                  CandleRectangleType++;
                  ObjectDelete(0,CTF+" Rectangle @ "+TimeToString(dt));
                  if(SelectedBarOpen<SelectedBarClose)
                    {
                     ObjectCreate(0,CTF+" Rectangle @ "+TimeToString(dt),OBJ_RECTANGLE,0,dt,SelectedBarOpen,TimeCurrent()+DaysToExtend,SelectedBarLow);
                     ObjectSetString(0,CTF+" Rectangle @ "+TimeToString(dt),OBJPROP_TEXT,"Rectangle High: "+DoubleToString(SelectedBarOpen,(int)MarketInfo("0",MODE_DIGITS))+"   Rectangle Low: "+DoubleToString(SelectedBarLow,(int)MarketInfo("0",MODE_DIGITS)));
                    }
                  else
                    {
                     ObjectCreate(0,CTF+" Rectangle @ "+TimeToString(dt),OBJ_RECTANGLE,0,dt,SelectedBarClose,TimeCurrent()+DaysToExtend,SelectedBarLow);
                     ObjectSetString(0,CTF+" Rectangle @ "+TimeToString(dt),OBJPROP_TEXT,"Rectangle High: "+DoubleToString(SelectedBarClose,(int)MarketInfo("0",MODE_DIGITS))+"   Rectangle Low: "+DoubleToString(SelectedBarLow,(int)MarketInfo("0",MODE_DIGITS)));
                    }
                  ObjectSetInteger(0,CTF+" Rectangle @ "+TimeToString(dt),OBJPROP_COLOR,CandleRectangleColor); 
                  //--- set line display style 
                  ObjectSetInteger(0,CTF+" Rectangle @ "+TimeToString(dt),OBJPROP_STYLE,STYLE_SOLID); 
                  //--- set line width 
                  ObjectSetInteger(0,CTF+" Rectangle @ "+TimeToString(dt),OBJPROP_WIDTH,1); 
                  //--- display in the foreground (false) or background (true) 
                  ObjectSetInteger(0,CTF+" Rectangle @ "+TimeToString(dt),OBJPROP_BACK,true); 
                  //--- enable (true) or disable (false) the mode of continuation of the line's display to the right 
                  ObjectSetInteger(0,CTF+" Rectangle @ "+TimeToString(dt),OBJPROP_HIDDEN,ObjectNotListed); 
                  ObjectSetInteger(0,CTF+" Rectangle @ "+TimeToString(dt),OBJPROP_TIMEFRAMES,PDArrayLineVisibility);
                  LastObjectName =  (CTF+" Rectangle @ "+TimeToString(dt));
                 }
               break;
               case 4:
                 {
                  CandleRectangleType=0;
                  ObjectDelete(0,CTF+" Rectangle @ "+TimeToString(dt));
                 }
               break;
              }               
           }
         break;
         case Key_Show_Object_Info:  // Show pip value for CBDR - show objects description
           {
            ShowObjDescription=(int)GlobalVariableGet(GV_ShowObjDescription);
            switch(ShowObjDescription)
              {
               case 0:
                 {
                  ChartSetInteger(0,CHART_SHOW_OBJECT_DESCR,0,1);
                  ChartRedraw(0);
                  GlobalVariableSet(GV_ShowObjDescription,1);
                 }
               break;
               case 1:
                 {
                  ChartSetInteger(0,CHART_SHOW_OBJECT_DESCR,0,0);
                  ChartRedraw(0);
                  GlobalVariableSet(GV_ShowObjDescription,0);
                 }
               break;
              }
           }
         break;
         case Key_Show_KillZones:  // Show the KillZones
           {
            if (ChartPeriod() <=60)
              {
               switch((int)GlobalVariableGet(GV_ShowKZ))
                 {
                  case 0:
                    {
                     GlobalVariableSet(GV_ShowKZ,1);
                     DrawKillZonesRectangles();
                    }
                  break;
                  case 1:
                    {
                     RemoveKillZonesRectangles();
                     GlobalVariableSet(GV_ShowKZ,2);
                     DrawKillZonesLine();
                    }
                  break;
                  case 2:
                    {
                     GlobalVariableSet(GV_ShowKZ,0);
                     RemoveKillZonesLine();
                    }
                  break;
                 }
              } // end && ChartPeriod() <=60
           } // end case Key_Show_KillZones
         break;
         case Key_Show_Equity_Opening_Hours:  // Show the NY Stock Exchange Openning hours KillZone
           {
            if (ChartPeriod() <=30)
              {
               switch((int)GlobalVariableGet(GV_ShowEquityKZ))
                 {
                  case 0:
                    {
                     GlobalVariableSet(GV_ShowEquityKZ,1);
                     DrawKillZonesEquity();
                    }
                  break;
                  case 1:
                    {
                     GlobalVariableSet(GV_ShowEquityKZ,0);
                     RemoveKillZonesEquity();
                    }
                  break;
                 }
              }
            else
              {
               Comment("Equity Kill Zone available on M30 charts and lower");
              } // end if(ChartPeriod() <=30
           } // end case Key_Show_Equity_Opening_Hours
         break;
         case Key_Toggle_Fib_Levels:  // Switch between Regular Fib and Reward to Risk ratio Fib 
           {
            if(ObjectType(lastobjclicked) == OBJ_FIBO)
              {
               switch(ShowFibRR)
                 {
                  case 0:  // regular fib levels
                    {
                     ShowFibRR++;
                     ObjectSetInteger(0,lastobjclicked,OBJPROP_FIBOLEVELS,10);
                     ObjectSet(lastobjclicked,OBJPROP_FIRSTLEVEL+0,0.0);  ObjectSetFiboDescription(lastobjclicked,0,"0%%   :: %$");
                     ObjectSet(lastobjclicked,OBJPROP_FIRSTLEVEL+1,0.25); ObjectSetFiboDescription(lastobjclicked,1,"25%%   :: %$"); 
                     ObjectSet(lastobjclicked,OBJPROP_FIRSTLEVEL+2,0.50); ObjectSetFiboDescription(lastobjclicked,2,"50%%   :: %$"); 
                     ObjectSet(lastobjclicked,OBJPROP_FIRSTLEVEL+3,0.62); ObjectSetFiboDescription(lastobjclicked,3,"OTE 62%%   :: %$"); 
                     ObjectSet(lastobjclicked,OBJPROP_FIRSTLEVEL+4,0.705); ObjectSetFiboDescription(lastobjclicked,4,"Sweet Spot 70.5%%   :: %$"); 
                     ObjectSet(lastobjclicked,OBJPROP_FIRSTLEVEL+5,0.79); ObjectSetFiboDescription(lastobjclicked,5,"OTE 79%%   :: %$"); 
                     ObjectSet(lastobjclicked,OBJPROP_FIRSTLEVEL+6,1.0); ObjectSetFiboDescription(lastobjclicked,6,"100%%   :: %$"); 
                     ObjectSet(lastobjclicked,OBJPROP_FIRSTLEVEL+7,-0.27); ObjectSetFiboDescription(lastobjclicked,7,"-27%%  Target 1  :: %$"); 
                     ObjectSet(lastobjclicked,OBJPROP_FIRSTLEVEL+8,-0.68); ObjectSetFiboDescription(lastobjclicked,8,"-68%%  Target 2  :: %$"); 
                     ObjectSet(lastobjclicked,OBJPROP_FIRSTLEVEL+9,-1.0); ObjectSetFiboDescription(lastobjclicked,9,"Symetrical Target  :: %$"); 
                    }
                  break;
                  case 1:  // reward to risk ratio fib levels
                    {
                     ShowFibRR++;
                     ObjectSetInteger(0,lastobjclicked,OBJPROP_FIBOLEVELS,14);
                     ObjectSet(lastobjclicked,OBJPROP_FIRSTLEVEL+0,0.0);  ObjectSetFiboDescription(lastobjclicked,0,"Stop Loss   :: %$");
                     ObjectSet(lastobjclicked,OBJPROP_FIRSTLEVEL+1,1.0); ObjectSetFiboDescription(lastobjclicked,1,"Entry   :: %$"); 
                     ObjectSet(lastobjclicked,OBJPROP_FIRSTLEVEL+2,1.25); ObjectSetFiboDescription(lastobjclicked,2,"Take Profit 0.25R:R   :: %$"); 
                     ObjectSet(lastobjclicked,OBJPROP_FIRSTLEVEL+3,1.5); ObjectSetFiboDescription(lastobjclicked,3,"Take Profit 0.5R:R   :: %$"); 
                     ObjectSet(lastobjclicked,OBJPROP_FIRSTLEVEL+4,2.0); ObjectSetFiboDescription(lastobjclicked,4,"Take Profit 1R:R   :: %$"); 
                     ObjectSet(lastobjclicked,OBJPROP_FIRSTLEVEL+5,3.0); ObjectSetFiboDescription(lastobjclicked,5,"Take Profit 2R:R   :: %$"); 
                     ObjectSet(lastobjclicked,OBJPROP_FIRSTLEVEL+6,4.0); ObjectSetFiboDescription(lastobjclicked,6,"Take Profit 3R:R   :: %$"); 
                     ObjectSet(lastobjclicked,OBJPROP_FIRSTLEVEL+7,5.0); ObjectSetFiboDescription(lastobjclicked,7,"Take Profit 4R:R   :: %$"); 
                     ObjectSet(lastobjclicked,OBJPROP_FIRSTLEVEL+8,6.0); ObjectSetFiboDescription(lastobjclicked,8,"Take Profit 5R:R   :: %$"); 
                     ObjectSet(lastobjclicked,OBJPROP_FIRSTLEVEL+9,7.0); ObjectSetFiboDescription(lastobjclicked,9,"Take Profit 6R:R   :: %$"); 
                     ObjectSet(lastobjclicked,OBJPROP_FIRSTLEVEL+10,8.0); ObjectSetFiboDescription(lastobjclicked,10,"Take Profit 7R:R   :: %$"); 
                     ObjectSet(lastobjclicked,OBJPROP_FIRSTLEVEL+11,9.0); ObjectSetFiboDescription(lastobjclicked,11,"Take Profit 8R:R   :: %$"); 
                     ObjectSet(lastobjclicked,OBJPROP_FIRSTLEVEL+12,10.0); ObjectSetFiboDescription(lastobjclicked,12,"Take Profit 9R:R   :: %$"); 
                     ObjectSet(lastobjclicked,OBJPROP_FIRSTLEVEL+13,11.0); ObjectSetFiboDescription(lastobjclicked,13,"Take Profit 10R:R   :: %$"); 
                    }
                  break;
                  case 2:  // 0%, 25%, 50%, 75%, 100% fib levels
                    {
                     ShowFibRR=0;
                     ObjectSetInteger(0,lastobjclicked,OBJPROP_FIBOLEVELS,5);
                     ObjectSet(lastobjclicked,OBJPROP_FIRSTLEVEL+0,0.0);  ObjectSetFiboDescription(lastobjclicked,0,"0%   :: %$");
                     ObjectSet(lastobjclicked,OBJPROP_FIRSTLEVEL+1,0.25); ObjectSetFiboDescription(lastobjclicked,1,"25%   :: %$"); 
                     ObjectSet(lastobjclicked,OBJPROP_FIRSTLEVEL+2,0.50); ObjectSetFiboDescription(lastobjclicked,2,"50%   :: %$"); 
                     ObjectSet(lastobjclicked,OBJPROP_FIRSTLEVEL+3,0.75); ObjectSetFiboDescription(lastobjclicked,3,"75%   :: %$"); 
                     ObjectSet(lastobjclicked,OBJPROP_FIRSTLEVEL+4,1.0); ObjectSetFiboDescription(lastobjclicked,4,"100%   :: %$"); 
                    }
                  break;
                 } // end switch(ShowFibRR)
              } // end if(ObjectType(lastobjclicked) == OBJ_FIBO)
           } // end case Key_Toggle_Fib_Levels
         break;
         case Key_Create_Screenshot:  //  
           {
            string localhour, localminute;
            if(TimeHour(TimeLocal())<10) localhour=StringConcatenate("0",TimeHour(TimeLocal()));
            else localminute=IntegerToString(TimeHour(TimeLocal()));
            if(TimeMinute(TimeLocal())<10) localhour=StringConcatenate("0",TimeMinute(TimeLocal()));
            else localminute=IntegerToString(TimeMinute(TimeLocal()));            
            if(!WindowScreenShot(StringConcatenate(TimeToStr(TimeLocal(),TIME_DATE)," ",localhour,"h",localminute," ",Symbol(),CTF_ScreenShot," Big.png"),2540,1280)) Print(GetLastError()); 
//            if(!WindowScreenShot(StringConcatenate(TimeToStr(TimeLocal(),TIME_DATE)," ",localhour,"h",localminute," ",Symbol(),CTF_ScreenShot," Small.PNG"),1390,815)) Print(GetLastError()); 
            if(!WindowScreenShot("Small.PNG",1390,815)) Print(GetLastError()); 
            Comment("Screen Shot Created");
           } // end case KEY_Star
         break;
         case Key_Show_CBDR:  // Show / hide CBDR
           {
            if (ChartPeriod() <=60)
              {
               switch(ShowCBDR)
                 {
                  case 0:  // Show CBDR from Hi / Low
                   {
                    Comment("CBDR Hi / Low");
                    ShowCBDR++;
                    for(int i=DaystoGoBack; i>=0; i--) 
                      { 
                       int DayOffset = 60 *60 * 24 * i;
                       // Get current date, convert it to a string, modify the string to add the CBDR end hour, convert the string to datetime format
                       datetime CBDREndTime = StringToTime(StringConcatenate(TimeToString(TimeCurrent()-DayOffset, TIME_DATE)," ",ServerCBDREnd,":00:00"));
                       for(int z=0; z<Bars; z++) 
                         { 
                          // Find the highest and lowest price for the CBDR
                          //   1st step is to find the bar # that correspond to the KillZone end time
                          if(Time[z] == CBDREndTime && (TimeDayOfWeek(CBDREndTime)!=0 && TimeDayOfWeek(CBDREndTime-(CBDRDuration*60*60))!=0))
                            {
                             int CBDREndBar = z;
                             //  2nd step: find the highest price using High[bar# found in 1st step]
                             double CBDRHighest = MathMax(High[iHighest(NULL,0,MODE_HIGH,(CBDRDuration*60/ChartPeriod(0)),CBDREndBar+1)],Open[z]);
                             //  3rd step: find the lowest price using Low[bar# found in 1st step]
                             double CBDRLowest = MathMin(Low[iLowest(NULL,0,MODE_LOW,(CBDRDuration*60/ChartPeriod(0)),CBDREndBar+1)],Open[z]);
                             CreateKZ("CBDR"+IntegerToString(i), CBDREndTime-(CBDRDuration*3600), CBDREndTime, CBDRHighest, CBDRLowest, CBDRColor);
                             // Calculate 1 Standard Deviation of CBDR
                             double CBDRStdDev = CBDRHighest - CBDRLowest;
                             ObjectSetString(0,"CBDR"+IntegerToString(i),OBJPROP_TEXT,IntegerToString((int)MathRound(CBDRStdDev/(Point*FractionalPipDivider)))+" Pips"); 
                             // Create trend line for Std Dev above CBDR
                             for (int std=0; std<=NumberOfStdDevToShow; std++)
                               {
                                ObjectCreate(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJ_TREND,0,CBDREndTime,CBDRHighest+(std*CBDRStdDev),CBDREndTime+57600,CBDRHighest+(std*CBDRStdDev));
                                ObjectSetInteger(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_COLOR,CBDRColorLine); 
                                ObjectSetInteger(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_STYLE,STYLE_DOT); 
                                ObjectSetInteger(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_WIDTH,1); 
                                ObjectSetInteger(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_BACK,true); 
                                ObjectSetInteger(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_RAY_RIGHT,false); 
                                ObjectSetInteger(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_HIDDEN,ObjectNotListed);
                                ObjectSetInteger(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1);
                               }
                             for (int std=0; std<=NumberOfStdDevToShow; std++)
                               {
                                ObjectCreate(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJ_TREND,0,CBDREndTime,CBDRLowest-(std*CBDRStdDev),CBDREndTime+57600,CBDRLowest-(std*CBDRStdDev));
                                ObjectSetInteger(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_COLOR,CBDRColorLine); 
                                ObjectSetInteger(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_STYLE,STYLE_DOT); 
                                ObjectSetInteger(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_WIDTH,1); 
                                ObjectSetInteger(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_BACK,true); 
                                ObjectSetInteger(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_RAY_RIGHT,false); 
                                ObjectSetInteger(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_HIDDEN,ObjectNotListed); 
                                ObjectSetInteger(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1);
                               }
                             // Create a vertical trend line to link Std Dev line above CBDR
                             ObjectCreate(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJ_TREND,0,CBDREndTime,CBDRHighest,CBDREndTime,CBDRHighest+(NumberOfStdDevToShow*CBDRStdDev));
                             ObjectSetInteger(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJPROP_COLOR,CBDRColorLine); 
                             ObjectSetInteger(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJPROP_STYLE,STYLE_DOT); 
                             ObjectSetInteger(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJPROP_WIDTH,1); 
                             ObjectSetInteger(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJPROP_BACK,true); 
                             ObjectSetInteger(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJPROP_RAY_RIGHT,false); 
                             ObjectSetInteger(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJPROP_HIDDEN,ObjectNotListed);
                             ObjectSetInteger(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1);
                             // Create a vertical trend line to link Std Dev line above CBDR
                             ObjectCreate(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJ_TREND,0,CBDREndTime,CBDRLowest,CBDREndTime,CBDRLowest-(NumberOfStdDevToShow*CBDRStdDev));
                             ObjectSetInteger(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJPROP_COLOR,CBDRColorLine); 
                             ObjectSetInteger(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJPROP_STYLE,STYLE_DOT); 
                             ObjectSetInteger(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJPROP_WIDTH,1); 
                             ObjectSetInteger(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJPROP_BACK,true); 
                             ObjectSetInteger(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJPROP_RAY_RIGHT,false); 
                             ObjectSetInteger(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJPROP_HIDDEN,ObjectNotListed);
                             ObjectSetInteger(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1);
                            }  // end if(Time[z] ==
                         } // end for(int z=0; z<=Bars-2; z++)
                      } // end for(int i=0; i<=DaystoGoBack; i++)
                   } // end case 0
                  break;
                  case 1:  // Show CBDR from Open / Close
                   {
                    Comment("CBDR Open / Close");
                    ShowCBDR++;
                    RemoveCBDR();
                    for(int i=DaystoGoBack; i>=0; i--) 
                      { 
                       int DayOffset = 60 *60 * 24 * i;
                       // Get current date, convert it to a string, modify the string to add the CBDR end hour, convert the string to datetime format
                       datetime CBDREndTime = StringToTime(StringConcatenate(TimeToString(TimeCurrent()-DayOffset, TIME_DATE)," ",ServerCBDREnd,":00:00"));
                       for(int z=0; z<Bars; z++) 
                         { 
                          // Find the highest and lowest price for the CBDR
                          //   1st step is to find the bar # that correspond to the KillZone end time
                          if(Time[z] == CBDREndTime && (TimeDayOfWeek(CBDREndTime)!=0 && TimeDayOfWeek(CBDREndTime-(CBDRDuration*60*60))!=0))
                            {
                             int CBDREndBar = z;
                             //  2nd step: find the highest price using High[bar# found in 1st step]
                             double CBDRHighest = MathMax(Open[iHighest(NULL,0,MODE_OPEN,(CBDRDuration*60/ChartPeriod(0)),CBDREndBar+1)],
                                                          Close[iHighest(NULL,0,MODE_CLOSE,(CBDRDuration*60/ChartPeriod(0)),CBDREndBar+1)]);
                             CBDRHighest = MathMax(CBDRHighest,Open[z]);
                             //  3rd step: find the lowest price using Low[bar# found in 1st step]
                             double CBDRLowest = MathMin(Open[iLowest(NULL,0,MODE_OPEN,(CBDRDuration*60/ChartPeriod(0)),CBDREndBar+1)],
                                                         Close[iLowest(NULL,0,MODE_CLOSE,(CBDRDuration*60/ChartPeriod(0)),CBDREndBar+1)]);
                             CBDRLowest = MathMin(CBDRLowest,Open[z]);
                             CreateKZ("CBDR"+IntegerToString(i), CBDREndTime-(CBDRDuration*3600), CBDREndTime, CBDRHighest, CBDRLowest, CBDRColor);
                             // Calculate 1 Standard Deviation of CBDR
                             double CBDRStdDev = CBDRHighest - CBDRLowest;
                             ObjectSetString(0,"CBDR"+IntegerToString(i),OBJPROP_TEXT,IntegerToString((int)MathRound(CBDRStdDev/(Point*FractionalPipDivider)))+" Pips"); 
                             // Create trend line for Std Dev above CBDR
                             for (int std=0; std<=NumberOfStdDevToShow; std++)
                               {
                                ObjectCreate(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJ_TREND,0,CBDREndTime,CBDRHighest+(std*CBDRStdDev),CBDREndTime+57600,CBDRHighest+(std*CBDRStdDev));
                                ObjectSetInteger(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_COLOR,CBDRColorLine); 
                                ObjectSetInteger(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_STYLE,STYLE_DOT); 
                                ObjectSetInteger(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_WIDTH,1); 
                                ObjectSetInteger(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_BACK,true); 
                                ObjectSetInteger(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_RAY_RIGHT,false); 
                                ObjectSetInteger(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_HIDDEN,ObjectNotListed); 
                                ObjectSetInteger(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1);
                               }
                             for (int std=0; std<=NumberOfStdDevToShow; std++)
                               {
                                ObjectCreate(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJ_TREND,0,CBDREndTime,CBDRLowest-(std*CBDRStdDev),CBDREndTime+57600,CBDRLowest-(std*CBDRStdDev));
                                ObjectSetInteger(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_COLOR,CBDRColorLine); 
                                ObjectSetInteger(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_STYLE,STYLE_DOT); 
                                ObjectSetInteger(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_WIDTH,1); 
                                ObjectSetInteger(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_BACK,true); 
                                ObjectSetInteger(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_RAY_RIGHT,false); 
                                ObjectSetInteger(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_HIDDEN,ObjectNotListed); 
                                ObjectSetInteger(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1);
                               }
                             // Create a vertical trend line to link Std Dev line above CBDR
                             ObjectCreate(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJ_TREND,0,CBDREndTime,CBDRHighest,CBDREndTime,CBDRHighest+(NumberOfStdDevToShow*CBDRStdDev));
                             ObjectSetInteger(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJPROP_COLOR,CBDRColorLine); 
                             ObjectSetInteger(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJPROP_STYLE,STYLE_DOT); 
                             ObjectSetInteger(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJPROP_WIDTH,1); 
                             ObjectSetInteger(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJPROP_BACK,true); 
                             ObjectSetInteger(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJPROP_RAY_RIGHT,false); 
                             ObjectSetInteger(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJPROP_HIDDEN,ObjectNotListed);
                             // Create a vertical trend line to link Std Dev line above CBDR
                             ObjectCreate(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJ_TREND,0,CBDREndTime,CBDRLowest,CBDREndTime,CBDRLowest-(NumberOfStdDevToShow*CBDRStdDev));
                             ObjectSetInteger(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJPROP_COLOR,CBDRColorLine); 
                             ObjectSetInteger(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJPROP_STYLE,STYLE_DOT); 
                             ObjectSetInteger(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJPROP_WIDTH,1); 
                             ObjectSetInteger(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJPROP_BACK,true); 
                             ObjectSetInteger(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJPROP_RAY_RIGHT,false); 
                             ObjectSetInteger(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJPROP_HIDDEN,ObjectNotListed);
                             ObjectSetInteger(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1);
                            }  // end if(Time[z] ==
                          } // end for(int z=0; z<=Bars-2; z++)
                      } // end for(int i=0; i<=DaystoGoBack; i++)
                   } // end case 1
                  break;
                  case 2:  // Show CBDR + Asia from Hi / Low
                   {
                    Comment("CBDR + Asia High / Low");
                    ShowCBDR++;
                    RemoveCBDR();
                    for(int i=DaystoGoBack; i>=0; i--) 
                      { 
                       int DayOffset = 60 *60 * 24 * i;
                       // Get current date, convert it to a string, modify the string to add the CBDR end hour, convert the string to datetime format
                       datetime CBDREndTime = StringToTime(StringConcatenate(TimeToString(TimeCurrent()-DayOffset, TIME_DATE)," ",ServerAsiaOpenEnd,":00:00"));
                       for(int z=0; z<Bars; z++) 
                         { 
                          // Find the highest and lowest price for the CBDR
                          //   1st step is to find the bar # that correspond to the KillZone end time
                          if(Time[z] == CBDREndTime && (TimeDayOfWeek(CBDREndTime)!=0 && TimeDayOfWeek(CBDREndTime-((CBDRandAsiaDuration)*60*60))!=0))
                            {
                             int CBDREndBar = z;
                             //  2nd step: find the highest price using High[bar# found in 1st step]
                             double CBDRHighest = MathMax(High[iHighest(NULL,0,MODE_HIGH,((CBDRandAsiaDuration)*60/ChartPeriod(0)),CBDREndBar+1)],Open[z]);
                             //  3rd step: find the lowest price using Low[bar# found in 1st step]
                             double CBDRLowest = MathMin(Low[iLowest(NULL,0,MODE_LOW,((CBDRandAsiaDuration)*60/ChartPeriod(0)),CBDREndBar+1)],Open[z]);
                             CreateKZ("CBDR"+IntegerToString(i), CBDREndTime-((CBDRandAsiaDuration)*3600), CBDREndTime, CBDRHighest, CBDRLowest, CBDRColor);
                             // Calculate 1 Standard Deviation of CBDR
                             double CBDRStdDev = CBDRHighest - CBDRLowest;
                             ObjectSetString(0,"CBDR"+IntegerToString(i),OBJPROP_TEXT,IntegerToString((int)MathRound(CBDRStdDev/(Point*FractionalPipDivider)))+" Pips"); 
                             // Create trend line for Std Dev above CBDR
                             for (int std=0; std<=NumberOfStdDevToShow; std++)
                               {
                                ObjectCreate(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJ_TREND,0,CBDREndTime,CBDRHighest+(std*CBDRStdDev),CBDREndTime+57600,CBDRHighest+(std*CBDRStdDev));
                                ObjectSetInteger(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_COLOR,CBDRColorLine); 
                                ObjectSetInteger(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_STYLE,STYLE_DOT); 
                                ObjectSetInteger(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_WIDTH,1); 
                                ObjectSetInteger(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_BACK,true); 
                                ObjectSetInteger(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_RAY_RIGHT,false); 
                                ObjectSetInteger(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_HIDDEN,ObjectNotListed); 
                                ObjectSetInteger(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1);
                               }
                             for (int std=0; std<=NumberOfStdDevToShow; std++)
                               {
                                ObjectCreate(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJ_TREND,0,CBDREndTime,CBDRLowest-(std*CBDRStdDev),CBDREndTime+57600,CBDRLowest-(std*CBDRStdDev));
                                ObjectSetInteger(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_COLOR,CBDRColorLine); 
                                ObjectSetInteger(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_STYLE,STYLE_DOT); 
                                ObjectSetInteger(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_WIDTH,1); 
                                ObjectSetInteger(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_BACK,true); 
                                ObjectSetInteger(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_RAY_RIGHT,false); 
                                ObjectSetInteger(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_HIDDEN,ObjectNotListed); 
                                ObjectSetInteger(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1);
                               }
                             // Create a vertical trend line to link Std Dev line above CBDR
                             ObjectCreate(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJ_TREND,0,CBDREndTime,CBDRHighest,CBDREndTime,CBDRHighest+(NumberOfStdDevToShow*CBDRStdDev));
                             ObjectSetInteger(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJPROP_COLOR,CBDRColorLine); 
                             ObjectSetInteger(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJPROP_STYLE,STYLE_DOT); 
                             ObjectSetInteger(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJPROP_WIDTH,1); 
                             ObjectSetInteger(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJPROP_BACK,true); 
                             ObjectSetInteger(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJPROP_RAY_RIGHT,false); 
                             ObjectSetInteger(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJPROP_HIDDEN,ObjectNotListed);
                             ObjectSetInteger(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1);
                             // Create a vertical trend line to link Std Dev line above CBDR
                             ObjectCreate(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJ_TREND,0,CBDREndTime,CBDRLowest,CBDREndTime,CBDRLowest-(NumberOfStdDevToShow*CBDRStdDev));
                             ObjectSetInteger(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJPROP_COLOR,CBDRColorLine); 
                             ObjectSetInteger(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJPROP_STYLE,STYLE_DOT); 
                             ObjectSetInteger(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJPROP_WIDTH,1); 
                             ObjectSetInteger(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJPROP_BACK,true); 
                             ObjectSetInteger(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJPROP_RAY_RIGHT,false); 
                             ObjectSetInteger(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJPROP_HIDDEN,ObjectNotListed);
                             ObjectSetInteger(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1);
                            }  // end if(Time[z] ==
                          } // end for(int z=0; z<=Bars-2; z++)
                      } // end for(int i=0; i<=DaystoGoBack; i++)
                   } // end case 2
                  break;
                  case 3:  // Show CBDR + Asia from Open / Close
                   {
                    Comment("CBDR + Asia Open / Close");
                    ShowCBDR++;
                    RemoveCBDR();
                    for(int i=DaystoGoBack; i>=0; i--) 
                      { 
                       int DayOffset = 60 *60 * 24 * i;
                       // Get current date, convert it to a string, modify the string to add the CBDR end hour, convert the string to datetime format
                       datetime CBDREndTime = StringToTime(StringConcatenate(TimeToString(TimeCurrent()-DayOffset, TIME_DATE)," ",ServerAsiaOpenEnd,":00:00"));
                       for(int z=0; z<Bars; z++) 
                         { 
                          // Find the highest and lowest price for the CBDR
                          //   1st step is to find the bar # that correspond to the KillZone end time
                          if(Time[z] == CBDREndTime && (TimeDayOfWeek(CBDREndTime)!=0 && TimeDayOfWeek(CBDREndTime-((CBDRandAsiaDuration)*60*60))!=0))
                            {
                             int CBDREndBar = z;
                             //  2nd step: find the highest price using High[bar# found in 1st step]
                             double CBDRHighest = MathMax(Open[iHighest(NULL,0,MODE_OPEN,((CBDRandAsiaDuration)*60/ChartPeriod(0)),CBDREndBar+1)],
                                                          Close[iHighest(NULL,0,MODE_CLOSE,((CBDRandAsiaDuration)*60/ChartPeriod(0)),CBDREndBar+1)]);
                             CBDRHighest = MathMax(CBDRHighest,Open[z]);
                             //  3rd step: find the lowest price using Low[bar# found in 1st step]
                             double CBDRLowest = MathMin(Open[iLowest(NULL,0,MODE_OPEN,((CBDRandAsiaDuration)*60/ChartPeriod(0)),CBDREndBar+1)],
                                                         Close[iLowest(NULL,0,MODE_CLOSE,((CBDRandAsiaDuration)*60/ChartPeriod(0)),CBDREndBar+1)]);
                             CBDRLowest = MathMin(CBDRLowest,Open[z]);
                             CreateKZ("CBDR"+IntegerToString(i), CBDREndTime-((CBDRandAsiaDuration)*3600), CBDREndTime, CBDRHighest, CBDRLowest, CBDRColor);
                             // Calculate 1 Standard Deviation of CBDR
                             double CBDRStdDev = CBDRHighest - CBDRLowest;
                             ObjectSetString(0,"CBDR"+IntegerToString(i),OBJPROP_TEXT,IntegerToString((int)MathRound(CBDRStdDev/(Point*FractionalPipDivider)))+" Pips"); 
                             // Create trend line for Std Dev above CBDR
                             for (int std=0; std<=NumberOfStdDevToShow; std++)
                               {
                                ObjectCreate(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJ_TREND,0,CBDREndTime,CBDRHighest+(std*CBDRStdDev),CBDREndTime+57600,CBDRHighest+(std*CBDRStdDev));
                                ObjectSetInteger(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_COLOR,CBDRColorLine); 
                                ObjectSetInteger(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_STYLE,STYLE_DOT); 
                                ObjectSetInteger(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_WIDTH,1); 
                                ObjectSetInteger(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_BACK,true); 
                                ObjectSetInteger(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_RAY_RIGHT,false); 
                                ObjectSetInteger(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_HIDDEN,ObjectNotListed); 
                                ObjectSetInteger(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1);
                               }
                             for (int std=0; std<=NumberOfStdDevToShow; std++)
                               {
                                ObjectCreate(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJ_TREND,0,CBDREndTime,CBDRLowest-(std*CBDRStdDev),CBDREndTime+57600,CBDRLowest-(std*CBDRStdDev));
                                ObjectSetInteger(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_COLOR,CBDRColorLine); 
                                ObjectSetInteger(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_STYLE,STYLE_DOT); 
                                ObjectSetInteger(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_WIDTH,1); 
                                ObjectSetInteger(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_BACK,true); 
                                ObjectSetInteger(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_RAY_RIGHT,false); 
                                ObjectSetInteger(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_HIDDEN,ObjectNotListed); 
                                ObjectSetInteger(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1);
                               }
                             // Create a vertical trend line to link Std Dev line above CBDR
                             ObjectCreate(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJ_TREND,0,CBDREndTime,CBDRHighest,CBDREndTime,CBDRHighest+(NumberOfStdDevToShow*CBDRStdDev));
                             ObjectSetInteger(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJPROP_COLOR,CBDRColorLine); 
                             ObjectSetInteger(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJPROP_STYLE,STYLE_DOT); 
                             ObjectSetInteger(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJPROP_WIDTH,1); 
                             ObjectSetInteger(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJPROP_BACK,true); 
                             ObjectSetInteger(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJPROP_RAY_RIGHT,false); 
                             ObjectSetInteger(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJPROP_HIDDEN,ObjectNotListed);
                             ObjectSetInteger(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1);
                             // Create a vertical trend line to link Std Dev line above CBDR
                             ObjectCreate(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJ_TREND,0,CBDREndTime,CBDRLowest,CBDREndTime,CBDRLowest-(NumberOfStdDevToShow*CBDRStdDev));
                             ObjectSetInteger(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJPROP_COLOR,CBDRColorLine); 
                             ObjectSetInteger(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJPROP_STYLE,STYLE_DOT); 
                             ObjectSetInteger(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJPROP_WIDTH,1); 
                             ObjectSetInteger(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJPROP_BACK,true); 
                             ObjectSetInteger(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJPROP_RAY_RIGHT,false); 
                             ObjectSetInteger(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJPROP_HIDDEN,ObjectNotListed);
                             ObjectSetInteger(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1);
                            }  // end if(Time[z] ==
                          } // end for(int z=0; z<=Bars-2; z++)
                      } // end for(int i=0; i<=DaystoGoBack; i++)
                   } // end case 3
                  break;
                  case 4:  // Show Asia from Hi / Low
                   {
                    Comment("Asia High / Low");
                    ShowCBDR++;
                    RemoveCBDR();
                    for(int i=DaystoGoBack; i>=0; i--) 
                      { 
                       int DayOffset = 60 *60 * 24 * i;
                       // Get current date, convert it to a string, modify the string to add the CBDR end hour, convert the string to datetime format
                       datetime CBDREndTime = StringToTime(StringConcatenate(TimeToString(TimeCurrent()-DayOffset, TIME_DATE)," ",ServerAsiaOpenEnd,":00:00"));
                       for(int z=0; z<Bars; z++) 
                         { 
                          // Find the highest and lowest price for the CBDR
                          //   1st step is to find the bar # that correspond to the KillZone end time
                          if(Time[z] == CBDREndTime && (TimeDayOfWeek(CBDREndTime)!=0 && TimeDayOfWeek(CBDREndTime-(AsiaOpenDuration*60*60))!=0))
                            {
                             int CBDREndBar = z;
                             //  2nd step: find the highest price using High[bar# found in 1st step]
                             double CBDRHighest = MathMax(High[iHighest(NULL,0,MODE_HIGH,(AsiaOpenDuration*60/ChartPeriod(0)),CBDREndBar+1)],Open[z]);
                             //  3rd step: find the lowest price using Low[bar# found in 1st step]
                             double CBDRLowest = MathMin(Low[iLowest(NULL,0,MODE_LOW,(AsiaOpenDuration*60/ChartPeriod(0)),CBDREndBar+1)],Open[z]);
                             CreateKZ("CBDR"+IntegerToString(i), CBDREndTime-(AsiaOpenDuration*3600), CBDREndTime, CBDRHighest, CBDRLowest, CBDRColor);
                             // Calculate 1 Standard Deviation of CBDR
                             double CBDRStdDev = CBDRHighest - CBDRLowest;
                             ObjectSetString(0,"CBDR"+IntegerToString(i),OBJPROP_TEXT,IntegerToString((int)MathRound(CBDRStdDev/(Point*FractionalPipDivider)))+" Pips"); 
                             // Create trend line for Std Dev above CBDR
                             for (int std=0; std<=NumberOfStdDevToShow; std++)
                               {
                                ObjectCreate(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJ_TREND,0,CBDREndTime,CBDRHighest+(std*CBDRStdDev),CBDREndTime+57600,CBDRHighest+(std*CBDRStdDev));
                                ObjectSetInteger(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_COLOR,CBDRColorLine); 
                                ObjectSetInteger(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_STYLE,STYLE_DOT); 
                                ObjectSetInteger(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_WIDTH,1); 
                                ObjectSetInteger(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_BACK,true); 
                                ObjectSetInteger(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_RAY_RIGHT,false); 
                                ObjectSetInteger(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_HIDDEN,ObjectNotListed); 
                                ObjectSetInteger(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1);
                               }
                             for (int std=0; std<=NumberOfStdDevToShow; std++)
                               {
                                ObjectCreate(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJ_TREND,0,CBDREndTime,CBDRLowest-(std*CBDRStdDev),CBDREndTime+57600,CBDRLowest-(std*CBDRStdDev));
                                ObjectSetInteger(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_COLOR,CBDRColorLine); 
                                ObjectSetInteger(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_STYLE,STYLE_DOT); 
                                ObjectSetInteger(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_WIDTH,1); 
                                ObjectSetInteger(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_BACK,true); 
                                ObjectSetInteger(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_RAY_RIGHT,false); 
                                ObjectSetInteger(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_HIDDEN,ObjectNotListed); 
                                ObjectSetInteger(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1);
                               }
                             // Create a vertical trend line to link Std Dev line above CBDR
                             ObjectCreate(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJ_TREND,0,CBDREndTime,CBDRHighest,CBDREndTime,CBDRHighest+(NumberOfStdDevToShow*CBDRStdDev));
                             ObjectSetInteger(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJPROP_COLOR,CBDRColorLine); 
                             ObjectSetInteger(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJPROP_STYLE,STYLE_DOT); 
                             ObjectSetInteger(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJPROP_WIDTH,1); 
                             ObjectSetInteger(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJPROP_BACK,true); 
                             ObjectSetInteger(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJPROP_RAY_RIGHT,false); 
                             ObjectSetInteger(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJPROP_HIDDEN,ObjectNotListed);
                             ObjectSetInteger(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1);
                             // Create a vertical trend line to link Std Dev line above CBDR
                             ObjectCreate(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJ_TREND,0,CBDREndTime,CBDRLowest,CBDREndTime,CBDRLowest-(NumberOfStdDevToShow*CBDRStdDev));
                             ObjectSetInteger(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJPROP_COLOR,CBDRColorLine); 
                             ObjectSetInteger(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJPROP_STYLE,STYLE_DOT); 
                             ObjectSetInteger(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJPROP_WIDTH,1); 
                             ObjectSetInteger(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJPROP_BACK,true); 
                             ObjectSetInteger(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJPROP_RAY_RIGHT,false); 
                             ObjectSetInteger(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJPROP_HIDDEN,ObjectNotListed);
                             ObjectSetInteger(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1);
                            }  // end if(Time[z] ==
                          } // end for(int z=0; z<=Bars-2; z++)
                      } // end for(int i=0; i<=DaystoGoBack; i++)
                   } // end case 4
                  break;
                  case 5:  // Show Asia from Open / Close
                   {
                    Comment("Asia Open / Close");
                    ShowCBDR++;
                    RemoveCBDR();
                    for(int i=DaystoGoBack; i>=0; i--) 
                      { 
                       int DayOffset = 60 *60 * 24 * i;
                       // Get current date, convert it to a string, modify the string to add the CBDR end hour, convert the string to datetime format
                       datetime CBDREndTime = StringToTime(StringConcatenate(TimeToString(TimeCurrent()-DayOffset, TIME_DATE)," ",ServerAsiaOpenEnd,":00:00"));
                       for(int z=0; z<Bars; z++) 
                         { 
                          // Find the highest and lowest price for the CBDR
                          //   1st step is to find the bar # that correspond to the KillZone end time
                          if(Time[z] == CBDREndTime && (TimeDayOfWeek(CBDREndTime)!=0 && TimeDayOfWeek(CBDREndTime-(AsiaOpenDuration*60*60))!=0))
                            {
                             int CBDREndBar = z;
                             //  2nd step: find the highest price using High[bar# found in 1st step]
                             double CBDRHighest = MathMax(Open[iHighest(NULL,0,MODE_OPEN,(AsiaOpenDuration*60/ChartPeriod(0)),CBDREndBar+1)],
                                                          Close[iHighest(NULL,0,MODE_CLOSE,(AsiaOpenDuration*60/ChartPeriod(0)),CBDREndBar+1)]);
                             CBDRHighest = MathMax(CBDRHighest,Open[z]);
                             //  3rd step: find the lowest price using Low[bar# found in 1st step]
                             double CBDRLowest = MathMin(Open[iLowest(NULL,0,MODE_OPEN,(AsiaOpenDuration*60/ChartPeriod(0)),CBDREndBar+1)],
                                                         Close[iLowest(NULL,0,MODE_CLOSE,(AsiaOpenDuration*60/ChartPeriod(0)),CBDREndBar+1)]);
                             CBDRLowest = MathMin(CBDRLowest,Open[z]);
                             CreateKZ("CBDR"+IntegerToString(i), CBDREndTime-(AsiaOpenDuration*3600), CBDREndTime, CBDRHighest, CBDRLowest, CBDRColor);
                             // Calculate 1 Standard Deviation of CBDR
                             double CBDRStdDev = CBDRHighest - CBDRLowest;
                             ObjectSetString(0,"CBDR"+IntegerToString(i),OBJPROP_TEXT,IntegerToString((int)MathRound(CBDRStdDev/(Point*FractionalPipDivider)))+" Pips"); 
                             // Create trend line for Std Dev above CBDR
                             for (int std=0; std<=NumberOfStdDevToShow; std++)
                               {
                                ObjectCreate(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJ_TREND,0,CBDREndTime,CBDRHighest+(std*CBDRStdDev),CBDREndTime+57600,CBDRHighest+(std*CBDRStdDev));
                                ObjectSetInteger(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_COLOR,CBDRColorLine); 
                                ObjectSetInteger(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_STYLE,STYLE_DOT); 
                                ObjectSetInteger(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_WIDTH,1); 
                                ObjectSetInteger(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_BACK,true); 
                                ObjectSetInteger(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_RAY_RIGHT,false); 
                                ObjectSetInteger(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_HIDDEN,ObjectNotListed); 
                                ObjectSetInteger(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1);
                               }
                             for (int std=0; std<=NumberOfStdDevToShow; std++)
                               {
                                ObjectCreate(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJ_TREND,0,CBDREndTime,CBDRLowest-(std*CBDRStdDev),CBDREndTime+57600,CBDRLowest-(std*CBDRStdDev));
                                ObjectSetInteger(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_COLOR,CBDRColorLine); 
                                ObjectSetInteger(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_STYLE,STYLE_DOT); 
                                ObjectSetInteger(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_WIDTH,1); 
                                ObjectSetInteger(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_BACK,true); 
                                ObjectSetInteger(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_RAY_RIGHT,false); 
                                ObjectSetInteger(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_HIDDEN,ObjectNotListed); 
                                ObjectSetInteger(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1);
                               }
                             // Create a vertical trend line to link Std Dev line above CBDR
                             ObjectCreate(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJ_TREND,0,CBDREndTime,CBDRHighest,CBDREndTime,CBDRHighest+(NumberOfStdDevToShow*CBDRStdDev));
                             ObjectSetInteger(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJPROP_COLOR,CBDRColorLine); 
                             ObjectSetInteger(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJPROP_STYLE,STYLE_DOT); 
                             ObjectSetInteger(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJPROP_WIDTH,1); 
                             ObjectSetInteger(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJPROP_BACK,true); 
                             ObjectSetInteger(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJPROP_RAY_RIGHT,false); 
                             ObjectSetInteger(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJPROP_HIDDEN,ObjectNotListed);
                             ObjectSetInteger(0,"CBDR Std Dev +VL "+IntegerToString(i),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1);
                             // Create a vertical trend line to link Std Dev line above CBDR
                             ObjectCreate(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJ_TREND,0,CBDREndTime,CBDRLowest,CBDREndTime,CBDRLowest-(NumberOfStdDevToShow*CBDRStdDev));
                             ObjectSetInteger(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJPROP_COLOR,CBDRColorLine); 
                             ObjectSetInteger(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJPROP_STYLE,STYLE_DOT); 
                             ObjectSetInteger(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJPROP_WIDTH,1); 
                             ObjectSetInteger(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJPROP_BACK,true); 
                             ObjectSetInteger(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJPROP_RAY_RIGHT,false); 
                             ObjectSetInteger(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJPROP_HIDDEN,ObjectNotListed);
                             ObjectSetInteger(0,"CBDR Std Dev -VL "+IntegerToString(i),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1);
                            }  // end if(Time[z] ==
                          } // end for(int z=0; z<=Bars-2; z++)
                      } // end for(int i=0; i<=DaystoGoBack; i++)
                   } // end case 5
                  break;
                  case 6:   // Hide CBDR
                   {
                    Comment("");
                    ShowCBDR=0;
                    RemoveCBDR();
                   }
                  break;
                 } // end switch 
              } // end ChartPeriod() <=60
           } // end case Key_Show_CBDR
         break;
         case Key_Extend_Last_Object_Clicked:  // Extend last clicked object
           {
            datetime originaldate = (datetime)ObjectGetInteger(0,lastobjclicked,OBJPROP_TIME2);
            datetime newdate = originaldate + (60*60*24*NumberOfDaysToExtend);
            ObjectSetInteger(0,lastobjclicked,OBJPROP_TIME2,newdate);
           }
         break;
         case Key_Shrink_Last_Object_Clicked:  // Shrink last clicked object
           {
            datetime originaldate = (datetime)ObjectGetInteger(0,lastobjclicked,OBJPROP_TIME2);
            datetime newdate = originaldate - (60*60*24*NumberOfDaysToShrink);
            ObjectSetInteger(0,lastobjclicked,OBJPROP_TIME2,newdate);
           }
         break;
         case Key_Change_Line_Type_Of_Last_Object_Clicked:  // Change the Line Type of the last clicked object
           {
            switch((int)ObjectGetInteger(0,lastobjclicked,OBJPROP_STYLE))
              {
               case 0:
                 {
                  ObjectSetInteger(0,lastobjclicked,OBJPROP_STYLE,1); // STYLE_DASH
                 }
               break;
               case 1:
                 {
                  ObjectSetInteger(0,lastobjclicked,OBJPROP_STYLE,2);  // STYLE_DOT
                 }
               break;
               case 2:
                 {
                  ObjectSetInteger(0,lastobjclicked,OBJPROP_STYLE,3);  // STYLE_DASHDOT
                 }
               break;
               case 3:
                 {
                  ObjectSetInteger(0,lastobjclicked,OBJPROP_STYLE,4);  // STYLE_DASHDOTDOT
                 }
               break;
               case 4:
                 {
                  ObjectSetInteger(0,lastobjclicked,OBJPROP_STYLE,0);  // STYLE_SOLID
                 }
               break;
              }
           }
         break;
         case Key_Change_Line_Thickness_Of_Last_Object_Clicked:  // Change the Line Thickness of the last clicked object
           {
            switch((int)ObjectGetInteger(0,lastobjclicked,OBJPROP_WIDTH))
              {
               case 1:
                 {
                  ObjectSetInteger(0,lastobjclicked,OBJPROP_WIDTH,2);
                 }
               break;
               case 2:
                 {
                  ObjectSetInteger(0,lastobjclicked,OBJPROP_WIDTH,3);
                 }
               break;
               case 3:
                 {
                  ObjectSetInteger(0,lastobjclicked,OBJPROP_WIDTH,4);
                 }
               break;
               case 4:
                 {
                  ObjectSetInteger(0,lastobjclicked,OBJPROP_WIDTH,5);
                 }
               break;
               case 5:
                 {
                  ObjectSetInteger(0,lastobjclicked,OBJPROP_WIDTH,1);
                 }
               break;
              }
           }
         break;
         case Key_Convert_Trendline_To_Horizontal_Line:
           {
            double OldPrice = ObjectGetDouble(0,lastobjclicked,OBJPROP_PRICE);
            int OldColor = (int)ObjectGetInteger(0,lastobjclicked,OBJPROP_COLOR);
            int OldLineType = (int)ObjectGetInteger(0,lastobjclicked,OBJPROP_STYLE);
            int OldLineWidth =  (int)ObjectGetInteger(0,lastobjclicked,OBJPROP_WIDTH);
            datetime OldTime1 = (datetime)StringSubstr(lastobjclicked, StringFind(lastobjclicked, "@")+2);  
            string OldText = ObjectGetString(0,lastobjclicked,OBJPROP_TEXT);
            string OldToolTip = ObjectGetString(0,lastobjclicked,OBJPROP_TOOLTIP);
            int OldTimeFrames = (int)ObjectGetInteger(0,lastobjclicked,OBJPROP_TIMEFRAMES);
            switch(ObjectType(lastobjclicked))
              {
               case 1:  // It is a Horizontal Line
                 {
                  ObjectDelete(0,lastobjclicked);  // Delete the Horizontal Line
                  ObjectCreate(0,lastobjclicked,OBJ_TREND,0,OldTime1,OldPrice,TimeCurrent()+DaysToExtend,OldPrice);
                  ObjectSetInteger(0,lastobjclicked,OBJPROP_COLOR,OldColor);
                  ObjectSetInteger(0,lastobjclicked,OBJPROP_STYLE,OldLineType);
                  ObjectSetInteger(0,lastobjclicked,OBJPROP_WIDTH,OldLineWidth);
                  ObjectSetString(0,lastobjclicked,OBJPROP_TEXT,OldText);
                  ObjectSetString(0,lastobjclicked,OBJPROP_TOOLTIP,OldToolTip);
                  ObjectSetInteger(0,lastobjclicked,OBJPROP_TIMEFRAMES,OldTimeFrames);
                 }
               break;
               case 2:  // It is a Trendline
                 {
                  ObjectDelete(0,lastobjclicked);  // Delete the Horizontal Line
                  ObjectCreate(0,lastobjclicked,OBJ_HLINE,0,NULL,OldPrice);
                  ObjectSetInteger(0,lastobjclicked,OBJPROP_COLOR,OldColor);
                  ObjectSetInteger(0,lastobjclicked,OBJPROP_STYLE,OldLineType);
                  ObjectSetInteger(0,lastobjclicked,OBJPROP_WIDTH,OldLineWidth);
                  ObjectSetString(0,lastobjclicked,OBJPROP_TEXT,OldText);
                  ObjectSetString(0,lastobjclicked,OBJPROP_TOOLTIP,OldToolTip);
                  ObjectSetInteger(0,lastobjclicked,OBJPROP_TIMEFRAMES,OldTimeFrames);
                 }
               break;
              }
           }
         break;
         case Key_Create_Price_Label:
           {
            string CurrentPriceLableToCreate = "Price Label "+DoubleToString(ObjectGetDouble(0,lastobjclicked,OBJPROP_PRICE));
            if(CurrentPriceLableToCreate!=LastPriceLabelCreated)
              {
               // Find if a Price Label for the last object clicked already exist
               if(ObjectFind(0,CurrentPriceLableToCreate)==0)
                 {   // if the existing Price Label is a Right one, change it to a Left one
                  if(ObjectGet(CurrentPriceLableToCreate,OBJPROP_ARROWCODE)==6)
                    {
                     PriceLableSwitch=1;
                    }
                  else if(ObjectGet(CurrentPriceLableToCreate,OBJPROP_ARROWCODE)==5)
                    {
                     PriceLableSwitch=3;
                    }
                 }
               else // There is no price label so need to create one
                 {
                  PriceLableSwitch=0;
                 }
              }
            datetime PriceLabelLeftDate = (datetime)ObjectGetInteger(0,lastobjclicked,OBJPROP_TIME1);
            datetime PriceLabelRightDate = (datetime)ObjectGetInteger(0,lastobjclicked,OBJPROP_TIME2);
            switch(PriceLableSwitch)
              {
               case 0:  // Create a Right Price Label              
                 {
                  ObjectCreate(0,"Price Label "+DoubleToString(ObjectGetDouble(0,lastobjclicked,OBJPROP_PRICE)),OBJ_ARROW_RIGHT_PRICE,0,PriceLabelRightDate,ObjectGetDouble(0,lastobjclicked,OBJPROP_PRICE));
                  ObjectSetInteger(0,"Price Label "+DoubleToString(ObjectGetDouble(0,lastobjclicked,OBJPROP_PRICE)),OBJPROP_COLOR,ObjectGetInteger(0,lastobjclicked,OBJPROP_COLOR));
                  ObjectSetInteger(0,"Price Label "+DoubleToString(ObjectGetDouble(0,lastobjclicked,OBJPROP_PRICE)),OBJPROP_WIDTH,Price_Labels_Default_Size);
                  ObjectSetInteger(0,"Price Label "+DoubleToString(ObjectGetDouble(0,lastobjclicked,OBJPROP_PRICE)),OBJPROP_HIDDEN,ObjectNotListed);
                  LastPriceLabelCreated="Price Label "+DoubleToString(ObjectGetDouble(0,lastobjclicked,OBJPROP_PRICE));
                  PriceLableSwitch=1;
                 }
               break;
               case 1:  // Create a Left Price Label 
                 {
                  ObjectDelete(0,"Price Label "+DoubleToString(ObjectGetDouble(0,lastobjclicked,OBJPROP_PRICE)));
                  ObjectCreate(0,"Price Label "+DoubleToString(ObjectGetDouble(0,lastobjclicked,OBJPROP_PRICE)),OBJ_ARROW_LEFT_PRICE,0,PriceLabelLeftDate,ObjectGetDouble(0,lastobjclicked,OBJPROP_PRICE));
                  ObjectSetInteger(0,"Price Label "+DoubleToString(ObjectGetDouble(0,lastobjclicked,OBJPROP_PRICE)),OBJPROP_COLOR,ObjectGetInteger(0,lastobjclicked,OBJPROP_COLOR));
                  ObjectSetInteger(0,"Price Label "+DoubleToString(ObjectGetDouble(0,lastobjclicked,OBJPROP_PRICE)),OBJPROP_WIDTH,Price_Labels_Default_Size);
                  ObjectSetInteger(0,"Price Label "+DoubleToString(ObjectGetDouble(0,lastobjclicked,OBJPROP_PRICE)),OBJPROP_HIDDEN,ObjectNotListed);
                  LastPriceLabelCreated="Price Label "+DoubleToString(ObjectGetDouble(0,lastobjclicked,OBJPROP_PRICE));
                  PriceLableSwitch=2;
                 }
               break;
               case 2:  // Create a Right Price Label anchored on the current time
                 {
                  ObjectDelete(0,"Price Label "+DoubleToString(ObjectGetDouble(0,lastobjclicked,OBJPROP_PRICE)));
                  ObjectCreate(0,"Price Label "+DoubleToString(ObjectGetDouble(0,lastobjclicked,OBJPROP_PRICE)),OBJ_ARROW_LEFT_PRICE,0,TimeCurrent(),ObjectGetDouble(0,lastobjclicked,OBJPROP_PRICE));
                  ObjectSetInteger(0,"Price Label "+DoubleToString(ObjectGetDouble(0,lastobjclicked,OBJPROP_PRICE)),OBJPROP_COLOR,ObjectGetInteger(0,lastobjclicked,OBJPROP_COLOR));
                  ObjectSetInteger(0,"Price Label "+DoubleToString(ObjectGetDouble(0,lastobjclicked,OBJPROP_PRICE)),OBJPROP_WIDTH,Price_Labels_Default_Size);
                  ObjectSetInteger(0,"Price Label "+DoubleToString(ObjectGetDouble(0,lastobjclicked,OBJPROP_PRICE)),OBJPROP_HIDDEN,ObjectNotListed);
                  LastPriceLabelCreated="Price Label "+DoubleToString(ObjectGetDouble(0,lastobjclicked,OBJPROP_PRICE));
                  PriceLableSwitch=3;
                 }
               break;
               case 3:  // Delete Price Label
                 {
                  ObjectDelete(0,"Price Label "+DoubleToString(ObjectGetDouble(0,lastobjclicked,OBJPROP_PRICE)));
                  LastPriceLabelCreated="Price Label "+DoubleToString(ObjectGetDouble(0,lastobjclicked,OBJPROP_PRICE));
                  PriceLableSwitch=0;
                 }
               break;
              }
           }
         break;
         case Key_Show_Chart_Price_Scale:  // Show the Price Scale
           {
            if (show_scaleprev != GlobalVariableGet(show_scale))
              {
               GlobalVariableSet(show_scale,1);
               show_scaleprev= GlobalVariableGet(show_scale);
               scale();
              }
            else
              {
               GlobalVariableSet(show_scale,0);
               ObjectDelete(0,"scaleVline");
               ObjectDelete(0,"scaleH1line");
               ObjectDelete(0,"scaleH2line");
               ObjectDelete(0,"scaletext");
              }
           }
         break;
         case Key_Toggle_Fix_Scale:  // Toggle Scale fix option On/Off
           {
            switch((int)ChartGetInteger(0,CHART_SCALEFIX))
              {
               case 0:
                 {
                  ChartSetInteger(0,CHART_SCALEFIX,TRUE);
                  ChartRedraw(0);
                 }
               break;
               case 1:
                 {
                  ChartSetInteger(0,CHART_SCALEFIX,FALSE);
                  ChartRedraw(0);
                 }
               break;
              }
           }
         break;  
         case Key_Show_Server_And_Local_Time:  // Show the Local and Server Date/Time
           {
            if (show_timeprev != GlobalVariableGet(show_time))
              {
               GlobalVariableSet(show_time,1);
               show_timeprev= GlobalVariableGet(show_time);
               server_localdatetime();
               PnLTextPosition();
              }
            else
              {
               GlobalVariableSet(show_time,0);
               ObjectDelete(0,"ServerTimeTitle");
               ObjectDelete(0,"ServerTime");
               ObjectDelete(0,"LocalTimeTitle");
               ObjectDelete(0,"LocalTime");
               PnLTextPosition();
              }               
           }
         break;
         case Key_LastObject_Visibility:  // Set visibility of selected object to current timeframe and lower only
           {
            ObjectSetInteger(0,lastobjclicked,OBJPROP_TIMEFRAMES,PDArrayLineVisibility);
           }
         break;
         case Key_Show_Period_Separators:  // Show the Period Separators
           {
            switch((int)GlobalVariableGet(GV_ShowPeriodSeparators))
              {
               case 0:    // Show Daily lines from midnight London
                 {
                  Comment("Midnight Longon daily lines separator");
                  GlobalVariableSet(GV_ShowPeriodSeparators,1);
                  period_separators();
                 }
               break;
               case 1:    // Show daily lines from midnight NY
                 {
                  RemovePeriodSeparators();
                  Comment("Midnight New York daily lines separator");
                  GlobalVariableSet(GV_ShowPeriodSeparators,2);
                  period_separators();
                 }
               break;
               case 2:   // Show true day begin and and lines
                 {
                  RemovePeriodSeparators();
                  Comment("True Day lines separator");
                  GlobalVariableSet(GV_ShowPeriodSeparators,3);
                  period_separators();
                 }
               break;
               case 3:   // Show CME Futures Session separator lines
                 {
                  RemovePeriodSeparators();
                  Comment("CME Futures New Day lines separator (ie 17h00 Chicago)");
                  GlobalVariableSet(GV_ShowPeriodSeparators,4);
                  period_separators();
                 }
               break;
               case 4:   // Do not show period separator lines
                 {
                  Comment("Period lines separator removed");
                  GlobalVariableSet(GV_ShowPeriodSeparators,0);
                  RemovePeriodSeparators();
                 }
               break;
              }
           }
         break;
         case Key_Daily_Projection_Lines:  // Show the Daily Price Projection lines
           {
            switch(DailyProjectionLineState)
              {
               case 0:  // Show projection from midnight London
                 {
                  if((ChartPeriod(0)<=240))
                    {
                     int counter=0;
                     for(int i=Bars-1; i>0; i--)
                       {
                        if(TimeDayOfWeek(Time[i])>0+ServerMidnightLondonDayOffset && TimeHour(Time[i])==ServerMidnightLondon && TimeMinute(Time[i])==0)
                          {
                           double MidnightOpenPrice = Open[i];
                           string Opendate = TimeToString(Time[i],TIME_DATE);
                           counter++;
                           ObjectCreate("TrueDayOpenPrice"+IntegerToString(counter),OBJ_TREND,0,Time[i],MidnightOpenPrice,Time[i]+DailyOpenPriceLineLength,MidnightOpenPrice);
                           ObjectSetInteger(0,"TrueDayOpenPrice"+IntegerToString(counter),OBJPROP_COLOR,DailyProjectionLineColor); // Color value to set/get object color.
                           ObjectSetInteger(0,"TrueDayOpenPrice"+IntegerToString(counter),OBJPROP_STYLE,STYLE_DOT); // Value is one of STYLE_SOLID, STYLE_DASH, STYLE_DOT, STYLE_DASHDOT, STYLE_DASHDOTDOT constants to set/get object line style.
                           ObjectSetInteger(0,"TrueDayOpenPrice"+IntegerToString(counter),OBJPROP_WIDTH,1); // Integer value to set/get object line width. Can be from 1 to 5.
                           ObjectSetInteger(0,"TrueDayOpenPrice"+IntegerToString(counter),OBJPROP_BACK,false); // Boolean value to set/get background drawing flag for object. (for example "true" will hide the value at the bottom of the chart.)
                           ObjectSetInteger(0,"TrueDayOpenPrice"+IntegerToString(counter),OBJPROP_RAY,false); // Boolean value to set/get ray flag of object. (for example "true" will extend the line to the right edge.)
                           ObjectSetInteger(0,"TrueDayOpenPrice"+IntegerToString(counter),OBJPROP_HIDDEN,ObjectNotListed);
                           ObjectSetString(0,"TrueDayOpenPrice"+IntegerToString(counter),OBJPROP_TOOLTIP,"Daily Open Price Projection\n"+Opendate+"\n"+DoubleToString(MidnightOpenPrice,(int)MarketInfo("0",MODE_DIGITS)));
                           ObjectSetInteger(0,"TrueDayOpenPrice"+IntegerToString(counter),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1|OBJ_PERIOD_H4);
                          }
                       }
                     DailyProjectionLineState=1;
                     Comment("Daily price projection from midnignt London active");
                    }
                 } 
               break;
               case 1:  // Show projection from midnight New York
                 {
                  if((ChartPeriod(0)<=240))
                    {   
                     for(int i=0; i<Bars-1; i++)   // Delete old bars first. 
                       {
                        ObjectDelete(0,"TrueDayOpenPrice"+IntegerToString(i));
                       }
                     int counter=0;
                     for(int i=Bars-1; i>0; i--)
                       {
                        if(TimeDayOfWeek(Time[i])>0+ServerMidnightNYDayOffset && TimeHour(Time[i])==ServerMidnightNY && TimeMinute(Time[i])==0)
                          {
                           double MidnightOpenPrice = Open[i];
                           string Opendate = TimeToString(Time[i],TIME_DATE);
                           counter++;
                           ObjectCreate("TrueDayOpenPrice"+IntegerToString(counter),OBJ_TREND,0,Time[i],MidnightOpenPrice,Time[i]+DailyOpenPriceLineLength,MidnightOpenPrice);
                           ObjectSetInteger(0,"TrueDayOpenPrice"+IntegerToString(counter),OBJPROP_COLOR,DailyProjectionLineColor); // Color value to set/get object color.
                           ObjectSetInteger(0,"TrueDayOpenPrice"+IntegerToString(counter),OBJPROP_STYLE,STYLE_DOT); // Value is one of STYLE_SOLID, STYLE_DASH, STYLE_DOT, STYLE_DASHDOT, STYLE_DASHDOTDOT constants to set/get object line style.
                           ObjectSetInteger(0,"TrueDayOpenPrice"+IntegerToString(counter),OBJPROP_WIDTH,1); // Integer value to set/get object line width. Can be from 1 to 5.
                           ObjectSetInteger(0,"TrueDayOpenPrice"+IntegerToString(counter),OBJPROP_BACK,false); // Boolean value to set/get background drawing flag for object. (for example "true" will hide the value at the bottom of the chart.)
                           ObjectSetInteger(0,"TrueDayOpenPrice"+IntegerToString(counter),OBJPROP_RAY,false); // Boolean value to set/get ray flag of object. (for example "true" will extend the line to the right edge.)
                           ObjectSetInteger(0,"TrueDayOpenPrice"+IntegerToString(counter),OBJPROP_HIDDEN,ObjectNotListed);
                           ObjectSetString(0,"TrueDayOpenPrice"+IntegerToString(counter),OBJPROP_TOOLTIP,"Daily Open Price Projection\n"+Opendate+"\n"+DoubleToString(MidnightOpenPrice,(int)MarketInfo("0",MODE_DIGITS)));
                           ObjectSetInteger(0,"TrueDayOpenPrice"+IntegerToString(counter),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1|OBJ_PERIOD_H4);
                          }
                       }
                     DailyProjectionLineState=2;
                     Comment("Daily price projection from midnight New York active");
                    }
                 } 
               break;
               case 2:  // Show projection from CME open
                 {
                  if((ChartPeriod(0)<=240))
                    {   
                     for(int i=0; i<Bars-1; i++)   // Delete old bars first. 
                       {
                        ObjectDelete(0,"TrueDayOpenPrice"+IntegerToString(i));
                       }
                     int counter=0;
                     if((ChartPeriod(0)<=15))
                       {
                        DailyProjectionLineState=3;
                        for(int i=Bars-1; i>0; i--)
                          {
                           if(TimeDayOfWeek(Time[i])>0 && TimeHour(Time[i])==(ServerCMEOpenHour) && TimeMinute(Time[i])==CMEOpenMinutes)
                             {
                              double TrueDayOpenPrice = Open[i];
                              string Opendate = TimeToString(Time[i],TIME_DATE);
                              counter++;
                              ObjectCreate("TrueDayOpenPrice"+IntegerToString(counter),OBJ_TREND,0,Time[i],TrueDayOpenPrice,Time[i]+DailyOpenPriceLineLength,TrueDayOpenPrice);
                              ObjectSetInteger(0,"TrueDayOpenPrice"+IntegerToString(counter),OBJPROP_COLOR,DailyProjectionLineColor); // Color value to set/get object color.
                              ObjectSetInteger(0,"TrueDayOpenPrice"+IntegerToString(counter),OBJPROP_STYLE,STYLE_DOT); // Value is one of STYLE_SOLID, STYLE_DASH, STYLE_DOT, STYLE_DASHDOT, STYLE_DASHDOTDOT constants to set/get object line style.
                              ObjectSetInteger(0,"TrueDayOpenPrice"+IntegerToString(counter),OBJPROP_WIDTH,1); // Integer value to set/get object line width. Can be from 1 to 5.
                              ObjectSetInteger(0,"TrueDayOpenPrice"+IntegerToString(counter),OBJPROP_BACK,false); // Boolean value to set/get background drawing flag for object. (for example "true" will hide the value at the bottom of the chart.)
                              ObjectSetInteger(0,"TrueDayOpenPrice"+IntegerToString(counter),OBJPROP_RAY,false); // Boolean value to set/get ray flag of object. (for example "true" will extend the line to the right edge.)
                              ObjectSetInteger(0,"TrueDayOpenPrice"+IntegerToString(counter),OBJPROP_HIDDEN,ObjectNotListed);
                              ObjectSetString(0,"TrueDayOpenPrice"+IntegerToString(counter),OBJPROP_TOOLTIP,"Daily Open Price Projection\n"+Opendate+"\n"+DoubleToString(TrueDayOpenPrice,(int)MarketInfo("0",MODE_DIGITS)));
                              ObjectSetInteger(0,"TrueDayOpenPrice"+IntegerToString(counter),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1|OBJ_PERIOD_H4);
                              Comment("Daily price projection from CME Open active");
                             }
                          }
                       }
                     else
                       {
                        Comment("Daily price projection lines removed");
                        DailyProjectionLineState=0;
                       }
                    }
                 } 
               break;
               case 3:
                 {
                  for(int i=0; i<Bars-1; i++)
                    {
                     ObjectDelete(0,"TrueDayOpenPrice"+IntegerToString(i));
                    }
                  DailyProjectionLineState=0;
                  Comment("Daily price projection lines removed");
                 }
               break;
              }
           }
         break;
         case Key_Weekly_Projection_Lines:  // Show Weekly Price Projection lines
            {
             switch(WeeklyProjectionLineState)
               {
                case 0:  // Show Weekly Projection Lines from Midnight London
                  {
                   if((ChartPeriod(0)<=240))
                     {   
                      int counter=0;
                      for(int i=Bars-1; i>0; i--)
                        {
                         if(TimeDayOfWeek(Time[i])==1+ServerMidnightLondonDayOffset && TimeHour(Time[i])==ServerMidnightLondon && TimeMinute(Time[i])==0)
                           {
                            double MidnightOpenPrice = Open[i];
                            string Opendate = TimeToString(Time[i],TIME_DATE);
                            counter++;
                            ObjectCreate("WeeklyOpenPrice"+IntegerToString(counter),OBJ_TREND,0,Time[i],MidnightOpenPrice,Time[i]+WeeklyOpenPriceLineLength,MidnightOpenPrice);
                            ObjectSetInteger(0,"WeeklyOpenPrice"+IntegerToString(counter),OBJPROP_COLOR,WeeklyProjectionLineColor); // Color value to set/get object color.
                            ObjectSetInteger(0,"WeeklyOpenPrice"+IntegerToString(counter),OBJPROP_STYLE,STYLE_DOT); // Value is one of STYLE_SOLID, STYLE_DASH, STYLE_DOT, STYLE_DASHDOT, STYLE_DASHDOTDOT constants to set/get object line style.
                            ObjectSetInteger(0,"WeeklyOpenPrice"+IntegerToString(counter),OBJPROP_WIDTH,1); // Integer value to set/get object line width. Can be from 1 to 5.
                            ObjectSetInteger(0,"WeeklyOpenPrice"+IntegerToString(counter),OBJPROP_BACK,false); // Boolean value to set/get background drawing flag for object. (for example "true" will hide the value at the bottom of the chart.)
                            ObjectSetInteger(0,"WeeklyOpenPrice"+IntegerToString(counter),OBJPROP_RAY,false); // Boolean value to set/get ray flag of object. (for example "true" will extend the line to the right edge.)
                            ObjectSetInteger(0,"WeeklyOpenPrice"+IntegerToString(counter),OBJPROP_HIDDEN,ObjectNotListed);
                            ObjectSetString(0,"WeeklyOpenPrice"+IntegerToString(counter),OBJPROP_TOOLTIP,"Weekly Open Price Projection\n"+Opendate+"\n"+DoubleToString(MidnightOpenPrice,(int)MarketInfo("0",MODE_DIGITS)));
                            ObjectSetInteger(0,"WeeklyOpenPrice"+IntegerToString(counter),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1|OBJ_PERIOD_H4);
                           }
                        }
                      Comment("Weekly price projection from midnight London active");
                      if(WeeklyProjectionLineGMTOnly)
                        {
                         WeeklyProjectionLineState=2;
                        }
                      else
                        {
                         WeeklyProjectionLineState=1;
                        }
                     }
                  }
                break;
                case 1:  // Show Weekly Projection Lines from midnight NY
                  {
                   if((ChartPeriod(0)<=240))
                     {
                      for(int i=0; i<Bars-1; i++)
                        {
                         ObjectDelete(0,"WeeklyOpenPrice"+IntegerToString(i));
                        }
                      int counter=0;
                      for(int i=Bars-1; i>0; i--)
                        {
                         if(TimeDayOfWeek(Time[i])==1+ServerMidnightNYDayOffset && TimeHour(Time[i])==ServerMidnightNY && TimeMinute(Time[i])==0)
                           {
                            double MidnightOpenPrice = Open[i];
                            string Opendate = TimeToString(Time[i],TIME_DATE);
                            counter++;
                            ObjectCreate("WeeklyOpenPrice"+IntegerToString(counter),OBJ_TREND,0,Time[i],MidnightOpenPrice,Time[i]+WeeklyOpenPriceLineLength,MidnightOpenPrice);
                            ObjectSetInteger(0,"WeeklyOpenPrice"+IntegerToString(counter),OBJPROP_COLOR,WeeklyProjectionLineColor); // Color value to set/get object color.
                            ObjectSetInteger(0,"WeeklyOpenPrice"+IntegerToString(counter),OBJPROP_STYLE,STYLE_DOT); // Value is one of STYLE_SOLID, STYLE_DASH, STYLE_DOT, STYLE_DASHDOT, STYLE_DASHDOTDOT constants to set/get object line style.
                            ObjectSetInteger(0,"WeeklyOpenPrice"+IntegerToString(counter),OBJPROP_WIDTH,1); // Integer value to set/get object line width. Can be from 1 to 5.
                            ObjectSetInteger(0,"WeeklyOpenPrice"+IntegerToString(counter),OBJPROP_BACK,false); // Boolean value to set/get background drawing flag for object. (for example "true" will hide the value at the bottom of the chart.)
                            ObjectSetInteger(0,"WeeklyOpenPrice"+IntegerToString(counter),OBJPROP_RAY,false); // Boolean value to set/get ray flag of object. (for example "true" will extend the line to the right edge.)
                            ObjectSetInteger(0,"WeeklyOpenPrice"+IntegerToString(counter),OBJPROP_HIDDEN,ObjectNotListed);
                            ObjectSetString(0,"WeeklyOpenPrice"+IntegerToString(counter),OBJPROP_TOOLTIP,"Weekly Open Price Projection\n"+Opendate+"\n"+DoubleToString(MidnightOpenPrice,(int)MarketInfo("0",MODE_DIGITS)));
                            ObjectSetInteger(0,"WeeklyOpenPrice"+IntegerToString(counter),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1|OBJ_PERIOD_H4);
                           }
                        }
                      Comment("Weekly price projection from midnight New York active");
                      WeeklyProjectionLineState=2;
                     }
                  }
                break;
                case 2:   // Remove Weekly Projection Lines
                  {
                   for(int i=0; i<Bars-1; i++)
                     {
                      ObjectDelete(0,"WeeklyOpenPrice"+IntegerToString(i));
                     }
                   Comment("Weekly price projection lines removed");
                   WeeklyProjectionLineState=0;
                  }
                break;
               }
            }
         break;
         case Key_Show_Trade_Level_Lines:  // Show or hide the trade levels lines
           {
            if(!Backtesting_Mode)
              {
               switch(ShowPriceLines)
                 {
                  case false:   // Price lines presently hidden, make it visible
                    {
                     ChartSetInteger(0,CHART_SHOW_TRADE_LEVELS,0,1);
                     ChartSetInteger(0,CHART_SHOW_ASK_LINE,1);
                     ChartSetInteger(0,CHART_SHOW_BID_LINE,1);
                     ChartRedraw(0);
                     ShowPriceLines=1;
                    }
                  break;
                  case true:   // Price lines presenlty visible, hide them
                    {
                     ChartSetInteger(0,CHART_SHOW_TRADE_LEVELS,0,0);
                     ChartSetInteger(0,CHART_SHOW_ASK_LINE,0);
                     ChartSetInteger(0,CHART_SHOW_BID_LINE,0);
                     ChartRedraw(0);
                     ShowPriceLines=0;
                    }
                  break;
                 }
              }
           }
         break;
         case Key_Show_Fib_Retracement:  // Show or hide Fibonacci retracements
           {
            if(ShowFiboPrev != ShowFibo)  // Hide Fibo
              {
               ShowFibo=OBJ_NO_PERIODS;
              }
            else   // Show Fibo
              {
               ShowFiboPrev=ShowFibo;
               ShowFibo=OBJ_ALL_PERIODS;
              }
            int TotalObject;
            TotalObject = ObjectsTotal(0,0,-1);  // Get total # of OBJ on the chart
            for(int i=TotalObject; i >= 0; i--) 
              {
               if(StringFind(ObjectName(0,i,0,-1),"Fibo ",0)==0) ObjectSetInteger(0,ObjectName(0,i,0,-1),OBJPROP_TIMEFRAMES,ShowFibo);
              }
            ChartRedraw(0);
           }
         break;
         case Key_Set_Chart_Auto_Scroll:  // Switch between Autoscroll ON/OFF 
           {
            if(!Backtesting_Mode)
              {
               if(ChartGetInteger(0,CHART_AUTOSCROLL,0))
                 {
                  ChartSetInteger(0,CHART_AUTOSCROLL,FALSE);
                 }
               else
                 {
                  ChartSetInteger(0,CHART_AUTOSCROLL,TRUE);
                 }
              }
           }
         break;
         case Key_Change_Timeframe_Down:  // Set current chart one Timeframe down 
           {
            if(ChartPeriod(0)==5)
              {
               ChartSetSymbolPeriod(0,NULL,1);
              }
            else if(ChartPeriod(0)==15)
              {
               ChartSetSymbolPeriod(0,NULL,5);
              }
            else if(ChartPeriod(0)==30)
              {
               ChartSetSymbolPeriod(0,NULL,15);
              }
            else if(ChartPeriod(0)==60)
              {
               ChartSetSymbolPeriod(0,NULL,30);
              }
            else if(ChartPeriod(0)==240)
              {
               ChartSetSymbolPeriod(0,NULL,60);
              }
            else if(ChartPeriod(0)==1440)
              {
               ChartSetSymbolPeriod(0,NULL,240);
              }
            else if (ChartPeriod(0)==10080)
              {
               ChartSetSymbolPeriod(0,NULL,1440);
              }
            else if (ChartPeriod(0)==43200)
              {
               ChartSetSymbolPeriod(0,NULL,10080);
              }
           }
         break;     
         case Key_Change_Timeframe_Up:  // Set current chart one Timeframe up 
           {
            if(ChartPeriod(0)==10080)
              {
               ChartSetSymbolPeriod(0,NULL,43200);
              }
            else if(ChartPeriod(0)==1440)
              {
               ChartSetSymbolPeriod(0,NULL,10080);
              }
            else if(ChartPeriod(0)==240)
              {
               ChartSetSymbolPeriod(0,NULL,1440);
              }
            else if(ChartPeriod(0)==60)
              {
               ChartSetSymbolPeriod(0,NULL,240);
              }
            else if(ChartPeriod(0)==30)
              {
               ChartSetSymbolPeriod(0,NULL,60);
              }
            else if (ChartPeriod(0)==15)
              {
               ChartSetSymbolPeriod(0,NULL,30);
              }
            else if (ChartPeriod(0)==5)
              {
               ChartSetSymbolPeriod(0,NULL,15);
              }
            else if (ChartPeriod(0)==1)
              {
               ChartSetSymbolPeriod(0,NULL,5);
              }
           }
         break;
         case Key_Show_ADR:  // Show ADR, AWR or Open Profit/Loss
           {
            switch((int)GlobalVariableGet(StringConcatenate("GV_ShowADRState_",SymbolInfoString("0",SYMBOL_DESCRIPTION))))
              {
               case 0:   // Show ADR and AWR
                 {
                  GlobalVariableSet(StringConcatenate("GV_ShowADRState_",SymbolInfoString("0",SYMBOL_DESCRIPTION)),1);
                  for(int i=0;i<=5;i++)
                    {
                     ObjectCreate("DR Title"+IntegerToString(i),OBJ_LABEL, 0, 0, 0);         
                     ObjectSet("DR Title"+IntegerToString(i),OBJPROP_CORNER, ADRDisplayCorner);
                     ObjectSet("DR Title"+IntegerToString(i),OBJPROP_XDISTANCE,ADR_x_StartingPosition*RetinaScaling);
                     ObjectSet("DR Title"+IntegerToString(i),OBJPROP_YDISTANCE,(ADR_y_StartingPosition+(i*15))*RetinaScaling);
                     ObjectSet("DR Title"+IntegerToString(i),OBJPROP_SELECTABLE,false);
                     ObjectSet("DR Title"+IntegerToString(i),OBJPROP_HIDDEN,ObjectNotListed);
                     if(i==0) ObjectSetText("DR Title"+IntegerToString(i),"Daily Range (pips)",font_size+1, font_face, ADR_Font_Color);
                     else if(i==1) ObjectSetText("DR Title"+IntegerToString(i),"Yesterday",font_size, font_face, ADR_Font_Color);
                     else ObjectSetText("DR Title"+IntegerToString(i),IntegerToString(i)+" days ago",font_size, font_face, ADR_Font_Color);
                     if(i>=1)
                       {
                        ObjectCreate("DR Value"+IntegerToString(i),OBJ_LABEL, 0, 0, 0);         
                        ObjectSet("DR Value"+IntegerToString(i),OBJPROP_CORNER, ADRDisplayCorner);
                        ObjectSet("DR Value"+IntegerToString(i),OBJPROP_XDISTANCE,(ADR_x_StartingPosition+63)*RetinaScaling);
                        ObjectSet("DR Value"+IntegerToString(i),OBJPROP_YDISTANCE,(ADR_y_StartingPosition+(i*15))*RetinaScaling);
                        ObjectSet("DR Value"+IntegerToString(i),OBJPROP_SELECTABLE,false);
                        ObjectSet("DR Value"+IntegerToString(i),OBJPROP_HIDDEN,ObjectNotListed);
                        ObjectSetText("DR Value"+IntegerToString(i),"= ",font_size, font_face, ADR_Font_Color);
                       }
                     ObjectCreate("ADR Title"+IntegerToString(i),OBJ_LABEL, 0, 0, 0);         
                     ObjectSet("ADR Title"+IntegerToString(i),OBJPROP_CORNER, ADRDisplayCorner);
                     ObjectSet("ADR Title"+IntegerToString(i),OBJPROP_XDISTANCE,(ADR_x_StartingPosition+120)*RetinaScaling);
                     ObjectSet("ADR Title"+IntegerToString(i),OBJPROP_YDISTANCE,(ADR_y_StartingPosition+(i*15))*RetinaScaling);
                     ObjectSet("ADR Title"+IntegerToString(i),OBJPROP_SELECTABLE,false);
                     ObjectSet("ADR Title"+IntegerToString(i),OBJPROP_HIDDEN,ObjectNotListed);
                     if(i==0) ObjectSetText("ADR Title"+IntegerToString(i),"Average Daily Range",font_size+1, font_face, ADR_Font_Color);
                     else if(i==1) ObjectSetText("ADR Title"+IntegerToString(i),"Last 5 days",font_size, font_face, ADR_Font_Color);
                     else if(i==2) ObjectSetText("ADR Title"+IntegerToString(i),"Last 10 days",font_size, font_face, ADR_Font_Color);
                     else if(i==3) ObjectSetText("ADR Title"+IntegerToString(i),"Last 15 days",font_size, font_face, ADR_Font_Color);
                     else if(i==4) ObjectSetText("ADR Title"+IntegerToString(i),"Last year",font_size, font_face, ADR_Font_Color);
                     else if(i==5) ObjectSetText("ADR Title"+IntegerToString(i),"Today so far",font_size, font_face, ADR_Font_Color);
                     if(i>=1)
                       {
                        ObjectCreate("ADR Value"+IntegerToString(i),OBJ_LABEL, 0, 0, 0);         
                        ObjectSet("ADR Value"+IntegerToString(i),OBJPROP_CORNER, ADRDisplayCorner);
                        ObjectSet("ADR Value"+IntegerToString(i),OBJPROP_XDISTANCE,(ADR_x_StartingPosition+120+83)*RetinaScaling);
                        ObjectSet("ADR Value"+IntegerToString(i),OBJPROP_YDISTANCE,(ADR_y_StartingPosition+(i*15))*RetinaScaling);  
                        ObjectSet("ADR Value"+IntegerToString(i),OBJPROP_SELECTABLE,false);
                        ObjectSet("ADR Value"+IntegerToString(i),OBJPROP_HIDDEN,ObjectNotListed);
                        ObjectSetText("ADR Value"+IntegerToString(i),"= ",font_size, font_face, ADR_Font_Color);
                       }
                     ObjectCreate("AWR Title"+IntegerToString(i),OBJ_LABEL, 0, 0, 0);         
                     ObjectSet("AWR Title"+IntegerToString(i),OBJPROP_CORNER, ADRDisplayCorner);
                     ObjectSet("AWR Title"+IntegerToString(i),OBJPROP_XDISTANCE,(ADR_x_StartingPosition+270)*RetinaScaling);
                     ObjectSet("AWR Title"+IntegerToString(i),OBJPROP_YDISTANCE,(ADR_y_StartingPosition+(i*15))*RetinaScaling);
                     ObjectSet("AWR Title"+IntegerToString(i),OBJPROP_SELECTABLE,false);
                     ObjectSet("AWR Title"+IntegerToString(i),OBJPROP_HIDDEN,ObjectNotListed);
                     if(i==0) ObjectSetText("AWR Title"+IntegerToString(i),"Average Weekly Range",font_size+1, font_face, ADR_Font_Color);
                     else if(i==1) ObjectSetText("AWR Title"+IntegerToString(i),"Last week",font_size, font_face, ADR_Font_Color);
                     else if(i==2) ObjectSetText("AWR Title"+IntegerToString(i),"Last 2 weeks",font_size, font_face, ADR_Font_Color);
                     else if(i==3) ObjectSetText("AWR Title"+IntegerToString(i),"Last 4 weeks",font_size, font_face, ADR_Font_Color);
                     else if(i==4) ObjectSetText("AWR Title"+IntegerToString(i),"Last 52 weeks",font_size, font_face, ADR_Font_Color);
                     else if(i==5) ObjectSetText("AWR Title"+IntegerToString(i),"This week so far",font_size, font_face, ADR_Font_Color);
                     if(i>=1)
                       {
                        ObjectCreate("AWR Value"+IntegerToString(i),OBJ_LABEL, 0, 0, 0);         
                        ObjectSet("AWR Value"+IntegerToString(i),OBJPROP_CORNER, ADRDisplayCorner);
                        ObjectSet("AWR Value"+IntegerToString(i),OBJPROP_XDISTANCE,(ADR_x_StartingPosition+270+90)*RetinaScaling);
                        ObjectSet("AWR Value"+IntegerToString(i),OBJPROP_YDISTANCE,(ADR_y_StartingPosition+(i*15))*RetinaScaling);
                        ObjectSet("AWR Value"+IntegerToString(i),OBJPROP_SELECTABLE,false);
                        ObjectSet("AWR Value"+IntegerToString(i),OBJPROP_HIDDEN,ObjectNotListed);
                        ObjectSet("AWR Value"+IntegerToString(i),OBJPROP_HIDDEN,ObjectNotListed);
                        ObjectSetText("AWR Value"+IntegerToString(i),"= ",font_size, font_face, ADR_Font_Color);
                       }
                    }  // end for(int i=0;i<=5;i++)
                  ADRCalculation();
                 }  // end case 0:
               break;
               case 1: // Show ADR, AWR and Open Profit/Loss
                 {
                  GlobalVariableSet(StringConcatenate("GV_ShowADRState_",SymbolInfoString("0",SYMBOL_DESCRIPTION)),2);
                  for(int i=0;i<=7;i++)
                    {
                     ObjectCreate("P&L Title"+IntegerToString(i),OBJ_LABEL, 0, 0, 0);         
                     ObjectSet("P&L Title"+IntegerToString(i),OBJPROP_CORNER, CORNER_RIGHT_UPPER);
                     ObjectSet("P&L Title"+IntegerToString(i),OBJPROP_SELECTABLE,false);
                     ObjectSet("P&L Title"+IntegerToString(i),OBJPROP_HIDDEN,ObjectNotListed);
                     if(i==0) ObjectSetText("P&L Title"+IntegerToString(i),"Open Profit",font_size+1, font_face, ADR_Font_Color);
                     if(i==1) ObjectSetText("P&L Title"+IntegerToString(i),"Stop Loss value",font_size, font_face, ADR_Font_Color);
                     if(i==2) ObjectSetText("P&L Title"+IntegerToString(i),"Take Profit value",font_size, font_face, ADR_Font_Color);
                     if(i==3) ObjectSetText("P&L Title"+IntegerToString(i),"",font_size, font_face, ADR_Font_Color);
                     if(i==4) ObjectSetText("P&L Title"+IntegerToString(i),"Lots in Active Orders",font_size, font_face, ADR_Font_Color);
                     if(i==5) ObjectSetText("P&L Title"+IntegerToString(i),"Lots in Pending Orders",font_size, font_face, ADR_Font_Color);
                     if(i==6) ObjectSetText("P&L Title"+IntegerToString(i),"Pending Orders Stop Loss value",font_size, font_face, ADR_Font_Color);
                     if(i==7) ObjectSetText("P&L Title"+IntegerToString(i),"Pending Orders Take Profit value",font_size, font_face, ADR_Font_Color);
                     // Values
                     ObjectCreate("P&L Value$"+IntegerToString(i),OBJ_LABEL, 0, 0, 0);         
                     ObjectSet("P&L Value$"+IntegerToString(i),OBJPROP_CORNER, CORNER_RIGHT_UPPER);
                     ObjectSet("P&L Value$"+IntegerToString(i),OBJPROP_SELECTABLE,false);
                     ObjectSet("P&L Value$"+IntegerToString(i),OBJPROP_HIDDEN,ObjectNotListed);
                     ObjectCreate("P&L Value%"+IntegerToString(i),OBJ_LABEL, 0, 0, 0);         
                     ObjectSet("P&L Value%"+IntegerToString(i),OBJPROP_CORNER, CORNER_RIGHT_UPPER);
                     ObjectSet("P&L Value%"+IntegerToString(i),OBJPROP_SELECTABLE,false);
                     ObjectSet("P&L Value%"+IntegerToString(i),OBJPROP_HIDDEN,ObjectNotListed);
                     ObjectCreate("P&L ValueNet"+IntegerToString(i),OBJ_LABEL, 0, 0, 0);         
                     ObjectSet("P&L ValueNet"+IntegerToString(i),OBJPROP_CORNER, CORNER_RIGHT_UPPER);
                     ObjectSet("P&L ValueNet"+IntegerToString(i),OBJPROP_SELECTABLE,false);
                     ObjectSet("P&L ValueNet"+IntegerToString(i),OBJPROP_HIDDEN,ObjectNotListed);
                    }
                  PnLTextPosition();
                  ADRCalculation();
                  PnLCalculation();
                 }
               break;
               case 2: // Show only Open Profit/Loss
                 {
                  GlobalVariableSet(StringConcatenate("GV_ShowADRState_",SymbolInfoString("0",SYMBOL_DESCRIPTION)),3);
                  ADRRemove();
                  PnLRemove();
                  for(int i=0;i<=7;i++)
                    {
                     ObjectCreate("P&L Title"+IntegerToString(i),OBJ_LABEL, 0, 0, 0);         
                     ObjectSet("P&L Title"+IntegerToString(i),OBJPROP_CORNER, CORNER_RIGHT_UPPER);
                     ObjectSet("P&L Title"+IntegerToString(i),OBJPROP_SELECTABLE,false);
                     ObjectSet("P&L Title"+IntegerToString(i),OBJPROP_HIDDEN,ObjectNotListed);
                     if(i==0) ObjectSetText("P&L Title"+IntegerToString(i),"Open Profit",font_size+1, font_face, ADR_Font_Color);
                     if(i==1) ObjectSetText("P&L Title"+IntegerToString(i),"Stop Loss value",font_size, font_face, ADR_Font_Color);
                     if(i==2) ObjectSetText("P&L Title"+IntegerToString(i),"Take Profit value",font_size, font_face, ADR_Font_Color);
                     if(i==3) ObjectSetText("P&L Title"+IntegerToString(i),"",font_size, font_face, ADR_Font_Color);
                     if(i==4) ObjectSetText("P&L Title"+IntegerToString(i),"Lots in Active Orders",font_size, font_face, ADR_Font_Color);
                     if(i==5) ObjectSetText("P&L Title"+IntegerToString(i),"Lots in Pending Orders",font_size, font_face, ADR_Font_Color);
                     if(i==6) ObjectSetText("P&L Title"+IntegerToString(i),"Pending Orders Stop Loss value",font_size, font_face, ADR_Font_Color);
                     if(i==7) ObjectSetText("P&L Title"+IntegerToString(i),"Pending Orders Take Profit value",font_size, font_face, ADR_Font_Color);
                     // Values
                     ObjectCreate("P&L Value$"+IntegerToString(i),OBJ_LABEL, 0, 0, 0);         
                     ObjectSet("P&L Value$"+IntegerToString(i),OBJPROP_CORNER, CORNER_RIGHT_UPPER);
                     ObjectSet("P&L Value$"+IntegerToString(i),OBJPROP_SELECTABLE,false);
                     ObjectSet("P&L Value$"+IntegerToString(i),OBJPROP_HIDDEN,ObjectNotListed);
                     ObjectCreate("P&L Value%"+IntegerToString(i),OBJ_LABEL, 0, 0, 0);         
                     ObjectSet("P&L Value%"+IntegerToString(i),OBJPROP_CORNER, CORNER_RIGHT_UPPER);
                     ObjectSet("P&L Value%"+IntegerToString(i),OBJPROP_SELECTABLE,false);
                     ObjectSet("P&L Value%"+IntegerToString(i),OBJPROP_HIDDEN,ObjectNotListed);
                     ObjectCreate("P&L ValueNet"+IntegerToString(i),OBJ_LABEL, 0, 0, 0);         
                     ObjectSet("P&L ValueNet"+IntegerToString(i),OBJPROP_CORNER, CORNER_RIGHT_UPPER);
                     ObjectSet("P&L ValueNet"+IntegerToString(i),OBJPROP_SELECTABLE,false);
                     ObjectSet("P&L ValueNet"+IntegerToString(i),OBJPROP_HIDDEN,ObjectNotListed);
                    }
                  PnLTextPosition();
                  PnLCalculation();
                 }
               break;
               case 3: // Do not show ADR, AWR and Open Profit/Loss
                 {
                  GlobalVariableSet(StringConcatenate("GV_ShowADRState_",SymbolInfoString("0",SYMBOL_DESCRIPTION)),0);
                  ADRRemove();
                  PnLRemove();
                 }
               break;
              }
           }
         break;        
         case Key_Rectangle_MidPoint_Line:  // To draw a horizontal line at the price midpoint (equilibrium) of the selected rectangle 
           {
            // Check if the last object cliced is a rectangle
            if(ObjectType(lastobjclicked)==OBJ_RECTANGLE)
              {
               // Get the Price High
               double MaxPrice=MathMax(ObjectGetDouble(0,lastobjclicked,OBJPROP_PRICE1),ObjectGetDouble(0,lastobjclicked,OBJPROP_PRICE2));
               // Get the Price Low
               double MinPrice=MathMin(ObjectGetDouble(0,lastobjclicked,OBJPROP_PRICE1),ObjectGetDouble(0,lastobjclicked,OBJPROP_PRICE2));
               // Calculate the Price midpoint
               double MidPrice=(MaxPrice-MinPrice)/2+MinPrice;
               // Get the oldest date
               datetime OldestDate=(datetime)MathMin(ObjectGetInteger(0,lastobjclicked,OBJPROP_TIME1),ObjectGetInteger(0,lastobjclicked,OBJPROP_TIME2));
               // Get the newest date
               datetime NewestDate=(datetime)MathMax(ObjectGetInteger(0,lastobjclicked,OBJPROP_TIME1),ObjectGetInteger(0,lastobjclicked,OBJPROP_TIME2));
               // Check if a line already exist
               if(ObjectFind(0,DoubleToString(MidPrice,(int)MarketInfo(NULL,MODE_DIGITS))+" : Rectangle Equilibrium "+CTF+" @ "+TimeToString(OldestDate))==0)
                 {
                  // Delete the existing line
                  ObjectDelete(0,DoubleToString(MidPrice,(int)MarketInfo(NULL,MODE_DIGITS))+" : Rectangle Equilibrium "+CTF+" @ "+TimeToString(OldestDate));
                 }
               else
                 {
                  // Check is the rectangle is drawn with background
                  if(ObjectGetInteger(0,lastobjclicked,OBJPROP_BACK)==0)
                    {
                     // Set the line color the same as rectangle color if not drawn with background color
                     // Get the rectangle color
                     string RectangleColor=ColorToString((color)ObjectGetInteger(0,lastobjclicked,OBJPROP_COLOR));
                     RectangleMidPointLineColor=(color)RectangleColor;
                    }
                  else
                    {
                     // Set the line color as the oposite of the rectangle color when drawn with background color
                     // Get the rectangle color
                     string RectangleColor=ColorToString((color)ObjectGetInteger(0,lastobjclicked,OBJPROP_COLOR));
                     // Convert the string into separate values for R,G,B
                     string RectangleColorRGB[];
                     StringSplit(RectangleColor,StringGetCharacter(",",0),RectangleColorRGB);
                     // Calculating the oposite color
                     RectangleColorRGB[0]=(string)(255-StringToInteger(RectangleColorRGB[0]));
                     RectangleColorRGB[1]=(string)(255-StringToInteger(RectangleColorRGB[1]));
                     RectangleColorRGB[2]=(string)(255-StringToInteger(RectangleColorRGB[2]));
                     RectangleMidPointLineColor=(color)StringConcatenate("C'", RectangleColorRGB[0], ",", RectangleColorRGB[1], ",", RectangleColorRGB[2]);
                    }                     
                  // Create the horizontal line to split the rectangle height in half
                  ObjectCreate(DoubleToString(MidPrice,(int)MarketInfo(NULL,MODE_DIGITS))+" : Rectangle Equilibrium "+CTF+" @ "+TimeToString(OldestDate),OBJ_TREND,0,OldestDate,MidPrice,NewestDate,MidPrice);
                  ObjectSetInteger(0,DoubleToString(MidPrice,(int)MarketInfo(NULL,MODE_DIGITS))+" : Rectangle Equilibrium "+CTF+" @ "+TimeToString(OldestDate),OBJPROP_COLOR,RectangleMidPointLineColor); // Color value to set/get object color.
                  ObjectSetInteger(0,DoubleToString(MidPrice,(int)MarketInfo(NULL,MODE_DIGITS))+" : Rectangle Equilibrium "+CTF+" @ "+TimeToString(OldestDate),OBJPROP_STYLE,STYLE_DOT); // Value is one of STYLE_SOLID, STYLE_DASH, STYLE_DOT, STYLE_DASHDOT, STYLE_DASHDOTDOT constants to set/get object line style.
                  ObjectSetInteger(0,DoubleToString(MidPrice,(int)MarketInfo(NULL,MODE_DIGITS))+" : Rectangle Equilibrium "+CTF+" @ "+TimeToString(OldestDate),OBJPROP_WIDTH,1); // Integer value to set/get object line width. Can be from 1 to 5.
                  ObjectSetInteger(0,DoubleToString(MidPrice,(int)MarketInfo(NULL,MODE_DIGITS))+" : Rectangle Equilibrium "+CTF+" @ "+TimeToString(OldestDate),OBJPROP_BACK,false); // Boolean value to set/get background drawing flag for object. (for example "true" will hide the value at the bottom of the chart.)
                  ObjectSetInteger(0,DoubleToString(MidPrice,(int)MarketInfo(NULL,MODE_DIGITS))+" : Rectangle Equilibrium "+CTF+" @ "+TimeToString(OldestDate),OBJPROP_RAY,false); // Boolean value to set/get ray flag of object. (for example "true" will extend the line to the right edge.)
                  ObjectSetInteger(0,DoubleToString(MidPrice,(int)MarketInfo(NULL,MODE_DIGITS))+" : Rectangle Equilibrium "+CTF+" @ "+TimeToString(OldestDate),OBJPROP_HIDDEN,ObjectNotListed);
 //                 ObjectSetString(0,DoubleToString(MidPrice,(int)MarketInfo(NULL,MODE_DIGITS))+" : Rectangle Equilibrium "+CTF+" @ "+TimeToString(OldestDate),OBJPROP_TOOLTIP,"Rectangle Equilibrium\n"+DoubleToString(MidPrice,(int)MarketInfo(NULL,MODE_DIGITS)));
                  ObjectSetInteger(0,DoubleToString(MidPrice,(int)MarketInfo(NULL,MODE_DIGITS))+" : Rectangle Equilibrium "+CTF+" @ "+TimeToString(OldestDate),OBJPROP_TIMEFRAMES,ObjectGetInteger(0,lastobjclicked,OBJPROP_TIMEFRAMES));
                 }
              }
           }
         break;
        }  // end switch(int(lparam))
        
        if(Backtesting_Mode)
          {
           if(int(lparam)==Key_Backtesting_Scroll_To_Target_Date)
             {
              if(BacktestingFirstPass)
                {
                 ChartSetInteger(0,CHART_AUTOSCROLL,FALSE);  // Set Autoscroll to off when begining backtesting
                 ChartSetInteger(0,CHART_SHOW_TRADE_LEVELS,0,0);   // Hide price and trade level lines
                 ChartSetInteger(0,CHART_SHOW_ASK_LINE,0);
                 ChartSetInteger(0,CHART_SHOW_BID_LINE,0);
                 BacktestingFirstPass=false;
                }
              BacktestingShiftToTargetDate();
             }
           if(int(lparam) == Key_Backtesting_Scroll_Forward)
             {
              targetdate = (int)GlobalVariableGet(gv_BacktestingTargetDate) + (ChartPeriod(0)*60);
              GlobalVariableSet(gv_BacktestingTargetDate,targetdate);
              BacktestingShiftToTargetDate();
             }
           if(int(lparam) == Key_Backtesting_Scroll_Backward)
             {
              ChartNavigate(0,CHART_CURRENT_POS,-(int)MathCeil(0.06 * WindowBarsPerChart()));
             }
          }

        if(GlobalVariableGet(GV_ShowPeriodSeparators)==1 || GlobalVariableGet(GV_ShowPeriodSeparators)==2 || GlobalVariableGet(GV_ShowPeriodSeparators)==3 || GlobalVariableGet(GV_ShowPeriodSeparators)==4) 
          {
           if(lparam == 107 || lparam == 187)  // + key pressed on num keypad or regular keys above letters
             {
              RemovePeriodSeparators();
              ZoomLevel = ZoomLevel +1;
              if(ZoomLevel>5) ZoomLevel=5;
              period_separators();
             }
           if(lparam == 109 || lparam == 189) // - key pressed on num keypad or regular keys above letters
             {
              RemovePeriodSeparators();
              ZoomLevel = ZoomLevel -1;
              if(ZoomLevel<0) ZoomLevel=0;
              period_separators();
             }
          }


      if (KEY_P_pressed == false && lparam == KEY_P)   // Key P pressed
        {
         if(Backtesting_Mode==true)
           {  
            KEY_P_pressed = true;
            KEY_D_pressed = false;
           }
        }
      else if (KEY_P_pressed == true || (Backtesting_Mode==false &&(ObjectGetDouble(0,LastObjectName,OBJPROP_PRICE,0))>=MarketInfo(NULL,MODE_BID)))
        {
         double objprice = ObjectGetDouble(0,LastObjectName,OBJPROP_PRICE,0);
         if (lparam == Key_Define_Line_As_Mitigation_Block) 
           {
            KEY_P_pressed = false;
            ObjectSetString(0,LastObjectName,OBJPROP_TEXT,"Mitigation Block"); 
            ObjectSetString(0,LastObjectName,OBJPROP_TOOLTIP,LastObjectName+"\n"+"Mitigation Block"+"\n"+DoubleToString(objprice,(int)MarketInfo(NULL,MODE_DIGITS)));
            ObjectSetInteger(0,LastObjectName,OBJPROP_STYLE,STYLE_DASHDOT);
            ObjectSetInteger(0,LastObjectName,OBJPROP_COLOR,BearishLineColor); 
           }
         if (lparam == Key_Define_Line_As_Bullish_Breaker) 
           {
            KEY_P_pressed = false;
            ObjectSetString(0,LastObjectName,OBJPROP_TEXT,"Bearish Breaker"); 
            ObjectSetString(0,LastObjectName,OBJPROP_TOOLTIP,LastObjectName+"\n"+"Bearish Breaker"+"\n"+DoubleToString(objprice,(int)MarketInfo(NULL,MODE_DIGITS)));
            ObjectSetInteger(0,LastObjectName,OBJPROP_STYLE,STYLE_DASHDOT);
            ObjectSetInteger(0,LastObjectName,OBJPROP_COLOR,BearishLineColor); 
           }
         if (lparam == Key_Define_Line_As_Liquidity_Void) 
           {
            KEY_P_pressed = false;
            ObjectSetString(0,LastObjectName,OBJPROP_TEXT,"Liquidity Void"); 
            ObjectSetString(0,LastObjectName,OBJPROP_TOOLTIP,LastObjectName+"\n"+"Liquidity Void"+"\n"+DoubleToString(objprice,(int)MarketInfo(NULL,MODE_DIGITS)));
            ObjectSetInteger(0,LastObjectName,OBJPROP_STYLE,STYLE_DASHDOT);
            ObjectSetInteger(0,LastObjectName,OBJPROP_COLOR,BearishLineColor); 
           }
         if (lparam == Key_Define_Line_As_Fair_Value_Gap) 
           {
            KEY_P_pressed = false;
            ObjectSetString(0,LastObjectName,OBJPROP_TEXT,"Fair Value Gap"); 
            ObjectSetString(0,LastObjectName,OBJPROP_TOOLTIP,LastObjectName+"\n"+"Fair Value Gap"+"\n"+DoubleToString(objprice,(int)MarketInfo(NULL,MODE_DIGITS)));
            ObjectSetInteger(0,LastObjectName,OBJPROP_STYLE,STYLE_DASHDOT);
            ObjectSetInteger(0,LastObjectName,OBJPROP_COLOR,BearishLineColor); 
           }
         if (lparam == Key_Define_Line_As_Order_Block) 
           {
            KEY_P_pressed = false;
            ObjectSetString(0,LastObjectName,OBJPROP_TEXT,"Bearish Orderblock"); 
            ObjectSetString(0,LastObjectName,OBJPROP_TOOLTIP,LastObjectName+"\n"+"Bearish Orderblock"+"\n"+DoubleToString(objprice,(int)MarketInfo(NULL,MODE_DIGITS)));
            ObjectSetInteger(0,LastObjectName,OBJPROP_COLOR,BearishLineColor); 
           }
         if (lparam == Key_Define_Line_As_Rejection_Block) 
           {
            KEY_P_pressed = false;
            ObjectSetString(0,LastObjectName,OBJPROP_TEXT,"Rejection Block"); 
            ObjectSetString(0,LastObjectName,OBJPROP_TOOLTIP,LastObjectName+"\n"+"Rejection Block"+"\n"+DoubleToString(objprice,(int)MarketInfo(NULL,MODE_DIGITS)));
            ObjectSetInteger(0,LastObjectName,OBJPROP_STYLE,STYLE_DASHDOTDOT);
            ObjectSetInteger(0,LastObjectName,OBJPROP_COLOR,BearishLineColor); 
           }
         if (lparam == Key_Define_Line_As_Old_Low_High) 
           {
            KEY_P_pressed = false;
            ObjectSetString(0,LastObjectName,OBJPROP_TEXT,"Old High/Low");
            ObjectSetString(0,LastObjectName,OBJPROP_TOOLTIP,LastObjectName+"\n"+"Old High/Low"+"\n"+DoubleToString(objprice,(int)MarketInfo(NULL,MODE_DIGITS)));
            ObjectSetInteger(0,LastObjectName,OBJPROP_STYLE,STYLE_DASHDOTDOT);
            ObjectSetInteger(0,LastObjectName,OBJPROP_COLOR,BearishLineColor); 
           } 
        }
      if (KEY_D_pressed == false && lparam == KEY_D)   // Key D pressed
        {  
         if(Backtesting_Mode==true)
           {
            KEY_P_pressed = false;
            KEY_D_pressed = true;
           }
        }
      else if (KEY_D_pressed==true || (Backtesting_Mode==false &&(ObjectGetDouble(0,LastObjectName,OBJPROP_PRICE,0))<=MarketInfo(NULL,MODE_BID)))
        {
         double objprice = ObjectGetDouble(0,LastObjectName,OBJPROP_PRICE,0);
         if (lparam == Key_Define_Line_As_Mitigation_Block) 
           {
            KEY_D_pressed = false;
            ObjectSetString(0,LastObjectName,OBJPROP_TEXT,"Mitigation Block"); 
            ObjectSetString(0,LastObjectName,OBJPROP_TOOLTIP,LastObjectName+"\n"+"Mitigation Block"+"\n"+DoubleToString(objprice,(int)MarketInfo(NULL,MODE_DIGITS)));
            ObjectSetInteger(0,LastObjectName,OBJPROP_STYLE,STYLE_DASHDOT);
            ObjectSetInteger(0,LastObjectName,OBJPROP_COLOR,BullishLineColor); 
           }
         if (lparam == Key_Define_Line_As_Bullish_Breaker) 
           {
            KEY_D_pressed = false;
            ObjectSetString(0,LastObjectName,OBJPROP_TEXT,"Bullish Breaker"); 
            ObjectSetString(0,LastObjectName,OBJPROP_TOOLTIP,LastObjectName+"\n"+"Bullish Breaker"+"\n"+DoubleToString(objprice,(int)MarketInfo(NULL,MODE_DIGITS)));
            ObjectSetInteger(0,LastObjectName,OBJPROP_STYLE,STYLE_DASHDOT);
            ObjectSetInteger(0,LastObjectName,OBJPROP_COLOR,BullishLineColor); 
           }
         if (lparam == Key_Define_Line_As_Liquidity_Void) 
           {
            KEY_D_pressed = false;
            ObjectSetString(0,LastObjectName,OBJPROP_TEXT,"Liquidity Void"); 
            ObjectSetString(0,LastObjectName,OBJPROP_TOOLTIP,LastObjectName+"\n"+"Liquidity Void"+"\n"+DoubleToString(objprice,(int)MarketInfo(NULL,MODE_DIGITS)));
            ObjectSetInteger(0,LastObjectName,OBJPROP_STYLE,STYLE_DASHDOT);
            ObjectSetInteger(0,LastObjectName,OBJPROP_COLOR,BullishLineColor); 
           }
         if (lparam == Key_Define_Line_As_Fair_Value_Gap) 
           {
            KEY_D_pressed = false;
            ObjectSetString(0,LastObjectName,OBJPROP_TEXT,"Fair Value Gap"); 
            ObjectSetString(0,LastObjectName,OBJPROP_TOOLTIP,LastObjectName+"\n"+"Fair Value Gap"+"\n"+DoubleToString(objprice,(int)MarketInfo(NULL,MODE_DIGITS)));
            ObjectSetInteger(0,LastObjectName,OBJPROP_STYLE,STYLE_DASHDOT);
            ObjectSetInteger(0,LastObjectName,OBJPROP_COLOR,BullishLineColor); 
           }
         if (lparam == Key_Define_Line_As_Order_Block) 
           {
            KEY_D_pressed = false;
            ObjectSetString(0,LastObjectName,OBJPROP_TEXT,"Bullish Orderblock"); 
            ObjectSetString(0,LastObjectName,OBJPROP_TOOLTIP,LastObjectName+"\n"+"Bullish Orderblock"+"\n"+DoubleToString(objprice,(int)MarketInfo(NULL,MODE_DIGITS)));
            ObjectSetInteger(0,LastObjectName,OBJPROP_COLOR,BullishLineColor); 
           }
         if (lparam == Key_Define_Line_As_Rejection_Block) 
           {
            KEY_D_pressed = false;
            ObjectSetString(0,LastObjectName,OBJPROP_TEXT,"Rejection Block"); 
            ObjectSetString(0,LastObjectName,OBJPROP_TOOLTIP,LastObjectName+"\n"+"Rejection Block"+"\n"+DoubleToString(objprice,(int)MarketInfo(NULL,MODE_DIGITS)));
            ObjectSetInteger(0,LastObjectName,OBJPROP_STYLE,STYLE_DASHDOTDOT);
            ObjectSetInteger(0,LastObjectName,OBJPROP_COLOR,BullishLineColor); 
           }
         if (lparam == Key_Define_Line_As_Old_Low_High) 
           {
            KEY_D_pressed = false;
            ObjectSetString(0,LastObjectName,OBJPROP_TEXT,"Old High/Low"); 
            ObjectSetString(0,LastObjectName,OBJPROP_TOOLTIP,LastObjectName+"\n"+"Old High/Low"+"\n"+DoubleToString(objprice,(int)MarketInfo(NULL,MODE_DIGITS)));
            ObjectSetInteger(0,LastObjectName,OBJPROP_STYLE,STYLE_DASHDOTDOT);
            ObjectSetInteger(0,LastObjectName,OBJPROP_COLOR,BullishLineColor); 
           }
        }
     } // end if(id==CHARTEVENT_KEYDOWN)
     
  if(id==CHARTEVENT_CHART_CHANGE)
    {
     if(GlobalVariableGet(GV_ShowKZ)==1) DrawKillZonesRectangles();  // To draw KZ rectangles when new chart is selected
     if(GlobalVariableGet(GV_ShowKZ)!=1 && DrawKillZonesRectanglesActive==true) RemoveKillZonesRectangles();  // To remove KZ rectangles when new chart is selected
     if(GlobalVariableGet(GV_ShowKZ)==2) DrawKillZonesLine();  // To draw KZ line when new chart is selected
     if(GlobalVariableGet(GV_ShowKZ)!=2 && DrawKillZonesLineActive==true) RemoveKillZonesLine();  // To remove KZ line when new chart is selected
     if(GlobalVariableGet(GV_ShowEquityKZ)==1) DrawKillZonesEquity();  // To draw Equity KZ rectangles when new chart is selected
     if(GlobalVariableGet(GV_ShowEquityKZ)==0 && DrawKillZonesEquityActive==true) RemoveKillZonesEquity(); // To remove Equity KZ rectangles when new chart is selected
     if(GlobalVariableGet(show_scale)) scale();
     else
       {
        ObjectDelete(0,"scaleVline");
        ObjectDelete(0,"scaleH1line");
        ObjectDelete(0,"scaleH2line");
        ObjectDelete(0,"scaletext");
       }
     ChartSetInteger(0,CHART_SHOW_OBJECT_DESCR,0,(int)GlobalVariableGet(GV_ShowObjDescription));
     if(Backtesting_Mode) BacktestingZoomChange();
     PnLTextPosition();
    }

  } // end void OnChartEvent
//----------------------------------  


//++++++++++++++++++++++++++++++++++
// Function to create KillZones
//++++++++++++++++++++++++++++++++++
void CreateKZ(string KZname, datetime KZbegin, datetime KZend, double KZlow, double KZhigh, color KZcolor)
  {
   ObjectCreate(0,KZname,OBJ_RECTANGLE,0,KZbegin,KZlow,KZend,KZhigh);
   ObjectSetInteger(0,KZname,OBJPROP_COLOR,KZcolor); 
   ObjectSetInteger(0,KZname,OBJPROP_BACK,true);
   ObjectSetInteger(0,KZname,OBJPROP_HIDDEN,ObjectNotListed);
   ObjectSetInteger(0,KZname,OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1);
  }
//----------------------------------  
  

//++++++++++++++++++++++++++++++++++
// Function to create the Price Scale
//++++++++++++++++++++++++++++++++++
void scale()
  {
   int x=10;  // x coordinate to place the scale
   int y=10;  // y coordinate to place the scale
   ENUM_BORDER_TYPE border=BORDER_FLAT;     // border type
   ENUM_BASE_CORNER corner=CORNER_RIGHT_UPPER; // chart corner for anchoring
   ENUM_LINE_STYLE style=STYLE_SOLID;        // flat border style
   int line_width=1;             // flat border width
   bool back=false;               // in the background
   bool hidden=true;              // hidden in the object list
   long z_order=0;                // priority for mouse click
   int pixels = (int)ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS,0);   // Get chart height in pixel
   double priceMin=ChartGetDouble(0,CHART_PRICE_MIN,0);  // Get lowest price of the chart price scale
   double priceMax=ChartGetDouble(0,CHART_PRICE_MAX,0);  // Get the highest price of the chart price scale
   int pricerangeinpips=0;
   if(priceMin!=0 && priceMax!=0 && pixels!=0)  // Don't run this section during chart initialization when those values are yet to be set
     {
      pricerangeinpips = (int)MathRound((priceMax - priceMin) / MarketInfo("0",MODE_POINT))/FractionalPipDivider;  // Get number of pips between chart lowest and highest price
      int scaletargetheight = (int)MathRound(pixels * 0.18);  // Set a target hight for the scale
      double pipsperpixel = (double)pricerangeinpips / (double)pixels;  // Get number of pips per vertical pixel
      double scaleinpips = scaletargetheight * pipsperpixel;  // Set the target scale size in pips
      if (scaleinpips >= 2 && scaleinpips <5) scaleinpips=2;  // Round the scale size to defined pips value
      if (scaleinpips >= 5 && scaleinpips <10) scaleinpips=5;
      if (scaleinpips >= 10 && scaleinpips <15) scaleinpips=10;
      if (scaleinpips >= 15 && scaleinpips <20) scaleinpips=15;
      if (scaleinpips >= 20 && scaleinpips <25) scaleinpips=20;
      if (scaleinpips >= 25 && scaleinpips <50) scaleinpips=25;
      if (scaleinpips >= 50 && scaleinpips <100) scaleinpips=50;
      if (scaleinpips >= 100 && scaleinpips <150) scaleinpips=100;
      if (scaleinpips >= 150 && scaleinpips <200) scaleinpips=150;
      if (scaleinpips >= 200 && scaleinpips < 250) scaleinpips=200;
      if (scaleinpips >= 250 && scaleinpips < 500) scaleinpips=250;
      if (scaleinpips >= 500 && scaleinpips < 1000) scaleinpips=500;
      if (scaleinpips >= 1000 && scaleinpips < 1500) scaleinpips=1000;
      if (scaleinpips >= 1500 && scaleinpips < 2000) scaleinpips=1500;
      if (scaleinpips >= 2000 && scaleinpips < 2500) scaleinpips=2000;
      if (scaleinpips >= 2500 && scaleinpips < 3000) scaleinpips=2500;
      if (scaleinpips >= 3000 && scaleinpips < 3500) scaleinpips=3000;
      if (scaleinpips >= 3500 && scaleinpips < 4000) scaleinpips=3500;
      if (scaleinpips >= 4000 && scaleinpips < 5000) scaleinpips=4000;
      if (scaleinpips >= 5000 && scaleinpips < 6000) scaleinpips=5000;
      if (scaleinpips >= 6000) scaleinpips=6000;
      string scaletext = StringConcatenate((int)scaleinpips," pips");  // Set the text to display on the scale
      int scaleinpixel = (int)MathRound(scaleinpips / pipsperpixel);  // Set the scale verticale size in pixels
      int scalemidpoint = MathAbs(scaleinpixel/2);  // Set the scale vertical size 50% height to anchor the text
      // Create the scale objects
      // Create the scale vertical line
      ObjectCreate(0,"scaleVline",OBJ_RECTANGLE_LABEL,0,x,y);
      ObjectSetInteger(0,"scaleVline",OBJPROP_XDISTANCE,x);
      ObjectSetInteger(0,"scaleVline",OBJPROP_YDISTANCE,y);
      ObjectSetInteger(0,"scaleVline",OBJPROP_XSIZE,1);
      ObjectSetInteger(0,"scaleVline",OBJPROP_YSIZE,scaleinpixel);
      ObjectSetInteger(0,"scaleVline",OBJPROP_BGCOLOR,PriceScaleColor);
      ObjectSetInteger(0,"scaleVline",OBJPROP_BORDER_TYPE,border);
      ObjectSetInteger(0,"scaleVline",OBJPROP_CORNER,corner);
      ObjectSetInteger(0,"scaleVline",OBJPROP_COLOR,PriceScaleColor);
      ObjectSetInteger(0,"scaleVline",OBJPROP_STYLE,style);
      ObjectSetInteger(0,"scaleVline",OBJPROP_WIDTH,line_width);
      ObjectSetInteger(0,"scaleVline",OBJPROP_BACK,back);
      ObjectSetInteger(0,"scaleVline",OBJPROP_SELECTABLE,selection);
      ObjectSetInteger(0,"scaleVline",OBJPROP_SELECTED,selection);
      ObjectSetInteger(0,"scaleVline",OBJPROP_HIDDEN,ObjectNotListed);
      ObjectSetInteger(0,"scaleVline",OBJPROP_ZORDER,z_order);
      // Create the scale top horizontal line
      ObjectCreate(0,"scaleH1line",OBJ_RECTANGLE_LABEL,0,x,y);
      ObjectSetInteger(0,"scaleH1line",OBJPROP_XDISTANCE,x);
      ObjectSetInteger(0,"scaleH1line",OBJPROP_YDISTANCE,y);
      ObjectSetInteger(0,"scaleH1line",OBJPROP_XSIZE,-4);
      ObjectSetInteger(0,"scaleH1line",OBJPROP_YSIZE,1);
      ObjectSetInteger(0,"scaleH1line",OBJPROP_BGCOLOR,PriceScaleColor);
      ObjectSetInteger(0,"scaleH1line",OBJPROP_BORDER_TYPE,border);
      ObjectSetInteger(0,"scaleH1line",OBJPROP_CORNER,corner);
      ObjectSetInteger(0,"scaleH1line",OBJPROP_COLOR,PriceScaleColor);
      ObjectSetInteger(0,"scaleH1line",OBJPROP_STYLE,style);
      ObjectSetInteger(0,"scaleH1line",OBJPROP_WIDTH,line_width);
      ObjectSetInteger(0,"scaleH1line",OBJPROP_BACK,back);
      ObjectSetInteger(0,"scaleH1line",OBJPROP_SELECTABLE,selection);
      ObjectSetInteger(0,"scaleH1line",OBJPROP_SELECTED,selection);
      ObjectSetInteger(0,"scaleH1line",OBJPROP_HIDDEN,ObjectNotListed);
      ObjectSetInteger(0,"scaleH1line",OBJPROP_ZORDER,z_order);
      // Create the scale bottom horizontal line
      ObjectCreate(0,"scaleH2line",OBJ_RECTANGLE_LABEL,0,x,y);
      ObjectSetInteger(0,"scaleH2line",OBJPROP_XDISTANCE,x);
      ObjectSetInteger(0,"scaleH2line",OBJPROP_YDISTANCE,y+scaleinpixel);
      ObjectSetInteger(0,"scaleH2line",OBJPROP_XSIZE,-4);
      ObjectSetInteger(0,"scaleH2line",OBJPROP_YSIZE,1);
      ObjectSetInteger(0,"scaleH2line",OBJPROP_BGCOLOR,PriceScaleColor);
      ObjectSetInteger(0,"scaleH2line",OBJPROP_BORDER_TYPE,border);
      ObjectSetInteger(0,"scaleH2line",OBJPROP_CORNER,corner);
      ObjectSetInteger(0,"scaleH2line",OBJPROP_COLOR,PriceScaleColor);
      ObjectSetInteger(0,"scaleH2line",OBJPROP_STYLE,style);
      ObjectSetInteger(0,"scaleH2line",OBJPROP_WIDTH,line_width);
      ObjectSetInteger(0,"scaleH2line",OBJPROP_BACK,back);
      ObjectSetInteger(0,"scaleH2line",OBJPROP_SELECTABLE,selection);
      ObjectSetInteger(0,"scaleH2line",OBJPROP_SELECTED,selection);
      ObjectSetInteger(0,"scaleH2line",OBJPROP_HIDDEN,ObjectNotListed);
      ObjectSetInteger(0,"scaleH2line",OBJPROP_ZORDER,z_order);
      // create the scale text to show the # of pips
      ObjectCreate(0,"scaletext",OBJ_LABEL,0,x,y);
      ObjectSetInteger(0,"scaletext",OBJPROP_XDISTANCE,x+3); 
      ObjectSetInteger(0,"scaletext",OBJPROP_YDISTANCE,y+scalemidpoint); 
      ObjectSetInteger(0,"scaletext",OBJPROP_CORNER,corner); 
      ObjectSetString(0,"scaletext",OBJPROP_TEXT,scaletext); 
      ObjectSetString(0,"scaletext",OBJPROP_FONT,"Arial"); 
      ObjectSetInteger(0,"scaletext",OBJPROP_FONTSIZE,8); 
      ObjectSetDouble(0,"scaletext",OBJPROP_ANGLE,90); 
      ObjectSetInteger(0,"scaletext",OBJPROP_ANCHOR,ANCHOR_LOWER); 
      ObjectSetInteger(0,"scaletext",OBJPROP_COLOR,PriceScaleColor); 
      ObjectSetInteger(0,"scaletext",OBJPROP_BACK,back); 
      ObjectSetInteger(0,"scaletext",OBJPROP_SELECTABLE,selection); 
      ObjectSetInteger(0,"scaletext",OBJPROP_SELECTED,selection); 
      ObjectSetInteger(0,"scaletext",OBJPROP_HIDDEN,ObjectNotListed); 
      ObjectSetInteger(0,"scaletext",OBJPROP_ZORDER,z_order); 
     } //end if(pricemin !=0...
  }
//----------------------------------  


//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Function to create and show the Local and Server Date/Time
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
void server_localdatetime()
  {
   // Mapping the day of week in text
   DOWintext[0] = "Sunday";
   DOWintext[1] = "Monday";
   DOWintext[2] = "Tuesday";
   DOWintext[3] = "Wednesday";
   DOWintext[4] = "Thursday";
   DOWintext[5] = "Friday";
   DOWintext[6] = "Saturday";
   ObjectCreate(0,"ServerTimeTitle", OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0,"ServerTimeTitle", OBJPROP_CORNER, time_corner);
   ObjectSetInteger(0,"ServerTimeTitle",OBJPROP_ANCHOR,ANCHOR_RIGHT_UPPER);
   ObjectSetInteger(0,"ServerTimeTitle", OBJPROP_XDISTANCE, time_x+220);
   ObjectSetInteger(0,"ServerTimeTitle", OBJPROP_YDISTANCE, time_y);
   ObjectSetInteger(0,"ServerTimeTitle", OBJPROP_BACK, DrawAsBackground);
   ObjectSetInteger(0,"ServerTimeTitle",OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(0,"ServerTimeTitle",OBJPROP_SELECTED,selection); 
   ObjectCreate(0,"ServerTime", OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0,"ServerTime", OBJPROP_CORNER, time_corner);
   ObjectSetInteger(0,"ServerTime",OBJPROP_ANCHOR,ANCHOR_RIGHT_UPPER);
   ObjectSetInteger(0,"ServerTime", OBJPROP_XDISTANCE, time_x+50);
   ObjectSetInteger(0,"ServerTime", OBJPROP_YDISTANCE, time_y);
   ObjectSetInteger(0,"ServerTime", OBJPROP_BACK, DrawAsBackground);
   ObjectSetInteger(0,"ServerTime",OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(0,"ServerTime",OBJPROP_SELECTED,selection); 
   ObjectCreate(0,"LocalTime", OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0,"LocalTime", OBJPROP_CORNER, time_corner);
   ObjectSetInteger(0,"LocalTime",OBJPROP_ANCHOR,ANCHOR_RIGHT_UPPER);
   ObjectSetInteger(0,"LocalTime", OBJPROP_XDISTANCE, time_x+50);
   ObjectSetInteger(0,"LocalTime", OBJPROP_YDISTANCE, time_y+12);
   ObjectSetInteger(0,"LocalTime", OBJPROP_BACK, DrawAsBackground);
   ObjectSetInteger(0,"LocalTime",OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(0,"LocalTime",OBJPROP_SELECTED,selection); 
   ObjectCreate(0,"LocalTimeTitle", OBJ_LABEL,0,0,0);
   ObjectSetInteger(0,"LocalTimeTitle", OBJPROP_CORNER, time_corner);
   ObjectSetInteger(0,"LocalTimeTitle",OBJPROP_ANCHOR,ANCHOR_RIGHT_UPPER);
   ObjectSetInteger(0,"LocalTimeTitle", OBJPROP_XDISTANCE, time_x+220);
   ObjectSetInteger(0,"LocalTimeTitle", OBJPROP_YDISTANCE, time_y+12);
   ObjectSetInteger(0,"LocalTimeTitle", OBJPROP_BACK, DrawAsBackground);
   ObjectSetInteger(0,"LocalTimeTitle",OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(0,"LocalTimeTitle",OBJPROP_SELECTED,selection); 
   string ServerCurrentTime = TimeToStr(TimeCurrent(), TIME_DATE | TIME_MINUTES); //"yyyy.mm.dd HH:MM"
   int DOW = TimeDayOfWeek( TimeCurrent());  // Day of week
   string SERVERTIME = StringConcatenate(DOWintext[DOW],"  ",ServerCurrentTime);
   ObjectSetText("ServerTimeTitle","Last candle update server time:", font_size, font_face, SpreadandTimeFontColor);
   ObjectSetText("ServerTime",SERVERTIME, font_size, font_face, SpreadandTimeFontColor);
   string LocalTime = TimeToStr(TimeLocal(), TIME_DATE | TIME_MINUTES); //"HH:MM"
   int LDOW = TimeDayOfWeek( TimeLocal());  // Day of week
   string LOCALTIME = StringConcatenate(DOWintext[LDOW],"  ",LocalTime);  // Create string DOW with HH:MM
   ObjectSetText("LocalTimeTitle","Local time:", font_size, font_face, SpreadandTimeFontColor);
   ObjectSetText("LocalTime",LOCALTIME, font_size, font_face, SpreadandTimeFontColor);
  }
//----------------------------------  


//++++++++++++++++++++++++++++++++++
// Function to show the Price Spread
//++++++++++++++++++++++++++++++++++
void spread()
  {
   string spreadtxt;
   if(FractionalPip)  // for brokers that use fractional pip
    {
     double spread = MarketInfo(Symbol(),MODE_SPREAD)/10;
     spreadtxt = StringConcatenate("Spread: ",NormalizeDouble(spread, 2)," pip");
    }
   else              // for brokers that don't use fractional pip
    {
     int spread = (int)MarketInfo(Symbol(),MODE_SPREAD);
     spreadtxt = StringConcatenate("Spread: ",spread," pip");
    }
   ObjectSetText("Spread", spreadtxt, font_size, font_face, SpreadandTimeFontColor);
  }
//----------------------------------  


//++++++++++++++++++++++++++++++++++
// Function to remove CBDR 
//++++++++++++++++++++++++++++++++++
void RemoveCBDR()
  {
   for(int i=DaystoGoBack; i>=0; i--) 
     { 
      ObjectDelete(0,"CBDR"+IntegerToString(i));
      for (int std=0; std<=NumberOfStdDevToShow; std++)
        {
         ObjectDelete(0,"CBDR +"+IntegerToString(std)+" Std Dev "+IntegerToString(i));
        }
      for (int std=0; std<=NumberOfStdDevToShow; std++)
        {
         ObjectDelete(0,"CBDR -"+IntegerToString(std)+" Std Dev "+IntegerToString(i));
        }
      ObjectDelete(0,"CBDR Std Dev +VL "+IntegerToString(i));
      ObjectDelete(0,"CBDR Std Dev -VL "+IntegerToString(i));
     } // end for(int i=
  }
//----------------------------------  


//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Function to draw KillZones at the bottom of the chart window 
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
void DrawKillZonesLine()
  {
   if (ChartPeriod() <=60 && GlobalVariableGet(GV_ShowKZ)==2)
     {
      RemoveKillZonesLine();  // to remove old rectangles in order to redraw them as the chart updates
      DrawKillZonesLineActive=true;
      ENUM_BORDER_TYPE border=BORDER_FLAT;     // border type
      ENUM_BASE_CORNER corner=CORNER_LEFT_LOWER; // chart corner for anchoring
      ENUM_LINE_STYLE style=STYLE_SOLID;        // flat border style
      int line_width=1;             // flat border width 
      bool back=false;               // in the background
      bool hidden=true;              // hidden in the object list
      long z_order=0;                // priority for mouse click
      datetime KZdt=0;
      double KZprice=0;
      int KZmainChartWindow=0;
      int pixels = (int)ChartGetInteger(0,CHART_WIDTH_IN_PIXELS,0);   // Get chart width in pixel
      // For Asia KZ
      int KZAsiaBeginPixel=0, KZAsiaEndPixel=0;
      int LastKZlineAsiaDateStart=0, LastKZlineAsiaDateEnd=0;
      // For NY KZ
      int KZNYBeginPixel=0, KZNYEndPixel=0;
      int LastKZlineNYDateStart=0, LastKZlineNYDateEnd=0;
      // For London Open KZ
      int KZLondonOpenBeginPixel=0, KZLondonOpenEndPixel=0;
      int LastKZlineLondonOpenDateStart=0, LastKZlineLondonOpenDateEnd=0;
      // For London Close KZ
      int KZLondonCloseBeginPixel=0, KZLondonCloseEndPixel=0;
      int LastKZlineLondonCloseDateStart=0, LastKZlineLondonCloseDateEnd=0;
      int KZCMEBeginPixel=0, KZCMEEndPixel=0;
      int LastKZlineCMEDateStart=0, LastKZlineCMEDateEnd=0;
      bool KZAsiaInCalculation=false, KZNYInCalculation=false, KZLondonOpenInCalculation=false;
      bool KZLondonCloseInCalculation=false, KZCMEInCalculation=false;
      for(int x=0; x<=pixels; x++)
        {
         ChartXYToTimePrice(0,x,1,KZmainChartWindow,KZdt,KZprice);
         // Asia KZ
         if(TimeHour(KZdt)==ServerAsiaOpenBegin && TimeMinute(KZdt)==0 && LastKZlineAsiaDateStart!=TimeDay(KZdt))
           {
            KZAsiaBeginPixel = x;
            LastKZlineAsiaDateStart = TimeDay(KZdt);
            KZAsiaInCalculation = true;
           }
         if( (TimeHour(KZdt)==ServerAsiaOpenEnd && TimeMinute(KZdt)==0 && LastKZlineAsiaDateEnd!=TimeDay(KZdt)) || (x==pixels && KZAsiaInCalculation==true) )
           {
            KZAsiaEndPixel = x;
            LastKZlineAsiaDateEnd = TimeDay(KZdt);
            ObjectCreate(0,"KZline"+IntegerToString(x),OBJ_RECTANGLE_LABEL,0,0,0);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_XDISTANCE,KZAsiaBeginPixel+1);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_YDISTANCE,KZLineThickness);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_XSIZE,KZAsiaEndPixel-KZAsiaBeginPixel);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_YSIZE,KZLineThickness);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_BGCOLOR,AsiaOpenKZLineColor);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_BORDER_TYPE,border);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_CORNER,corner);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_COLOR,AsiaOpenKZLineColor);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_STYLE,style);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_WIDTH,line_width);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_BACK,back);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_SELECTABLE,selection);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_SELECTED,selection);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_HIDDEN,ObjectNotListed);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_ZORDER,z_order);
            KZAsiaInCalculation = false;
           }
         // NY KZ
         if(TimeHour(KZdt)==ServerNYOpenBegin && TimeMinute(KZdt)==0 && LastKZlineNYDateStart!=TimeDay(KZdt))
           {
            KZNYBeginPixel = x;
            LastKZlineNYDateStart = TimeDay(KZdt);
            KZNYInCalculation = true;
           }
         if( (TimeHour(KZdt)==ServerNYOpenEnd && TimeMinute(KZdt)==0 && LastKZlineNYDateEnd!=TimeDay(KZdt)) || (x==pixels && KZNYInCalculation==true) )
           {
            KZNYEndPixel = x;
            LastKZlineNYDateEnd = TimeDay(KZdt);
            ObjectCreate(0,"KZline"+IntegerToString(x),OBJ_RECTANGLE_LABEL,0,0,0);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_XDISTANCE,KZNYBeginPixel+1);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_YDISTANCE,KZLineThickness);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_XSIZE,KZNYEndPixel-KZNYBeginPixel);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_YSIZE,KZLineThickness);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_BGCOLOR,NYOpenKZLineColor);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_BORDER_TYPE,border);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_CORNER,corner);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_COLOR,NYOpenKZLineColor);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_STYLE,style);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_WIDTH,line_width);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_BACK,back);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_SELECTABLE,selection);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_SELECTED,selection);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_HIDDEN,ObjectNotListed);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_ZORDER,z_order);
            KZNYInCalculation = false;
           }
         // London Open
         if(TimeHour(KZdt)==ServerLondonOpenBegin && TimeMinute(KZdt)==0 && LastKZlineLondonOpenDateStart!=TimeDay(KZdt))
           {
            KZLondonOpenBeginPixel = x;
            LastKZlineLondonOpenDateStart = TimeDay(KZdt);
            KZLondonOpenInCalculation = true;
           }
         if( (TimeHour(KZdt)==ServerLondonOpenEnd && TimeMinute(KZdt)==0 && LastKZlineLondonOpenDateEnd!=TimeDay(KZdt)) || (x==pixels && KZLondonOpenInCalculation==true) )
           {
            KZLondonOpenEndPixel = x;
            LastKZlineLondonOpenDateEnd = TimeDay(KZdt);
            ObjectCreate(0,"KZline"+IntegerToString(x),OBJ_RECTANGLE_LABEL,0,0,0);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_XDISTANCE,KZLondonOpenBeginPixel+1);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_YDISTANCE,KZLineThickness);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_XSIZE,KZLondonOpenEndPixel-KZLondonOpenBeginPixel);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_YSIZE,KZLineThickness);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_BGCOLOR,LondonOpenKZLineColor);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_BORDER_TYPE,border);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_CORNER,corner);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_COLOR,LondonOpenKZLineColor);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_STYLE,style);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_WIDTH,line_width);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_BACK,back);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_SELECTABLE,selection);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_SELECTED,selection);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_HIDDEN,ObjectNotListed);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_ZORDER,z_order);
            KZLondonOpenInCalculation = false;
           }
         // London Close
         if(TimeHour(KZdt)==ServerLondonCloseBegin && TimeMinute(KZdt)==0 && LastKZlineLondonCloseDateStart!=TimeDay(KZdt))
           {
            KZLondonCloseBeginPixel = x;
            LastKZlineLondonCloseDateStart = TimeDay(KZdt);
            KZLondonCloseInCalculation = true;
           }
         if( (TimeHour(KZdt)==ServerLondonCloseEnd && TimeMinute(KZdt)==0 && LastKZlineLondonCloseDateEnd!=TimeDay(KZdt)) || (x==pixels && KZLondonCloseInCalculation) )
           {
            KZLondonCloseEndPixel = x;
            LastKZlineLondonCloseDateEnd = TimeDay(KZdt);
            ObjectCreate(0,"KZline"+IntegerToString(x),OBJ_RECTANGLE_LABEL,0,0,0);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_XDISTANCE,KZLondonCloseBeginPixel+1);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_YDISTANCE,KZLineThickness);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_XSIZE,KZLondonCloseEndPixel-KZLondonCloseBeginPixel);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_YSIZE,KZLineThickness);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_BGCOLOR,LondonCloseKZLineColor);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_BORDER_TYPE,border);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_CORNER,corner);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_COLOR,LondonCloseKZLineColor);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_STYLE,style);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_WIDTH,line_width);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_BACK,back);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_SELECTABLE,selection);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_SELECTED,selection);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_HIDDEN,ObjectNotListed);
            ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_ZORDER,z_order);
            KZLondonCloseInCalculation = false;
           }
         // CME Open
         if(ShowCMEKZ==true && ChartPeriod() <=15)
           {
            if(TimeHour(KZdt)==(ServerCMEOpenHour) && TimeMinute(KZdt)==CMEOpenMinutes && LastKZlineCMEDateStart!=TimeDay(KZdt))
              {
               KZCMEBeginPixel = x;
               LastKZlineCMEDateStart = TimeDay(KZdt);
               KZCMEInCalculation = true;
              }
            if( (TimeHour(KZdt)==(ServerCMEOpenHour) && TimeMinute(KZdt)==CMEOpenMinutes+15 && LastKZlineCMEDateEnd!=TimeDay(KZdt)) || (x==pixels && KZCMEInCalculation==true) )
              {
               KZCMEEndPixel = x;
               LastKZlineCMEDateEnd = TimeDay(KZdt);
               ObjectCreate(0,"KZline"+IntegerToString(x),OBJ_RECTANGLE_LABEL,0,0,0);
               ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_XDISTANCE,KZCMEBeginPixel+1);
               ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_YDISTANCE,KZLineThickness*2);
               ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_XSIZE,KZCMEEndPixel-KZCMEBeginPixel);
               ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_YSIZE,KZLineThickness);
               ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_BGCOLOR,CMEOpenKZLineColor);
               ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_BORDER_TYPE,border);
               ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_CORNER,corner);
               ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_COLOR,CMEOpenKZLineColor);
               ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_STYLE,style);
               ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_WIDTH,line_width);
               ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_BACK,back);
               ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_SELECTABLE,selection);
               ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_SELECTED,selection);
               ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_HIDDEN,ObjectNotListed);
               ObjectSetInteger(0,"KZline"+IntegerToString(x),OBJPROP_ZORDER,z_order);
               KZCMEInCalculation = false;
              }
           }  // end if(ShowCMEKZ)
        }  // end for(int x=0; x<=pixels; x++)
     } // end if (ChartPeriod() <=60)
  }
//----------------------------------  


//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Function to delete KillZones line at the bottom of the chart window 
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
void RemoveKillZonesLine()
  {
   int pixels = (int)ChartGetInteger(0,CHART_WIDTH_IN_PIXELS,0);   // Get chart width in pixel
   for(int x=0; x<=pixels; x++)
     {
      ObjectDelete(0,"KZline"+IntegerToString(x));
     }
   DrawKillZonesLineActive=false;
  }
//----------------------------------  


//++++++++++++++++++++++++++++++++++
// Function to remove KillZones 
//++++++++++++++++++++++++++++++++++
void RemoveKillZonesRectangles()
  {
   int KZNumberToDelete = MathMax(LondonOpenKZno,LondonCloseKZno);
   KZNumberToDelete = MathMax(KZNumberToDelete,NYOpenKZno);
   KZNumberToDelete = MathMax(KZNumberToDelete,AsiaOpenKZno);
   for(int i=0; i<=KZNumberToDelete; i++) 
     { 
      ObjectDelete(0,"London Open"+IntegerToString(i));
      ObjectDelete(0,"London Close"+IntegerToString(i));
      ObjectDelete(0,"NY Open"+IntegerToString(i));
      ObjectDelete(0,"Asia Open"+IntegerToString(i));
     } // end for(int i=
   LondonOpenKZno=0;
   LondonCloseKZno=0;
   NYOpenKZno=0;
   AsiaOpenKZno=0;
   DrawKillZones_FirstPass=true;
   DrawKillZonesRectanglesActive=false;
  }
//----------------------------------  


//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Function to draw the Kill Zones rectangles. 
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
void DrawKillZonesRectangles()
  {
   if(GlobalVariableGet(GV_ShowKZ)!=1 && DrawKillZonesRectanglesActive==true)
     {
      RemoveKillZonesRectangles();
     }
   // Validate if KillZones should be drawn only on 60 min charts and lower
   if(GlobalVariableGet(GV_ShowKZ)==1 && ChartPeriod(0)<=60)
     {
      DrawKillZonesRectanglesActive=true;
      int BarsUsed=IndicatorCounted();
      int BarsToProcess = Bars-1 - BarsUsed;
      if(DrawKillZones_FirstPass)
        {
         BarsToProcess=Bars-1;
         for(int i=0; i<BarsToProcess; i++)
           {
            // For London Open KZ
            // check if Time of current bar = KZ end time
            if(TimeHour(Time[i])==ServerLondonOpenEnd && TimeMinute(Time[i])==0)
              {
               // Calculate the expected number of bars to the left of the KZ end the KZ should begin
               int KZBeginBarsOffset = 60/ChartPeriod(0)*LondonOpenDuration;
               // Find the bar # for KZ begining time
               // validate the time of KZBeginBarsOffset = KZ Begin time
               for(int z=0; z<=KZBeginBarsOffset; z++)
                 {
                  if(i+z<=Bars-1)  // To prevent going above the maxumum number of bars
                    {
                     if(TimeHour(Time[i+z])==ServerLondonOpenBegin && TimeMinute(Time[i+z])==0)
                       {
                        // Find the highest and lowest price for each KillZone
                        double KZHighest=MathMax(High[iHighest(NULL,0,MODE_HIGH,KZBeginBarsOffset,i+1)],Open[i]);
                        double KZLowest=MathMin(Low[iLowest(NULL,0,MODE_LOW,KZBeginBarsOffset,i+1)],Open[i]);
                        CreateKZ("London Open"+IntegerToString(LondonOpenKZno), Time[i+z], Time[i], KZHighest, KZLowest, LondonOpenColor);
                        ObjectSetString(0,"London Open"+IntegerToString(LondonOpenKZno),OBJPROP_TEXT,IntegerToString((int)MathRound((KZHighest-KZLowest)/(Point*FractionalPipDivider)))+" Pips");
                        LondonOpenKZno++;
                        if(i+KZBeginBarsOffset<=BarsToProcess) i=i+KZBeginBarsOffset;
                       }
                    }
                 }
              }
            // For London Close KZ
            // check if Time of current bar = KZ end time
            if(TimeHour(Time[i])==ServerLondonCloseEnd && TimeMinute(Time[i])==0)
              {
               // Calculate the expected number of bars to the left of the KZ end the KZ should begin
               int KZBeginBarsOffset = 60/ChartPeriod(0)*LondonCloseDuration;
               // Find the bar # for KZ begining time
               // validate the time of KZBeginBarsOffset = KZ Begin time
               for(int z=0; z<=KZBeginBarsOffset; z++)
                 {
                  if(i+z<=Bars-1)  // To prevent going above the maxumum number of bars
                    {
                     if(TimeHour(Time[i+z])==ServerLondonCloseBegin && TimeMinute(Time[i+z])==0)
                       {
                        // Find the highest and lowest price for each KillZone
                        double KZHighest=MathMax(High[iHighest(NULL,0,MODE_HIGH,KZBeginBarsOffset,i+1)],Open[i]);
                        double KZLowest=MathMin(Low[iLowest(NULL,0,MODE_LOW,KZBeginBarsOffset,i+1)],Open[i]);
                        CreateKZ("London Close"+IntegerToString(LondonCloseKZno), Time[i+z], Time[i], KZHighest, KZLowest, LondonCloseColor);
                        ObjectSetString(0,"London Close"+IntegerToString(LondonCloseKZno),OBJPROP_TEXT,IntegerToString((int)MathRound((KZHighest-KZLowest)/(Point*FractionalPipDivider)))+" Pips");
                        LondonCloseKZno++;
                        if(i+KZBeginBarsOffset<=BarsToProcess) i=i+KZBeginBarsOffset;
                       }
                    }
                 }
              }
            // For NY Open KZ
            // check if Time of current bar = KZ end time
            if(TimeHour(Time[i])==ServerNYOpenEnd && TimeMinute(Time[i])==0)
              {
               // Calculate the expected number of bars to the left of the KZ end the KZ should begin
               int KZBeginBarsOffset = 60/ChartPeriod(0)*NYOpenDuration;
               // Find the bar # for KZ begining time
               // validate the time of KZBeginBarsOffset = KZ Begin time
               for(int z=0; z<=KZBeginBarsOffset; z++)
                 {
                  if(i+z<=Bars-1)  // To prevent going above the maxumum number of bars
                    {
                     if(TimeHour(Time[i+z])==ServerNYOpenBegin && TimeMinute(Time[i+z])==0)
                       {
                        // Find the highest and lowest price for each KillZone
                        double KZHighest=MathMax(High[iHighest(NULL,0,MODE_HIGH,KZBeginBarsOffset,i+1)],Open[i]);
                        double KZLowest=MathMin(Low[iLowest(NULL,0,MODE_LOW,KZBeginBarsOffset,i+1)],Open[i]);
                        CreateKZ("NY Open"+IntegerToString(NYOpenKZno), Time[i+z], Time[i], KZHighest, KZLowest, NYOpenColor);
                        ObjectSetString(0,"NY Open"+IntegerToString(NYOpenKZno),OBJPROP_TEXT,IntegerToString((int)MathRound((KZHighest-KZLowest)/(Point*FractionalPipDivider)))+" Pips");
                        NYOpenKZno++;
                        if(i+KZBeginBarsOffset<=BarsToProcess) i=i+KZBeginBarsOffset;
                       }
                    }
                 }
              }
            // For Asia Open KZ
            // check if Time of current bar = KZ end time
            if(TimeHour(Time[i])==ServerAsiaOpenEnd && TimeMinute(Time[i])==0)
              {
               // Calculate the expected number of bars to the left of the KZ end the KZ should begin
               int KZBeginBarsOffset = 60/ChartPeriod(0)*AsiaOpenDuration;
               // Find the bar # for KZ begining time
               // validate the time of KZBeginBarsOffset = KZ Begin time
               for(int z=0; z<=KZBeginBarsOffset; z++)
                 {
                  if(i+z<=Bars-1)  // To prevent going above the maxumum number of bars
                    {
                     if(TimeHour(Time[i+z])==ServerAsiaOpenBegin && TimeMinute(Time[i+z])==0)
                       {
                        // Find the highest and lowest price for each KillZone
                        double KZHighest=MathMax(High[iHighest(NULL,0,MODE_HIGH,KZBeginBarsOffset,i+1)],Open[i]);
                        double KZLowest=MathMin(Low[iLowest(NULL,0,MODE_LOW,KZBeginBarsOffset,i+1)],Open[i]);
                        CreateKZ("Asia Open"+IntegerToString(AsiaOpenKZno), Time[i+z], Time[i], KZHighest, KZLowest, AsiaOpenColor);
                        ObjectSetString(0,"Asia Open"+IntegerToString(AsiaOpenKZno),OBJPROP_TEXT,IntegerToString((int)MathRound((KZHighest-KZLowest)/(Point*FractionalPipDivider)))+" Pips");
                        AsiaOpenKZno++;
                        if(i+KZBeginBarsOffset<=BarsToProcess) i=i+KZBeginBarsOffset;
                       }
                    }
                 }
              }
           }  // end of for(int i=0; i<BarsToProcess; i++)
        }  // end of if(DrawKillZones_FirstPass)
      DrawKillZones_FirstPass=false;
      // The following section is to draw a KZ rectangle when the current time is within a KZ (ie after the KZ begining but before the end) and Bars>0 to skip this calculation when opening a blank chart on which there is not yet any bars
      if(GlobalVariableGet(GV_ShowKZ)==1 && ChartPeriod(0)<=60 && DrawKillZones_FirstPass==false && Bars>0)
        {
         // For London Open KZ
         if(ServerLondonOpenBeginDayOffset == ServerLondonOpenEndDayOffset)
           {
            if(TimeHour(Time[0])>=ServerLondonOpenBegin && TimeHour(Time[0])<ServerLondonOpenEnd)
              {
               ObjectDelete(0,"London Open"+IntegerToString(LondonOpenKZno));
               //find how many candles to the left the KZ begin candle is
               for(int z=0; z<=60/ChartPeriod(0)*LondonOpenDuration; z++)
                 {
                  if(TimeHour(Time[z])==ServerLondonOpenBegin && TimeMinute(Time[z])==0)
                    {
                     // Find the highest and lowest price for each KillZone
                     double KZHighest=High[iHighest(NULL,0,MODE_HIGH,z+1,0)];
                     double KZLowest=Low[iLowest(NULL,0,MODE_LOW,z+1,0)];
                     // When the current KZ is within only the first candle (#0) need to extend the rectangle by one candle otherwise the rectangle start and end date are the same
                     datetime KZend; 
                     if(z==0) KZend = (datetime)Time[0]+(ChartPeriod(0)*60);
                     else KZend = Time[0];
                     CreateKZ("London Open"+IntegerToString(LondonOpenKZno), Time[z], KZend, KZHighest, KZLowest, LondonOpenColor);
                     ObjectSetString(0,"London Open"+IntegerToString(LondonOpenKZno),OBJPROP_TEXT,IntegerToString((int)MathRound((KZHighest-KZLowest)/(Point*FractionalPipDivider)))+" Pips");
                     if(TimeHour(Time[0])==ServerLondonOpenEnd && TimeMinute(Time[0])==0) LondonOpenKZno++;
                    } 
                 }
              }
           }
         else
           {
            if(TimeHour(Time[0])>=ServerLondonOpenBegin || TimeHour(Time[0])<ServerLondonOpenEnd)
              {
               ObjectDelete(0,"London Open"+IntegerToString(LondonOpenKZno));
               //find how many candles to the left the KZ begin candle is
               for(int z=0; z<=60/ChartPeriod(0)*LondonOpenDuration; z++)
                 {
                  if(TimeHour(Time[z])==ServerLondonOpenBegin && TimeMinute(Time[z])==0)
                    {
                     // Find the highest and lowest price for each KillZone
                     double KZHighest=High[iHighest(NULL,0,MODE_HIGH,z+1,0)];
                     double KZLowest=Low[iLowest(NULL,0,MODE_LOW,z+1,0)];
                     // When the current KZ is within only the first candle (#0) need to extend the rectangle by one candle otherwise the rectangle start and end date are the same
                     datetime KZend; 
                     if(z==0) KZend = (datetime)Time[0]+(ChartPeriod(0)*60);
                     else KZend = Time[0];
                     CreateKZ("London Open"+IntegerToString(LondonOpenKZno), Time[z], KZend, KZHighest, KZLowest, LondonOpenColor);
                     ObjectSetString(0,"London Open"+IntegerToString(LondonOpenKZno),OBJPROP_TEXT,IntegerToString((int)MathRound((KZHighest-KZLowest)/(Point*FractionalPipDivider)))+" Pips");
                     if(TimeHour(Time[0])==ServerLondonOpenEnd && TimeMinute(Time[0])==0) LondonOpenKZno++;
                    } 
                 }
              }
           }
         // For London Close KZ
         if(ServerLondonCloseBeginDayOffset == ServerLondonCloseEndDayOffset)
           {
            if(TimeHour(Time[0])>=ServerLondonCloseBegin && TimeHour(Time[0])<ServerLondonCloseEnd)
              {
               ObjectDelete(0,"London Close"+IntegerToString(LondonCloseKZno));
               //find how many candles to the left the KZ begin candle is
               for(int z=0; z<=60/ChartPeriod(0)*LondonCloseDuration; z++)
                 {
                  if(TimeHour(Time[z])==ServerLondonCloseBegin && TimeMinute(Time[z])==0)
                    {
                     // Find the highest and lowest price for each KillZone
                     double KZHighest=High[iHighest(NULL,0,MODE_HIGH,z+1,0)];
                     double KZLowest=Low[iLowest(NULL,0,MODE_LOW,z+1,0)];
                     // When the current KZ is within only the first candle (#0) need to extend the rectangle by one candle otherwise the rectangle start and end date are the same
                     datetime KZend; 
                     if(z==0) KZend = (datetime)Time[0]+(ChartPeriod(0)*60);
                     else KZend = Time[0];
                     CreateKZ("London Close"+IntegerToString(LondonCloseKZno), Time[z], KZend, KZHighest, KZLowest, LondonCloseColor);
                     ObjectSetString(0,"London Close"+IntegerToString(LondonCloseKZno),OBJPROP_TEXT,IntegerToString((int)MathRound((KZHighest-KZLowest)/(Point*FractionalPipDivider)))+" Pips");
                     if(TimeHour(Time[0])==ServerLondonCloseEnd && TimeMinute(Time[0])==0) LondonCloseKZno++;
                    } 
                 }
              }
           }
         else
           {
            if(TimeHour(Time[0])>=ServerLondonCloseBegin || TimeHour(Time[0])<ServerLondonCloseEnd)
              {
               ObjectDelete(0,"London Close"+IntegerToString(LondonCloseKZno));
               //find how many candles to the left the KZ begin candle is
               for(int z=0; z<=60/ChartPeriod(0)*LondonCloseDuration; z++)
                 {
                  if(TimeHour(Time[z])==ServerLondonCloseBegin && TimeMinute(Time[z])==0)
                    {
                     // Find the highest and lowest price for each KillZone
                     double KZHighest=High[iHighest(NULL,0,MODE_HIGH,z+1,0)];
                     double KZLowest=Low[iLowest(NULL,0,MODE_LOW,z+1,0)];
                     // When the current KZ is within only the first candle (#0) need to extend the rectangle by one candle otherwise the rectangle start and end date are the same
                     datetime KZend; 
                     if(z==0) KZend = (datetime)Time[0]+(ChartPeriod(0)*60);
                     else KZend = Time[0];
                     CreateKZ("London Close"+IntegerToString(LondonCloseKZno), Time[z], KZend, KZHighest, KZLowest, LondonCloseColor);
                     ObjectSetString(0,"London Close"+IntegerToString(LondonCloseKZno),OBJPROP_TEXT,IntegerToString((int)MathRound((KZHighest-KZLowest)/(Point*FractionalPipDivider)))+" Pips");
                     if(TimeHour(Time[0])==ServerLondonCloseEnd && TimeMinute(Time[0])==0) LondonCloseKZno++;
                    } 
                 }
              }
           }
         // For NY Open KZ
         if(ServerNYOpenBeginDayOffset == ServerNYOpenEndDayOffset)
           {
            if(TimeHour(Time[0])>=ServerNYOpenBegin && TimeHour(Time[0])<ServerNYOpenEnd)
              {
               ObjectDelete(0,"NY Open"+IntegerToString(NYOpenKZno));
               //find how many candles to the left the KZ begin candle is
               for(int z=0; z<=60/ChartPeriod(0)*NYOpenDuration; z++)
                 {
                  if(TimeHour(Time[z])==ServerNYOpenBegin && TimeMinute(Time[z])==0)
                    {
                     // Find the highest and lowest price for each KillZone
                     double KZHighest=High[iHighest(NULL,0,MODE_HIGH,z+1,0)];
                     double KZLowest=Low[iLowest(NULL,0,MODE_LOW,z+1,0)];
                     // When the current KZ is within only the first candle (#0) need to extend the rectangle by one candle otherwise the rectangle start and end date are the same
                     datetime KZend; 
                     if(z==0) KZend = (datetime)Time[0]+(ChartPeriod(0)*60);
                     else KZend = Time[0];
                     CreateKZ("NY Open"+IntegerToString(NYOpenKZno), Time[z], KZend, KZHighest, KZLowest, NYOpenColor);
                     ObjectSetString(0,"NY Open"+IntegerToString(NYOpenKZno),OBJPROP_TEXT,IntegerToString((int)MathRound((KZHighest-KZLowest)/(Point*FractionalPipDivider)))+" Pips");
                     if(TimeHour(Time[0])==ServerNYOpenEnd && TimeMinute(Time[0])==0) NYOpenKZno++;
                    } 
                 }
              }
           }
         else
           {
            if(TimeHour(Time[0])>=ServerNYOpenBegin || TimeHour(Time[0])<ServerNYOpenEnd)
              {
               ObjectDelete(0,"NY Open"+IntegerToString(NYOpenKZno));
               //find how many candles to the left the KZ begin candle is
               for(int z=0; z<=60/ChartPeriod(0)*NYOpenDuration; z++)
                 {
                  if(TimeHour(Time[z])==ServerNYOpenBegin && TimeMinute(Time[z])==0)
                    {
                     // Find the highest and lowest price for each KillZone
                     double KZHighest=High[iHighest(NULL,0,MODE_HIGH,z+1,0)];
                     double KZLowest=Low[iLowest(NULL,0,MODE_LOW,z+1,0)];
                     // When the current KZ is within only the first candle (#0) need to extend the rectangle by one candle otherwise the rectangle start and end date are the same
                     datetime KZend; 
                     if(z==0) KZend = (datetime)Time[0]+(ChartPeriod(0)*60);
                     else KZend = Time[0];
                     CreateKZ("NY Open"+IntegerToString(NYOpenKZno), Time[z], KZend, KZHighest, KZLowest, NYOpenColor);
                     ObjectSetString(0,"NY Open"+IntegerToString(NYOpenKZno),OBJPROP_TEXT,IntegerToString((int)MathRound((KZHighest-KZLowest)/(Point*FractionalPipDivider)))+" Pips");
                     if(TimeHour(Time[0])==ServerNYOpenEnd && TimeMinute(Time[0])==0) NYOpenKZno++;
                    } 
                 }
              }
           }
         // For Asia Open KZ
         if(ServerAsiaOpenBeginDayOffset == ServerAsiaOpenEndDayOffset)
           {
            if(TimeHour(Time[0])>=ServerAsiaOpenBegin && TimeHour(Time[0])<ServerAsiaOpenEnd)
              {
               ObjectDelete(0,"Asia Open"+IntegerToString(AsiaOpenKZno));
               //find how many candles to the left the KZ begin candle is
               for(int z=0; z<=60/ChartPeriod(0)*AsiaOpenDuration; z++)
                 {
                  if(TimeHour(Time[z])==ServerAsiaOpenBegin && TimeMinute(Time[z])==0)
                    {
                     // Find the highest and lowest price for each KillZone
                     double KZHighest=High[iHighest(NULL,0,MODE_HIGH,z+1,0)];
                     double KZLowest=Low[iLowest(NULL,0,MODE_LOW,z+1,0)];
                     // When the current KZ is within only the first candle (#0) need to extend the rectangle by one candle otherwise the rectangle start and end date are the same
                     datetime KZend; 
                     if(z==0) KZend = (datetime)Time[0]+(ChartPeriod(0)*60);
                     else KZend = Time[0];
                     CreateKZ("Asia Open"+IntegerToString(AsiaOpenKZno), Time[z], KZend, KZHighest, KZLowest, AsiaOpenColor);
                     ObjectSetString(0,"Asia Open"+IntegerToString(AsiaOpenKZno),OBJPROP_TEXT,IntegerToString((int)MathRound((KZHighest-KZLowest)/(Point*FractionalPipDivider)))+" Pips");
                     if(TimeHour(Time[0])==ServerAsiaOpenEnd && TimeMinute(Time[0])==0) AsiaOpenKZno++;
                    } 
                 }
              }
           }
         else
           {
            if(TimeHour(Time[0])>=ServerAsiaOpenBegin || TimeHour(Time[0])<ServerAsiaOpenEnd)
              {
               ObjectDelete(0,"Asia Open"+IntegerToString(AsiaOpenKZno));
               //find how many candles to the left the KZ begin candle is
               for(int z=0; z<=60/ChartPeriod(0)*AsiaOpenDuration; z++)
                 {
                  if(TimeHour(Time[z])==ServerAsiaOpenBegin && TimeMinute(Time[z])==0)
                    {
                     // Find the highest and lowest price for each KillZone
                     double KZHighest=High[iHighest(NULL,0,MODE_HIGH,z+1,0)];
                     double KZLowest=Low[iLowest(NULL,0,MODE_LOW,z+1,0)];
                     // When the current KZ is within only the first candle (#0) need to extend the rectangle by one candle otherwise the rectangle start and end date are the same
                     datetime KZend; 
                     if(z==0) KZend = (datetime)Time[0]+(ChartPeriod(0)*60);
                     else KZend = Time[0];
                     CreateKZ("Asia Open"+IntegerToString(AsiaOpenKZno), Time[z], KZend, KZHighest, KZLowest, AsiaOpenColor);
                     ObjectSetString(0,"Asia Open"+IntegerToString(AsiaOpenKZno),OBJPROP_TEXT,IntegerToString((int)MathRound((KZHighest-KZLowest)/(Point*FractionalPipDivider)))+" Pips");
                     if(TimeHour(Time[0])==ServerAsiaOpenEnd && TimeMinute(Time[0])==0) AsiaOpenKZno++;
                    } 
                 }
              }
           }
        }  // end of if(... DrawKillZones_FirstPass==false)
     }  // end of if(GlobalVariableGet(GV_ShowKZ)==1 && ChartPeriod(0)<=60)
  }  // end of void DrawKillZones()
//----------------------------------  


//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Function to draw the Equity Kill Zone rectangles 
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
void DrawKillZonesEquity()
  {
   if(GlobalVariableGet(GV_ShowEquityKZ)==0 && ChartPeriod(0)<=30 && DrawKillZonesEquityActive==true)
     {
      RemoveKillZonesEquity();
     }
   // Validate if KillZones should be drawn; only on 30 min charts and lower
   if(GlobalVariableGet(GV_ShowEquityKZ)==1 && ChartPeriod(0)<=30)
     {
      DrawKillZonesEquityActive=true;
      int BarsUsed=IndicatorCounted();
      int BarsToProcess = Bars-1 - BarsUsed;
      if(DrawEquityKillZone_FirstPass)
        {
         BarsToProcess=Bars-1;
         for(int i=0; i<BarsToProcess; i++)
           {
            // check if Time of current bar = KZ end time
            if(TimeHour(Time[i])==ServerEquityEnd && TimeMinute(Time[i])==0)
              {
             // Calculate number of bars to the left the current KZ begins
               int KZBeginBarsOffset = (int)(60/ChartPeriod(0)*(double)EquityDuration);
               // validate the time of KZBeginBarsOffset = KZ Begin time
               if(i+KZBeginBarsOffset<=Bars-1)  // To prevent going above the maxumum number of bars
                 {
                  if(TimeHour(Time[i+KZBeginBarsOffset])==ServerEquityBeginHour && TimeMinute(Time[i+KZBeginBarsOffset])==EquityBeginMinutes)
                    {
                     // Find the highest and lowest price for each KillZone
                     double KZHighest=MathMax(High[iHighest(NULL,0,MODE_HIGH,KZBeginBarsOffset,i+1)],Open[i]);
                     double KZLowest=MathMin(Low[iLowest(NULL,0,MODE_LOW,KZBeginBarsOffset,i+1)],Open[i]);
                     CreateKZ("Equity Open"+IntegerToString(EquityKZno), Time[i+KZBeginBarsOffset], Time[i], KZHighest, KZLowest, EquityOpenColor);
                     ObjectSetString(0,"Equity Open"+IntegerToString(EquityKZno),OBJPROP_TEXT,IntegerToString((int)MathRound((KZHighest-KZLowest)/(Point*FractionalPipDivider)))+" Pips");
                     EquityKZno++;
                     if(i+KZBeginBarsOffset<=BarsToProcess) i=i+KZBeginBarsOffset;
                    }
                 }
              }
           }  // end of for(int i=0; i<BarsToProcess; i++)
        }  // end of if(DrawEquityKillZone_FirstPass)
      DrawEquityKillZone_FirstPass=false;
      // The following section is to draw a KZ rectangle when the current time is within a KZ (ie after the KZ begining but before the end)
      if(GlobalVariableGet(GV_ShowEquityKZ)==1 && ChartPeriod(0)<=60 && DrawEquityKillZone_FirstPass==false)
        {
         if((TimeHour(Time[0])>ServerEquityBeginHour || (TimeHour(Time[0])==ServerEquityBeginHour && TimeMinute(Time[0])>=EquityBeginMinutes)) && TimeHour(Time[0])<ServerEquityEnd)
           {
            ObjectDelete(0,"Equity Open"+IntegerToString(EquityKZno));
            //find how many candles to the left the KZ begin candle is
            for(int z=0; z<=60/ChartPeriod(0)*(double)EquityDuration; z++)
              {
               if(TimeHour(Time[z])==ServerEquityBeginHour && TimeMinute(Time[z])==EquityBeginMinutes)
                 {
                  // Find the highest and lowest price
                  double KZHighest=High[iHighest(NULL,0,MODE_HIGH,z,0)];
                  double KZLowest=Low[iLowest(NULL,0,MODE_LOW,z,0)];
                  CreateKZ("Equity Open"+IntegerToString(EquityKZno), Time[z], Time[0], KZHighest, KZLowest, EquityOpenColor);
                  ObjectSetString(0,"Equity Open"+IntegerToString(EquityKZno),OBJPROP_TEXT,IntegerToString((int)MathRound((KZHighest-KZLowest)/(Point*FractionalPipDivider)))+" Pips");
                  if(TimeHour(Time[0])==ServerEquityEnd && TimeMinute(Time[0])==0) EquityKZno++;
                 }
              }
           }
        }  // end of if(... DrawEquityKillZone_FirstPass==false)
     }  // end of if(GlobalVariableGet(GV_ShowEquityKZ)==1 && ChartPeriod(0)<=30)
  }  // end of void DrawEquityKillZones()

//----------------------------------  


//++++++++++++++++++++++++++++++++++
// Function to remove Equity KillZones 
//++++++++++++++++++++++++++++++++++
void RemoveKillZonesEquity()
  {
   for(int i=0; i<=EquityKZno; i++) 
     { 
      ObjectDelete(0,"Equity Open"+IntegerToString(i));
     } // end for(int i=
   EquityKZno=0;
   DrawEquityKillZone_FirstPass=true;
   DrawKillZonesEquityActive=false;
  }
//----------------------------------  


//+++++++++++++++++++++++++++++++++++++
// Function to remove Period Separators
//+++++++++++++++++++++++++++++++++++++
void RemovePeriodSeparators()
  {
   for(int i=0; i<Bars-1; i++)
     {
      ObjectDelete(0,"PS"+IntegerToString(i));
      ObjectDelete(0,"CMEPriceProjection"+IntegerToString(i));
     }
   YearlyPSLine=0;
   QuarterlyPsLine=0;
   MonthlyPSLine=0;
   EveryMondayPSLine=0;
   DailyPSLine=0;
   period_separators_FirstPass=true;
  }
//----------------------------------  


//+++++++++++++++++++++++++++++++++++++++++++++++++
// Function to Calculate the Period Separators
//+++++++++++++++++++++++++++++++++++++++++++++++++
void period_separators()
  {
   int BarsUsed=IndicatorCounted();
   int BarsToProcess = Bars-1 - BarsUsed;
   if(period_separators_FirstPass)
     {
      counterPS=0;
      BarsToProcess=Bars-1;
     }
   period_separators_FirstPass=false;
   // Draw lines from Midnight London
   if(GlobalVariableGet(GV_ShowPeriodSeparators)==1)
     {  
      for(int i=0; i<BarsToProcess; i++)
        {
         if(counterPS>=MaximumPSLines) break;
         // Monday London midnight lines
         if((ChartPeriod(0)<=240))
           {   
            if(TimeDayOfWeek(Time[i])==1+ServerMidnightLondonDayOffset && TimeHour(Time[i])==ServerMidnightLondon && TimeMinute(Time[i])==0)
              {
               counterPS++;
               drawPS("PS"+IntegerToString(counterPS),Time[i],Red);  //,MondayTDBeginColor);
               ObjectSetString(0,"PS"+IntegerToString(counterPS),OBJPROP_TOOLTIP,StringConcatenate("Monday   ",TimeToString(Time[i],TIME_DATE),"\nLondon midnight"));
              }
           }
         // Tuesday to Friday True Day Begin lines
         if( (ChartPeriod(0)<240) || (ChartPeriod(0)==240 && ZoomLevel>=2) )
           {
            if(TimeDayOfWeek(Time[i])==2+ServerMidnightLondonDayOffset && TimeHour(Time[i])==ServerMidnightLondon && TimeMinute(Time[i])==0)
              {
               counterPS++;
               drawPS("PS"+IntegerToString(counterPS),Time[i],Tue_Fri_TDBeginColor);
               ObjectSetString(0,"PS"+IntegerToString(counterPS),OBJPROP_TOOLTIP,StringConcatenate("Tuesday   ",TimeToString(Time[i],TIME_DATE),"\nLondon midnight"));
              }
            if(TimeDayOfWeek(Time[i])==3+ServerMidnightLondonDayOffset && TimeHour(Time[i])==ServerMidnightLondon && TimeMinute(Time[i])==0)
              {
               counterPS++;
               drawPS("PS"+IntegerToString(counterPS),Time[i],Tue_Fri_TDBeginColor);
               ObjectSetString(0,"PS"+IntegerToString(counterPS),OBJPROP_TOOLTIP,StringConcatenate("Wednesday   ",TimeToString(Time[i],TIME_DATE),"\nLondon midnight"));
              }
            if(TimeDayOfWeek(Time[i])==4+ServerMidnightLondonDayOffset && TimeHour(Time[i])==ServerMidnightLondon && TimeMinute(Time[i])==0)
              {
               counterPS++;
               drawPS("PS"+IntegerToString(counterPS),Time[i],Tue_Fri_TDBeginColor);
               ObjectSetString(0,"PS"+IntegerToString(counterPS),OBJPROP_TOOLTIP,StringConcatenate("Thursday   ",TimeToString(Time[i],TIME_DATE),"\nLondon midnight"));
              }
            if(TimeDayOfWeek(Time[i])==5+ServerMidnightLondonDayOffset && TimeHour(Time[i])==ServerMidnightLondon && TimeMinute(Time[i])==0)
              {
               counterPS++;
               drawPS("PS"+IntegerToString(counterPS),Time[i],Tue_Fri_TDBeginColor);
               ObjectSetString(0,"PS"+IntegerToString(counterPS),OBJPROP_TOOLTIP,StringConcatenate("Friday   ",TimeToString(Time[i],TIME_DATE),"\nLondon midnight"));
              }
           }
        }
     }  // end of if(ShowPeriodSeparatorsState==0)
     // End of Draw lines from Midnight London


   // Draw lines from Midnight New York
   if(GlobalVariableGet(GV_ShowPeriodSeparators)==2)
     {  
      for(int i=0; i<BarsToProcess; i++)
        {
         if(counterPS>=MaximumPSLines) break;
         // Monday London midnight lines
         if((ChartPeriod(0)<=240))
           {   
            if(TimeDayOfWeek(Time[i])==1+ServerMidnightNYDayOffset && TimeHour(Time[i])==ServerMidnightNY && TimeMinute(Time[i])==0)
              {
               counterPS++;
               drawPS("PS"+IntegerToString(counterPS),Time[i],MondayTDBeginColor);
               ObjectSetString(0,"PS"+IntegerToString(counterPS),OBJPROP_TOOLTIP,StringConcatenate("Monday   ",TimeToString(Time[i],TIME_DATE),"\nNew York midnight"));
              }
           }
         // Tuesday to Friday True Day Begin lines
         if( (ChartPeriod(0)<240) || (ChartPeriod(0)==240 && ZoomLevel>=2) )
           {
            if(TimeDayOfWeek(Time[i])==2+ServerMidnightNYDayOffset && TimeHour(Time[i])==ServerMidnightNY && TimeMinute(Time[i])==0)
              {
               counterPS++;
               drawPS("PS"+IntegerToString(counterPS),Time[i],Tue_Fri_TDBeginColor);
               ObjectSetString(0,"PS"+IntegerToString(counterPS),OBJPROP_TOOLTIP,StringConcatenate("Tuesday   ",TimeToString(Time[i],TIME_DATE),"\nNew York midnight"));
              }
            if(TimeDayOfWeek(Time[i])==3+ServerMidnightNYDayOffset && TimeHour(Time[i])==ServerMidnightNY && TimeMinute(Time[i])==0)
              {
               counterPS++;
               drawPS("PS"+IntegerToString(counterPS),Time[i],Tue_Fri_TDBeginColor);
               ObjectSetString(0,"PS"+IntegerToString(counterPS),OBJPROP_TOOLTIP,StringConcatenate("Wednesday   ",TimeToString(Time[i],TIME_DATE),"\nNew York midnight"));
              }
            if(TimeDayOfWeek(Time[i])==4+ServerMidnightNYDayOffset && TimeHour(Time[i])==ServerMidnightNY && TimeMinute(Time[i])==0)
              {
               counterPS++;
               drawPS("PS"+IntegerToString(counterPS),Time[i],Tue_Fri_TDBeginColor);
               ObjectSetString(0,"PS"+IntegerToString(counterPS),OBJPROP_TOOLTIP,StringConcatenate("Thursday   ",TimeToString(Time[i],TIME_DATE),"\nNew York midnight"));
              }
            if(TimeDayOfWeek(Time[i])==5+ServerMidnightNYDayOffset && TimeHour(Time[i])==ServerMidnightNY && TimeMinute(Time[i])==0)
              {
               counterPS++;
               drawPS("PS"+IntegerToString(counterPS),Time[i],Tue_Fri_TDBeginColor);
               ObjectSetString(0,"PS"+IntegerToString(counterPS),OBJPROP_TOOLTIP,StringConcatenate("Friday   ",TimeToString(Time[i],TIME_DATE),"\nNew York midnight"));
              }
           }
        }
     }  // end of if(ShowPeriodSeparatorsState==1)
     // End of Draw lines from Midnight New York


   // Draw True Day lines
   if(GlobalVariableGet(GV_ShowPeriodSeparators)==3)
     {  
      for(int i=0; i<BarsToProcess; i++)
        {
         if(DailyPSLine>=MaximumPSLines) break;
         // Monday True Day Begin lines
         if((ChartPeriod(0)<=240))
           {   
            if(TimeDayOfWeek(Time[i])==1+ServerTrueDayStartDayOffset && TimeHour(Time[i])==ServerTrueDayStart && TimeMinute(Time[i])==0)
              {
               counterPS++;
               DailyPSLine++;
               drawPS("PS"+IntegerToString(counterPS),Time[i],MondayTDBeginColor);
               ObjectSetString(0,"PS"+IntegerToString(counterPS),OBJPROP_TOOLTIP,StringConcatenate("Monday   ",TimeToString(Time[i],TIME_DATE),"\nTrue Day Begin"));
              }
           }
         // Tuesday to Friday True Day Begin lines
         if( (ChartPeriod(0)<240) || (ChartPeriod(0)==240 && ZoomLevel>=2) )
           {
            if(TimeDayOfWeek(Time[i])==2+ServerTrueDayStartDayOffset && TimeHour(Time[i])==ServerTrueDayStart && TimeMinute(Time[i])==0)
              {
               counterPS++;
               DailyPSLine++;
               drawPS("PS"+IntegerToString(counterPS),Time[i],Tue_Fri_TDBeginColor);
               ObjectSetString(0,"PS"+IntegerToString(counterPS),OBJPROP_TOOLTIP,StringConcatenate("Tuesday   ",TimeToString(Time[i],TIME_DATE),"\nTrue Day Begin"));
              }
            if(TimeDayOfWeek(Time[i])==3+ServerTrueDayStartDayOffset && TimeHour(Time[i])==ServerTrueDayStart && TimeMinute(Time[i])==0)
              {
               counterPS++;
               DailyPSLine++;
               drawPS("PS"+IntegerToString(counterPS),Time[i],Tue_Fri_TDBeginColor);
               ObjectSetString(0,"PS"+IntegerToString(counterPS),OBJPROP_TOOLTIP,StringConcatenate("Wednesday   ",TimeToString(Time[i],TIME_DATE),"\nTrue Day Begin"));
              }
            if(TimeDayOfWeek(Time[i])==4+ServerTrueDayStartDayOffset && TimeHour(Time[i])==ServerTrueDayStart && TimeMinute(Time[i])==0)
              {
               counterPS++;
               DailyPSLine++;
               drawPS("PS"+IntegerToString(counterPS),Time[i],Tue_Fri_TDBeginColor);
               ObjectSetString(0,"PS"+IntegerToString(counterPS),OBJPROP_TOOLTIP,StringConcatenate("Thursday   ",TimeToString(Time[i],TIME_DATE),"\nTrue Day Begin"));
              }
            if(TimeDayOfWeek(Time[i])==5+ServerTrueDayStartDayOffset && TimeHour(Time[i])==ServerTrueDayStart && TimeMinute(Time[i])==0)
              {
               counterPS++;
               DailyPSLine++;
               drawPS("PS"+IntegerToString(counterPS),Time[i],Tue_Fri_TDBeginColor);
               ObjectSetString(0,"PS"+IntegerToString(counterPS),OBJPROP_TOOLTIP,StringConcatenate("Friday   ",TimeToString(Time[i],TIME_DATE),"\nTrue Day Begin"));
              }
           }
         // Monday to Thursday True Day End lines
         if( (ChartPeriod(0)<=30) || (ChartPeriod(0)==60 && ZoomLevel>=2) )
           {
            if(TimeDayOfWeek(Time[i])==1+ServerTrueDayEndDayOffset && TimeHour(Time[i])==ServerTrueDayEnd && TimeMinute(Time[i])==0)
              {
               counterPS++;
               drawPS("PS"+IntegerToString(counterPS),Time[i],Mon_Thr_TDEndColor);
               ObjectSetString(0,"PS"+IntegerToString(counterPS),OBJPROP_TOOLTIP,StringConcatenate("Monday   ",TimeToString(Time[i],TIME_DATE),"\nTrue Day End"));
              }
            if(TimeDayOfWeek(Time[i])==2+ServerTrueDayEndDayOffset && TimeHour(Time[i])==ServerTrueDayEnd && TimeMinute(Time[i])==0)
              {
               counterPS++;
               drawPS("PS"+IntegerToString(counterPS),Time[i],Mon_Thr_TDEndColor);
               ObjectSetString(0,"PS"+IntegerToString(counterPS),OBJPROP_TOOLTIP,StringConcatenate("Tuesday   ",TimeToString(Time[i],TIME_DATE),"\nTrue Day End"));
              }
            if(TimeDayOfWeek(Time[i])==3+ServerTrueDayEndDayOffset && TimeHour(Time[i])==ServerTrueDayEnd && TimeMinute(Time[i])==0)
              {
               counterPS++;
               drawPS("PS"+IntegerToString(counterPS),Time[i],Mon_Thr_TDEndColor);
               ObjectSetString(0,"PS"+IntegerToString(counterPS),OBJPROP_TOOLTIP,StringConcatenate("Wednesday   ",TimeToString(Time[i],TIME_DATE),"\nTrue Day End"));
              }
            if(TimeDayOfWeek(Time[i])==4+ServerTrueDayEndDayOffset && TimeHour(Time[i])==ServerTrueDayEnd && TimeMinute(Time[i])==0)
              {
               counterPS++;
               drawPS("PS"+IntegerToString(counterPS),Time[i],Mon_Thr_TDEndColor);
               ObjectSetString(0,"PS"+IntegerToString(counterPS),OBJPROP_TOOLTIP,StringConcatenate("Thursday   ",TimeToString(Time[i],TIME_DATE),"\nTrue Day End"));
              }
           }
         // Friday True Day End Lines
         if(ChartPeriod(0)<=60)
           {
            if(TimeDayOfWeek(Time[i])==5+ServerTrueDayEndDayOffset && TimeHour(Time[i])==ServerTrueDayEnd && TimeMinute(Time[i])==0)
              {
               counterPS++;
               drawPS("PS"+IntegerToString(counterPS),Time[i],Friday_TDEnd);
               ObjectSetString(0,"PS"+IntegerToString(counterPS),OBJPROP_TOOLTIP,StringConcatenate("Friday   ",TimeToString(Time[i],TIME_DATE),"\nTrue Day End"));
              }
           }
        }
     }  // end of if(ShowPeriodSeparatorsState==3)
   // End of Draw True Day lines


   // Draw lines from CME Futures new day time (ie 17h00 Chicago)
   if(GlobalVariableGet(GV_ShowPeriodSeparators)==4)
     {  
      for(int i=0; i<BarsToProcess; i++)
        {
         // Sunday 17h00 Chicaco (new week)
         if((ChartPeriod(0)<=240))
           {   
            if(DailyPSLine>=MaximumPSLines) break;
            if(TimeDayOfWeek(Time[i])==0+ServerCMEFuturesDayBeginHourDayOffset && TimeHour(Time[i])==ServerCMEFuturesDayBeginHour && TimeMinute(Time[i])==0)
              {
               // Draw Begining of session vertical line
               counterPS++;
               DailyPSLine++;
               drawPS("PS"+IntegerToString(counterPS),Time[i],CMEDayBeginSunday);
               ObjectSetString(0,"PS"+IntegerToString(counterPS),OBJPROP_TOOLTIP,StringConcatenate("Monday session   ",TimeToString(Time[i],TIME_DATE),"\nCME Futures day begin"));
               // Draw Opening price projection line
               ObjectCreate("CMEPriceProjection"+IntegerToString(counterPS),OBJ_TREND,0,Time[i],Open[i],Time[i]+(CMEFuturesDayDuration*60*60)-(ChartPeriod(0)*60),Open[i]);
               ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_COLOR,CMEDayBeginSunday); // Color value to set/get object color.
               ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_STYLE,STYLE_DOT); // Value is one of STYLE_SOLID, STYLE_DASH, STYLE_DOT, STYLE_DASHDOT, STYLE_DASHDOTDOT constants to set/get object line style.
               ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_WIDTH,1); // Integer value to set/get object line width. Can be from 1 to 5.
               ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_BACK,false); // Boolean value to set/get background drawing flag for object. (for example "true" will hide the value at the bottom of the chart.)
               ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_RAY,false); // Boolean value to set/get ray flag of object. (for example "true" will extend the line to the right edge.)
               ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_HIDDEN,ObjectNotListed);
               ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1|OBJ_PERIOD_H4);
               ObjectSetString(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_TOOLTIP,"CME Monday Session\nOpen Price Projection\n"+TimeToString(Time[i],TIME_DATE)+"\n"+DoubleToString(Open[i],(int)MarketInfo("0",MODE_DIGITS)));
               // Draw End of session vertical line
               counterPS++;
               // The CME Day end time = Day begin time + duration in seconds (ie 23h * 60 min * 60 sec) - one candle duration in second (ie ChartPeriod(0) * 60 sec)
               drawPS("PS"+IntegerToString(counterPS),Time[i]+(CMEFuturesDayDuration*60*60)-(ChartPeriod(0)*60),CMEDayEndMon_Thr);
               ObjectSetString(0,"PS"+IntegerToString(counterPS),OBJPROP_TOOLTIP,StringConcatenate("Monday session   ",TimeToString(Time[i],TIME_DATE),"\nCME Futures day end"));
               // Find bar # corresponding to session end time
               int EndBarNumber=i-((CMEFuturesDayDuration*60*60)/(ChartPeriod(0)*60));
               // Sometime there is less bar # for the session duration because there were no ticks so the target bar # could be below 0 but a candle # can't be below 0
               if(EndBarNumber<0) EndBarNumber=0;
               for(int z=EndBarNumber; z<i; z++)
                 {
                  if(Time[z]==Time[i]+(CMEFuturesDayDuration*60*60)-(ChartPeriod(0)*60))
                    {
                     // Draw Closing price projection line
                     ObjectCreate("CMEPriceProjection"+IntegerToString(counterPS),OBJ_TREND,0,Time[i],Close[z],Time[z],Close[z]);
                     ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_COLOR,CMEDayEndMon_Thr); // Color value to set/get object color.
                     ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_STYLE,STYLE_DOT); // Value is one of STYLE_SOLID, STYLE_DASH, STYLE_DOT, STYLE_DASHDOT, STYLE_DASHDOTDOT constants to set/get object line style.
                     ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_WIDTH,1); // Integer value to set/get object line width. Can be from 1 to 5.
                     ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_BACK,false); // Boolean value to set/get background drawing flag for object. (for example "true" will hide the value at the bottom of the chart.)
                     ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_RAY,false); // Boolean value to set/get ray flag of object. (for example "true" will extend the line to the right edge.)
                     ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_HIDDEN,ObjectNotListed);
                     ObjectSetString(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_TOOLTIP,"CME Monday Session\nClose Price Projection\n"+TimeToString(Time[z],TIME_DATE)+"\n"+DoubleToString(Close[z],(int)MarketInfo("0",MODE_DIGITS))+"\n\nRange (Close-Open): "+IntegerToString((int)MathRound((Close[z]-Open[i])/(Point*FractionalPipDivider)))+" Pips");
                    }
                 }
              }
           }
         // Monday to Thursday 17h00 Chicago (new day)
         if( (ChartPeriod(0)<240) || (ChartPeriod(0)==240 && ZoomLevel>=2) )
           {
            if(TimeDayOfWeek(Time[i])==1+ServerCMEFuturesDayBeginHourDayOffset && TimeHour(Time[i])==ServerCMEFuturesDayBeginHour && TimeMinute(Time[i])==0)
              {
               // Draw Begining of Tuesday session vertical line
               counterPS++;
               DailyPSLine++;
               drawPS("PS"+IntegerToString(counterPS),Time[i],CMEDayBeginMon_Thr);
               ObjectSetString(0,"PS"+IntegerToString(counterPS),OBJPROP_TOOLTIP,StringConcatenate("Tuesday session   ",TimeToString(Time[i],TIME_DATE),"\nCME Futures day begin"));
               // Draw Opening price projection line
               ObjectCreate("CMEPriceProjection"+IntegerToString(counterPS),OBJ_TREND,0,Time[i],Open[i],Time[i]+(CMEFuturesDayDuration*60*60)-(ChartPeriod(0)*60),Open[i]);
               ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_COLOR,CMEDayBeginMon_Thr); // Color value to set/get object color.
               ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_STYLE,STYLE_DOT); // Value is one of STYLE_SOLID, STYLE_DASH, STYLE_DOT, STYLE_DASHDOT, STYLE_DASHDOTDOT constants to set/get object line style.
               ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_WIDTH,1); // Integer value to set/get object line width. Can be from 1 to 5.
               ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_BACK,false); // Boolean value to set/get background drawing flag for object. (for example "true" will hide the value at the bottom of the chart.)
               ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_RAY,false); // Boolean value to set/get ray flag of object. (for example "true" will extend the line to the right edge.)
               ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_HIDDEN,ObjectNotListed);
               ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1|OBJ_PERIOD_H4);
               ObjectSetString(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_TOOLTIP,"CME Tuesday Session\nOpen Price Projection\n"+TimeToString(Time[i])+"\n"+DoubleToString(Open[i],(int)MarketInfo("0",MODE_DIGITS)));
               // Draw End of session vertical line
               counterPS++;
               // The CME Day end time = Day begin time + duration in seconds (ie 23h * 60 min * 60 sec) - one candle duration in second (ie ChartPeriod(0) * 60 sec)
               drawPS("PS"+IntegerToString(counterPS),Time[i]+(CMEFuturesDayDuration*60*60)-(ChartPeriod(0)*60),CMEDayEndMon_Thr);
               ObjectSetString(0,"PS"+IntegerToString(counterPS),OBJPROP_TOOLTIP,StringConcatenate("Tuesday session   ",TimeToString(Time[i],TIME_DATE),"\nCME Futures day end"));
               // Find bar # corresponding to session end time
               int EndBarNumber=i-((CMEFuturesDayDuration*60*60)/(ChartPeriod(0)*60));
               // Sometime there is less bar # for the session duration because there were no ticks so the target bar # could be below 0 but a candle # can't be below 0
               if(EndBarNumber<0) EndBarNumber=0;
               for(int z=EndBarNumber; z<i; z++)
                 {
                  if(Time[z]==Time[i]+(CMEFuturesDayDuration*60*60)-(ChartPeriod(0)*60))
                    {
                     // Draw Closing price projection line
                     ObjectCreate("CMEPriceProjection"+IntegerToString(counterPS),OBJ_TREND,0,Time[i],Close[z],Time[z],Close[z]);
                     ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_COLOR,CMEDayEndMon_Thr); // Color value to set/get object color.
                     ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_STYLE,STYLE_DOT); // Value is one of STYLE_SOLID, STYLE_DASH, STYLE_DOT, STYLE_DASHDOT, STYLE_DASHDOTDOT constants to set/get object line style.
                     ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_WIDTH,1); // Integer value to set/get object line width. Can be from 1 to 5.
                     ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_BACK,false); // Boolean value to set/get background drawing flag for object. (for example "true" will hide the value at the bottom of the chart.)
                     ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_RAY,false); // Boolean value to set/get ray flag of object. (for example "true" will extend the line to the right edge.)
                     ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_HIDDEN,ObjectNotListed);
                     ObjectSetString(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_TOOLTIP,"CME Tuesday Session\nClose Price Projection\n"+TimeToString(Time[z])+"\n"+DoubleToString(Close[z],(int)MarketInfo("0",MODE_DIGITS))+"\n\nRange (Close-Open): "+IntegerToString((int)MathRound((Close[z]-Open[i])/(Point*FractionalPipDivider)))+" Pips");
                    }
                 }
              }
            if(TimeDayOfWeek(Time[i])==2+ServerCMEFuturesDayBeginHourDayOffset && TimeHour(Time[i])==ServerCMEFuturesDayBeginHour && TimeMinute(Time[i])==0)
              {
               // Draw Begining of Wednesday session vertical line
               counterPS++;
               DailyPSLine++;
               drawPS("PS"+IntegerToString(counterPS),Time[i],CMEDayBeginMon_Thr);
               ObjectSetString(0,"PS"+IntegerToString(counterPS),OBJPROP_TOOLTIP,StringConcatenate("Wednesday session   ",TimeToString(Time[i],TIME_DATE),"\nCME Futures day begin"));
               // Draw Opening price projection line
               ObjectCreate("CMEPriceProjection"+IntegerToString(counterPS),OBJ_TREND,0,Time[i],Open[i],Time[i]+(CMEFuturesDayDuration*60*60)-(ChartPeriod(0)*60),Open[i]);
               ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_COLOR,CMEDayBeginMon_Thr); // Color value to set/get object color.
               ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_STYLE,STYLE_DOT); // Value is one of STYLE_SOLID, STYLE_DASH, STYLE_DOT, STYLE_DASHDOT, STYLE_DASHDOTDOT constants to set/get object line style.
               ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_WIDTH,1); // Integer value to set/get object line width. Can be from 1 to 5.
               ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_BACK,false); // Boolean value to set/get background drawing flag for object. (for example "true" will hide the value at the bottom of the chart.)
               ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_RAY,false); // Boolean value to set/get ray flag of object. (for example "true" will extend the line to the right edge.)
               ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_HIDDEN,ObjectNotListed);
               ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1|OBJ_PERIOD_H4);
               ObjectSetString(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_TOOLTIP,"CME Wednesday Session\nOpen Price Projection\n"+TimeToString(Time[i])+"\n"+DoubleToString(Open[i],(int)MarketInfo("0",MODE_DIGITS)));
               // Draw End of session vertical line
               counterPS++;
               drawPS("PS"+IntegerToString(counterPS),Time[i]+(CMEFuturesDayDuration*60*60)-(ChartPeriod(0)*60),CMEDayEndMon_Thr);
               ObjectSetString(0,"PS"+IntegerToString(counterPS),OBJPROP_TOOLTIP,StringConcatenate("Wednesday session   ",TimeToString(Time[i],TIME_DATE),"\nCME Futures day end"));
               // Find bar # corresponding to session end time
               int EndBarNumber=i-((CMEFuturesDayDuration*60*60)/(ChartPeriod(0)*60));
               // Sometime there is less bar # for the session duration because there were no ticks so the target bar # could be below 0 but a candle # can't be below 0
               if(EndBarNumber<0) EndBarNumber=0;
               for(int z=EndBarNumber; z<i; z++)
                 {
                  if(Time[z]==Time[i]+(CMEFuturesDayDuration*60*60)-(ChartPeriod(0)*60))
                    {
                     // Draw Closing price projection line
                     ObjectCreate("CMEPriceProjection"+IntegerToString(counterPS),OBJ_TREND,0,Time[i],Close[z],Time[z],Close[z]);
                     ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_COLOR,CMEDayEndMon_Thr); // Color value to set/get object color.
                     ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_STYLE,STYLE_DOT); // Value is one of STYLE_SOLID, STYLE_DASH, STYLE_DOT, STYLE_DASHDOT, STYLE_DASHDOTDOT constants to set/get object line style.
                     ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_WIDTH,1); // Integer value to set/get object line width. Can be from 1 to 5.
                     ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_BACK,false); // Boolean value to set/get background drawing flag for object. (for example "true" will hide the value at the bottom of the chart.)
                     ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_RAY,false); // Boolean value to set/get ray flag of object. (for example "true" will extend the line to the right edge.)
                     ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_HIDDEN,ObjectNotListed);
                     ObjectSetString(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_TOOLTIP,"CME Wednesday Session\nClose Price Projection\n"+TimeToString(Time[z])+"\n"+DoubleToString(Close[z],(int)MarketInfo("0",MODE_DIGITS))+"\n\nRange (Close-Open): "+IntegerToString((int)MathRound((Close[z]-Open[i])/(Point*FractionalPipDivider)))+" Pips");
                    }
                 }
              }
            if(TimeDayOfWeek(Time[i])==3+ServerCMEFuturesDayBeginHourDayOffset && TimeHour(Time[i])==ServerCMEFuturesDayBeginHour && TimeMinute(Time[i])==0)
              {
               // Draw Begining of Thursday session vertical line
               counterPS++;
               DailyPSLine++;
               drawPS("PS"+IntegerToString(counterPS),Time[i],CMEDayBeginMon_Thr);
               ObjectSetString(0,"PS"+IntegerToString(counterPS),OBJPROP_TOOLTIP,StringConcatenate("Thursday session   ",TimeToString(Time[i],TIME_DATE),"\nCME Futures day begin"));
               // Draw Opening price projection line
               ObjectCreate("CMEPriceProjection"+IntegerToString(counterPS),OBJ_TREND,0,Time[i],Open[i],Time[i]+(CMEFuturesDayDuration*60*60)-(ChartPeriod(0)*60),Open[i]);
               ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_COLOR,CMEDayBeginMon_Thr); // Color value to set/get object color.
               ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_STYLE,STYLE_DOT); // Value is one of STYLE_SOLID, STYLE_DASH, STYLE_DOT, STYLE_DASHDOT, STYLE_DASHDOTDOT constants to set/get object line style.
               ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_WIDTH,1); // Integer value to set/get object line width. Can be from 1 to 5.
               ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_BACK,false); // Boolean value to set/get background drawing flag for object. (for example "true" will hide the value at the bottom of the chart.)
               ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_RAY,false); // Boolean value to set/get ray flag of object. (for example "true" will extend the line to the right edge.)
               ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_HIDDEN,ObjectNotListed);
               ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1|OBJ_PERIOD_H4);
               ObjectSetString(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_TOOLTIP,"CME Thursday Session\nOpen Price Projection\n"+TimeToString(Time[i])+"\n"+DoubleToString(Open[i],(int)MarketInfo("0",MODE_DIGITS)));
               // Draw End of session vertical line
               counterPS++;
               drawPS("PS"+IntegerToString(counterPS),Time[i]+(CMEFuturesDayDuration*60*60)-(ChartPeriod(0)*60),CMEDayEndMon_Thr);
               ObjectSetString(0,"PS"+IntegerToString(counterPS),OBJPROP_TOOLTIP,StringConcatenate("Thursday session   ",TimeToString(Time[i],TIME_DATE),"\nCME Futures day end"));
               // Find bar # corresponding to session end time
               int EndBarNumber=i-((CMEFuturesDayDuration*60*60)/(ChartPeriod(0)*60));
               // Sometime there is less bar # for the session duration because there were no ticks so the target bar # could be below 0 but a candle # can't be below 0
               if(EndBarNumber<0) EndBarNumber=0;
               for(int z=EndBarNumber; z<i; z++)
                 {
                  if(Time[z]==Time[i]+(CMEFuturesDayDuration*60*60)-(ChartPeriod(0)*60))
                    {
                     // Draw Closing price projection line
                     ObjectCreate("CMEPriceProjection"+IntegerToString(counterPS),OBJ_TREND,0,Time[i],Close[z],Time[z],Close[z]);
                     ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_COLOR,CMEDayEndMon_Thr); // Color value to set/get object color.
                     ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_STYLE,STYLE_DOT); // Value is one of STYLE_SOLID, STYLE_DASH, STYLE_DOT, STYLE_DASHDOT, STYLE_DASHDOTDOT constants to set/get object line style.
                     ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_WIDTH,1); // Integer value to set/get object line width. Can be from 1 to 5.
                     ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_BACK,false); // Boolean value to set/get background drawing flag for object. (for example "true" will hide the value at the bottom of the chart.)
                     ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_RAY,false); // Boolean value to set/get ray flag of object. (for example "true" will extend the line to the right edge.)
                     ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_HIDDEN,ObjectNotListed);
                     ObjectSetString(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_TOOLTIP,"CME Thursday Session\nClose Price Projection\n"+TimeToString(Time[z])+"\n"+DoubleToString(Close[z],(int)MarketInfo("0",MODE_DIGITS))+"\n\nRange (Close-Open): "+IntegerToString((int)MathRound((Close[z]-Open[i])/(Point*FractionalPipDivider)))+" Pips");
                    }
                 }
              }
            if(TimeDayOfWeek(Time[i])==4+ServerCMEFuturesDayBeginHourDayOffset && TimeHour(Time[i])==ServerCMEFuturesDayBeginHour && TimeMinute(Time[i])==0)
              {
               // Draw Begining of Friday session vertical line
               counterPS++;
               DailyPSLine++;
               drawPS("PS"+IntegerToString(counterPS),Time[i],CMEDayBeginMon_Thr);
               ObjectSetString(0,"PS"+IntegerToString(counterPS),OBJPROP_TOOLTIP,StringConcatenate("Friday session   ",TimeToString(Time[i],TIME_DATE),"\nCME Futures day begin"));
               // Draw Opening price projection line
               ObjectCreate("CMEPriceProjection"+IntegerToString(counterPS),OBJ_TREND,0,Time[i],Open[i],Time[i]+(CMEFuturesDayDuration*60*60)-(ChartPeriod(0)*60),Open[i]);
               ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_COLOR,CMEDayBeginMon_Thr); // Color value to set/get object color.
               ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_STYLE,STYLE_DOT); // Value is one of STYLE_SOLID, STYLE_DASH, STYLE_DOT, STYLE_DASHDOT, STYLE_DASHDOTDOT constants to set/get object line style.
               ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_WIDTH,1); // Integer value to set/get object line width. Can be from 1 to 5.
               ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_BACK,false); // Boolean value to set/get background drawing flag for object. (for example "true" will hide the value at the bottom of the chart.)
               ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_RAY,false); // Boolean value to set/get ray flag of object. (for example "true" will extend the line to the right edge.)
               ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_HIDDEN,ObjectNotListed);
               ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1|OBJ_PERIOD_H4);
               ObjectSetString(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_TOOLTIP,"CME Friday Session\nOpen Price Projection\n"+TimeToString(Time[i])+"\n"+DoubleToString(Open[i],(int)MarketInfo("0",MODE_DIGITS)));
               // Draw End of session vertical line
               counterPS++;
               drawPS("PS"+IntegerToString(counterPS),Time[i]+(CMEFuturesDayDuration*60*60)-(ChartPeriod(0)*60),CMEDayEndFriday);
               ObjectSetString(0,"PS"+IntegerToString(counterPS),OBJPROP_TOOLTIP,StringConcatenate("Friday session   ",TimeToString(Time[i],TIME_DATE),"\nCME Futures day end\n",counterPS));
               // Find bar # corresponding to session end time
               int EndBarNumber=i-((CMEFuturesDayDuration*60*60)/(ChartPeriod(0)*60));
               // Sometime there is less bar # for the session duration because there were no ticks so the target bar # could be below 0 but a candle # can't be below 0
               if(EndBarNumber<0) EndBarNumber=0;
               for(int z=EndBarNumber; z<i; z++)
                 {
                  if(Time[z]==Time[i]+(CMEFuturesDayDuration*60*60)-(ChartPeriod(0)*60))
                    {
                     // Draw Closing price projection line
                     ObjectCreate("CMEPriceProjection"+IntegerToString(counterPS),OBJ_TREND,0,Time[i],Close[z],Time[z],Close[z]);
                     ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_COLOR,CMEDayEndMon_Thr); // Color value to set/get object color.
                     ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_STYLE,STYLE_DOT); // Value is one of STYLE_SOLID, STYLE_DASH, STYLE_DOT, STYLE_DASHDOT, STYLE_DASHDOTDOT constants to set/get object line style.
                     ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_WIDTH,1); // Integer value to set/get object line width. Can be from 1 to 5.
                     ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_BACK,false); // Boolean value to set/get background drawing flag for object. (for example "true" will hide the value at the bottom of the chart.)
                     ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_RAY,false); // Boolean value to set/get ray flag of object. (for example "true" will extend the line to the right edge.)
                     ObjectSetInteger(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_HIDDEN,ObjectNotListed);
                     ObjectSetString(0,"CMEPriceProjection"+IntegerToString(counterPS),OBJPROP_TOOLTIP,"CME Friday Session\nClose Price Projection\n"+TimeToString(Time[z])+"\n"+DoubleToString(Close[z],(int)MarketInfo("0",MODE_DIGITS))+"\n\nRange (Close-Open): "+IntegerToString((int)MathRound((Close[z]-Open[i])/(Point*FractionalPipDivider)))+" Pips");
                    }
                 }
              }
           }
        }
     }  // end of if(ShowPeriodSeparatorsState==4)
     // End of Draw lines from CME Futures new day time (ie 17h00 Chicago)

   if(GlobalVariableGet(GV_ShowPeriodSeparators)==1 || GlobalVariableGet(GV_ShowPeriodSeparators)==2 || GlobalVariableGet(GV_ShowPeriodSeparators)==3)
     {
   // Monday of every week Lines
   if(ChartPeriod(0)==1440 && ZoomLevel>=3)
     {
      for (int i=0; i<BarsToProcess; i++)
        {
         if(EveryMondayPSLine>MaximumPSLines*4) break;
         if(TimeDayOfWeek(Time[i])==1)  // This is a Monday candle
           {
            counterPS++;
            EveryMondayPSLine++;
            drawPS("PS"+IntegerToString(counterPS),Time[i],MondayTDBeginColor);
            ObjectSetString(0,"PS"+IntegerToString(counterPS),OBJPROP_TOOLTIP,"Monday\nof every week");
           }
        }
     }
   // End of Monday of every week Lines
     

   // 1st day of every month Lines
   if(ChartPeriod(0)==1440)
     {
      for (int i=0; i<BarsToProcess; i++)
        {
         if(MonthlyPSLine>MaximumPSLines) break;
         // Because the 1st candle on daily chart for the month is not necessarily on the 1st day
         // of the month, need to scan from the 4th day of the month and draw a line from there. 
         // If the next line is also on the same month at the previous line, then delete that
         // previous line.
         if(TimeDay(Time[i])==1)
           {
            if(PSLastLineDrawMonth==TimeMonth(Time[i]))
              {
               ObjectDelete(0,"PS"+IntegerToString(counterPS));
               MonthlyPSLine--;
              }
            counterPS++;
            MonthlyPSLine++;
            string date = TimeToString(Time[i],TIME_DATE);
            drawPS("PS"+IntegerToString(counterPS),Time[i],MonthlyPSColor);
            ObjectSetString(0,"PS"+IntegerToString(counterPS),OBJPROP_TOOLTIP,"Monthly\n"+date);
            PSLastLineDrawMonth=TimeMonth(Time[i]);
           }
         if(TimeDay(Time[i])==2)
           {
            if(PSLastLineDrawMonth==TimeMonth(Time[i]))
              {
               ObjectDelete(0,"PS"+IntegerToString(counterPS));
               MonthlyPSLine--;
              }
            counterPS++;
            MonthlyPSLine++;
            string date = TimeToString(Time[i],TIME_DATE);
            drawPS("PS"+IntegerToString(counterPS),Time[i],MonthlyPSColor);
            ObjectSetString(0,"PS"+IntegerToString(counterPS),OBJPROP_TOOLTIP,"Monthly\n"+date);
            PSLastLineDrawMonth=TimeMonth(Time[i]);
           }
         if(TimeDay(Time[i])==3)
           {
            if(PSLastLineDrawMonth==TimeMonth(Time[i]))
              {
               ObjectDelete(0,"PS"+IntegerToString(counterPS));
               MonthlyPSLine--;
              }
            counterPS++;
            MonthlyPSLine++;
            string date = TimeToString(Time[i],TIME_DATE);
            drawPS("PS"+IntegerToString(counterPS),Time[i],MonthlyPSColor);
            ObjectSetString(0,"PS"+IntegerToString(counterPS),OBJPROP_TOOLTIP,"Monthly\n"+date);
            PSLastLineDrawMonth=TimeMonth(Time[i]);
           }
         if(TimeDay(Time[i])==4)
           {
            if(PSLastLineDrawMonth==TimeMonth(Time[i]))
              {
               ObjectDelete(0,"PS"+IntegerToString(counterPS));
               MonthlyPSLine--;
              }
            counterPS++;
            MonthlyPSLine++;
            string date = TimeToString(Time[i],TIME_DATE);
            drawPS("PS"+IntegerToString(counterPS),Time[i],MonthlyPSColor);
            ObjectSetString(0,"PS"+IntegerToString(counterPS),OBJPROP_TOOLTIP,"Monthly\n"+date);
            PSLastLineDrawMonth=TimeMonth(Time[i]);
           }
        }
     }
   // End of 1st day of every month Lines

   // Quarterly lines
   if(ChartPeriod(0)==10080)
     {
      for(int i=0; i<BarsToProcess; i++)
        {
         if(QuarterlyPsLine>MaximumPSLines) break;
         if((TimeMonth(Time[i]))==1)
           {
            if(PSLastLineDrawQuarter==TimeMonth(Time[i]))
              {
               ObjectDelete(0,"PS"+IntegerToString(counterPS));
               QuarterlyPsLine--;
              }
            counterPS++;
            QuarterlyPsLine++;
            string year = IntegerToString(TimeYear(Time[i]));
            drawPS("PS"+IntegerToString(counterPS),Time[i],QuarterlyPSColor);
            ObjectSetString(0,"PS"+IntegerToString(counterPS),OBJPROP_TOOLTIP,"Q1 "+year);
            PSLastLineDrawQuarter=TimeMonth(Time[i]);
           }
         if((TimeMonth(Time[i]))==4)
           {
            if(PSLastLineDrawQuarter==TimeMonth(Time[i]))
              {
               ObjectDelete(0,"PS"+IntegerToString(counterPS));
               QuarterlyPsLine--;
              }
            counterPS++;
            QuarterlyPsLine++;
            string year = IntegerToString(TimeYear(Time[i]));
            drawPS("PS"+IntegerToString(counterPS),Time[i],QuarterlyPSColor);
            ObjectSetString(0,"PS"+IntegerToString(counterPS),OBJPROP_TOOLTIP,"Q2 "+year);
            PSLastLineDrawQuarter=TimeMonth(Time[i]);
           }
         if((TimeMonth(Time[i]))==7)
           {
            if(PSLastLineDrawQuarter==TimeMonth(Time[i]))
              {
               ObjectDelete(0,"PS"+IntegerToString(counterPS));
               QuarterlyPsLine--;
              }
            counterPS++;
            QuarterlyPsLine++;
            string year = IntegerToString(TimeYear(Time[i]));
            drawPS("PS"+IntegerToString(counterPS),Time[i],QuarterlyPSColor);
            ObjectSetString(0,"PS"+IntegerToString(counterPS),OBJPROP_TOOLTIP,"Q3 "+year);
            PSLastLineDrawQuarter=TimeMonth(Time[i]);
           }
         if((TimeMonth(Time[i]))==10)
           {
            if(PSLastLineDrawQuarter==TimeMonth(Time[i]))
              {
               ObjectDelete(0,"PS"+IntegerToString(counterPS));
               QuarterlyPsLine--;
              }
            counterPS++;
            QuarterlyPsLine++;
            string year = IntegerToString(TimeYear(Time[i]));
            drawPS("PS"+IntegerToString(counterPS),Time[i],QuarterlyPSColor);
            ObjectSetString(0,"PS"+IntegerToString(counterPS),OBJPROP_TOOLTIP,"Q4 "+year);
            PSLastLineDrawQuarter=TimeMonth(Time[i]);
           }
        }
     }
   // End of Quarterly lines


   // Yearly lines
   if(ChartPeriod(0)==43200)
     {
      for(int i=0; i<BarsToProcess; i++)
        {
         if((TimeMonth(Time[i]))==1)
           {
            YearlyPSLine++;
            counterPS++;
            string year = IntegerToString(TimeYear(Time[i]));
            drawPS("PS"+IntegerToString(counterPS),Time[i],YearlyPSColor);
            ObjectSetString(0,"PS"+IntegerToString(counterPS),OBJPROP_TOOLTIP,year);
            if(YearlyPSLine>MaximumPSLines) break;
           }
        }
     }
   // End of Yearly lines
  }
  } // end void period_separators
//-------------------------------------------------  


//+++++++++++++++++++++++++++++++++++++++++++++++++
// Function to Draw the Period Separators Objects
//+++++++++++++++++++++++++++++++++++++++++++++++++
void drawPS(string PSname, datetime PSdate, color PScolor)
  {
   ObjectCreate(0,PSname,OBJ_VLINE,0,PSdate,0);
   ObjectSetInteger(0,PSname,OBJPROP_COLOR,PScolor); 
   ObjectSetInteger(0,PSname,OBJPROP_BACK,true);
   ObjectSetInteger(0,PSname,OBJPROP_STYLE,STYLE_DOT);
   ObjectSetInteger(0,PSname,OBJPROP_WIDTH,1);
   ObjectSetInteger(0,PSname,OBJPROP_HIDDEN,ObjectNotListed);
  }
//-------------------------------------------------  


//+++++++++++++++++++++++++++++++++++++++++++++++++
// BacktestingShiftToTargetDate                                       
//      move the chart to the target date                           
//+++++++++++++++++++++++++++++++++++++++++++++++++
void BacktestingShiftToTargetDate()
  {
   // First need to ensure the chart screen is completly filled with candles. Otherwise, the calculation 
   // of the latest candle date won't work.
   // If there is not enough data to create candles to completly fill the chart, then display
   // an alert message. 
   if(Time[WindowFirstVisibleBar()]==Time[Bars-1])
     {
      Comment("Backtesting Error: Not enough data to fill the whole screen with the selected target date");
     }
   if(GlobalVariableGet(gv_BacktestingTargetDate) != 0)   // check first if targetdate is set
     {
      if(ChartPeriod(0)<=1440) // For D1 and lower TimeFrames
        {
         targetdateInNumber = (int)GlobalVariableGet(gv_BacktestingTargetDate);
         targetdateInNumber = targetdateInNumber/(ChartPeriod(0)*60);  // targetdate / number of seconds for increment 
         targetdateInNumber = (targetdateInNumber*(ChartPeriod(0)*60))-(ChartPeriod(0)*60);
        }
      if(ChartPeriod(0)==10080) // For W1 TimeFrame
        {
         targetdateInNumber = (int)GlobalVariableGet(gv_BacktestingTargetDate);
         targetdateInNumber = targetdateInNumber/86400;  // targetdate / number of seconds in one day, this will give the # of whole days since 1970 
         targetdateInNumber = targetdateInNumber*86400;  // targetdate * number of seconds in one day = targetdate date rounded at midnight
         int dayofweek = TimeDayOfWeek(targetdateInNumber); 
         targetdateInNumber = targetdateInNumber - (dayofweek*86400) - (86400*7); // targetdate - (shift to Sunday of that week) - (shift another 7 days to get previous week sunday)
        }
      if(ChartPeriod(0)==43200) // For M1 TimeFrame
        {
         targetdateInNumber = (int)GlobalVariableGet(gv_BacktestingTargetDate);
         targetdateInNumber = targetdateInNumber/86400;  // targetdate / number of seconds in one day, this will give the # of whole days since 1970 
         targetdateInNumber = targetdateInNumber*86400;  // targetdate * number of seconds in one day = targetdate date rounded at midnight
         int dayofmonth = TimeDay(targetdateInNumber); 
         targetdateInNumber = targetdateInNumber - (dayofmonth*86400); // targetdate - (shift to first day of that month)
        }
      Comment("Target Date: ",(datetime)GlobalVariableGet(gv_BacktestingTargetDate), "  Most right candle to show: ", (datetime)targetdateInNumber);

      // If code below is used to validate if there is enough data to fill the entire chart with candles. 
      // To do so, use the time of the oldest candle from history, add the equilavent delta time to 
      // fill the entire chart with candles and the resulting time must be lower than  
      // Divide this time difference by TimeFrame*60 to get the number of bars between the target date and oldest bar date
      if((Time[Bars-1]+(WindowBarsPerChart()*(ChartPeriod(0)*60)))<targetdateInNumber)
        {
         for (int i=Bars-2; i>=0; i--)
           {
            if( Time[i] <= targetdateInNumber ) targetbarno = i;
           }
         int lastbarno = WindowFirstVisibleBar() - WindowBarsPerChart();
         ChartNavigate(0,CHART_CURRENT_POS,lastbarno-targetbarno);
        }
      else
        {
         Comment("Backtesting Error: Not enough data");
        }
     }  // end if(targetdate != 0)
  }  // end ShiftToTargetDate
//-------------------------------------------------  


//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//  BacktestingZoomLevel                                                        
//      returns the current zoom level (value from 1 to 5)
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
int BacktestingZoomLevel()
  {
   return((int)ChartGetInteger(0,CHART_SCALE,0));
  }  // end ZoomLevel
//-------------------------------------------------  


//+++++++++++++++++++++++++++++++++++++++++++++++++
//  BacktestingZoomChange                                                       
//      detect when the zoom level changes                           
//+++++++++++++++++++++++++++++++++++++++++++++++++
void BacktestingZoomChange()
  {
   if(PreviousZoomLevel > BacktestingZoomLevel())
     {
      // If code below is used to validate if there is enough data to fill the entire chart with candles. 
      // To do so, use the time of the oldest candle from history, add the equilavent delta time to 
      // fill the entire chart with candles and the resulting time must be lower than  
      // Divide this time difference by TimeFrame*60 to get the number of bars between the target date and oldest bar date
      if((Time[Bars-1]+(WindowBarsPerChart()*(ChartPeriod(0)*60)))>targetdateInNumber)
        {
         Comment("Backtesting Error: Not enough data to fill the chart with candles");
         ChartSetInteger(0,CHART_SCALE,0,PreviousZoomLevel);
        }
      else  // Zoom -
        {
         PreviousZoomLevel = BacktestingZoomLevel();
         BacktestingShiftToTargetDate();
        }
     }
   else if(PreviousZoomLevel < BacktestingZoomLevel())   // Zoom +
     {
      PreviousZoomLevel = BacktestingZoomLevel();
      BacktestingShiftToTargetDate();
     }
  }  // end ZoomChange
//-------------------------------------------------  


//++++++++++++++++++++++++++++++++++++++++++++++++++++++++   
// ADR calculations
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++   
void ADRCalculation()
  {
   if(GlobalVariableGet(StringConcatenate("GV_ShowADRState_",SymbolInfoString("0",SYMBOL_DESCRIPTION)))==1 ||
      GlobalVariableGet(StringConcatenate("GV_ShowADRState_",SymbolInfoString("0",SYMBOL_DESCRIPTION)))==2)
    {
     int ADRLastCalculatedRangeDay=0;
     // To calculate today's range
     ADR[4] = (int)MathRound((iHigh(NULL,PERIOD_D1,0)-iLow(NULL,PERIOD_D1,0))/(Point*FractionalPipDivider));
     ObjectSetText("ADR Value5","= "+IntegerToString((int)ADR[4]),font_size, font_face, ADR_Font_Color);
     // To calculate this week range
     AWR[4] = MathRound((iHigh(NULL,PERIOD_W1,0)-iLow(NULL,PERIOD_W1,0))/(Point*FractionalPipDivider));
     ObjectSetText("AWR Value5","= "+IntegerToString((int)AWR[4]),font_size, font_face, ADR_Font_Color);
     // To calculate previous days range
     if(ADRLastCalculatedRangeDay != TimeDay(iTime(NULL,PERIOD_D1,0)))
       {
        double ADRtemp=0.0, AWRtemp=0.0;
        int iDR=1;
        int ADRCountedDays=0;
        for(int i=1;i<=7;i++)    // To calculate Daily Range go back to 7 days in case there are weekend days
          {
           if(TimeDayOfWeek(iTime(NULL,PERIOD_D1,i))!=0 && TimeDayOfWeek(iTime(NULL,PERIOD_D1,i))!=6)
             {
              if(iDR<=5) // to fill only the 5 elements of the Daily Range Value array
                {
                 range_day[iDR]=MathRound((iHigh(NULL,PERIOD_D1,i)-iLow(NULL,PERIOD_D1,i))/(Point*FractionalPipDivider));
                 ObjectSetText("DR Value"+IntegerToString(iDR),"= "+IntegerToString((int)range_day[iDR]),font_size, font_face, ADR_Font_Color);
                 iDR++;
                }
             }
          }
        // To calculate Average Daily Range
        for(int i=1;i<=365;i++)   
          {
           if(TimeDayOfWeek(iTime(NULL,PERIOD_D1,i))!=0 && TimeDayOfWeek(iTime(NULL,PERIOD_D1,i))!=6)
             {
             ADRCountedDays++;
              ADRtemp=ADRtemp+MathRound((iHigh(NULL,PERIOD_D1,i)-iLow(NULL,PERIOD_D1,i))/(Point*FractionalPipDivider));
              if(ADRCountedDays==5) ADR[0] = MathRound(ADRtemp/ADRCountedDays);
              if(ADRCountedDays==10) ADR[1] = MathRound(ADRtemp/ADRCountedDays);
              if(ADRCountedDays==15) ADR[2] = MathRound(ADRtemp/ADRCountedDays);
              if(ADRCountedDays==260) ADR[3] = MathRound(ADRtemp/ADRCountedDays);
              ObjectSetText("ADR Value1","= "+IntegerToString((int)ADR[0]),font_size, font_face, ADR_Font_Color);
              ObjectSetText("ADR Value2","= "+IntegerToString((int)ADR[1]),font_size, font_face, ADR_Font_Color);
              ObjectSetText("ADR Value3","= "+IntegerToString((int)ADR[2]),font_size, font_face, ADR_Font_Color);
              ObjectSetText("ADR Value4","= "+IntegerToString((int)ADR[3]),font_size, font_face, ADR_Font_Color);
              ObjectSetText("ADR Value5","= "+IntegerToString((int)ADR[4]),font_size, font_face, ADR_Font_Color);
             }
          }
        // To calculate Average Weekly Range
        for(int i=1;i<=52;i++)    
          {
           AWRtemp=AWRtemp+MathRound((iHigh(NULL,PERIOD_W1,i)-iLow(NULL,PERIOD_W1,i))/(Point*FractionalPipDivider));
           if(i==1)AWR[0] = MathRound(AWRtemp/i);
           if(i==2) AWR[1] = MathRound(AWRtemp/i);
           if(i==4) AWR[2] = MathRound(AWRtemp/i);
           if(i==52) AWR[3] = MathRound(AWRtemp/i);
           ObjectSetText("AWR Value1","= "+IntegerToString((int)AWR[0]),font_size, font_face, ADR_Font_Color);
           ObjectSetText("AWR Value2","= "+IntegerToString((int)AWR[1]),font_size, font_face, ADR_Font_Color);
           ObjectSetText("AWR Value3","= "+IntegerToString((int)AWR[2]),font_size, font_face, ADR_Font_Color);
           ObjectSetText("AWR Value4","= "+IntegerToString((int)AWR[3]),font_size, font_face, ADR_Font_Color);
           ObjectSetText("AWR Value5","= "+IntegerToString((int)AWR[4]),font_size, font_face, ADR_Font_Color);
          }
        //  Saved current time to ADRLastCalculatedRangeDay
        ADRLastCalculatedRangeDay = TimeDay(iTime(NULL,PERIOD_D1,0));
       }
    }
  }  // End ADR calculations
//-------------------------------------------------------------   


//++++++++++++++++++++++++++++++++++++++++++++++++++++++++   
// ADR_Remove 
//    to remove ADR and AWR objects
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++   
void ADRRemove()
  {
   for(int i=0;i<=6;i++)
     {
      ObjectDelete("DR Title"+IntegerToString(i));
      ObjectDelete("DR Value"+IntegerToString(i));
      ObjectDelete("ADR Title"+IntegerToString(i));
      ObjectDelete("ADR Value"+IntegerToString(i));
      ObjectDelete("AWR Title"+IntegerToString(i));
      ObjectDelete("AWR Value"+IntegerToString(i));
     }
  }
//-------------------------------------------------------------   
  
  
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// PnLTextPosition
//    to position the PnL text properly according to chart size
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
void PnLTextPosition()
  {
   if(GlobalVariableGet(StringConcatenate("GV_ShowADRState_",SymbolInfoString("0",SYMBOL_DESCRIPTION)))==2 ||
      GlobalVariableGet(StringConcatenate("GV_ShowADRState_",SymbolInfoString("0",SYMBOL_DESCRIPTION)))==3)
   
     {
      if(ChartGetInteger(0,CHART_WIDTH_IN_PIXELS,0)>=1500*RetinaScaling)
        {
         PnLTextXPosition=(int)(580*RetinaScaling);
         PnLTextYPosition=0;
        }
      else if(ChartGetInteger(0,CHART_WIDTH_IN_PIXELS,0)>=1120*RetinaScaling)
        {
         PnLTextXPosition=(int)(230*RetinaScaling);
         if(GlobalVariableGet(show_time))
           {
            PnLTextYPosition=(int)(40*RetinaScaling);
           }
         else
           {
            PnLTextYPosition=0;
           }
        }           
      else
        {
         PnLTextXPosition=(int)((ChartGetInteger(0,CHART_WIDTH_IN_PIXELS,0)-170)*RetinaScaling);
         if(GlobalVariableGet(show_time))
           {
            PnLTextYPosition=(int)(40*RetinaScaling);
           }
         else
           {
            PnLTextYPosition=0;
           }
        }
      for(int i=0;i<=7;i++)
        {
         int PendingOrderSpacer=0;
         if(i>=5) PendingOrderSpacer=(int)(3*RetinaScaling);
         ObjectSet("P&L Title"+IntegerToString(i), OBJPROP_XDISTANCE,PnLTextXPosition*RetinaScaling);
         ObjectSet("P&L Title"+IntegerToString(i), OBJPROP_YDISTANCE,(PnLTextYPosition+((i*15)*RetinaScaling)+PendingOrderSpacer));
         ObjectSet("P&L Value$"+IntegerToString(i), OBJPROP_XDISTANCE,(PnLTextXPosition-65)*RetinaScaling);
         ObjectSet("P&L Value$"+IntegerToString(i), OBJPROP_YDISTANCE,(PnLTextYPosition+((i*15))*RetinaScaling+PendingOrderSpacer));
         ObjectSet("P&L Value%"+IntegerToString(i), OBJPROP_XDISTANCE,(PnLTextXPosition-115)*RetinaScaling);
         ObjectSet("P&L Value%"+IntegerToString(i), OBJPROP_YDISTANCE,(PnLTextYPosition+((i*15)*RetinaScaling)+PendingOrderSpacer));
         ObjectSet("P&L ValueNet"+IntegerToString(i), OBJPROP_XDISTANCE,(PnLTextXPosition-165)*RetinaScaling);
         ObjectSet("P&L ValueNet"+IntegerToString(i), OBJPROP_YDISTANCE,(PnLTextYPosition+((i*15)*RetinaScaling)+PendingOrderSpacer));
        }
      }
  }
//-------------------------------------------------------------   


//++++++++++++++++++++++++++++++++++++++++++++++++++++++++   
// PnLRemove 
//    to remove PnL objects
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++   
void PnLRemove()
  {
   for(int i=0;i<=7;i++)
     {
      ObjectDelete("P&L Title"+IntegerToString(i));
      ObjectDelete("P&L Value$"+IntegerToString(i));
      ObjectDelete("P&L Value%"+IntegerToString(i));
      ObjectDelete("P&L ValueNet"+IntegerToString(i));
     }
  }
//-------------------------------------------------------------   


//++++++++++++++++++++++++++++++++++++++++++++++++++++++++   
// PnL calculations
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++   
void PnLCalculation()
  {
   if(GlobalVariableGet(StringConcatenate("GV_ShowADRState_",SymbolInfoString("0",SYMBOL_DESCRIPTION)))==2 ||
      GlobalVariableGet(StringConcatenate("GV_ShowADRState_",SymbolInfoString("0",SYMBOL_DESCRIPTION)))==3)
    {
     OpenOrderProfitTotal=0;
     OpenOrderWorstLoss=0; 
     OpenOrderBestProfit=0;
     PendingOrderWorstLoss=0;
     PendingOrderBestProfit=0;
     BuyLots=0;
     SellLots=0;
     PendingBuyLots=0;
     PendingSellLots=0;
     OpenOrderPriceTotal=0;
     OpenOrderPriceQty=0;
     for(int i=0;i<=OrdersTotal();i++)
       {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
          {
           if(OrderSymbol()==ChartSymbol(0))  // to get Open Order only for Symbol of current chart
             {
              if(OrderType()==0 || OrderType()==1)  // Open orders, active trades
                {
                 OpenOrderProfitTotal= OpenOrderProfitTotal + OrderProfit();  // add open profit for each order to get the total
                 // calculation of wrost lost based on Stop Loss
                 if(OrderStopLoss()!=0.00)
                   {
                    OpenOrderWorstLoss=OpenOrderWorstLoss+MathAbs((OrderOpenPrice()-OrderStopLoss())*OrderLots()*100000*MarketInfo(Symbol(),MODE_TICKVALUE));
                   }
                 if(OrderStopLoss()==0.00)
                   {
                    OpenOrderWorstLoss=OpenOrderWorstLoss+AccountBalance();
                   }
                 if(OrderTakeProfit()!=0.00)
                   {
                    OpenOrderBestProfit=OpenOrderBestProfit+MathAbs((OrderTakeProfit()-OrderOpenPrice())*OrderLots()*100000*MarketInfo(Symbol(),MODE_TICKVALUE));
                   }
                 if(OrderType()==0)
                   {
                    BuyLots=BuyLots+OrderLots();
                   }
                 if(OrderType()==1)
                   {
                    SellLots=SellLots+OrderLots();
                   }
                 if(OrderType()==0 || OrderType()==1)
                   {
                    OpenOrderPriceTotal = OpenOrderPriceTotal + OrderOpenPrice();
                    OpenOrderPriceQty++;
                   }
                }
              else   // Pending orders
                {
                 // calculation of wrost lost based on Stop Loss
                 if(OrderStopLoss()!=0.00)
                   {
                    PendingOrderWorstLoss=PendingOrderWorstLoss+MathAbs((OrderOpenPrice()-OrderStopLoss())*OrderLots()*100000*MarketInfo(Symbol(),MODE_TICKVALUE));
                   }
                 if(OrderStopLoss()==0.00)
                   {
                    PendingOrderWorstLoss=PendingOrderWorstLoss+AccountBalance();
                   }
                 if(OrderTakeProfit()!=0.00)
                   {
                    PendingOrderBestProfit=PendingOrderBestProfit+MathAbs((OrderTakeProfit()-OrderOpenPrice())*OrderLots()*100000*MarketInfo(Symbol(),MODE_TICKVALUE));
                   }
                 if(OrderType()==2 || OrderType()==4)
                   {
                    PendingBuyLots=PendingBuyLots+OrderLots();
                   }
                 if(OrderType()==3 || OrderType()==5)
                   {
                    PendingSellLots=PendingSellLots+OrderLots();
                   }
                }
             }  // end if(OrderSymbol()==ChartSymbol(0))
           OpenOrderProfitInPercentage = OpenOrderProfitTotal/AccountBalance()*100;
           if(OpenOrderWorstLoss>AccountBalance()) OpenOrderWorstLoss=AccountBalance();
           OpenOrderProfitInDollarText=StringConcatenate(DoubleToString(OpenOrderProfitTotal,2)+"$");
           OpenOrderProfitInPercentageText=StringConcatenate(DoubleToString(OpenOrderProfitInPercentage,2)+"%");
           OpenOrderWorstLossInDollarText=StringConcatenate("-"+DoubleToString(OpenOrderWorstLoss,2)+"$");
           OpenOrderWorstLossInPercentageText=StringConcatenate("-"+DoubleToString(OpenOrderWorstLoss/AccountBalance()*100,2)+"%");
           OpenOrderBestProfitInDollarText=StringConcatenate(DoubleToString(OpenOrderBestProfit,2)+"$");
           OpenOrderBestProfitInPercentageText=StringConcatenate(DoubleToString(OpenOrderBestProfit/AccountBalance()*100,2)+"%");

           if(PendingOrderWorstLoss>AccountBalance()) PendingOrderWorstLoss=AccountBalance();
           PendingOrderWorstLossInDollerText=StringConcatenate("-"+DoubleToString(PendingOrderWorstLoss,2)+"$");
           PendingOrderWorstLossInPercentageText=StringConcatenate("-"+DoubleToString(PendingOrderWorstLoss/AccountBalance()*100,2)+"%");
           PendingOrderBestProfitInDollarText=StringConcatenate(DoubleToString(PendingOrderBestProfit,2)+"$");
           PendingOrderBestProfitInPercentageText=StringConcatenate(DoubleToString(PendingOrderBestProfit/AccountBalance()*100,2)+"%");
           ObjectSetText("P&L Value$"+IntegerToString(0),OpenOrderProfitInDollarText,font_size+1, font_face, ADR_Font_Color);
           ObjectSetText("P&L Value$"+IntegerToString(1),OpenOrderWorstLossInDollarText,font_size, font_face, ADR_Font_Color);
           ObjectSetText("P&L Value$"+IntegerToString(2),OpenOrderBestProfitInDollarText,font_size, font_face, ADR_Font_Color);
           ObjectSetText("P&L Value$"+IntegerToString(3),"Buy",font_size, font_face, ADR_Font_Color);
           ObjectSetText("P&L Value$"+IntegerToString(4),DoubleToString(BuyLots,2),font_size, font_face, ADR_Font_Color);
           ObjectSetText("P&L Value$"+IntegerToString(5),DoubleToString(PendingBuyLots,2),font_size, font_face, ADR_Font_Color);
           ObjectSetText("P&L Value$"+IntegerToString(6),PendingOrderWorstLossInDollerText,font_size, font_face, ADR_Font_Color);
           ObjectSetText("P&L Value$"+IntegerToString(7),PendingOrderBestProfitInDollarText,font_size, font_face, ADR_Font_Color);
           ObjectSetText("P&L Value%"+IntegerToString(0),OpenOrderProfitInPercentageText,font_size+1, font_face, ADR_Font_Color);
           ObjectSetText("P&L Value%"+IntegerToString(1),OpenOrderWorstLossInPercentageText,font_size, font_face, ADR_Font_Color);
           ObjectSetText("P&L Value%"+IntegerToString(2),OpenOrderBestProfitInPercentageText,font_size, font_face, ADR_Font_Color);
           ObjectSetText("P&L Value%"+IntegerToString(3),"Sell",font_size, font_face, ADR_Font_Color);
           ObjectSetText("P&L Value%"+IntegerToString(4),DoubleToString(-SellLots,2),font_size, font_face, ADR_Font_Color);
           ObjectSetText("P&L Value%"+IntegerToString(5),DoubleToString(-PendingSellLots,2),font_size, font_face, ADR_Font_Color);
           ObjectSetText("P&L Value%"+IntegerToString(6),PendingOrderWorstLossInPercentageText,font_size, font_face, ADR_Font_Color);
           ObjectSetText("P&L Value%"+IntegerToString(7),PendingOrderBestProfitInPercentageText,font_size, font_face, ADR_Font_Color);
           ObjectSetText("P&L ValueNet"+IntegerToString(0),"Avg price",font_size, font_face, ADR_Font_Color);
           ObjectSetText("P&L ValueNet"+IntegerToString(1),"",font_size, font_face, ADR_Font_Color);
           ObjectSetText("P&L ValueNet"+IntegerToString(2),"",font_size, font_face, ADR_Font_Color);
           ObjectSetText("P&L ValueNet"+IntegerToString(3),"Net",font_size, font_face, ADR_Font_Color);
           ObjectSetText("P&L ValueNet"+IntegerToString(4),DoubleToString(BuyLots-SellLots,2),font_size, font_face, ADR_Font_Color);
           ObjectSetText("P&L ValueNet"+IntegerToString(5),DoubleToString(PendingBuyLots-PendingSellLots,2),font_size, font_face, ADR_Font_Color);
           ObjectSetText("P&L ValueNet"+IntegerToString(6),"",font_size, font_face, ADR_Font_Color);
           ObjectSetText("P&L ValueNet"+IntegerToString(7),"",font_size, font_face, ADR_Font_Color);
          }
       }
     if(OpenOrderPriceQty>0)
       {
        OpenOrderPriceAvg=OpenOrderPriceTotal/OpenOrderPriceQty;
       }
     else
       {
        OpenOrderPriceAvg=0;
       }
     ObjectSetText("P&L ValueNet"+IntegerToString(1),DoubleToString(OpenOrderPriceAvg,(int)MarketInfo("0",MODE_DIGITS)),font_size, font_face, ADR_Font_Color);
    }  // end if(ShowADRState==2 || ShowADRState==3)
  }
//-------------------------------------------------------------   


//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Save historical price data to files
//
// 1st step:
//   Open the file and read the latest (ie date from the last line).
//   Store that date into a variable.
//
// 2nd step:
//   - if the date from the 1st step = 0, then get the whole history
//     availabe and dump it into the file
//   - if the date from the 1st step is a valid date, find the
//     candle for that date.
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
void save_history()
  {
   for(iPair=0; iPair<=19; iPair++)
     {
      if(Pair[iPair]!="")  // Validate the pair text is not empty, if not empty, then save the history, if empty, do nothing
        {
         int digits = (int)MarketInfo(Pair[iPair],MODE_DIGITS);
         for(iperiod=0; iperiod<=8; iperiod++)
           {
            FileHandle=FileOpen(Pair[iPair]+IntegerToString(period[iperiod])+".csv",FILE_READ|FILE_WRITE|FILE_CSV,",");
            if(FileHandle!=INVALID_HANDLE)
             {
              string FileLastTime,FileLastDate,FileLastOpen,FileLastHigh,FileLastLow,FileLastClose,FileLastVol;
              datetime LastestDateFromFile;
              while(!FileIsEnding(FileHandle))
                {
                 FileLastDate = FileReadString(FileHandle);
                 FileLastTime = FileReadString(FileHandle);
                 FileLastOpen = FileReadString(FileHandle);
                 FileLastHigh = FileReadString(FileHandle);
                 FileLastLow = FileReadString(FileHandle);
                 FileLastClose = FileReadString(FileHandle);
                 FileLastVol = FileReadString(FileHandle);
                }
              // If the file is empty, load all available history
              if(FileSize(FileHandle)==0) // the file is empty
                {
                 for(int i=iBars(Pair[iPair],period[iperiod])-1; i>=1; i--)
                   {
                    FileWrite(FileHandle,TimeToString(iTime(Pair[iPair],period[iperiod],i),TIME_DATE),TimeToString(iTime(Pair[iPair],period[iperiod],i),TIME_MINUTES),DoubleToString(iOpen(Pair[iPair],period[iperiod],i),digits),DoubleToString(iHigh(Pair[iPair],period[iperiod],i),digits),DoubleToString(iLow(Pair[iPair],period[iperiod],i),digits),DoubleToString(iClose(Pair[iPair],period[iperiod],i),digits),iVolume(Pair[iPair],period[iperiod],i)); 
                   }
                }
              else  // There is data in the file.... append new data to the end of the file
                {
                 LastestDateFromFile = StringToTime(StringConcatenate(FileLastDate," ",FileLastTime));
                 // find the candle # for the LastestDateFromFile
                 for(int x=iBars(Pair[iPair],period[iperiod])-1; x>=1; x--)
                   {
                    if(iTime(Pair[iPair],period[iperiod],x)>LastestDateFromFile)
                      {
                       FileWrite(FileHandle,TimeToString(iTime(Pair[iPair],period[iperiod],x),TIME_DATE),TimeToString(iTime(Pair[iPair],period[iperiod],x),TIME_MINUTES),DoubleToString(iOpen(Pair[iPair],period[iperiod],x),digits),DoubleToString(iHigh(Pair[iPair],period[iperiod],x),digits),DoubleToString(iLow(Pair[iPair],period[iperiod],x),digits),DoubleToString(iClose(Pair[iPair],period[iperiod],x),digits),iVolume(Pair[iPair],period[iperiod],x)); 
                      }
                   }
                 }
              FileClose(FileHandle);
             }
            else Print("File ",Pair[iPair]+IntegerToString(period[iperiod])," open failed, error ",GetLastError()); // Print error if the file open fails
           } // end for(iperiod=0; iperiod<=8; iperiod++)
        } // end if(Pair[iPair]!="")
     } // end for(iPair=0; iPair<=19; iPair++)
  }
//-------------------------------------------------------------   


//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Local time to Server time
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
void LocalTimeToServerTime(int LocalTime, int ServerToLocalTimeDifference)
  {
   ServerTime = LocalTime-(ServerToLocalTimeDifference);
   ServerTimeDayOffset=0;
   if(ServerTime>24)
     {
      ServerTime = ServerTime-24;
      ServerTimeDayOffset = 1;
     } 
   if(ServerTime<0)
     {
      ServerTime = 24+ServerTime;
      ServerTimeDayOffset = -1;
     }
   if(ServerTime==24)
     { 
      ServerTime = 0;
      ServerTimeDayOffset = 1;
     }
  }
//-------------------------------------------------------------   


//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Convert all local time defined to to Server time
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
void ConvertLocalTimetoServerTime()
  {
  // London Open Begin Server Time
  LocalTimeToServerTime(LondonOpenBegin,ServerTimeDiffWithLondon);
  ServerLondonOpenBegin=ServerTime;
  ServerLondonOpenBeginDayOffset=ServerTimeDayOffset;
  // London Open End Server Time
  LocalTimeToServerTime(LondonOpenEnd,ServerTimeDiffWithLondon);
  ServerLondonOpenEnd=ServerTime;
  ServerLondonOpenEndDayOffset=ServerTimeDayOffset;
  
  // London Close Begin Server Time
  LocalTimeToServerTime(LondonCloseBegin,ServerTimeDiffWithLondon);
  ServerLondonCloseBegin=ServerTime;
  ServerLondonCloseBeginDayOffset=ServerTimeDayOffset;
  // London Close End Server Time
  LocalTimeToServerTime(LondonCloseEnd,ServerTimeDiffWithLondon);
  ServerLondonCloseEnd=ServerTime;
  ServerLondonCloseEndDayOffset=ServerTimeDayOffset;

  // NY Begin Server Time
  LocalTimeToServerTime(NYOpenBegin,ServerTimeDiffWithNY);
  ServerNYOpenBegin=ServerTime;
  ServerNYOpenBeginDayOffset=ServerTimeDayOffset;
  // NY End Server Time
  LocalTimeToServerTime(NYOpenEnd,ServerTimeDiffWithNY);
  ServerNYOpenEnd=ServerTime;
  ServerNYOpenEndDayOffset=ServerTimeDayOffset;

  // Asia Begin Server Time
  LocalTimeToServerTime(AsiaOpenBegin,ServerTimeDiffWithTokyo);
  ServerAsiaOpenBegin=ServerTime;
  ServerAsiaOpenBeginDayOffset=ServerTimeDayOffset;
  // Asia End Server Time
  LocalTimeToServerTime(AsiaOpenEnd,ServerTimeDiffWithTokyo);
  ServerAsiaOpenEnd=ServerTime;
  ServerAsiaOpenEndDayOffset=ServerTimeDayOffset;

  // CBDR Begin Server Time
  LocalTimeToServerTime(CBDRBegin,ServerTimeDiffWithNY);
  ServerCBDRBegin=ServerTime;
  ServerCBDRBeginDayOffset=ServerTimeDayOffset;
  // CBDR End Server Time
  LocalTimeToServerTime(CBDREnd,ServerTimeDiffWithNY);
  ServerCBDREnd=ServerTime;
  ServerCBDREndDayOffset=ServerTimeDayOffset;

  // NY Stock Exchange Open Server Time
  LocalTimeToServerTime(EquityBeginHour,ServerTimeDiffWithNY);
  ServerEquityBeginHour=ServerTime;
  ServerEquityBeginHourDayOffset=ServerTimeDayOffset;
  // NY Stock Exchange Close Server Time
  LocalTimeToServerTime(EquityEnd,ServerTimeDiffWithNY);
  ServerEquityEnd=ServerTime;
  ServerEquityEndDayOffset=ServerTimeDayOffset;
  
  // CME Opening Server Time
  LocalTimeToServerTime(CMEOpenHour,ServerTimeDiffWithNY);
  ServerCMEOpenHour=ServerTime;
  
  // Midnight in NY
  LocalTimeToServerTime(MidnightNY,ServerTimeDiffWithNY);
  ServerMidnightNY = ServerTime;
  ServerMidnightNYDayOffset = ServerTimeDayOffset;
  
  // Midnight in London
  LocalTimeToServerTime(MidnightLondon,ServerTimeDiffWithLondon);
  ServerMidnightLondon = ServerTime;
  ServerMidnightLondonDayOffset = ServerTimeDayOffset;
  
  // TrueDayStart
  LocalTimeToServerTime(TrueDayStart,ServerTimeDiffWithNY);
  ServerTrueDayStart = ServerTime;
  ServerTrueDayStartDayOffset = ServerTimeDayOffset;

  // TrueDayEnd
  LocalTimeToServerTime(TrueDayEnd,ServerTimeDiffWithNY);
  ServerTrueDayEnd = ServerTime;
  ServerTrueDayEndDayOffset = ServerTimeDayOffset;

  // CME Futures Day begin hour
  LocalTimeToServerTime(CMEFuturesDayBeginHour,ServerTimeDiffWithNY);
  ServerCMEFuturesDayBeginHour = ServerTime;
  ServerCMEFuturesDayBeginHourDayOffset = ServerTimeDayOffset;

  // CME Futures Day end hour
  LocalTimeToServerTime(CMEFuturesDayEndHour,ServerTimeDiffWithNY);
  ServerCMEFuturesDayEndHour = ServerTime;
  ServerCMEFuturesDayEndHourDayOffset = ServerTimeDayOffset;
  }
//-------------------------------------------------------------   
