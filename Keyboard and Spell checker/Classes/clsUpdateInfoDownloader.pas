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

{$INCLUDE ../ProjectDefines.inc}
Unit clsUpdateInfoDownloader;

Interface

Uses
  SysUtils,
  Classes,
  Windows,
  DateUtils,
  Forms,
  XMLIntf, XMLDoc,
  system.Variants,
  OverbyteIcsWndControl,
  OverbyteIcsHttpProt,
  Wininet;

Type
  TUpdateCheck = Class
  Private
    Downloader: THttpCli;
    MemS: TMemoryStream;
    XML: IXMLDocument;
    root: IXMLNode;
    child: IXMLNode;
    StillDownloading: Boolean;
    Verbose: Boolean;

    Function IsUpdate(Const Major, Minor, Release, Build: Integer): Boolean;
    Procedure FinishDownload(Sender: TObject; RqType: THttpRequest;
      Error: Word);
  Public

    Function IsConnected: Boolean;
    Procedure Check;
    Procedure CheckSilent;
    Constructor Create;
    Destructor Destroy; Override;
  End;

Var
  Updater: TUpdateCheck;

Const
{$IFDEF BetaVersion}
{$IFDEF PortableOn}
  UpdateInfo =
    'http://www.omicronlab.com/download/liveupdate/portable_avrokeyboard/versioninfo_beta.xml';
{$ELSE}
  UpdateInfo =
    'http://www.omicronlab.com/download/liveupdate/avrokeyboard/versioninfo_beta.xml';
{$ENDIF}
{$ELSE}
{$IFDEF PortableOn}
  UpdateInfo =
    'http://www.omicronlab.com/download/liveupdate/portable_avrokeyboard/versioninfo.xml';
{$ELSE}
  UpdateInfo =
    'http://www.omicronlab.com/download/liveupdate/avrokeyboard/versioninfo.xml';
{$ENDIF}
{$ENDIF}

Implementation

Uses
  clsFileVersion,
  ufrmUpdateNotify,
  uWindowHandlers;

{ TUpdateCheck }
{ =============================================================================== }

Procedure TUpdateCheck.Check;
Begin
  If StillDownloading Then
    exit
  Else
  Begin
    MemS := TMemoryStream.Create;

    Verbose := True;
    Downloader.URL := UpdateInfo;
    Downloader.RcvdStream := MemS;
    Downloader.GetASync;
    StillDownloading := True;
  End;
End;

{ =============================================================================== }

Procedure TUpdateCheck.CheckSilent;
Begin
  If StillDownloading Then
    exit
  Else
  Begin
    MemS := TMemoryStream.Create;

    Verbose := False;
    Downloader.URL := UpdateInfo;
    Downloader.RcvdStream := MemS;
    Downloader.GetASync;
    StillDownloading := True;
  End;
End;

{ =============================================================================== }

Constructor TUpdateCheck.Create;
Begin
  // Execute the parent (TObject) constructor first
  Inherited; // Call the parent Create method
  Downloader := THttpCli.Create(Nil);
  Downloader.RequestVer := '1.0';
  Downloader.Agent := 'User-Agent: Avro Keyboard';
  Downloader.NoCache := True;
  Downloader.OnRequestDone := FinishDownload;

  StillDownloading := False;
End;

{ =============================================================================== }

Destructor TUpdateCheck.Destroy;
Begin
  FreeAndNil(Downloader);
  Inherited;
End;

{ =============================================================================== }
{$HINTS Off}

Procedure TUpdateCheck.FinishDownload(Sender: TObject; RqType: THttpRequest;
  Error: Word);
Var
  Major, Minor, Release, Build: Integer;
  changelogurl, downloadurl, productpageurl, releasedate: String;
Begin

  Major := 0;
  Minor := 0;
  Release := 0;
  Build := 0;

  StillDownloading := False;

  If (Downloader.StatusCode = 200) And (Error = 0) Then
  Begin
    XML := TXMLDocument.Create(nil);
    XML.Active := True;
    XML.Encoding := 'UTF-8';
    XML.LoadFromStream(MemS);

    Try
      Try
        // int
        Major := (XML.DocumentElement.ChildNodes.FindNode('versionmajor')
          .NodeValue);
        Minor := (XML.DocumentElement.ChildNodes.FindNode('versionminor')
          .NodeValue);
        Release := (XML.DocumentElement.ChildNodes.FindNode('versionrevision')
          .NodeValue);
        If XML.DocumentElement.ChildNodes.FindNode('versionbuild') <> Nil Then
          // Avro 4.x compatibility
          Build := XML.DocumentElement.ChildNodes.FindNode('versionbuild')
            .NodeValue;
        // str
        changelogurl := (XML.DocumentElement.ChildNodes.FindNode('changelogurl')
          .NodeValue);
        downloadurl := (XML.DocumentElement.ChildNodes.FindNode('downloadurl')
          .NodeValue);
        productpageurl :=
          (XML.DocumentElement.ChildNodes.FindNode('productpageurl').NodeValue);
        releasedate := (XML.DocumentElement.ChildNodes.FindNode('releasedate')
          .NodeValue);
      Except
        On e: exception Do
        Begin
          If Verbose Then
            Application.MessageBox
              ('There was an error checking update for Avro Keyboard.' + #10 +
              'Please try again later.', 'Ooops!', MB_OK + MB_ICONHAND +
              MB_DEFBUTTON1 + MB_SYSTEMMODAL);
          exit;
        End;
      End;
    Finally
      XML.Active := False;
      XML := nil;
      FreeAndNil(MemS);
    End;

    If IsUpdate(Major, Minor, Release, Build) = True Then
    Begin
      CheckCreateForm(TfrmUpdateNotify, frmUpdateNotify, 'frmUpdateNotify');
      frmUpdateNotify.SetupAndShow(IntToStr(Major) + '.' + IntToStr(Minor) + '.'
        + IntToStr(Release) + '.' + IntToStr(Build), releasedate, changelogurl,
        downloadurl);
    End
    Else
    Begin
      If Verbose Then
        Application.MessageBox
          ('You are using the latest version of Avro Keyboard.' + #10 +
          'No update is available at this moment', 'Avro Keyboard',
          MB_OK + MB_ICONEXCLAMATION + MB_DEFBUTTON1 + MB_SYSTEMMODAL);
    End;
  End
  Else
  Begin
    If Verbose Then
      Application.MessageBox
        ('There was an error checking update for Avro Keyboard.' + #10 +
        'Please try again later.', 'Ooops!', MB_OK + MB_ICONHAND + MB_DEFBUTTON1
        + MB_SYSTEMMODAL);
  End;

End;

{ =============================================================================== }

Function TUpdateCheck.IsConnected: Boolean;
Var
  dwConnectionTypes: DWORD;
Begin
  Result := False;
  dwConnectionTypes := INTERNET_CONNECTION_MODEM + INTERNET_CONNECTION_LAN +
    INTERNET_CONNECTION_PROXY;

  Result := InternetGetConnectedState(@dwConnectionTypes, 0);
End;

{ =============================================================================== }

Function TUpdateCheck.IsUpdate(Const Major, Minor, Release,
  Build: Integer): Boolean;
Var
  Version: TFileVersion;
Begin
  Version := TFileVersion.Create();
  Result := False;

  Try
    If Major > Version.VerMajor Then
    Begin
      Result := True;
    End
    Else If Major = Version.VerMajor Then
    Begin
      If Minor > Version.VerMinor Then
      Begin
        Result := True;
      End
      Else If Minor = Version.VerMinor Then
      Begin
        If Release > Version.VerRelease Then
        Begin
          Result := True;
        End
        Else If Release = Version.VerRelease Then
        Begin
          If Build > Version.VerBuild Then
          Begin
            Result := True;
          End;
        End;
      End;
    End;

  Finally
    Version.Free;
  End;

End;
{$HINTS On}

End.
