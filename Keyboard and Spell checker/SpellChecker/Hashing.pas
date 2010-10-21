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

Unit Hashing;

Interface
uses
SysUtils;

Var
     CRC32TableInit           : Boolean = False;
     CRC32Table               : Array[Byte] Of LongWord;
     CRC32Poly                : LongWord = $EDB88320;


Function HashBuf(Const Buf; Const BufSize: Integer;
     Const Slots: LongWord = 0): LongWord;
Function HashStr(Const StrBuf: Pointer; Const StrLength: Integer;
     Const Slots: LongWord = 0): LongWord; overload;
Function HashStr(Const S: AnsiString; Const Slots: LongWord = 0): LongWord; overload;


Implementation

Procedure InitCRC32Table;
Var
     I, J                     : Byte;
     R                        : LongWord;
Begin
     For I := $00 To $FF Do Begin
          R := I;
          For J := 8 Downto 1 Do
               If R And 1 <> 0 Then
                    R := (R Shr 1) Xor CRC32Poly
               Else
                    R := R Shr 1;
          CRC32Table[I] := R;
     End;
     CRC32TableInit := True;
End;

Function CalcCRC32Byte(Const CRC32: LongWord; Const Octet: Byte): LongWord;
Begin
     Result := CRC32Table[Byte(CRC32) Xor Octet] Xor (CRC32 Shr 8);
End;

Function CRC32Buf(Const CRC32: LongWord; Const Buf; Const BufSize: Integer): LongWord;
Var
     P                        : PByte;
     I                        : Integer;
Begin
     If Not CRC32TableInit Then
          InitCRC32Table;
     P := @Buf;
     Result := CRC32;
     For I := 1 To BufSize Do Begin
          Result := CalcCRC32Byte(Result, P^);
          Inc(P);
     End;
End;

Procedure CRC32Init(Var CRC32: LongWord);
Begin
     CRC32 := $FFFFFFFF;
End;

Function CalcCRC32(Const Buf; Const BufSize: Integer): LongWord;
Begin
     CRC32Init(Result);
     Result := Not CRC32Buf(Result, Buf, BufSize);
End;

Function HashBuf(Const Buf; Const BufSize: Integer; Const Slots: LongWord): LongWord;
Begin
     If BufSize <= 0 Then
          Result := 0
     Else
          Result := CalcCRC32(Buf, BufSize);
     // Mod into slots
     If (Slots <> 0) And (Slots <> High(LongWord)) Then
          Result := Result Mod Slots;
End;

Function HashStr(Const StrBuf: Pointer; Const StrLength: Integer;
     Const Slots: LongWord): LongWord;

Var
     P                        : PChar;
     I, J                     : Integer;

     Procedure CRC32StrBuf(Const Size: Integer);
     Begin

          Result := CRC32Buf(Result, P^, Size);
     End;

Begin
     // Return 0 for an empty string
     Result := 0;
     If (StrLength <= 0) Or Not Assigned(StrBuf) Then
          exit;

     If Not CRC32TableInit Then
          InitCRC32Table;
     Result := $FFFFFFFF;
     P := StrBuf;

     If StrLength <= 48 Then            // Hash everything for short strings
          CRC32StrBuf(StrLength)
     Else Begin
          // Hash first 16 bytes
          CRC32StrBuf(16);

          // Hash last 16 bytes
          Inc(P, StrLength - 16);
          CRC32StrBuf(16);

          // Hash 16 bytes sampled from rest of string
          I := (StrLength - 48) Div 16;
          P := StrBuf;
          Inc(P, 16);
          For J := 1 To 16 Do Begin
               CRC32StrBuf(1);
               Inc(P, I + 1);
          End;
     End;    

     // Mod into slots
     If (Slots <> 0) And (Slots <> High(LongWord)) Then
          Result := Result Mod Slots;
End;

Function HashStr(Const S: AnsiString; Const Slots: LongWord): LongWord;
Begin
     Result := HashStr(Pointer(S), Length(S), Slots);
End;

End.

