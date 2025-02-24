object frmSkinCreator: TfrmSkinCreator
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Skin designer for Avro Keyboard'
  ClientHeight = 471
  ClientWidth = 517
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Icon.Data = {
    0000010001001010000001002000680400001600000028000000100000002000
    0000010020000000000040040000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000002121
    21121C1C1C4C1F1F1F501F1F1F501F1F1F501F1F1F501F1F1F501F1F1F501F1F
    1F501F1F1F501F1F1F501F1F1F501F1F1F501F1F1F5015151546111111127575
    75A9D2D2D2FFD5D5D5FFD5D5D5FFD5D5D5FFD5D5D5FFD5D5D5FFD5D5D5FFD5D5
    D5FFD5D5D5FFD5D5D5FFD5D5D5FFD5D5D5FFD5D5D5FFCBCBCBFD32323276A3A3
    A3D9C9C9C9FFBDB6AFFFCEC7BFFFE4DCD3FFE9E1D8FFE9E1D8FFE9E1D8FFE9E1
    D8FFE9E1D8FFE9E1D8FFE9E1D8FFE8E0D8FFE6E2DDFFE0E0E0FF585858A19F9F
    9FDAA19F9DFFE0CCB6FFAD9D8BFFBE9871FFD3AB81FFC19E79FFD3A97DFFD3A9
    7DFFCBA782FFC29B73FFCFA87FFFDECFC0FFC4B3A1FFDDDDDDFF565656A29696
    96DA959290FFD2AC8AFFFDFDFCFFC5BCB2FFE5DBD2FFB29172FFC7976BFFC797
    6BFFE2CAB4FFBEB0A3FFEEE7E1FFF0E8E2FFD2AE8DFFD6D6D6FF505050A28D8D
    8DDA908C89FFBB865AFFDCC1ACFFFFFFFFFFFFFFFFFFAA8465FFBB8559FFBB85
    59FFDDC2ACFFFFFFFFFFFCFBFBFFB38D6DFFC99E7BFFCECECEFF4A4A4AA28484
    84DA8A8684FFBB8A65FFEADED5FFFFFFFFFFFFFFFFFFA57A5AFFAF7346FFAF73
    46FFD7B9A2FFFFFFFFFFFFFFFFFFAF9C8EFFB78B6AFFCACACAFF454545A27F7F
    7FDA8C8885FFC2997CFFC4B8AFFFC1B4AAFFBCABA0FF956340FFA36134FFA361
    34FFB88B6CFFBCAB9FFFBCAB9FFFB8A598FFB0805FFFCCCCCCFF3F3F3FA27C7C
    7CDA8B8784FFBA8A6CFFEADCD3FFFFFFFFFFFFFFFFFFAD8E7BFFB78565FFAE77
    53FFD4B6A3FFFFFFFFFFFCFCFCFFB38A70FFB07A57FFCDCDCDFF3C3C3CA27B7B
    7BDA8C8784FFBD9075FFEBDED6FFFFFFFFFFFFFFFFFFB49A8BFFC8A28CFFC69F
    89FFE2CEC2FFFFFFFFFFFEFEFEFFA08C80FFB78A6FFFCFCFCFFF3B3B3BA27C7C
    7CDA8E8885FFCDAC9AFFFDFDFCFFE9DBD3FFEFE4DEFFC4B0A4FFD3B6A5FFD2B3
    A2FFE6D5CCFFDFCABEFFF0E6E0FFF0EEEDFF90705EFFCDCDCDFF3A3A3AA27F7F
    7FDA908D8BFFB38469FFC29B84FFBC9077FFBC9077FFBD9278FFBC9077FFBB8F
    76FFBC9078FFBB8D74FFBA8C73FFC9A591FF9D7159FFCDCDCDFF3A3A3AA27F7F
    7FD6D0D0D0FF908E8DFF908E8DFF908E8DFF908E8DFF908E8DFF908E8DFF908E
    8DFF908E8DFF908E8DFF908E8DFF92908EFFA2A1A1FFE5E5E5FF3838389D6363
    637A9B9B9BF3A1A1A1F5A1A1A1F5A1A1A1F5A1A1A1F5A1A1A1F5A1A1A1F5A1A1
    A1F5A1A1A1F5A1A1A1F5A1A1A1F5A1A1A1F5A1A1A1F5898989E92D2D2D470000
    0000494949034A4A4A044A4A4A044A4A4A044A4A4A044A4A4A044A4A4A044A4A
    4A044A4A4A044A4A4A044A4A4A044A4A4A04494949043939390300000000FFFF
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000080010000}
  OnCreate = FormCreate
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 63
    Width = 497
    Height = 362
    TabOrder = 1
    object Label3: TLabel
      Left = 18
      Top = 11
      Width = 113
      Height = 13
      Caption = 'Edit Skin Properties:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 34
      Top = 33
      Width = 53
      Height = 13
      Caption = 'Skin Name:'
    end
    object Label5: TLabel
      Left = 34
      Top = 58
      Width = 39
      Height = 13
      Caption = 'Version:'
    end
    object Label6: TLabel
      Left = 34
      Top = 84
      Width = 56
      Height = 13
      Caption = 'Your Name:'
    end
    object Label7: TLabel
      Left = 34
      Top = 111
      Width = 49
      Height = 13
      Caption = 'Comment:'
    end
    object Label8: TLabel
      Left = 20
      Top = 177
      Width = 273
      Height = 13
      Caption = 'Select Buttons You Want to Include in "Top Bar":'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object EditSkinName: TEdit
      Left = 93
      Top = 30
      Width = 239
      Height = 21
      TabOrder = 0
    end
    object EditSkinVer: TEdit
      Left = 93
      Top = 55
      Width = 144
      Height = 21
      TabOrder = 1
      Text = '1.0'
    end
    object EditDesignerName: TEdit
      Left = 93
      Top = 81
      Width = 239
      Height = 21
      TabOrder = 2
    end
    object EditComment: TMemo
      Left = 93
      Top = 108
      Width = 239
      Height = 42
      ScrollBars = ssVertical
      TabOrder = 3
    end
    object CheckAvroIcon: TCheckBox
      Left = 34
      Top = 196
      Width = 97
      Height = 17
      Caption = 'Avro Icon'
      Checked = True
      Enabled = False
      State = cbChecked
      TabOrder = 4
    end
    object CheckKM: TCheckBox
      Left = 33
      Top = 220
      Width = 97
      Height = 17
      Caption = 'Keyboard Mode'
      Checked = True
      Enabled = False
      State = cbChecked
      TabOrder = 5
    end
    object CheckKL: TCheckBox
      Left = 33
      Top = 243
      Width = 97
      Height = 17
      Caption = 'Keyboard Layout'
      Checked = True
      State = cbChecked
      TabOrder = 6
    end
    object CheckLayoutViewer: TCheckBox
      Left = 149
      Top = 196
      Width = 97
      Height = 17
      Caption = 'Layout Viewer'
      Checked = True
      State = cbChecked
      TabOrder = 7
    end
    object CheckMouse: TCheckBox
      Left = 149
      Top = 220
      Width = 97
      Height = 17
      Caption = 'Avro Mouse'
      Checked = True
      State = cbChecked
      TabOrder = 8
    end
    object CheckTools: TCheckBox
      Left = 149
      Top = 243
      Width = 97
      Height = 17
      Caption = 'Tools'
      Checked = True
      State = cbChecked
      TabOrder = 9
    end
    object CheckWeb: TCheckBox
      Left = 252
      Top = 196
      Width = 97
      Height = 17
      Caption = 'Web Options'
      Checked = True
      State = cbChecked
      TabOrder = 10
    end
    object CheckHelp: TCheckBox
      Left = 252
      Top = 220
      Width = 97
      Height = 17
      Caption = 'Help'
      Checked = True
      State = cbChecked
      TabOrder = 11
    end
    object CheckExit: TCheckBox
      Left = 252
      Top = 243
      Width = 97
      Height = 17
      Caption = 'Exit'
      Checked = True
      Enabled = False
      State = cbChecked
      TabOrder = 12
    end
    object Panel3: TPanel
      Left = 17
      Top = 272
      Width = 464
      Height = 77
      ParentBackground = False
      TabOrder = 13
      object Image1: TImage
        Left = 10
        Top = 13
        Width = 12
        Height = 12
        AutoSize = True
        Picture.Data = {
          0954474946496D6167654749463839610C000C00B30000EFF4F5DBE6E9D1DFE3
          ACC5CD5F8E9DE5EDEF557F8CC5D6DCFFFFFF496D790000000000000000000000
          0000000000000021F90400000000002C000000000C000C0083EFF4F5DBE6E9D1
          DFE3ACC5CD5F8E9DE5EDEF557F8CC5D6DCFFFFFF496D79000000000000000000
          000000000000000000041F30C949ABBD01A142EC00865108D7241C65121446F9
          B5E581A6B424D7B815010021F90400000000002C000000000C000C0083EFF4F5
          DBE6E9D1DFE3ACC5CD5F8E9DE5EDEF557F8CC5D6DCFFFFFF496D790000000000
          00000000000000000000000000041F30C949ABBD01A142EC00865108D7241C65
          121446F9B5E581A6B424D7B815010021F90400000000002C000000000C000C00
          83EFF4F5DBE6E9D1DFE3ACC5CD5F8E9DE5EDEF557F8CC5D6DCFFFFFF496D7900
          0000000000000000000000000000000000041F30C949ABBD01A142EC00865108
          D7241C65121446F9B5E581A6B424D7B815010021F90400000000002C00000000
          0C000C0083EFF4F5DBE6E9D1DFE3ACC5CD5F8E9DE5EDEF557F8CC5D6DCFFFFFF
          496D79000000000000000000000000000000000000041F30C949ABBD01A142EC
          00865108D7241C65121446F9B5E581A6B424D7B81501003B}
      end
      object Label13: TLabel
        Left = 27
        Top = 12
        Width = 23
        Height = 13
        Caption = 'Hint'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label14: TLabel
        Left = 12
        Top = 31
        Width = 437
        Height = 97
        AutoSize = False
        Caption = 
          'Not all the buttons are compulsory in Avro Keyboard'#39's Top Bar. Y' +
          'ou can choose which one to add or remove from your skin. Choosin' +
          'g more buttons makes accessing to different features easier, whi' +
          'le a smaller skin with fewer buttons occupies less area on the s' +
          'creen.'
        WordWrap = True
      end
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 63
    Width = 497
    Height = 362
    TabOrder = 6
    object ScrollBoxImageAdd: TScrollBox
      Left = 50
      Top = 16
      Width = 409
      Height = 337
      HorzScrollBar.Smooth = True
      HorzScrollBar.Tracking = True
      VertScrollBar.Smooth = True
      VertScrollBar.Tracking = True
      BorderStyle = bsNone
      TabOrder = 0
      inline FrameImageAdd1: TFrameImageAdd
        Left = 0
        Top = 0
        Width = 377
        Height = 1250
        HorzScrollBar.Visible = False
        VertScrollBar.Visible = False
        Color = clWhite
        ParentBackground = False
        ParentColor = False
        TabOrder = 0
        ExplicitWidth = 377
        inherited PanelTopBar: TPanel
          StyleElements = [seFont, seClient, seBorder]
          inherited Label1: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Label2: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited ImagePath_TopBar: TEdit
            StyleElements = [seFont, seClient, seBorder]
          end
        end
        inherited PanelAvroIcon: TPanel
          StyleElements = [seFont, seClient, seBorder]
          inherited Label3: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Label4: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Label5: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Label6: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited AvroIcon: TEdit
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited AvroIconOver: TEdit
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited AvroIconDown: TEdit
            StyleElements = [seFont, seClient, seBorder]
          end
        end
        inherited PanelKM_E: TPanel
          StyleElements = [seFont, seClient, seBorder]
          inherited Label7: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Label8: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Label9: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Label10: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited KMSys: TEdit
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited KMSysOver: TEdit
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited KMSysDown: TEdit
            StyleElements = [seFont, seClient, seBorder]
          end
        end
        inherited PanelKM_B: TPanel
          StyleElements = [seFont, seClient, seBorder]
          inherited Label11: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Label12: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Label13: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Label14: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited KMBangla: TEdit
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited KMBanglaOver: TEdit
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited KMBanglaDown: TEdit
            StyleElements = [seFont, seClient, seBorder]
          end
        end
        inherited PanelKL: TPanel
          StyleElements = [seFont, seClient, seBorder]
          inherited Label15: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Label16: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Label17: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Label18: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited KL: TEdit
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited KLOver: TEdit
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited KLDown: TEdit
            StyleElements = [seFont, seClient, seBorder]
          end
        end
        inherited PanelLV: TPanel
          StyleElements = [seFont, seClient, seBorder]
          inherited Label19: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Label20: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Label21: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Label22: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited LayoutV: TEdit
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited LayoutVOver: TEdit
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited LayoutVDown: TEdit
            StyleElements = [seFont, seClient, seBorder]
          end
        end
        inherited PanelMouse: TPanel
          StyleElements = [seFont, seClient, seBorder]
          inherited Label23: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Label24: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Label25: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Label26: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited AvroMouse: TEdit
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited AvroMouseOver: TEdit
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited AvroMouseDown: TEdit
            StyleElements = [seFont, seClient, seBorder]
          end
        end
        inherited PanelTools: TPanel
          StyleElements = [seFont, seClient, seBorder]
          inherited Label27: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Label28: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Label29: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Label30: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Tools: TEdit
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited ToolsOver: TEdit
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited ToolsDown: TEdit
            StyleElements = [seFont, seClient, seBorder]
          end
        end
        inherited PanelHelp: TPanel
          StyleElements = [seFont, seClient, seBorder]
          inherited Label31: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Label32: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Label33: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Label34: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Help: TEdit
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited HelpOver: TEdit
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited HelpDown: TEdit
            StyleElements = [seFont, seClient, seBorder]
          end
        end
        inherited PanelWeb: TPanel
          StyleElements = [seFont, seClient, seBorder]
          inherited Label39: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Label40: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Label41: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Label42: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Web: TEdit
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited WebOver: TEdit
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited WebDown: TEdit
            StyleElements = [seFont, seClient, seBorder]
          end
        end
        inherited PanelExit: TPanel
          StyleElements = [seFont, seClient, seBorder]
          inherited Label35: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Label36: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Label37: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Label38: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Exit: TEdit
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited ExitOver: TEdit
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited ExitDown: TEdit
            StyleElements = [seFont, seClient, seBorder]
          end
        end
        inherited PanelPreview: TPanel
          StyleElements = [seFont, seClient, seBorder]
          inherited Label43: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Preview: TEdit
            StyleElements = [seFont, seClient, seBorder]
          end
        end
      end
    end
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 63
    Width = 497
    Height = 362
    TabOrder = 7
    object Label2: TLabel
      Left = 198
      Top = 339
      Width = 268
      Height = 13
      Caption = 'Clicking on '#39'< Previous'#39' button will reset all adjustments!'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    inline FrameDrag1: TFrameDrag
      Left = 18
      Top = 30
      Width = 455
      Height = 308
      TabOrder = 0
      ExplicitLeft = 18
      ExplicitTop = 30
      inherited Label1: TLabel
        Left = 119
        Top = 259
        StyleElements = [seFont, seClient, seBorder]
        ExplicitLeft = 119
        ExplicitTop = 259
      end
      inherited Label2: TLabel
        Top = 259
        StyleElements = [seFont, seClient, seBorder]
        ExplicitTop = 259
      end
      inherited Label3: TLabel
        Width = 394
        Height = 13
        StyleElements = [seFont, seClient, seBorder]
        ExplicitWidth = 394
        ExplicitHeight = 13
      end
      inherited ScrollBox1: TScrollBox
        inherited Panel1: TPanel
          StyleElements = [seFont, seClient, seBorder]
        end
      end
      inherited XPos: TEdit
        StyleElements = [seFont, seClient, seBorder]
      end
      inherited YPos: TEdit
        StyleElements = [seFont, seClient, seBorder]
      end
    end
  end
  object GroupBox4: TGroupBox
    Left = 8
    Top = 63
    Width = 497
    Height = 362
    TabOrder = 8
    object Label9: TLabel
      Left = 32
      Top = 32
      Width = 99
      Height = 13
      Caption = 'Almost complete!'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label10: TLabel
      Left = 81
      Top = 109
      Width = 219
      Height = 13
      Caption = 'Click on the Save Skin button to Save the skin'
    end
    object ButtonSaveSkin: TButton
      Left = 137
      Top = 128
      Width = 225
      Height = 51
      Caption = 'Save Skin...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = ButtonSaveSkinClick
    end
    object Panel2: TPanel
      Left = 20
      Top = 266
      Width = 461
      Height = 64
      Color = clWhite
      ParentBackground = False
      TabOrder = 1
      object Label11: TLabel
        Left = 16
        Top = 8
        Width = 421
        Height = 25
        AutoSize = False
        Caption = 
          'You can Share your skin with Avro Keyboard users if you wish. Cl' +
          'ick on the following link to submit this skin to OmicronLab:'
        WordWrap = True
      end
      object LabelShareLink: TLabel
        Left = 189
        Top = 37
        Width = 56
        Height = 16
        Cursor = crHandPoint
        Caption = 'Share it!'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold, fsUnderline]
        ParentFont = False
        OnClick = LabelShareLinkClick
      end
    end
  end
  object Panel1: TPanel
    Left = -2
    Top = -8
    Width = 595
    Height = 65
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object Label1: TLabel
      Left = 10
      Top = 21
      Width = 273
      Height = 25
      Caption = 'Welcome to Skin Designer'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object ButtonHelp: TButton
      Left = 430
      Top = 21
      Width = 75
      Height = 25
      Caption = 'Help'
      TabOrder = 0
      Visible = False
      OnClick = ButtonHelpClick
    end
  end
  object ButtonAbout: TButton
    Left = 8
    Top = 431
    Width = 75
    Height = 25
    Caption = 'About...'
    TabOrder = 2
    OnClick = ButtonAboutClick
  end
  object ButtonPrev: TButton
    Left = 237
    Top = 431
    Width = 75
    Height = 25
    Caption = '< Previous'
    Enabled = False
    TabOrder = 3
    OnClick = ButtonPrevClick
  end
  object ButtonNext: TButton
    Left = 318
    Top = 431
    Width = 75
    Height = 25
    Caption = 'Next >'
    TabOrder = 4
    OnClick = ButtonNextClick
  end
  object ButtonExit: TButton
    Left = 428
    Top = 431
    Width = 75
    Height = 25
    Caption = 'Exit'
    TabOrder = 5
    OnClick = ButtonExitClick
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'avroskin'
    Filter = 'Skin Files (*.avroskin)|*.avroskin'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofNoReadOnlyReturn, ofNoNetworkButton, ofEnableSizing, ofForceShowHidden]
    Title = 'Save Avro Keyboard Skin'
    Left = 144
    Top = 432
  end
end
