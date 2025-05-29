{
  =============================================================================
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.
  =============================================================================
}

{$INCLUDE ../ProjectDefines.inc}
{ COMPLETE TRANSFERING }

unit clsE2BCharBased;

interface

uses
  classes,
  sysutils,
  StrUtils,
  clsEnglishToBangla,
  clsPhoneticRegExBuilder,
  Generics.Collections,
  clsAbbreviation,
  clsUnicodeToBijoy2000;

const
  Max_EnglishLength    = 50;
  Max_RegExQueryLength = 5000;

type
  TPhoneticCache = record
    EnglishT: string;
    Results: TStringList;
  end;

  // Skeleton of Class TE2BCharBased
type
  TE2BCharBased = class
    private
      Parser:                    TEnglishToBangla;
      RegExBuilder:              TEnglishToRegEx;
      Abbreviation:              TAbbreviation;
      Bijoy:                     TUnicodeToBijoy2000;
      EnglishT:                  string;
      PrevBanglaT:               string;
      BlockLast:                 boolean;
      WStringList:               TStringList;
      NewBanglaText:             string;
      FAutoCorrect:              boolean;
      CandidateDict:             TDictionary<string, string>;
      ManuallySelectedCandidate: boolean;
      DetermineZWNJ_ZWJ:         string;
      PhoneticCache:             array [1 .. Max_EnglishLength] of TPhoneticCache;

      procedure Fix_ZWNJ_ZWJ(var rList: TStringList);
      procedure ProcessSpace(var Block: boolean);
      procedure ParseAndSend;
      procedure ParseAndSendNow;
      procedure ProcessEnter(var Block: boolean);
      procedure DoBackspace(var Block: boolean);
      procedure MyProcessVKeyDown(const KeyCode: Integer; var Block: boolean; const var_IfShift: boolean; const var_IfTrueShift: boolean);
      procedure AddStr(const Str: string);

      procedure LoadCandidateOptions;
      procedure SaveCandidateOptions;
      procedure UpdateCandidateOption;

      procedure AddToCache(const MiddleMain_T: string; var rList: TStringList);
      procedure AddSuffix(const MiddleMain_T: string; var rList: TStringList);

      procedure CutText(const inputEStr: string; var outSIgnore: string; var outMidMain: string; var outEIgnore: string);
      procedure PadResults(const Starting_Ignoreable_T, Ending_Ignorable_T: string; var rList: TStringList);
      function EscapeSpecialCharacters(const inputT: string): string;

      procedure SetAutoCorrectEnabled(const Value: boolean);
      function GetAutoCorrectEnabled: boolean;

    public
      constructor Create;           // Initializer
      destructor Destroy; override; // Destructor

      function ProcessVKeyDown(const KeyCode: Integer; var Block: boolean): string;
      procedure ProcessVKeyUP(const KeyCode: Integer; var Block: boolean);
      procedure ResetDeadKey;
      procedure SelectCandidate(const Item: string);
      // Published
      property AutoCorrectEnabled: boolean read GetAutoCorrectEnabled write SetAutoCorrectEnabled;
  end;

implementation

uses
  KeyboardFunctions,
  VirtualKeyCode,
  uForm1,
  clsLayout,
  uRegistrySettings,
  ufrmPrevW,
  uSimilarSort,
  uRegExPhoneticSearch,
  uFileFolderHandling,
  BanglaChars,
  uDBase,
  WindowsVersion;

{ TE2BCharBased }

{ =============================================================================== }

procedure TE2BCharBased.AddStr(const Str: string);
begin
  EnglishT := EnglishT + Str;

  ParseAndSend;

  if ShowPrevWindow = 'YES' then
    frmPrevW.UpdatePreviewCaption(EnglishT)
  else
    frmPrevW.HidePreview;

end;

{ =============================================================================== }

procedure TE2BCharBased.AddSuffix(const MiddleMain_T: string; var rList: TStringList);
var
  iLen, J, K: Integer;
  isSuffix:   string;
  B_Suffix:   string;
  TempList:   TStringList;
begin
  iLen := Length(MiddleMain_T);
  rList.Sorted := True;
  rList.Duplicates := dupIgnore;

  if iLen >= 2 then
  begin
    TempList := TStringList.Create;
    for J := 2 to iLen do
    begin
      isSuffix := LowerCase(MidStr(MiddleMain_T, J, iLen));

      if suffix.TryGetValue(isSuffix, B_Suffix) then
      begin
        if PhoneticCache[iLen - Length(isSuffix)].Results.Count > 0 then
        begin
          for K := 0 to PhoneticCache[iLen - Length(isSuffix)].Results.Count - 1 do
          begin
            if IsVowel(RightStr(PhoneticCache[iLen - Length(isSuffix)].Results[K], 1)) and (IsKar(LeftStr(B_Suffix, 1))) then
            begin
              TempList.Add(PhoneticCache[iLen - Length(isSuffix)].Results[K] + b_Y + B_Suffix);
            end
            else
            begin
              if RightStr(PhoneticCache[iLen - Length(isSuffix)].Results[K], 1) = b_Khandatta then
                TempList.Add(MidStr(PhoneticCache[iLen - Length(isSuffix)].Results[K], 1, Length(PhoneticCache[iLen - Length(isSuffix)].Results[K]) - 1) + b_T
                    + B_Suffix)
              else if RightStr(PhoneticCache[iLen - Length(isSuffix)].Results[K], 1) = b_Anushar then
                TempList.Add(MidStr(PhoneticCache[iLen - Length(isSuffix)].Results[K], 1, Length(PhoneticCache[iLen - Length(isSuffix)].Results[K]) - 1) + b_NGA
                    + B_Suffix)
              else
                TempList.Add(PhoneticCache[iLen - Length(isSuffix)].Results[K] + B_Suffix);
            end;
          end;
        end;
      end;
    end;

    for J := 0 to TempList.Count - 1 do
    begin
      rList.Add(TempList[J]);
    end;

    TempList.Clear;
    FreeAndNil(TempList);
  end;
end;

{ =============================================================================== }

procedure TE2BCharBased.AddToCache(const MiddleMain_T: string; var rList: TStringList);
var
  iLen: Integer;
begin
  iLen := Length(MiddleMain_T);
  PhoneticCache[iLen].EnglishT := MiddleMain_T;
  PhoneticCache[iLen].Results.Clear;
  PhoneticCache[iLen].Results.Assign(rList);
end;

{ =============================================================================== }

constructor TE2BCharBased.Create;
var
  I: Integer;
begin
  inherited;
  Parser := TEnglishToBangla.Create;
  Abbreviation := TAbbreviation.Create;
  Bijoy := TUnicodeToBijoy2000.Create;
  RegExBuilder := TEnglishToRegEx.Create;
  WStringList := TStringList.Create;
  CandidateDict := TDictionary<string, string>.Create;
  LoadCandidateOptions;

  for I := low(PhoneticCache) to high(PhoneticCache) do
  begin
    PhoneticCache[I].Results := TStringList.Create;
  end;

  // If IsWinVistaOrLater Then
  DetermineZWNJ_ZWJ := ZWJ;
  // Else
  // DetermineZWNJ_ZWJ := ZWNJ;

end;

{ =============================================================================== }

procedure TE2BCharBased.CutText(const inputEStr: string; var outSIgnore, outMidMain, outEIgnore: string);
var
  I:                 Integer;
  p, q:              Integer;
  EStrLen:           Integer;
  tStr:              Char;
  reverse_inputEStr: string;
  temporaryString:   string;
begin

  tStr := #0;
  p := 0;

  EStrLen := Length(inputEStr);
  // Start Cutting outSIgnore
  for I := 1 to EStrLen do
  begin

    temporaryString := MidStr(inputEStr, I, 1);
    if Length(temporaryString) > 0 then
      tStr := temporaryString[1];

    case tStr of
      '~', '!', '@', '#', '%', '&', '*', '(', ')', '-', '_', '=', '+', '[', ']', '{', '}', #39, '"', ';', '<', '>', '/', '?', '|', '\', '.':

        p := I;

      ',':
        p := I;

      ':':
        Break;

      '`':
        p := I
      else
        Break;
    end;
  end;

  outSIgnore := LeftStr(inputEStr, p);
  // End Cutting outSIgnore

  // Start Cutting outEIgnore
  tStr := #0;
  q := 0;

  reverse_inputEStr := ReverseString(inputEStr);
  for I := 1 to EStrLen - p do
  begin
    temporaryString := MidStr(reverse_inputEStr, I, 1);
    if Length(temporaryString) > 0 then
      tStr := temporaryString[1];

    case tStr of
      '~', '!', '@', '#', '%', '&', '*', '(', ')', '-', '_', '=', '+', '[', ']', '{', '}', #39, #34, ';', '<', '>', '/', '.', '?', '|', '\':
        q := I;
      ',':
        q := I;

      '`':
        q := I;

      ':':
        q := I;

      else
        Break;
    end;
  end;

  outEIgnore := RightStr(inputEStr, q);
  // End Cutting outEIgnore

  // Start Cutting outMidMain
  temporaryString := MidStr(inputEStr, p + 1, Length(inputEStr));
  temporaryString := LeftStr(temporaryString, Length(temporaryString) - q);
  outMidMain := temporaryString;

end;

{ =============================================================================== }

destructor TE2BCharBased.Destroy;
var
  I: Integer;
begin
  WStringList.Clear;
  FreeAndNil(WStringList);
  FreeAndNil(Bijoy);
  FreeAndNil(Parser);
  FreeAndNil(RegExBuilder);
  FreeAndNil(Abbreviation);
  if SaveCandidate = 'YES' then
    SaveCandidateOptions;
  FreeAndNil(CandidateDict);

  for I := low(PhoneticCache) to high(PhoneticCache) do
  begin
    PhoneticCache[I].Results.Clear;
    PhoneticCache[I].Results.Free;
  end;

  inherited;
end;

{ =============================================================================== }

procedure TE2BCharBased.DoBackspace(var Block: boolean);
var
  BijoyNewBanglaText: string;
begin

  if (Length(EnglishT) - 1) <= 0 then
  begin

    if OutputIsBijoy <> 'YES' then
    begin
      if (Length(NewBanglaText) - 1) >= 1 then
        Backspace(Length(NewBanglaText) - 1);
    end
    else
    begin
      BijoyNewBanglaText := Bijoy.Convert(NewBanglaText);
      if (Length(BijoyNewBanglaText) - 1) >= 1 then
        Backspace(Length(BijoyNewBanglaText) - 1);
    end;

    ResetDeadKey;
    Block := False;
  end
  else if (Length(EnglishT) - 1) > 0 then
  begin
    Block := True;
    EnglishT := LeftStr(EnglishT, Length(EnglishT) - 1);
    ParseAndSend;
  end;

  // TODO: Move this settings based logic to the preview window,
  // it should be able to decide itself if the windows should be visible or not
  // then make HidePreview private there
  if ShowPrevWindow = 'YES' then
  begin
    if EnglishT <> '' then
      frmPrevW.UpdatePreviewCaption(EnglishT)
    else
      frmPrevW.HidePreview;
  end
  else
    frmPrevW.HidePreview;

end;

{ =============================================================================== }

function TE2BCharBased.EscapeSpecialCharacters(const inputT: string): string;
var
  T: string;
begin
  T := inputT;
  T := ReplaceStr(T, '\', '');
  T := ReplaceStr(T, '|', '');
  T := ReplaceStr(T, '(', '');
  T := ReplaceStr(T, ')', '');
  T := ReplaceStr(T, '[', '');
  T := ReplaceStr(T, ']', '');
  T := ReplaceStr(T, '{', '');
  T := ReplaceStr(T, '}', '');
  T := ReplaceStr(T, '^', '');
  T := ReplaceStr(T, '$', '');
  T := ReplaceStr(T, '*', '');
  T := ReplaceStr(T, '+', '');
  T := ReplaceStr(T, '?', '');
  T := ReplaceStr(T, '.', '');

  // Additional characters
  T := ReplaceStr(T, '~', '');
  T := ReplaceStr(T, '!', '');
  T := ReplaceStr(T, '@', '');
  T := ReplaceStr(T, '#', '');
  T := ReplaceStr(T, '%', '');
  T := ReplaceStr(T, '&', '');
  T := ReplaceStr(T, '-', '');
  T := ReplaceStr(T, '_', '');
  T := ReplaceStr(T, '=', '');
  T := ReplaceStr(T, #39, '');
  T := ReplaceStr(T, '"', '');
  T := ReplaceStr(T, ';', '');
  T := ReplaceStr(T, '<', '');
  T := ReplaceStr(T, '>', '');
  T := ReplaceStr(T, '/', '');
  T := ReplaceStr(T, '\', '');
  T := ReplaceStr(T, ',', '');
  T := ReplaceStr(T, ':', '');
  T := ReplaceStr(T, '`', '');
  T := ReplaceStr(T, b_Taka, '');
  T := ReplaceStr(T, b_Dari, '');

  Result := T;

end;

{ =============================================================================== }

procedure TE2BCharBased.Fix_ZWNJ_ZWJ(var rList: TStringList);
var
  I:                        Integer;
  StartCounter, EndCounter: Integer;
begin
  StartCounter := 0;
  EndCounter := rList.Count - 1;

  if EndCounter <= 0 then
    exit;

  rList.Sorted := False;

  for I := StartCounter to EndCounter do
  begin
    rList[I] := ReplaceStr(rList[I], b_R + ZWNJ + b_Hasanta + b_Z, b_R + DetermineZWNJ_ZWJ + b_Hasanta + b_Z);
  end;
end;

{ =============================================================================== }

function TE2BCharBased.GetAutoCorrectEnabled: boolean;
begin
  Result := Parser.AutoCorrectEnabled;
end;

{ =============================================================================== }

procedure TE2BCharBased.LoadCandidateOptions;
var
  I, p:                  Integer;
  FirstPart, SecondPart: string;
  tmpList:               TStringList;
begin
  if FileExists(GetAvroDataDir + 'CandidateOptions.dat') = False then
    exit;
  try
    try
      tmpList := TStringList.Create;
      tmpList.LoadFromFile(GetAvroDataDir + 'CandidateOptions.dat', TEncoding.UTF8);
      for I := 1 to tmpList.Count - 1 do
      begin
        if trim(tmpList[I]) <> '' then
        begin
          p := Pos(' ', trim(tmpList[I]));
          FirstPart := LeftStr(trim(tmpList[I]), p - 1);
          SecondPart := MidStr(trim(tmpList[I]), p + 1, Length(trim(tmpList[I])));
          CandidateDict.AddOrSetValue(FirstPart, SecondPart);
        end;
      end;
    except
      on E: Exception do
      begin
        // Nothing
      end;
    end;
  finally
    tmpList.Clear;
    FreeAndNil(tmpList);
  end;

end;

{ =============================================================================== }

procedure TE2BCharBased.MyProcessVKeyDown(const KeyCode: Integer; var Block: boolean; const var_IfShift, var_IfTrueShift: boolean);
begin
  Block := False;
  case KeyCode of
    VK_DECIMAL:
      begin
        AddStr('.`');
        Block := True;
        exit;
      end;
    VK_DIVIDE:
      begin
        AddStr('/');
        Block := True;
        exit;
      end;
    VK_MULTIPLY:
      begin
        AddStr('*');
        Block := True;
        exit;
      end;
    VK_SUBTRACT:
      begin
        AddStr('-');
        Block := True;
        exit;
      end;
    VK_ADD:
      begin
        AddStr('+');
        Block := True;
        exit;
      end;

    VK_OEM_1:
      begin // key ;:
        if var_IfTrueShift = True then
          AddStr(':');
        if var_IfTrueShift = False then
          AddStr(';');
        Block := True;
        exit;
      end;
    VK_OEM_2:
      begin // key /?
        if var_IfTrueShift = True then
        begin
          AddStr('?');
          Block := True;
        end;

        if var_IfTrueShift = False then
        begin
          AddStr('/');
          Block := True;
        end;
        exit;
      end;

    VK_OEM_3:
      begin // key `~
        if var_IfTrueShift = True then
          AddStr('~');
        if var_IfTrueShift = False then
          AddStr('`');
        Block := True;
        exit;
      end;

    VK_OEM_4:
      begin // key [{
        if var_IfTrueShift = True then
          AddStr('{');
        if var_IfTrueShift = False then
          AddStr('[');
        Block := True;
        exit;
      end;

    VK_OEM_5:
      begin // key \|
        if var_IfTrueShift = True then
        begin
          if PipeToDot = 'YES' then
            AddStr('.`') { New dot! }
          else
            AddStr('|');
        end;
        if var_IfTrueShift = False then
          AddStr('\');
        Block := True;
        exit;
      end;
    VK_OEM_6:
      begin // key ]}
        if var_IfTrueShift = True then
          AddStr('}');
        if var_IfTrueShift = False then
          AddStr(']');
        Block := True;
        exit;
      end;
    VK_OEM_7:
      begin // key '"
        if var_IfTrueShift = True then
          AddStr('"');
        if var_IfTrueShift = False then
          AddStr(#39);
        Block := True;
        exit;
      end;
    VK_OEM_COMMA:
      begin // key ,<
        if var_IfTrueShift = True then
          AddStr('<');
        if var_IfTrueShift = False then
          AddStr(',');
        Block := True;
        exit;
      end;
    VK_OEM_MINUS:
      begin // key - underscore
        if var_IfTrueShift = True then
          AddStr('_');
        if var_IfTrueShift = False then
          AddStr('-');
        Block := True;
        exit;
      end;
    VK_OEM_PERIOD:
      begin // key . >
        if var_IfTrueShift = True then
          AddStr('>');
        if var_IfTrueShift = False then
          AddStr('.');
        Block := True;
        exit;
      end;
    VK_OEM_PLUS:
      begin // key =+
        if var_IfTrueShift = True then
          AddStr('+');
        if var_IfTrueShift = False then
          AddStr('=');
        Block := True;
        exit;
      end;

    VK_0:
      begin
        if var_IfTrueShift = True then
          AddStr(')');
        if var_IfTrueShift = False then
          AddStr('0');
        Block := True;
        exit;
      end;
    VK_1:
      begin
        if var_IfTrueShift = True then
          AddStr('!');
        if var_IfTrueShift = False then
          AddStr('1');
        Block := True;
        exit;
      end;
    VK_2:
      begin
        if var_IfTrueShift = True then
          AddStr('@');
        if var_IfTrueShift = False then
          AddStr('2');
        Block := True;
        exit;
      end;
    VK_3:
      begin
        if var_IfTrueShift = True then
          AddStr('#');
        if var_IfTrueShift = False then
          AddStr('3');
        Block := True;
        exit;
      end;
    VK_4:
      begin
        if var_IfTrueShift = True then
          AddStr('$');
        if var_IfTrueShift = False then
          AddStr('4');
        Block := True;
        exit;
      end;
    VK_5:
      begin
        if var_IfTrueShift = True then
          AddStr('%');
        if var_IfTrueShift = False then
          AddStr('5');
        Block := True;
        exit;
      end;
    VK_6:
      begin
        if var_IfTrueShift = True then
          AddStr('^');
        if var_IfTrueShift = False then
          AddStr('6');
        Block := True;
        exit;
      end;
    VK_7:
      begin
        if var_IfTrueShift = True then
          AddStr('&');
        if var_IfTrueShift = False then
          AddStr('7');
        Block := True;
        exit;
      end;
    VK_8:
      begin
        if var_IfTrueShift = True then
          AddStr('*');
        if var_IfTrueShift = False then
          AddStr('8');
        Block := True;
        exit;
      end;
    VK_9:
      begin
        if var_IfTrueShift = True then
          AddStr('(');
        if var_IfTrueShift = False then
          AddStr('9');
        Block := True;
        exit;
      end;

    VK_NUMPAD0:
      begin
        AddStr('0');
        Block := True;
        exit;
      end;
    VK_NUMPAD1:
      begin
        AddStr('1');
        Block := True;
        exit;
      end;
    VK_NUMPAD2:
      begin
        AddStr('2');
        Block := True;
        exit;
      end;
    VK_NUMPAD3:
      begin
        AddStr('3');
        Block := True;
        exit;
      end;
    VK_NUMPAD4:
      begin
        AddStr('4');
        Block := True;
        exit;
      end;
    VK_NUMPAD5:
      begin
        AddStr('5');
        Block := True;
        exit;
      end;
    VK_NUMPAD6:
      begin
        AddStr('6');
        Block := True;
        exit;
      end;
    VK_NUMPAD7:
      begin
        AddStr('7');
        Block := True;
        exit;
      end;
    VK_NUMPAD8:
      begin
        AddStr('8');
        Block := True;
        exit;
      end;
    VK_NUMPAD9:
      begin
        AddStr('9');
        Block := True;
        exit;
      end;

    A_Key:
      begin
        if var_IfShift = True then
          AddStr('A');
        if var_IfShift = False then
          AddStr('a');
        Block := True;
        exit;
      end;
    B_Key:
      begin
        if var_IfShift = True then
          AddStr('B');
        if var_IfShift = False then
          AddStr('b');
        Block := True;
        exit;
      end;
    C_Key:
      begin
        if var_IfShift = True then
          AddStr('C');
        if var_IfShift = False then
          AddStr('c');
        Block := True;
        exit;
      end;
    D_Key:
      begin
        if var_IfShift = True then
          AddStr('D');
        if var_IfShift = False then
          AddStr('d');
        Block := True;
        exit;
      end;
    E_Key:
      begin
        if var_IfShift = True then
          AddStr('E');
        if var_IfShift = False then
          AddStr('e');
        Block := True;
        exit;
      end;
    F_Key:
      begin
        if var_IfShift = True then
          AddStr('F');
        if var_IfShift = False then
          AddStr('f');
        Block := True;
        exit;
      end;
    G_Key:
      begin
        if var_IfShift = True then
          AddStr('G');
        if var_IfShift = False then
          AddStr('g');
        Block := True;
        exit;
      end;
    H_Key:
      begin
        if var_IfShift = True then
          AddStr('H');
        if var_IfShift = False then
          AddStr('h');
        Block := True;
        exit;
      end;
    I_Key:
      begin
        if var_IfShift = True then
          AddStr('I');
        if var_IfShift = False then
          AddStr('i');
        Block := True;
        exit;
      end;
    J_Key:
      begin
        if var_IfShift = True then
          AddStr('J');
        if var_IfShift = False then
          AddStr('j');
        Block := True;
        exit;
      end;
    K_Key:
      begin
        if var_IfShift = True then
          AddStr('K');
        if var_IfShift = False then
          AddStr('k');
        Block := True;
        exit;
      end;
    L_Key:
      begin
        if var_IfShift = True then
          AddStr('L');
        if var_IfShift = False then
          AddStr('l');
        Block := True;
        exit;
      end;
    M_Key:
      begin
        if var_IfShift = True then
          AddStr('M');
        if var_IfShift = False then
          AddStr('m');
        Block := True;
        exit;
      end;
    N_Key:
      begin
        if var_IfShift = True then
          AddStr('N');
        if var_IfShift = False then
          AddStr('n');
        Block := True;
        exit;
      end;
    O_Key:
      begin
        if var_IfShift = True then
          AddStr('O');
        if var_IfShift = False then
          AddStr('o');
        Block := True;
        exit;
      end;
    P_Key:
      begin
        if var_IfShift = True then
          AddStr('P');
        if var_IfShift = False then
          AddStr('p');
        Block := True;
        exit;
      end;
    Q_Key:
      begin
        if var_IfShift = True then
          AddStr('Q');
        if var_IfShift = False then
          AddStr('q');
        Block := True;
        exit;
      end;
    R_Key:
      begin
        if var_IfShift = True then
          AddStr('R');
        if var_IfShift = False then
          AddStr('r');
        Block := True;
        exit;
      end;
    S_Key:
      begin
        if var_IfShift = True then
          AddStr('S');
        if var_IfShift = False then
          AddStr('s');
        Block := True;
        exit;
      end;
    T_Key:
      begin
        if var_IfShift = True then
          AddStr('T');
        if var_IfShift = False then
          AddStr('t');
        Block := True;
        exit;
      end;
    U_Key:
      begin
        if var_IfShift = True then
          AddStr('U');
        if var_IfShift = False then
          AddStr('u');
        Block := True;
        exit;
      end;
    V_Key:
      begin
        if var_IfShift = True then
          AddStr('V');
        if var_IfShift = False then
          AddStr('v');
        Block := True;
        exit;
      end;
    W_Key:
      begin
        if var_IfShift = True then
          AddStr('W');
        if var_IfShift = False then
          AddStr('w');
        Block := True;
        exit;
      end;
    X_Key:
      begin
        if var_IfShift = True then
          AddStr('X');
        if var_IfShift = False then
          AddStr('x');
        Block := True;
        exit;
      end;
    Y_Key:
      begin
        if var_IfShift = True then
          AddStr('Y');
        if var_IfShift = False then
          AddStr('y');
        Block := True;
        exit;
      end;
    Z_Key:
      begin
        if var_IfShift = True then
          AddStr('Z');
        if var_IfShift = False then
          AddStr('z');
        Block := True;
        exit;
      end;

    // Special cases-------------------->
    VK_HOME:
      begin
        Block := False;
        ResetDeadKey;
        exit;
      end;
    VK_END:
      begin
        Block := False;
        ResetDeadKey;
        exit;
      end;
    VK_PRIOR:
      begin
        Block := False;
        ResetDeadKey;
        exit;
      end;
    VK_NEXT:
      begin
        Block := False;
        ResetDeadKey;
        exit;
      end;
    VK_UP:
      begin
        if (frmPrevW.List.Count > 1) and (EnglishT <> '') then
        begin
          Block := True;
          frmPrevW.SelectPrevItem;
          UpdateCandidateOption;
          exit;
        end
        else
        begin
          Block := False;
          ResetDeadKey;
          exit;
        end;
      end;
    VK_DOWN:
      begin
        if (frmPrevW.List.Count > 1) and (EnglishT <> '') then
        begin
          Block := True;
          frmPrevW.SelectNextItem;
          UpdateCandidateOption;
          exit;
        end
        else
        begin
          Block := False;
          ResetDeadKey;
          exit;
        end;
      end;
    VK_RIGHT:
      begin
        Block := False;
        ResetDeadKey;
        exit;
      end;
    VK_LEFT:
      begin
        Block := False;
        ResetDeadKey;
        exit;
      end;
    VK_BACK:
      begin
        DoBackspace(Block);
        exit;
      end;
    VK_DELETE:
      begin
        Block := False;
        ResetDeadKey;
        exit;
      end;
    VK_ESCAPE:
      begin
        if (frmPrevW.IsPreviewVisible = True) and (EnglishT <> '') then
        begin
          Block := True;
          ResetDeadKey;
          exit;
        end;
      end;

    VK_INSERT:
      begin
        Block := True;
        exit;
      end;
  end;
end;

{ =============================================================================== }

procedure TE2BCharBased.PadResults(const Starting_Ignoreable_T, Ending_Ignorable_T: string; var rList: TStringList);
var
  B_Starting_Ignoreable_T, B_Ending_Ignorable_T: string;
  I:                                             Integer;
begin
  Parser.AutoCorrectEnabled := False;
  B_Starting_Ignoreable_T := Parser.Convert(Starting_Ignoreable_T);
  B_Ending_Ignorable_T := Parser.Convert(Ending_Ignorable_T);

  rList.Sorted := False;
  for I := 0 to rList.Count - 1 do
  begin
    rList[I] := B_Starting_Ignoreable_T + rList[I] + B_Ending_Ignorable_T;
  end;
end;

{ =============================================================================== }

procedure TE2BCharBased.ParseAndSend;
var
  I:                                                        Integer;
  RegExQuery:                                               string;
  TempBanglaText1, TempBanglaText2:                         string;
  DictionaryFirstItem:                                      string;
  Starting_Ignoreable_T, Middle_Main_T, Ending_Ignorable_T: string;
  AbbText:                                                  string;
  CandidateItem:                                            string;
begin
  frmPrevW.List.Items.Clear;

  Parser.AutoCorrectEnabled := True;
  TempBanglaText1 := Parser.Convert(EnglishT);
  Parser.AutoCorrectEnabled := False;
  TempBanglaText2 := Parser.Convert(EnglishT);

  if TempBanglaText1 = TempBanglaText2 then
    frmPrevW.List.Items.Add(TempBanglaText1)
  else
  begin
    // If FAutoCorrect Then Begin
    frmPrevW.List.Items.Add(TempBanglaText1);
    frmPrevW.List.Items.Add(TempBanglaText2);
    // End
    // Else Begin
    // frmPrevW.List.Items.Add(TempBanglaText2);
    // frmPrevW.List.Items.Add(TempBanglaText1);
    // End;
  end;

  if (PhoneticMode = 'ONLYCHAR') or (ShowPrevWindow = 'NO') then
  begin
    if (TempBanglaText1 <> TempBanglaText2) then
    begin
      if FAutoCorrect then
        frmPrevW.SelectItem(EscapeSpecialCharacters(TempBanglaText1))
      else
        frmPrevW.SelectItem(EscapeSpecialCharacters(TempBanglaText2));
    end
    else
      frmPrevW.SelectFirstItem;
  end
  else
  begin
    CutText(EnglishT, Starting_Ignoreable_T, Middle_Main_T, Ending_Ignorable_T);
    if (Length(Middle_Main_T) <= Max_EnglishLength) and (Length(Middle_Main_T) > 0) then
    begin

      WStringList.Clear;

      if Middle_Main_T = PhoneticCache[Length(Middle_Main_T)].EnglishT then
      begin
        WStringList.Assign(PhoneticCache[Length(Middle_Main_T)].Results);
        AddSuffix(Middle_Main_T, WStringList);
        SimilarSort(TempBanglaText2, WStringList);
        AbbText := '';
        AbbText := Abbreviation.CheckConvert(Middle_Main_T);
        if AbbText <> '' then
          WStringList.Add(AbbText);
        PadResults(Starting_Ignoreable_T, Ending_Ignorable_T, WStringList);
      end
      else
      begin
        RegExQuery := RegExBuilder.Convert(Middle_Main_T);
        uRegExPhoneticSearch.SearchPhonetic(Middle_Main_T, RegExQuery, WStringList);

        Fix_ZWNJ_ZWJ(WStringList);
        AddToCache(Middle_Main_T, WStringList);
        AddSuffix(Middle_Main_T, WStringList);
        SimilarSort(TempBanglaText2, WStringList);
        AbbText := '';
        AbbText := Abbreviation.CheckConvert(Middle_Main_T);
        if AbbText <> '' then
          WStringList.Add(AbbText);
        PadResults(Starting_Ignoreable_T, Ending_Ignorable_T, WStringList);
      end;

      if WStringList.Count > 0 then
        DictionaryFirstItem := WStringList[0];

      for I := 0 to WStringList.Count - 1 do
      begin
        if (WStringList[I] <> TempBanglaText1) and (WStringList[I] <> TempBanglaText2) then
          frmPrevW.List.Items.Add(WStringList[I]);
      end;

      // Add English option as the last item
      frmPrevW.List.Items.Add(EnglishT);

      // frmPrevW.SelectFirstItem;
      if CandidateDict.TryGetValue(Middle_Main_T, CandidateItem) and (SaveCandidate = 'YES') then
      begin
        frmPrevW.SelectItem(EscapeSpecialCharacters(CandidateItem));
      end
      else
      begin
        if WStringList.Count > 0 then
        begin
          if Length(Middle_Main_T) = 1 then
            frmPrevW.SelectFirstItem
          else
          begin
            if (TempBanglaText1 <> TempBanglaText2) then
            begin
              if FAutoCorrect then
                frmPrevW.SelectItem(EscapeSpecialCharacters(TempBanglaText1))
              else
              begin
                if PhoneticMode = 'DICT' then
                begin
                  if DictionaryFirstItem <> '' then
                    frmPrevW.SelectItem(EscapeSpecialCharacters(DictionaryFirstItem))
                  else
                    frmPrevW.SelectItem(EscapeSpecialCharacters(WStringList[0]));
                end
                else if PhoneticMode = 'CHAR' then
                begin
                  frmPrevW.SelectItem(EscapeSpecialCharacters(TempBanglaText2))
                end;
              end;
            end
            else
            begin
              if PhoneticMode = 'DICT' then
              begin
                if DictionaryFirstItem <> '' then
                  frmPrevW.SelectItem(EscapeSpecialCharacters(DictionaryFirstItem))
                else
                  frmPrevW.SelectItem(EscapeSpecialCharacters(WStringList[0]));
              end
              else if PhoneticMode = 'CHAR' then
              begin
                frmPrevW.SelectItem(EscapeSpecialCharacters(TempBanglaText2))
              end;
            end;
          end;
        end
        else
          frmPrevW.SelectFirstItem;
      end;
    end
    else
      frmPrevW.SelectFirstItem;
  end;

  frmPrevW.UpdateListHeight;

  ManuallySelectedCandidate := False;
end;

{ =============================================================================== }

procedure TE2BCharBased.ParseAndSendNow;
var
  I, Matched, UnMatched:                Integer;
  BijoyPrevBanglaT, BijoyNewBanglaText: string;
begin
  Matched := 0;

  if OutputIsBijoy <> 'YES' then
  begin
    { Output to Unicode }
    if PrevBanglaT = '' then
    begin
      SendKey_Char(NewBanglaText);
      PrevBanglaT := NewBanglaText;
    end
    else
    begin
      for I := 1 to Length(PrevBanglaT) do
      begin
        if MidStr(PrevBanglaT, I, 1) = MidStr(NewBanglaText, I, 1) then
          Matched := Matched + 1
        else
          Break;
      end;
      UnMatched := Length(PrevBanglaT) - Matched;

      if UnMatched >= 1 then
        Backspace(UnMatched);
      SendKey_Char(MidStr(NewBanglaText, Matched + 1, Length(NewBanglaText)));
      PrevBanglaT := NewBanglaText;
    end;

  end
  else
  begin
    { Output to Bijoy }
    BijoyPrevBanglaT := Bijoy.Convert(PrevBanglaT);
    BijoyNewBanglaText := Bijoy.Convert(NewBanglaText);

    if BijoyPrevBanglaT = '' then
    begin
      SendKey_Char(BijoyNewBanglaText);
      PrevBanglaT := NewBanglaText;
    end
    else
    begin
      for I := 1 to Length(BijoyPrevBanglaT) do
      begin
        if MidStr(BijoyPrevBanglaT, I, 1) = MidStr(BijoyNewBanglaText, I, 1) then
          Matched := Matched + 1
        else
          Break;
      end;
      UnMatched := Length(BijoyPrevBanglaT) - Matched;

      if UnMatched >= 1 then
        Backspace(UnMatched);
      SendKey_Char(MidStr(BijoyNewBanglaText, Matched + 1, Length(BijoyNewBanglaText)));
      PrevBanglaT := NewBanglaText;
    end;

  end;
end;

{ =============================================================================== }

procedure TE2BCharBased.ProcessEnter(var Block: boolean);
begin
  ResetDeadKey;
  Block := False;
end;

{ =============================================================================== }

procedure TE2BCharBased.ProcessSpace(var Block: boolean);
begin
  ResetDeadKey;
  Block := False;
end;

{ =============================================================================== }

function TE2BCharBased.ProcessVKeyDown(const KeyCode: Integer; var Block: boolean): string;
var
  m_Block: boolean;
begin
  m_Block := False;
  if (IfControl = True) or (IfAlter = True) or (IfWinKey = True) then
  begin
    Block := False;
    BlockLast := False;
    ProcessVKeyDown := '';
    exit;
  end;

  if (KeyCode = VK_SHIFT) or (KeyCode = VK_LSHIFT) or (KeyCode = VK_RSHIFT) then
  begin
    Block := False;
    BlockLast := False;
    ProcessVKeyDown := '';
    exit;
  end;

  if AvroMainForm1.GetMyCurrentKeyboardMode = SysDefault then
  begin
    Block := False;
    BlockLast := False;
    ProcessVKeyDown := '';
    exit;
  end
  else if AvroMainForm1.GetMyCurrentKeyboardMode = bangla then
  begin
    if KeyCode = VK_SPACE then
    begin
      ProcessSpace(Block);
      ProcessVKeyDown := '';
      exit;
    end
    else if KeyCode = VK_TAB then
    begin
      if TabBrowsing = 'YES' then
      begin
        if (frmPrevW.List.Count > 1) and (EnglishT <> '') then
        begin
          Block := True;
          frmPrevW.SelectNextItem;
          UpdateCandidateOption;
          exit;
        end
        else
        begin
          ResetDeadKey;
          Block := False;
          ProcessVKeyDown := '';
          exit;
        end;
      end
      else
      begin
        ResetDeadKey;
        Block := False;
        ProcessVKeyDown := '';
        exit;
      end;
    end
    else if KeyCode = VK_RETURN then
    begin
      ProcessEnter(Block);
      ProcessVKeyDown := '';
      exit;
    end
    else
    begin

      MyProcessVKeyDown(KeyCode, m_Block, IfShift, IfTrueShift);
      ProcessVKeyDown := '';

      Block := m_Block;
      BlockLast := m_Block;
    end;
  end;

end;

{ =============================================================================== }

procedure TE2BCharBased.ProcessVKeyUP(const KeyCode: Integer; var Block: boolean);
begin
  if (KeyCode = VK_SHIFT) or (KeyCode = VK_RSHIFT) or (KeyCode = VK_LSHIFT) or (KeyCode = VK_LCONTROL) or (KeyCode = VK_RCONTROL) or (KeyCode = VK_CONTROL) or
    (KeyCode = VK_MENU) or (KeyCode = VK_LMENU) or (KeyCode = VK_RMENU) or (IfWinKey = True) then
  begin
    Block := False;
    BlockLast := False;
    exit;
  end;

  if AvroMainForm1.GetMyCurrentKeyboardMode = SysDefault then
  begin
    Block := False;
    BlockLast := False;
  end
  else if AvroMainForm1.GetMyCurrentKeyboardMode = bangla then
  begin
    if BlockLast = True then
      Block := True;
  end;
end;

{ =============================================================================== }

procedure TE2BCharBased.ResetDeadKey;
var
  I: Integer;
begin
  PrevBanglaT := '';
  EnglishT := '';
  BlockLast := False;
  NewBanglaText := '';

  for I := low(PhoneticCache) to high(PhoneticCache) do
  begin
    PhoneticCache[I].EnglishT := '';
    PhoneticCache[I].Results.Clear;
  end;

  if ShowPrevWindow = 'YES' then
    frmPrevW.HidePreview;

end;

{ =============================================================================== }

procedure TE2BCharBased.SaveCandidateOptions;
var
  S:       string;
  tmpList: TStringList;
begin
  try
    try
      tmpList := TStringList.Create;
      tmpList.Add('// Avro Phonetic Candidate Selection Options (Do not remove this line)');
      for S in CandidateDict.Keys do
      begin
        tmpList.Add(S + ' ' + CandidateDict.Items[S]);
      end;
      tmpList.SaveToFile(GetAvroDataDir + 'CandidateOptions.dat', TEncoding.UTF8);
    except
      on E: Exception do
      begin
        // Nothing
      end;
    end;
  finally
    tmpList.Clear;
    FreeAndNil(tmpList);
  end;
end;

{ =============================================================================== }

procedure TE2BCharBased.SelectCandidate(const Item: string);
begin
  NewBanglaText := Item;
  ParseAndSendNow;
  ManuallySelectedCandidate := True;
end;

{ =============================================================================== }

procedure TE2BCharBased.SetAutoCorrectEnabled(const Value: boolean);
begin
  Parser.AutoCorrectEnabled := Value;
  FAutoCorrect := Value;
end;

{ =============================================================================== }

procedure TE2BCharBased.UpdateCandidateOption;
var
  Dummy, Middle_Main_T: string;
begin
  CutText(EnglishT, Dummy, Middle_Main_T, Dummy);
  if ManuallySelectedCandidate then
  begin
    if trim(Middle_Main_T) <> '' then
    begin
      CandidateDict.AddOrSetValue(Middle_Main_T, NewBanglaText);
    end;
  end;
end;

{ =============================================================================== }

end.
