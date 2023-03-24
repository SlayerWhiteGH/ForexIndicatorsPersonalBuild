//+------------------------------------------------------------------+
//|                                        My Note Color Tape v1.mq4 |
//|                            GPL Open Source © 2015, Janez Hoèevar |
//|                                    www.forexfactory.com/saronko  |
//+------------------------------------------------------------------+
//+---------------------------------------------------------------------------+
//| Copyright (c) 2015                                                        |
//|                                                                           |
//| Permission to use, copy, modify, and/or distribute this software for any  |
//| purpose with or without fee is hereby granted, provided that the above    |
//| copyright notice and this permission notice appear in all copies.         |
//|                                                                           |
//| THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES  |
//| WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF          |
//| MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR   |
//| ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES    |
//| WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN     |
//| ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF   |
//| OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.            |
//|                                                                           |
//+---------------------------------------------------------------------------+


#property copyright     "Saronko"
//#property version     "1.00"
#property link          "http://www.forexfactory.com/saronko"
#property description   "Version 1.1, Open GPL"     
#property description   "My note label and Background Rectangle Label"
#property indicator_chart_window

//**************Settings for Note Label
extern string   Note_setting            ="***My Note Settings***";//*My Note Settings*
extern string   Note_Input              ="I wish you good trading day:)";//Yor Message
extern string   Corner_Note             ="0 top left, 1 top right, 2 bottom left, 3 bottom right";
extern int      CornerGeneral           = 0;
extern int      Note_X_Position         = 80;//Note X Position
extern int      Note_Y_Position         = 0;//Note Y Position
extern string   Note_Font               = "Arial";//Note Font
extern int      Note_Font_Size          = 10;//Note Font Size
extern color    Note_Color              = Black;//Note Color
extern int      Note_Angle              = 0;//Note Angle


//**************Settings for Back Box
extern string  Back_Box_setting        = "***Tape Settings****";//***Tape Settings****
extern int     X_Shift                 = -1;//TAPE X SHIF
input int      Y_Shift                 = -1;//TAPE Y SHIFT
input int      width                   = 170;//TAPE Width
input int      height                  = 20;//TAPE Height
input color    Back_Color              = Gray;//TAPE Color
extern bool    BackTransparent         = FALSE;//TAPE Transparency
extern string  ID_setting              ="***IF more than 1 indi on chart change ID !***";//*My Note Settings*
extern string  MyNoteID                = "B";//IF more than 1 on chart change ID !

string BackBox= "RLHide"+MyNoteID;


#define OBJNote "Note1"+MyNoteID


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//**********indicator buffers mapping for BackBox
     ObjectCreate    (0,BackBox,OBJ_RECTANGLE_LABEL,0,0,0);
     ObjectSetInteger(0,BackBox,OBJPROP_XDISTANCE,Note_X_Position+X_Shift);
     ObjectSetInteger(0,BackBox,OBJPROP_YDISTANCE,Note_Y_Position+Y_Shift);
     ObjectSetInteger(0,BackBox,OBJPROP_XSIZE,width);
     ObjectSetInteger(0,BackBox,OBJPROP_YSIZE,height);
     ObjectSetInteger(0,BackBox,OBJPROP_BGCOLOR,Back_Color);
     ObjectSetInteger(0,BackBox,OBJPROP_BACK,BackTransparent);
     ObjectSetInteger(0,BackBox,OBJPROP_CORNER,CornerGeneral);
     ObjectSetInteger(0,BackBox,OBJPROP_BORDER_TYPE,BORDER_FLAT);
     ObjectSetInteger(0,BackBox,OBJPROP_COLOR,Back_Color);
     ObjectSetInteger(0,BackBox,OBJPROP_HIDDEN,False);   
//---
   return(INIT_SUCCEEDED);
   
  }
  int start()

   {
//***********************Create Tekst Object   
      ObjectCreate   (OBJNote, OBJ_LABEL, 0, 0, 0);
      ObjectSet      (OBJNote, OBJPROP_CORNER, CornerGeneral);
      ObjectSet      (OBJNote, OBJPROP_ANGLE,Note_Angle);
      ObjectSet      (OBJNote, OBJPROP_YDISTANCE, Note_Y_Position); //UP DOWN
      ObjectSet      (OBJNote, OBJPROP_XDISTANCE, Note_X_Position);//Left Right
      ObjectSetText  (OBJNote, Note_Input, Note_Font_Size, Note_Font, Note_Color); 
      
 return(0); 
  }    

//--- Delete object
int deinit()
{
     
   ObjectDelete(BackBox);
   ObjectDelete(OBJNote);     
    
return(0);
}
