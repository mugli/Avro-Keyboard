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

{ COMPLETE TRANSFERING! }

Unit uRegistrySettings;

Interface

Uses
		 Classes,
		 Sysutils,
		 clsRegistry_XMLSetting,
		 uWindowHandlers,
		 Windows,
		 Forms,
		 StrUtils;

Const
		 NumberOfVisibleHints: Integer = 2;


Var
		 DontShowComplexLNotification: String;
		 DontShowStartupWizard: String;

		 // General settings
		 StartWithWindows: String;
		 ShowSplash: String;
		 DefaultUIMode: String;
		 LastUIMode: String;
		 TopBarPosX: String;
		 TopBarXButton: String;


		 // Inteface Settings
		 TopBarTransparent: String;
		 TopBarTransparencyLevel: String;
		 InterfaceSkin: String;
		 TrayHintShowTimes: String;
		 TopHintShowTimes: String;

		 // Webbuddy Options
		 AvroUpdateCheck: String;
		 AvroUpdateLastCheck: TDateTime;


		 // Hotkey settings
		 ModeSwitchKey: String;
		 ToggleOutputModeKey: String;
		 SpellerLauncherKey: String;


		 // Avro Mouse Settings
		 AvroMouseChangeModeLocale: String;
		 AvroMousePosX: String;
		 AvroMousePosY: String;

		 // Avro Phonetic Settings
		 PhoneticAutoCorrect: String;
		 ShowPrevWindow: String;
		 PhoneticMode: String;
		 SaveCandidate: String;
		 AddToPhoneticDict: String;
		 TabBrowsing: String;
		 PipeToDot: String;
		 EnableJoNukta: String;


		 // Input Locale Settings
		 ChangeInputLocale: String;
		 PrefferedLocale: String;

		 // Fixed Layout Settings
		 DefaultLayout: String; // NOT A Fixed Layout SETTING!
		 OldStyleReph: String;
		 VowelFormating: String;
		 NumPadBangla: String;
		 FullOldStyleTyping: String;
		 AutomaticallyFixChandra: String;




		 // Keyboard Layout Viewer Settings
		 ShowLayoutOnTop: String;
		 SavePosLayoutViewer: String;
		 LayoutViewerPosX: String;
		 LayoutViewerPosY: String;
		 LayoutViewerSize: String;

		 // Global Output settings
		 OutputIsBijoy: String;
		 ShowOutputwarning: String;



Procedure SaveUISettings;
Procedure LoadSettings;
Procedure ValidateSettings;
Procedure SaveSettings;


Procedure LoadSettingsFromFile;
Procedure SaveSettingsInXML;

Procedure LoadSettingsFromRegistry;
Procedure SaveSettingsInRegistry;

Implementation

Uses
		 uForm1,
		 uTopBar,
		 WindowsVersion,
		 uLocale;

{ =============================================================================== }

Procedure LoadSettingsFromFile;
Var
		 Reg: TMyRegistry;
		 XML: TXMLSetting;
Begin
		 Reg := TMyRegistry.create;
		 Reg.RootKey := HKEY_CURRENT_USER;

		 If Reg.OpenKey('Control Panel\Desktop', True) = True Then Begin
					Reg.WriteInteger('LowLevelHooksTimeout', 5000);
		 End;

		 Reg.Free;

		 XML := TXMLSetting.create;
		 XML.LoadXMLData;

		 DontShowComplexLNotification := UpperCase(XML.GetValue('DontShowComplexLNotification', 'NO'));
		 DontShowStartupWizard := UpperCase(XML.GetValue('DontShowStartupWizard', 'NO'));

		 // General settings
		 StartWithWindows := UpperCase(XML.GetValue('StartWithWindows', 'Yes'));
		 DefaultUIMode := UpperCase(XML.GetValue('DefaultUIMode', 'LastUI'));
		 ShowSplash := UpperCase(XML.GetValue('ShowSplash', 'YES'));
		 LastUIMode := UpperCase(XML.GetValue('LastUIMode', 'Top Bar'));
		 TopBarPosX := UpperCase(XML.GetValue('TopBarPosX', '1000000'));
		 TopBarXButton := UpperCase(XML.GetValue('TopBarXButton', 'Show Menu'));
		 TopBarTransparent := UpperCase(XML.GetValue('TopBarTransparent', 'Yes'));

		 // Inteface Settings
		 InterfaceSkin := XML.GetValue('InterfaceSkin', 'internalskin*');
		 TopBarTransparencyLevel := XML.GetValue('TopBarTransparencyLevel', '80');
		 TopBarTransparent := XML.GetValue('TopBarTransparent', 'YES');
		 TrayHintShowTimes := XML.GetValue('TrayHintShowTimes', '0');
		 TopHintShowTimes := XML.GetValue('TopHintShowTimes', '0');


		 // Webbuddy Options
		 AvroUpdateCheck := UpperCase(XML.GetValue('AvroUpdateCheck', 'Yes'));
		 AvroUpdateLastCheck := XML.GetValue('AvroUpdateLastCheck', Now);


		 // Hotkey settings
		 ModeSwitchKey := UpperCase(XML.GetValue('ModeSwitchKey', 'F12'));
		 ToggleOutputModeKey := UpperCase(XML.GetValue('ToggleOutputModeKey', 'F12'));
		 SpellerLauncherKey := UpperCase(XML.GetValue('SpellerLauncherKey', 'F7'));

		 // Avro Mouse Settings
		 AvroMouseChangeModeLocale := UpperCase(XML.GetValue('AvroMouseChangeModeLocale', 'No'));
		 AvroMousePosX := UpperCase(XML.GetValue('AvroMousePosX', '0'));
		 AvroMousePosY := UpperCase(XML.GetValue('AvroMousePosY', '0'));

		 // Avro Phonetic Settings
		 PhoneticAutoCorrect := UpperCase(XML.GetValue('PhoneticAutoCorrect', 'Yes'));
		 ShowPrevWindow := UpperCase(XML.GetValue('ShowPrevWindow', 'Yes'));
		 PhoneticMode := UpperCase(XML.GetValue('PhoneticMode', 'CHAR'));
		 SaveCandidate := UpperCase(XML.GetValue('SaveCandidate', 'YES'));
		 AddToPhoneticDict := UpperCase(XML.GetValue('AddToPhoneticDict', 'YES'));
		 TabBrowsing := UpperCase(XML.GetValue('TabBrowsing', 'YES'));
		 PipeToDot := UpperCase(XML.GetValue('PipeToDot', 'YES'));
		 EnableJoNukta := UpperCase(XML.GetValue('EnableJoNukta', 'NO'));


		 // Input Locale Settings
		 ChangeInputLocale := UpperCase(XML.GetValue('ChangeInputLocale', 'Yes'));
		 PrefferedLocale := UpperCase(XML.GetValue('PrefferedLocale', 'India'));
		 // PrefferedLocaleEnglish := XML.GetValue('PrefferedLocaleEnglish', 'Locale:00000409');

		 // Tools Settings
		 OldStyleReph := UpperCase(XML.GetValue('OldStyleReph', 'Yes'));
		 VowelFormating := UpperCase(XML.GetValue('VowelFormating', 'Yes'));
		 NumPadBangla := UpperCase(XML.GetValue('NumPadBangla', 'Yes'));
		 FullOldStyleTyping := UpperCase(XML.GetValue('FullOldStyleTyping', 'No'));
		 AutomaticallyFixChandra := UpperCase(XML.GetValue('AutomaticallyFixChandra', 'Yes'));

		 // Keyboard Layout Viewer Settings
		 DefaultLayout := XML.GetValue('DefaultLayout', 'avrophonetic*');
		 ShowLayoutOnTop := UpperCase(XML.GetValue('ShowLayoutOnTop', 'Yes'));
		 SavePosLayoutViewer := UpperCase(XML.GetValue('SavePosLayoutViewer', 'Yes'));
		 LayoutViewerPosX := UpperCase(XML.GetValue('LayoutViewerPosX', '0'));
		 LayoutViewerPosY := UpperCase(XML.GetValue('LayoutViewerPosY', '0'));
		 LayoutViewerSize := UpperCase(XML.GetValue('LayoutViewerSize', '60%'));

		 // Global Output settings
		 OutputIsBijoy := UpperCase(XML.GetValue('OutputIsBijoy', 'No'));
		 ShowOutputwarning := UpperCase(XML.GetValue('ShowOutputwarning', 'Yes'));

		 XML.Free;

End;

{ =============================================================================== }

Procedure SaveSettingsInXML;
Var
		 XML: TXMLSetting;
Begin
		 XML := TXMLSetting.create;
		 XML.CreateNewXMLData;

		 XML.SetValue('DontShowComplexLNotification', DontShowComplexLNotification);
		 XML.SetValue('DontShowStartupWizard', DontShowStartupWizard);

		 // General settings
		 XML.SetValue('StartWithWindows', StartWithWindows);
		 XML.SetValue('ShowSplash', ShowSplash);
		 XML.SetValue('DefaultUIMode', DefaultUIMode);
		 XML.SetValue('LastUIMode', LastUIMode);
		 XML.SetValue('TopBarPosX', TopBarPosX);
		 XML.SetValue('TopBarXButton', TopBarXButton);
		 XML.SetValue('TopBarTransparent', TopBarTransparent);


		 // Inteface Settings
		 XML.SetValue('InterfaceSkin', InterfaceSkin);
		 XML.SetValue('TopBarTransparencyLevel', TopBarTransparencyLevel);
		 XML.SetValue('TopBarTransparent', TopBarTransparent);
		 XML.SetValue('TrayHintShowTimes', TrayHintShowTimes);
		 XML.SetValue('TopHintShowTimes', TopHintShowTimes);



		 // Webbuddy Options
		 XML.SetValue('AvroUpdateCheck', AvroUpdateCheck);
		 XML.SetValue('AvroUpdateLastCheck', AvroUpdateLastCheck);

		 // Hotkey settings
		 XML.SetValue('ModeSwitchKey', ModeSwitchKey);
		 XML.SetValue('ToggleOutputModeKey', ToggleOutputModeKey);
		 XML.SetValue('SpellerLauncherKey', SpellerLauncherKey);

		 // Avro Mouse Settings
		 XML.SetValue('AvroMouseChangeModeLocale', AvroMouseChangeModeLocale);
		 XML.SetValue('AvroMousePosX', AvroMousePosX);
		 XML.SetValue('AvroMousePosY', AvroMousePosY);
		 // XML.SetValue('AvroMouseSavePos', AvroMouseSavePos);

		 // Avro Phonetic Settings
		 XML.SetValue('PhoneticAutoCorrect', PhoneticAutoCorrect);
		 XML.SetValue('ShowPrevWindow', ShowPrevWindow);
		 XML.SetValue('PhoneticMode', PhoneticMode);
		 XML.SetValue('SaveCandidate', SaveCandidate);
		 XML.SetValue('AddToPhoneticDict', AddToPhoneticDict);
		 XML.SetValue('TabBrowsing', TabBrowsing);
		 XML.SetValue('PipeToDot', PipeToDot);
		 XML.SetValue('EnableJoNukta', EnableJoNukta);

		 // Input Locale Settings
		 XML.SetValue('ChangeInputLocale', ChangeInputLocale);
		 XML.SetValue('PrefferedLocale', PrefferedLocale);

		 // Tools Settings
		 XML.SetValue('OldStyleReph', OldStyleReph);
		 XML.SetValue('VowelFormating', VowelFormating);
		 XML.SetValue('NumPadBangla', NumPadBangla);
		 XML.SetValue('AutomaticallyFixChandra', AutomaticallyFixChandra);
		 XML.SetValue('FullOldStyleTyping', FullOldStyleTyping);

		 // Keyboard Layout Viewer Settings
		 XML.SetValue('DefaultLayout', DefaultLayout);
		 XML.SetValue('ShowLayoutOnTop', ShowLayoutOnTop);
		 XML.SetValue('SavePosLayoutViewer', SavePosLayoutViewer);
		 XML.SetValue('LayoutViewerPosX', LayoutViewerPosX);
		 XML.SetValue('LayoutViewerPosY', LayoutViewerPosY);
		 XML.SetValue('LayoutViewerSize', LayoutViewerSize);


		 // Global Output settings
		 XML.SetValue('OutputIsBijoy', OutputIsBijoy);
		 XML.SetValue('ShowOutputwarning', ShowOutputwarning);


		 XML.SaveXMLData;
		 XML.Free;


End;

{ =============================================================================== }


Procedure LoadSettingsFromRegistry;
Var
		 Reg: TMyRegistry;
Begin
		 Reg := TMyRegistry.create;
		 Reg.RootKey := HKEY_CURRENT_USER;

		 If Reg.OpenKey('Control Panel\Desktop', True) = True Then Begin
					Reg.WriteInteger('LowLevelHooksTimeout', 5000);
		 End;
		 Reg.CloseKey;

		 Reg.RootKey := HKEY_CURRENT_USER;
		 If Reg.OpenKey('Software\OmicronLab\Avro Keyboard', True) = True Then Begin
					DontShowComplexLNotification := UpperCase(Reg.ReadStringDef('DontShowComplexLNotification', 'NO'));
					DontShowStartupWizard := UpperCase(Reg.ReadStringDef('DontShowStartupWizard', 'NO'));

					// General settings
					StartWithWindows := UpperCase(Reg.ReadStringDef('StartWithWindows', 'Yes'));
					ShowSplash := UpperCase(Reg.ReadStringDef('ShowSplash', 'Yes'));
					DefaultUIMode := UpperCase(Reg.ReadStringDef('DefaultUIMode', 'LastUI'));
					LastUIMode := UpperCase(Reg.ReadStringDef('LastUIMode', 'Top Bar'));
					TopBarPosX := UpperCase(Reg.ReadStringDef('TopBarPosX', '1000000'));
					TopBarXButton := UpperCase(Reg.ReadStringDef('TopBarXButton', 'Show Menu'));
					TopBarTransparent := UpperCase(Reg.ReadStringDef('TopBarTransparent', 'Yes'));
					AvroUpdateCheck := UpperCase(Reg.ReadStringDef('AvroUpdateCheck', 'Yes'));
					AvroUpdateLastCheck := Reg.ReadDateDef('AvroUpdateLastCheck', Now);

					// Inteface Settings
					InterfaceSkin := Reg.ReadStringDef('InterfaceSkin', 'internalskin*');
					TopBarTransparencyLevel := Reg.ReadStringDef('TopBarTransparencyLevel', '80');
					TopBarTransparent := Reg.ReadStringDef('TopBarTransparent', 'YES');
					TrayHintShowTimes := Reg.ReadStringDef('TrayHintShowTimes', '0');
					TopHintShowTimes := Reg.ReadStringDef('TopHintShowTimes', '0');


					// Hotkey settings
					ModeSwitchKey := UpperCase(Reg.ReadStringDef('ModeSwitchKey', 'F12'));
					ToggleOutputModeKey := UpperCase(Reg.ReadStringDef('ToggleOutputModeKey', 'F12'));
					SpellerLauncherKey := UpperCase(Reg.ReadStringDef('SpellerLauncherKey', 'F7'));


					// Avro Mouse Settings
					AvroMouseChangeModeLocale := UpperCase(Reg.ReadStringDef('AvroMouseChangeModeLocale', 'No'));
					AvroMousePosX := UpperCase(Reg.ReadStringDef('AvroMousePosX', '0'));
					AvroMousePosY := UpperCase(Reg.ReadStringDef('AvroMousePosY', '0'));

					// Avro Phonetic Settings
					PhoneticAutoCorrect := UpperCase(Reg.ReadStringDef('PhoneticAutoCorrect', 'Yes'));
					ShowPrevWindow := UpperCase(Reg.ReadStringDef('ShowPrevWindow', 'Yes'));
					PhoneticMode := UpperCase(Reg.ReadStringDef('PhoneticMode', 'CHAR'));
					SaveCandidate := UpperCase(Reg.ReadStringDef('SaveCandidate', 'YES'));
					AddToPhoneticDict := UpperCase(Reg.ReadStringDef('AddToPhoneticDict', 'YES'));
					TabBrowsing := UpperCase(Reg.ReadStringDef('TabBrowsing', 'YES'));
					PipeToDot := UpperCase(Reg.ReadStringDef('PipeToDot', 'YES'));
					EnableJoNukta := UpperCase(Reg.ReadStringDef('EnableJoNukta', 'NO'));

					// Input Locale Settings
					ChangeInputLocale := UpperCase(Reg.ReadStringDef('ChangeInputLocale', 'Yes'));
					PrefferedLocale := UpperCase(Reg.ReadStringDef('PrefferedLocale', 'India'));

					// Tools Settings
					OldStyleReph := UpperCase(Reg.ReadStringDef('OldStyleReph', 'Yes'));
					VowelFormating := UpperCase(Reg.ReadStringDef('VowelFormating', 'Yes'));
					NumPadBangla := UpperCase(Reg.ReadStringDef('NumPadBangla', 'Yes'));
					FullOldStyleTyping := UpperCase(Reg.ReadStringDef('FullOldStyleTyping', 'No'));
					AutomaticallyFixChandra := UpperCase(Reg.ReadStringDef('AutomaticallyFixChandra', 'Yes'));

					// Keyboard Layout Viewer Settings
					DefaultLayout := Reg.ReadStringDef('DefaultLayout', 'avrophonetic*');
					ShowLayoutOnTop := UpperCase(Reg.ReadStringDef('ShowLayoutOnTop', 'Yes'));
					SavePosLayoutViewer := UpperCase(Reg.ReadStringDef('SavePosLayoutViewer', 'Yes'));
					LayoutViewerPosX := UpperCase(Reg.ReadStringDef('LayoutViewerPosX', '0'));
					LayoutViewerPosY := UpperCase(Reg.ReadStringDef('LayoutViewerPosY', '0'));
					LayoutViewerSize := UpperCase(Reg.ReadStringDef('LayoutViewerSize', '60%'));

					// Global Output settings
					OutputIsBijoy := UpperCase(Reg.ReadStringDef('OutputIsBijoy', 'No'));
					ShowOutputwarning := UpperCase(Reg.ReadStringDef('ShowOutputwarning', 'Yes'));

		 End;

		 Reg.Free;

End;

{ =============================================================================== }

Procedure SaveSettingsInRegistry;
Var
		 Reg: TMyRegistry;
Begin
		 Reg := TMyRegistry.create;
		 Reg.RootKey := HKEY_CURRENT_USER;

		 If Reg.OpenKey('Software\OmicronLab\Avro Keyboard', True) = True Then Begin
					Reg.WriteString('AppPath', ExtractFileDir(Application.ExeName));
					Reg.WriteString('AppExeName', ExtractFileName(Application.ExeName));


					Reg.WriteString('DontShowComplexLNotification', DontShowComplexLNotification);
					Reg.WriteString('DontShowStartupWizard', DontShowStartupWizard);


					// General settings
					Reg.WriteString('StartWithWindows', StartWithWindows);
					Reg.WriteString('ShowSplash', ShowSplash);
					Reg.WriteString('DefaultUIMode', DefaultUIMode);
					Reg.WriteString('LastUIMode', LastUIMode);
					Reg.WriteString('TopBarPosX', TopBarPosX);
					Reg.WriteString('TopBarXButton', TopBarXButton);
					Reg.WriteString('TopBarTransparent', TopBarTransparent);


					// Inteface Settings
					Reg.WriteString('InterfaceSkin', InterfaceSkin);
					Reg.WriteString('TopBarTransparencyLevel', TopBarTransparencyLevel);
					Reg.WriteString('TopBarTransparent', TopBarTransparent);
					Reg.WriteString('TrayHintShowTimes', TrayHintShowTimes);
					Reg.WriteString('TopHintShowTimes', TopHintShowTimes);


					// Webbuddy Options
					Reg.WriteString('AvroUpdateCheck', AvroUpdateCheck);
					Reg.WriteDateTime('AvroUpdateLastCheck', AvroUpdateLastCheck);

					// Hotkeys settings
					Reg.WriteString('ModeSwitchKey', ModeSwitchKey);
					Reg.WriteString('ToggleOutputModeKey', ToggleOutputModeKey);
					Reg.WriteString('SpellerLauncherKey', SpellerLauncherKey);

					// Avro Mouse Settings
					Reg.WriteString('AvroMouseChangeModeLocale', AvroMouseChangeModeLocale);
					Reg.WriteString('AvroMousePosX', AvroMousePosX);
					Reg.WriteString('AvroMousePosY', AvroMousePosY);

					// Avro Phonetic Settings
					Reg.WriteString('PhoneticAutoCorrect', PhoneticAutoCorrect);
					Reg.WriteString('ShowPrevWindow', ShowPrevWindow);
					Reg.WriteString('PhoneticMode', PhoneticMode);
					Reg.WriteString('SaveCandidate', SaveCandidate);
					Reg.WriteString('AddToPhoneticDict', AddToPhoneticDict);
					Reg.WriteString('TabBrowsing', TabBrowsing);
					Reg.WriteString('PipeToDot', PipeToDot);
					Reg.WriteString('EnableJoNukta', EnableJoNukta);

					// Input Locale Settings
					Reg.WriteString('ChangeInputLocale', ChangeInputLocale);
					Reg.WriteString('PrefferedLocale', PrefferedLocale);


					// Tools Settings
					Reg.WriteString('OldStyleReph', OldStyleReph);
					Reg.WriteString('VowelFormating', VowelFormating);
					Reg.WriteString('NumPadBangla', NumPadBangla);
					Reg.WriteString('AutomaticallyFixChandra', AutomaticallyFixChandra);
					Reg.WriteString('FullOldStyleTyping', FullOldStyleTyping);

					// Keyboard Layout Viewer Settings
					Reg.WriteString('DefaultLayout', DefaultLayout);
					Reg.WriteString('ShowLayoutOnTop', ShowLayoutOnTop);
					Reg.WriteString('SavePosLayoutViewer', SavePosLayoutViewer);
					Reg.WriteString('LayoutViewerPosX', LayoutViewerPosX);
					Reg.WriteString('LayoutViewerPosY', LayoutViewerPosY);
					Reg.WriteString('LayoutViewerSize', LayoutViewerSize);

					// Global Output settings
					Reg.WriteString('OutputIsBijoy', OutputIsBijoy);
					Reg.WriteString('ShowOutputwarning', ShowOutputwarning);

		 End;

		 Reg.CloseKey;
		 Reg.RootKey := HKEY_CURRENT_USER;

		 If Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', True) = True Then Begin
					If StartWithWindows = 'NO' Then
							 Reg.DeleteValue('Avro Keyboard')
					Else
							 Reg.WriteString('Avro Keyboard', Application.ExeName);
		 End;

		 Reg.Free;

End;

{ =============================================================================== }

Procedure SaveUISettings;
Begin
		 If IsFormVisible('TopBar') = True Then Begin
					LastUIMode := 'TOP BAR';
					TopBarPosX := IntToStr(TopBar.Left);
		 End
		 Else Begin
					LastUIMode := 'ICON';
		 End;

		 DefaultLayout := AvroMainForm1.GetMyCurrentLayout;

		 SaveSettings;
End;

Procedure LoadSettings;
Begin

		 {$IFDEF PortableOn}

		 LoadSettingsFromFile;

		 {$ELSE}

		 LoadSettingsFromRegistry;

		 {$ENDIF}

		 ValidateSettings;
End;

{ =============================================================================== }

Procedure ValidateSettings;
Begin
		 // General settings
		 If Not((StartWithWindows = 'YES') Or (StartWithWindows = 'NO')) Then
					StartWithWindows := 'YES';
		 If Not((DefaultUIMode = 'TOP BAR') Or (DefaultUIMode = 'ICON') Or (DefaultUIMode = 'LASTUI')) Then
					DefaultUIMode := 'LASTUI';
		 If Not((LastUIMode = 'ICON') Or (LastUIMode = 'TOP BAR')) Then
					LastUIMode := 'TOP BAR';
		 If Not(StrToInt(TopBarPosX) > 0) Then
					TopBarPosX := '1000000';
		 If Not((TopBarXButton = 'MINIMIZE') Or (TopBarXButton = 'EXIT') Or (TopBarXButton = 'SHOW MENU')) Then
					TopBarXButton := 'SHOW MENU';
		 If Not((TopBarTransparent = 'YES') Or (TopBarTransparent = 'NO')) Then
					TopBarTransparent := 'YES';

		 // Keyboard Mode settings
		 If Not((ModeSwitchKey = 'F1') Or (ModeSwitchKey = 'F2') Or (ModeSwitchKey = 'F3') Or (ModeSwitchKey = 'F4') Or (ModeSwitchKey = 'F5') Or (ModeSwitchKey = 'F6') Or (ModeSwitchKey = 'F7') Or (ModeSwitchKey = 'F8') Or (ModeSwitchKey = 'F9') Or
						(ModeSwitchKey = 'F10') Or (ModeSwitchKey = 'F11') Or (ModeSwitchKey = 'F12') Or (ModeSwitchKey = 'CTRL+SPACE')) Then
					ModeSwitchKey := 'F12';
		 If Not((ToggleOutputModeKey = 'F1') Or (ToggleOutputModeKey = 'F2') Or (ToggleOutputModeKey = 'F3') Or (ToggleOutputModeKey = 'F4') Or (ToggleOutputModeKey = 'F5') Or (ToggleOutputModeKey = 'F6') Or (ToggleOutputModeKey = 'F7') Or
						(ToggleOutputModeKey = 'F8') Or (ToggleOutputModeKey = 'F9') Or (ToggleOutputModeKey = 'F10') Or (ToggleOutputModeKey = 'F11') Or (ToggleOutputModeKey = 'F12')) Then
					ToggleOutputModeKey := 'F12';
		 If Not((SpellerLauncherKey = 'F1') Or (SpellerLauncherKey = 'F2') Or (SpellerLauncherKey = 'F3') Or (SpellerLauncherKey = 'F4') Or (SpellerLauncherKey = 'F5') Or (SpellerLauncherKey = 'F6') Or (SpellerLauncherKey = 'F7') Or
						(SpellerLauncherKey = 'F8') Or (SpellerLauncherKey = 'F9') Or (SpellerLauncherKey = 'F10') Or (SpellerLauncherKey = 'F11') Or (SpellerLauncherKey = 'F12')) Then
					SpellerLauncherKey := 'F12';


		 // Avro Mouse Settings
		 If Not((AvroMouseChangeModeLocale = 'YES') Or (AvroMouseChangeModeLocale = 'NO')) Then
					AvroMouseChangeModeLocale := 'YES';
		 If Not(StrToInt(AvroMousePosX) > 0) Then
					AvroMousePosX := '0';
		 If Not(StrToInt(AvroMousePosY) > 0) Then
					AvroMousePosY := '0';

		 // Avro Phonetic Settings
		 If Not((PhoneticAutoCorrect = 'YES') Or (PhoneticAutoCorrect = 'NO')) Then
					PhoneticAutoCorrect := 'YES';
		 If Not((ShowPrevWindow = 'YES') Or (ShowPrevWindow = 'NO')) Then
					ShowPrevWindow := 'YES';
		 If Not((TabBrowsing = 'YES') Or (TabBrowsing = 'NO')) Then
					TabBrowsing := 'YES';
		 If Not((PipeToDot = 'YES') Or (PipeToDot = 'NO')) Then
					PipeToDot := 'YES';
		 If Not((EnableJoNukta = 'YES') Or (EnableJoNukta = 'NO')) Then
					EnableJoNukta := 'NO';

		 // Input Locale Settings
		 If Not((ChangeInputLocale = 'YES') Or (ChangeInputLocale = 'NO')) Then
					ChangeInputLocale := 'YES';
		 If Not((PrefferedLocale = 'BANGLADESH') Or (PrefferedLocale = 'INDIA') Or (PrefferedLocale = 'ASSAMESE')) Then
					PrefferedLocale := 'INDIA';

		 // Tools Settings
		 If Not((OldStyleReph = 'YES') Or (OldStyleReph = 'NO')) Then
					OldStyleReph := 'YES';
		 If Not((VowelFormating = 'YES') Or (VowelFormating = 'NO')) Then
					VowelFormating := 'YES';
		 If Not((NumPadBangla = 'YES') Or (NumPadBangla = 'NO')) Then
					NumPadBangla := 'YES';
		 If Not((FullOldStyleTyping = 'YES') Or (FullOldStyleTyping = 'NO')) Then
					FullOldStyleTyping := 'No';
		 If Not((AutomaticallyFixChandra = 'YES') Or (AutomaticallyFixChandra = 'NO')) Then
					AutomaticallyFixChandra := 'YES';

		 // Keyboard Layout Viewer Settings
		 If Not((ShowLayoutOnTop = 'YES') Or (ShowLayoutOnTop = 'NO')) Then
					ShowLayoutOnTop := 'YES';
		 If Not((SavePosLayoutViewer = 'YES') Or (SavePosLayoutViewer = 'NO')) Then
					SavePosLayoutViewer := 'YES';
		 If Not(StrToInt(LayoutViewerPosX) > 0) Then
					LayoutViewerPosX := '0';
		 If Not(StrToInt(LayoutViewerPosY) > 0) Then
					LayoutViewerPosX := '0';
		 // If Not ((StrToInt(LayoutViewerSize) > 50) And (RightStr(LayoutViewerSize, 1) = '%')) Then LayoutViewerSize := '60%';


		 // Global Output settings
		 If Not((OutputIsBijoy = 'YES') Or (OutputIsBijoy = 'NO')) Then
					OutputIsBijoy := 'NO';
		 If Not((ShowOutputwarning = 'YES') Or (ShowOutputwarning = 'NO')) Then
					ShowOutputwarning := 'YES';

		 { Done : Validate locale settings here }
		 If IsWinVistaOrLater = True Then Begin
					If (IsBangladeshLocaleInstalled = False) Then Begin
							 If (PrefferedLocale = 'BANGLADESH') Then
										PrefferedLocale := 'INDIA';
					End;

					If (IsAssameseLocaleInstalled = False) Then Begin
							 If (PrefferedLocale = 'ASSAMESE') Then Begin
										PrefferedLocale := 'INDIA';
							 End;

					End;
		 End;
End;

{ =============================================================================== }

Procedure SaveSettings;
Begin

		 {$IFDEF PortableOn}

		 SaveSettingsInXML;

		 {$ELSE}

		 SaveSettingsInRegistry;

		 {$ENDIF}

End;

{ =============================================================================== }

End.
