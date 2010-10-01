{
  =============================================================================
  *****************************************************************************
     The contents of this file are subject to the Mozilla Public License
     Version 1.1 (the "License"); you may not use this file except in
     compliance with the License. You may obtain a copy of the License at
     http://www.mozilla.org/MPL/

     Software distributed under the License is distributed on an "AS IS"
     basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
     License for the specific language governing rights and limitations
     under the License.

     The Original Code is Avro Keyboard 5.

     The Initial Developer of the Original Code is
     Mehdi Hasan Khan (mhasan@omicronlab.com).

     Copyright (C) OmicronLab (http://www.omicronlab.com). All Rights Reserved.


     Contributor(s): ______________________________________.

  *****************************************************************************
  =============================================================================
}

{$IFDEF SpellChecker}
{$INCLUDE ../../ProjectDefines.inc}
{$ELSE}
{$INCLUDE ../ProjectDefines.inc}
{$ENDIF}

Unit VirtualKeyCode;

Interface

Const
     //---------------------------------------------------
     //Regularly used keycodes

     VK_ADD                   = $6B;
     VK_APPS                  = $5D;
     VK_BACK                  = $8;
     VK_CAPITAL               = $14;
     VK_CONTROL               = $11;
     VK_DECIMAL               = $6E;
     VK_DELETE                = $2E;
     VK_DIVIDE                = $6F;
     VK_DOWN                  = $28;
     VK_END                   = $23;
     VK_F1                    = $70;
     VK_F10                   = $79;
     VK_F11                   = $7A;
     VK_F12                   = $7B;
     VK_F2                    = $71;
     VK_F3                    = $72;
     VK_F4                    = $73;
     VK_F5                    = $74;
     VK_F6                    = $75;
     VK_F7                    = $76;
     VK_F8                    = $77;
     VK_F9                    = $78;
     VK_HOME                  = $24;
     VK_INSERT                = $2D;
     VK_LBUTTON               = $1;
     VK_LCONTROL              = $A2;
     VK_LEFT                  = $25;
     VK_LMENU                 = $A4;
     VK_LSHIFT                = $A0;
     VK_LWIN                  = $5B;
     VK_MENU                  = $12;
     VK_MULTIPLY              = $6A;
     VK_NEXT                  = $22;
     VK_NUMLOCK               = $90;

     VK_NUMPAD0               = $60;
     VK_NUMPAD1               = $61;
     VK_NUMPAD2               = $62;
     VK_NUMPAD3               = $63;
     VK_NUMPAD4               = $64;
     VK_NUMPAD5               = $65;
     VK_NUMPAD6               = $66;
     VK_NUMPAD7               = $67;
     VK_NUMPAD8               = $68;
     VK_NUMPAD9               = $69;

     VK_OEM_1                 = $BA;
     VK_OEM_2                 = $BF;
     VK_OEM_3                 = $C0;
     VK_OEM_4                 = $DB;
     VK_OEM_5                 = $DC;
     VK_OEM_6                 = $DD;
     VK_OEM_7                 = $DE;
     VK_OEM_COMMA             = $BC;
     VK_OEM_MINUS             = $BD;
     VK_OEM_PERIOD            = $BE;
     VK_OEM_PLUS              = $BB;
     VK_PRIOR                 = $21;
     VK_RBUTTON               = $2;
     VK_RCONTROL              = $A3;
     VK_RETURN                = $D;
     VK_RIGHT                 = $27;
     VK_RMENU                 = $A5;
     VK_RSHIFT                = $A1;
     VK_RWIN                  = $5C;
     VK_SHIFT                 = $10;
     VK_SPACE                 = $20;
     VK_SUBTRACT              = $6D;
     VK_TAB                   = $9;
     VK_UP                    = $26;

     //Keycodes with custom name
     VK_0                     = $30;
     VK_1                     = $31;
     VK_2                     = $32;
     VK_3                     = $33;
     VK_4                     = $34;
     VK_5                     = $35;
     VK_6                     = $36;
     VK_7                     = $37;
     VK_8                     = $38;
     VK_9                     = $39;

     A_Key                    = $41;
     B_Key                    = $42;
     C_Key                    = $43;
     D_Key                    = $44;
     E_Key                    = $45;
     F_Key                    = $46;
     G_Key                    = $47;
     H_Key                    = $48;
     I_Key                    = $49;
     J_Key                    = $4A;
     K_Key                    = $4B;
     L_Key                    = $4C;
     M_Key                    = $4D;
     N_Key                    = $4E;
     O_Key                    = $4F;
     P_Key                    = $50;
     Q_Key                    = $51;
     R_Key                    = $52;
     S_Key                    = $53;
     T_Key                    = $54;
     U_Key                    = $55;
     V_Key                    = $56;
     W_Key                    = $57;
     X_Key                    = $58;
     Y_Key                    = $59;
     Z_Key                    = $5A;

     //---------------------------------------------------
     //Below is the Keys that are not used or rarely used
     VK_ACCEPT                = $1E;
     VK_ATTN                  = $F6;
     VK_BROWSER_BACK          = $A6;
     VK_BROWSER_FAVORITES     = $AB;
     VK_BROWSER_FORWARD       = $A7;
     VK_BROWSER_HOME          = $AC;
     VK_BROWSER_REFRESH       = $A8;
     VK_BROWSER_SEARCH        = $AA;
     VK_BROWSER_STOP          = $A9;
     VK_CANCEL                = $3;
     VK_CONVERT               = $1C;
     VK_CRSEL                 = $F7;
     VK_DBE_ALPHANUMERIC      = $F0;
     VK_DBE_CODEINPUT         = $FA;
     VK_DBE_DBCSCHAR          = $F4;
     VK_DBE_DETERMINESTRING   = $FC;
     VK_DBE_ENTERDLGCONVERSIONMODE = $FD;
     VK_DBE_ENTERIMECONFIGMODE = $F8;
     VK_DBE_ENTERWORDREGISTERMODE = $F7;
     VK_DBE_FLUSHSTRING       = $F9;
     VK_DBE_HIRAGANA          = $F2;
     VK_DBE_KATAKANA          = $F1;
     VK_DBE_NOCODEINPUT       = $FB;
     VK_DBE_NOROMAN           = $F6;
     VK_DBE_ROMAN             = $F5;
     VK_DBE_SBCSCHAR          = $F3;
     VK_CLEAR                 = $C;
     VK_EREOF                 = $F9;
     VK_ESCAPE                = $1B;
     VK_EXECUTE               = $2B;
     VK_EXSEL                 = $F8;
     VK_F13                   = $7C;
     VK_F14                   = $7D;
     VK_F15                   = $7E;
     VK_F16                   = $7F;
     VK_F17                   = $80;
     VK_F18                   = $81;
     VK_F19                   = $82;
     VK_F20                   = $83;
     VK_F21                   = $84;
     VK_F22                   = $85;
     VK_F23                   = $86;
     VK_F24                   = $87;
     VK_FINAL                 = $18;
     VK_HANGEUL               = $15;
     VK_HANGUL                = $15;
     VK_HANJA                 = $19;
     VK_HELP                  = $2F;
     VK_ICO_00                = $E4;
     VK_ICO_CLEAR             = $E6;
     VK_ICO_HELP              = $E3;
     VK_JUNJA                 = $17;
     VK_KANA                  = $15;
     VK_KANJI                 = $19;
     VK_LAUNCH_APP1           = $B6;
     VK_LAUNCH_APP2           = $B7;
     VK_LAUNCH_MAIL           = $B4;
     VK_LAUNCH_MEDIA_SELECT   = $B5;
     VK_MBUTTON               = $4;
     VK_MEDIA_NEXT_TRACK      = $B0;
     VK_MEDIA_PLAY_PAUSE      = $B3;
     VK_MEDIA_PREV_TRACK      = $B1;
     VK_MEDIA_STOP            = $B2;
     VK_MODECHANGE            = $1F;
     VK_NONAME                = $FC;
     VK_NONCONVERT            = $1D;
     VK_OEM_102               = $E2;
     VK_OEM_8                 = $DF;
     VK_OEM_ATTN              = $F0;
     VK_OEM_AUTO              = $F3;
     VK_OEM_AX                = $E1;
     VK_OEM_BACKTAB           = $F5;
     VK_OEM_CLEAR             = $FE;
     VK_OEM_COPY              = $F2;
     VK_OEM_CUSEL             = $EF;
     VK_OEM_ENLW              = $F4;
     VK_OEM_FINISH            = $F1;
     VK_OEM_FJ_JISHO          = $92;
     VK_OEM_FJ_LOYA           = $95;
     VK_OEM_FJ_MASSHOU        = $93;
     VK_OEM_FJ_ROYA           = $96;
     VK_OEM_FJ_TOUROKU        = $94;
     VK_OEM_JUMP              = $EA;
     VK_OEM_NEC_EQUAL         = $92;
     VK_OEM_PA1               = $EB;
     VK_OEM_PA2               = $EC;
     VK_OEM_PA3               = $ED;
     VK_OEM_RESET             = $E9;
     VK_OEM_WSCTRL            = $EE;
     VK_PA1                   = $FD;
     VK_PACKET                = $E7;
     VK_PAUSE                 = $13;
     VK_PLAY                  = $FA;
     VK_PRINT                 = $2A;
     VK_PROCESSKEY            = $E5;
     VK_SCROLL                = $91;
     VK_SELECT                = $29;
     VK_SEPARATOR             = $6C;
     VK_VOLUME_DOWN           = $AE;
     VK_VOLUME_MUTE           = $AD;
     VK_VOLUME_UP             = $AF;
     VK_XBUTTON1              = $5;
     VK_XBUTTON2              = $6;
     VK_ZOOM                  = $FB;
     VK_SLEEP                 = $5F;
     VK_SNAPSHOT              = $2C;


Implementation

End.
