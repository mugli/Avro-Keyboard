{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
  =============================================================================
}

unit uClipboard;

interface

uses
  clipbrd,
  Classes,
  Windows,
  SysUtils;

procedure LoadClipboard(S: TStream);
procedure SaveClipboard(S: TStream);

implementation

procedure CopyStreamToClipboard(fmt: Cardinal; S: TStream);
var
  hMem: THandle;
  pMem: Pointer;
begin
  Assert(Assigned(S));
  S.Position := 0;
  hMem := GlobalAlloc(GHND or GMEM_DDESHARE, S.Size);
  if hMem <> 0 then
  begin
    pMem := GlobalLock(hMem);
    if pMem <> nil then
    begin
      try
        S.Read(pMem^, S.Size);
        S.Position := 0;
      finally
        GlobalUnlock(hMem);
      end;
      Clipboard.Open;
      try
        Clipboard.SetAsHandle(fmt, hMem);
      finally
        Clipboard.Close;
      end;
    end { If }
    else
    begin
      GlobalFree(hMem);
      OutOfMemoryError;
    end;
  end { If }
  else
    OutOfMemoryError;
end; { CopyStreamToClipboard }

procedure CopyStreamFromClipboard(fmt: Cardinal; S: TStream);
var
  hMem: THandle;
  pMem: Pointer;
begin
  Assert(Assigned(S));
  hMem := Clipboard.GetAsHandle(fmt);
  if hMem <> 0 then
  begin
    pMem := GlobalLock(hMem);
    if pMem <> nil then
    begin
      try
        S.Write(pMem^, GlobalSize(hMem));
        S.Position := 0;
      finally
        GlobalUnlock(hMem);
      end;
    end; { If }
    // raise Exception.Create('CopyStreamFromClipboard: could not lock global handle ' +
    // 'obtained from clipboard!');
  end; { If }
end;   { CopyStreamFromClipboard }

procedure SaveClipboardFormat(fmt: Word; writer: TWriter);
var
  fmtname: array [0 .. 128] of Char;
  ms:      TMemoryStream;
begin
  Assert(Assigned(writer));
  if 0 = GetClipboardFormatName(fmt, fmtname, SizeOf(fmtname)) then
    fmtname[0] := #0;
  ms := TMemoryStream.Create;
  try
    CopyStreamFromClipboard(fmt, ms);
    if ms.Size > 0 then
    begin
      writer.WriteInteger(fmt);
      writer.WriteString(fmtname);
      writer.WriteInteger(ms.Size);
      writer.Write(ms.Memory^, ms.Size);
    end; { If }
  finally
    ms.Free
  end; { Finally }
end;   { SaveClipboardFormat }

procedure LoadClipboardFormat(reader: TReader);
var
  fmt:     Integer;
  fmtname: string;
  Size:    Integer;
  ms:      TMemoryStream;
begin
  Assert(Assigned(reader));
  fmt := reader.ReadInteger;
  fmtname := reader.ReadString;
  Size := reader.ReadInteger;
  ms := TMemoryStream.Create;
  try
    ms.Size := Size;
    reader.Read(ms.Memory^, Size);
    if Length(fmtname) > 0 then
      fmt := RegisterCLipboardFormat(PChar(fmtname));
    if fmt <> 0 then
      CopyStreamToClipboard(fmt, ms);
  finally
    ms.Free;
  end; { Finally }
end;   { LoadClipboardFormat }

procedure SaveClipboard(S: TStream);
var
  writer: TWriter;
  i:      Integer;
begin
  Assert(Assigned(S));
  writer := TWriter.Create(S, 4096);
  try
    try
      Clipboard.Open;
      try
        writer.WriteListBegin;
        for i := 0 to Clipboard.formatcount - 1 do
          SaveClipboardFormat(Clipboard.Formats[i], writer);
        writer.WriteListEnd;
      finally
        Clipboard.Close;
      end;
      { Finally }
    except
      on e: exception do
      begin
        // Nothing
      end;
    end;
  finally
    writer.Free
  end; { Finally }
end;   { SaveClipboard }

procedure LoadClipboard(S: TStream);
var
  reader: TReader;
begin
  Assert(Assigned(S));
  S.Position := 0;
  reader := TReader.Create(S, 4096);
  try
    try
      Clipboard.Open;
      try
        Clipboard.Clear;
        reader.ReadListBegin;
        while not reader.EndOfList do
          LoadClipboardFormat(reader);
        reader.ReadListEnd;
      finally
        Clipboard.Close;
      end; { Finally }
    except
      on e: exception do
      begin
        // Nothing
      end;
    end;
  finally
    reader.Free
  end; { Finally }
end;   { LoadClipboard }

end.
