{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
  =============================================================================
}

{$INCLUDE ../ProjectDefines.inc}
unit clsUpdateInfoDownloader;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Net.HttpClient,
  System.Net.URLClient,
  System.Net.HttpClientComponent,
  Xml.XMLIntf,
  Xml.XMLDoc,
  System.Variants,
  Vcl.Forms,
  Windows,
  Winapi.WinInet;

type
  TUpdateCheck = class
    private
      HttpClient:       TNetHTTPClient;
      HttpRequest:      TNetHTTPRequest;
      Xml:              IXMLDocument;
      StillDownloading: Boolean;
      Verbose:          Boolean;

      function IsUpdate(const Major, Minor, Release, Build: Integer): Boolean;
      procedure ProcessResponse(const Response: string);
    public
      function IsConnected: Boolean;
      procedure Check;
      procedure CheckSilent;
      constructor Create;
      destructor Destroy; override;
  end;

var
  Updater: TUpdateCheck;

const
  {$IFDEF BetaVersion}
  {$IFDEF PortableOn}
  UpdateInfo = 'https://www.omicronlab.com/download/liveupdate/portable_avrokeyboard/versioninfo_beta.xml';
  {$ELSE}
  UpdateInfo = 'https://www.omicronlab.com/download/liveupdate/avrokeyboard/versioninfo_beta.xml';
  {$ENDIF}
  {$ELSE}
  {$IFDEF PortableOn}
  UpdateInfo = 'https://www.omicronlab.com/download/liveupdate/portable_avrokeyboard/versioninfo.xml';
  {$ELSE}
  UpdateInfo = 'https://www.omicronlab.com/download/liveupdate/avrokeyboard/versioninfo.xml';
  {$ENDIF}
  {$ENDIF}

implementation

uses
  clsFileVersion,
  ufrmUpdateNotify,
  uWindowHandlers,
  System.Threading,
  DebugLog;

{ TUpdateCheck }
{ =============================================================================== }
procedure TUpdateCheck.Check;
begin
  if StillDownloading then
    Exit;

  Verbose := True;
  StillDownloading := True;

  TTask.Run(
      procedure
    var
      Response: string;
    begin
      try
        Response := HttpClient.Get(UpdateInfo).ContentAsString();
        TThread.Queue(nil,
            procedure
          begin
            ProcessResponse(Response);
          end);
      except
        on E: Exception do
        begin
          StillDownloading := False;
          if Verbose then
            Application.MessageBox('There was an error checking for updates. Please try again later.', 'Error', MB_OK or MB_ICONHAND or MB_DEFBUTTON1 or
              MB_SYSTEMMODAL);
        end;
      end;
    end);
end;

{ =============================================================================== }

procedure TUpdateCheck.CheckSilent;
begin
  if StillDownloading then
    Exit;

  Verbose := False;
  StillDownloading := True;

  TTask.Run(
    procedure
    var
      Response: string;
    begin
      try
        Response := HttpClient.Get(UpdateInfo).ContentAsString();
        TThread.Queue(nil,
            procedure
          begin
            ProcessResponse(Response);
          end);
      except
        on E: Exception do
          StillDownloading := False;
      end;
    end);
end;

constructor TUpdateCheck.Create;
begin
  inherited;
  HttpClient := TNetHTTPClient.Create(nil);
  HttpRequest := TNetHTTPRequest.Create(nil);
  HttpRequest.Client := HttpClient;
  HttpClient.UserAgent := 'Avro Keyboard';
  HttpClient.AllowCookies := True;
  StillDownloading := False;
end;

{ =============================================================================== }

destructor TUpdateCheck.Destroy;
begin
  HttpRequest.Free;
  HttpClient.Free;
  inherited;
end;

{ =============================================================================== }

procedure TUpdateCheck.ProcessResponse(const Response: string);
var
  Major, Minor, Release, Build:                           Integer;
  changelogurl, downloadurl, productpageurl, releasedate: string;
begin
  StillDownloading := False;

  try
    Xml := TXMLDocument.Create(nil);
    Xml.LoadFromXML(Response);
    Xml.Active := True;

    // Extracting update information
    Major := Xml.DocumentElement.ChildNodes['versionmajor'].NodeValue;
    Minor := Xml.DocumentElement.ChildNodes['versionminor'].NodeValue;
    Release := Xml.DocumentElement.ChildNodes['versionrevision'].NodeValue;
    if Assigned(Xml.DocumentElement.ChildNodes.FindNode('versionbuild')) then
      Build := Xml.DocumentElement.ChildNodes['versionbuild'].NodeValue
    else
      Build := 0; // Default for Avro 4.x compatibility

    changelogurl := Xml.DocumentElement.ChildNodes['changelogurl'].NodeValue;
    downloadurl := Xml.DocumentElement.ChildNodes['downloadurl'].NodeValue;
    productpageurl := Xml.DocumentElement.ChildNodes['productpageurl'].NodeValue;
    releasedate := Xml.DocumentElement.ChildNodes['releasedate'].NodeValue;

    if IsUpdate(Major, Minor, Release, Build) then
    begin
      CheckCreateForm(TfrmUpdateNotify, frmUpdateNotify, 'frmUpdateNotify');
      frmUpdateNotify.SetupAndShow(Format('%d.%d.%d.%d', [Major, Minor, Release, Build]), releasedate, changelogurl, downloadurl);
    end
    else if Verbose then
    begin
      Application.MessageBox('You are using the latest version of Avro Keyboard.' + #10 + 'No update is available at this moment.', 'Avro Keyboard',
        MB_OK or MB_ICONEXCLAMATION or MB_DEFBUTTON1 or MB_SYSTEMMODAL);
    end;

  except
    on E: Exception do
    begin
      if Verbose then
        Application.MessageBox('There was an error processing update information. Please try again later.', 'Error', MB_OK or MB_ICONHAND or MB_DEFBUTTON1 or
          MB_SYSTEMMODAL);
    end;
  end;
end;

{ =============================================================================== }

function TUpdateCheck.IsConnected: Boolean;
var
  dwConnectionTypes: DWORD;
begin
  Result := False;
  dwConnectionTypes := INTERNET_CONNECTION_MODEM + INTERNET_CONNECTION_LAN + INTERNET_CONNECTION_PROXY;

  Result := InternetGetConnectedState(@dwConnectionTypes, 0);
end;

{ =============================================================================== }

function TUpdateCheck.IsUpdate(const Major, Minor, Release, Build: Integer): Boolean;
var
  Version: TFileVersion;
begin
  Version := TFileVersion.Create;
  Log('IsUpdate check (Remote) Major:' + IntToStr(Major) + ' Minor:' + IntToStr(Minor) + ' Release:' + IntToStr(Release) + ' Build:' + IntToStr(Build));
  Log('IsUpdate check (Own) Major:' + IntToStr(Version.VerMajor) + ' Minor:' + IntToStr(Version.VerMinor) + ' Release:' + IntToStr(Version.VerRelease) +
    ' Build:' + IntToStr(Version.VerBuild));
  try
    Result := (Major > Version.VerMajor) or ((Major = Version.VerMajor) and (Minor > Version.VerMinor)) or
      ((Major = Version.VerMajor) and (Minor = Version.VerMinor) and (Release > Version.VerRelease)) or
      ((Major = Version.VerMajor) and (Minor = Version.VerMinor) and (Release = Version.VerRelease) and (Build > Version.VerBuild));
  finally
    Version.Free;
  end;
end;

end.
