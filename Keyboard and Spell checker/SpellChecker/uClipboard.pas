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

Unit uClipboard;

Interface
Uses
     clipbrd,
     Classes,
     Windows,
     SysUtils;

Procedure LoadClipboard(S: TStream);
Procedure SaveClipboard(S: TStream);


Implementation

Procedure CopyStreamToClipboard(fmt: Cardinal; S: TStream);
Var
     hMem                     : THandle;
     pMem                     : Pointer;
Begin
     Assert(Assigned(S));
     S.Position := 0;
     hMem := GlobalAlloc(GHND Or GMEM_DDESHARE, S.Size);
     If hMem <> 0 Then Begin
          pMem := GlobalLock(hMem);
          If pMem <> Nil Then Begin
               Try
                    S.Read(pMem^, S.Size);
                    S.Position := 0;
               Finally
                    GlobalUnlock(hMem);
               End;
               Clipboard.Open;
               Try
                    Clipboard.SetAsHandle(fmt, hMem);
               Finally
                    Clipboard.Close;
               End;
          End                           { If }
          Else Begin
               GlobalFree(hMem);
               OutOfMemoryError;
          End;
     End                                { If }
     Else
          OutOfMemoryError;
End;                                    { CopyStreamToClipboard }

Procedure CopyStreamFromClipboard(fmt: Cardinal; S: TStream);
Var
     hMem                     : THandle;
     pMem                     : Pointer;
Begin
     Assert(Assigned(S));
     hMem := Clipboard.GetAsHandle(fmt);
     If hMem <> 0 Then Begin
          pMem := GlobalLock(hMem);
          If pMem <> Nil Then Begin
               Try
                    S.Write(pMem^, GlobalSize(hMem));
                    S.Position := 0;
               Finally
                    GlobalUnlock(hMem);
               End;
          End;                          { If }
          //   raise Exception.Create('CopyStreamFromClipboard: could not lock global handle ' +
         //      'obtained from clipboard!');
     End;                               { If }
End;                                    { CopyStreamFromClipboard }

Procedure SaveClipboardFormat(fmt: Word; writer: TWriter);
Var
     fmtname                  : Array[0..128] Of Char;
     ms                       : TMemoryStream;
Begin
     Assert(Assigned(writer));
     If 0 = GetClipboardFormatName(fmt, fmtname, SizeOf(fmtname)) Then
          fmtname[0] := #0;
     ms := TMemoryStream.Create;
     Try
          CopyStreamFromClipboard(fmt, ms);
          If ms.Size > 0 Then Begin
               writer.WriteInteger(fmt);
               writer.WriteString(fmtname);
               writer.WriteInteger(ms.Size);
               writer.Write(ms.Memory^, ms.Size);
          End;                          { If }
     Finally
          ms.Free
     End;                               { Finally }
End;                                    { SaveClipboardFormat }

Procedure LoadClipboardFormat(reader: TReader);
Var
     fmt                      : Integer;
     fmtname                  : String;
     Size                     : Integer;
     ms                       : TMemoryStream;
Begin
     Assert(Assigned(reader));
     fmt := reader.ReadInteger;
     fmtname := reader.ReadString;
     Size := reader.ReadInteger;
     ms := TMemoryStream.Create;
     Try
          ms.Size := Size;
          reader.Read(ms.memory^, Size);
          If Length(fmtname) > 0 Then
               fmt := RegisterCLipboardFormat(PChar(fmtname));
          If fmt <> 0 Then
               CopyStreamToClipboard(fmt, ms);
     Finally
          ms.Free;
     End;                               { Finally }
End;                                    { LoadClipboardFormat }

Procedure SaveClipboard(S: TStream);
Var
     writer                   : TWriter;
     i                        : Integer;
Begin
     Assert(Assigned(S));
     writer := TWriter.Create(S, 4096);
     Try
          Try
               Clipboard.Open;
               Try
                    writer.WriteListBegin;
                    For i := 0 To Clipboard.formatcount - 1 Do
                         SaveClipboardFormat(Clipboard.Formats[i], writer);
                    writer.WriteListEnd;
               Finally
                    Clipboard.Close;
               End;
               { Finally }
          Except
               On e: exception Do Begin
                    //Nothing
               End;
          End;
     Finally
          writer.Free
     End;                               { Finally }
End;                                    { SaveClipboard }

Procedure LoadClipboard(S: TStream);
Var
     reader                   : TReader;
Begin
     Assert(Assigned(S));
     S.Position := 0;
     reader := TReader.Create(S, 4096);
     Try
          Try
               Clipboard.Open;
               Try
                    clipboard.Clear;
                    reader.ReadListBegin;
                    While Not reader.EndOfList Do
                         LoadClipboardFormat(reader);
                    reader.ReadListEnd;
               Finally
                    Clipboard.Close;
               End;                     { Finally }
          Except
               On e: exception Do Begin
                    //Nothing
               End;
          End;
     Finally
          reader.Free
     End;                               { Finally }
End;                                    { LoadClipboard }

End.

