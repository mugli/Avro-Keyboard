object frmSpell: TfrmSpell
  Left = 0
  Top = 0
  Margins.Left = 5
  Margins.Top = 5
  Margins.Right = 5
  Margins.Bottom = 5
  Caption = 'Untitled - Avro Pad'
  ClientHeight = 384
  ClientWidth = 746
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Tahoma'
  Font.Style = []
  Icon.Data = {
    0000010001001010000001002000680400001600000028000000100000002000
    0000010020000000000000040000120B0000120B000000000000000000000000
    00000000000000000001000000080000001B0000003400000049000000570000
    005900000051000000410000002B000000130000000400000000000000000000
    0000000000010000000D0000002C5E2112788F341BB7A93D22D6B34225E09436
    1ECB762B17B8290F088D0000006B000000440000001C00000005000000000000
    00010000000B6123134BAF4023C6DD613DFCE97450FFED7C58FFEC7955FFE974
    50FFE36945FFD15433F7772B18C00000007A0000004C0000001B000000040000
    00056E26143ECC5130E5F18864FFF8936EFFFCBFA0FFFDC8B0FFF9916CFFF891
    6DFFF38662FFEC7854FFE16441FF8D341DCD0000007A00000043000000126624
    1319CB5533D2F49570FFFDA37DFFF7A483FFFDDDC4FFFFE3CDFFFAA687FFF994
    6FFFFA9571FFF68C68FFEE7C58FFE16441FF6D2715BA000000690000002AB640
    2270EE9C77FFFDB28EFFF8A07BFFFACFBAFFFFEFDEFFFFE7D1FFFCC7AFFFF996
    70FFF99773FFFA9671FFF68C68FFEB7854FFD15432F6270E088C00000040CF5B
    3AC0FAC19BFFFCAF89FFF6A887FFFDEDE5FFFFF7EDFFFFECD9FFFEDFCAFFFAA4
    82FFF99974FFF99773FFFA9571FFF38662FFE36744FF762A17B70000004FDF7B
    57F0FCCCA5FFFAB18AFFFADACDFFFFFCFAFFF7CEBDFFFDE7D9FFFFF0E1FFFCC5
    ABFFFA9B75FFF99A76FFF99773FFF8906CFFE9724EFF8E341DC700000057E796
    72F3FFDBB3FFFBCEB6FFFEF8F6FFFACDB3FFF6A880FFF5C8B7FFFFF9F0FFFEE3
    D2FFFAA784FFFA9C77FFF99975FFF99571FFED7955FFAE4024DC00000054E383
    60F5FEE2BBFFF6C2A6FFFBCEADFFFBC59DFFFDC49DFFF4AE8DFFFCE8DFFFFFF9
    EFFFFDCCB4FFFA9C76FFFA9B77FFF99672FFED7A57FFA23C21CF00000046D966
    43D1FDEAC3FFFEDCB5FFFDD6AEFFFDD4ADFFFCCDA7FFFCC099FFF3AE92FFFCEC
    E4FFFFF5ECFFFBB190FFFA9A75FFFA9975FFE7724EFF89311AB000000031D04A
    288AF4CBA5FFFFF6D0FFFEE3BBFFFDDDB6FFFDD3ADFFFDCAA5FFFAB78FFFF6B7
    9AFFFCEEE5FFFEE5D7FFFBA17CFFF7946FFFDB5D3AFC511D106E00000019CD44
    231CDE734FF0FEFBD5FFFFF7CFFFFEE3BCFFFDD7B1FFFCCDA7FFFCC39DFFFBB5
    8EFFFAB18FFFFDD8C5FFFEC8B0FFF08560FFAE3F23C30000002A000000080000
    0000CE44234CE79D79F5FEFCD4FFFFF8D0FFFEDDB7FFFCCEA7FFFCC19CFFFBB6
    92FFFCAE89FFFCAF8AFFF49571FFCC5230E34A1A0E3D0000000C000000010000
    000000000000CE45234BDD724EDBF4CBA4FFFDEAC3FFFDDFB8FFFCD5AEFFFCD0
    AAFFF8BF99FFEB946FFFC34E2DC17B2B173B0000000900000001000000000000
    00000000000000000000CC44231ACE492882D76644BFDF7955EFDE7753F2DE79
    55E9CC5A38B3AE3C1F5E0000000C00000003000000000000000000000000C003
    0000800100000000000000000000000000000000000000000000000000000000
    00000000000000000000000000000000000080000000C0010000E0070000}
  Menu = MainMenu1
  Visible = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 144
  DesignSize = (
    746
    384)
  TextHeight = 21
  object MEMO: TMemo
    Left = 2
    Top = 0
    Width = 732
    Height = 362
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Siyam Rupali'
    Font.Style = []
    HideSelection = False
    MaxLength = 2147483632
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
    WantTabs = True
    OnChange = MEMOChange
  end
  object Progress: TProgressBar
    Left = 6
    Top = 366
    Width = 722
    Height = 15
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 1
    Visible = False
  end
  object MainMenu1: TMainMenu
    Left = 280
    Top = 8
    object File1: TMenuItem
      Caption = 'File'
      object New1: TMenuItem
        Caption = 'New'
        ShortCut = 16462
        OnClick = New1Click
      end
      object Open1: TMenuItem
        Caption = 'Open...'
        ShortCut = 16463
        OnClick = Open1Click
      end
      object Save1: TMenuItem
        Caption = 'Save'
        ShortCut = 16467
        OnClick = Save1Click
      end
      object Saveas1: TMenuItem
        Caption = 'Save As...'
        OnClick = Saveas1Click
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object Close1: TMenuItem
        Caption = 'Close'
        OnClick = Close1Click
      end
    end
    object Edit1: TMenuItem
      Caption = 'Edit'
      object SelectAll1: TMenuItem
        Caption = 'Select All'
        ShortCut = 16449
        OnClick = SelectAll1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Cut1: TMenuItem
        Caption = 'Cut'
        OnClick = Cut1Click
      end
      object Copy1: TMenuItem
        Caption = 'Copy'
        OnClick = Copy1Click
      end
      object Paste1: TMenuItem
        Caption = 'Paste'
        OnClick = Paste1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Clearall1: TMenuItem
        Caption = 'Clear all'
        ShortCut = 8238
        OnClick = Clearall1Click
      end
    end
    object Format1: TMenuItem
      Caption = 'Format'
      object WordWrap1: TMenuItem
        Caption = 'Word Wrap'
        Checked = True
        OnClick = WordWrap1Click
      end
      object Font1: TMenuItem
        Caption = 'Font...'
        OnClick = Font1Click
      end
    end
    object Spellcheck1: TMenuItem
      Caption = 'Spell check'
      object Startspellchek1: TMenuItem
        Caption = 'Spell check now'
        Default = True
        ShortCut = 118
        OnClick = Startspellchek1Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Spellcheckoptions1: TMenuItem
        Caption = 'Spell check options...'
        OnClick = Spellcheckoptions1Click
      end
    end
    object N5: TMenuItem
      Caption = '?'
      OnClick = N5Click
    end
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'txt'
    Filter = 'Text Files (*.txt)|*.TXT|All Files|*'
    Options = [ofHideReadOnly, ofExtensionDifferent, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 192
    Top = 8
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'txt'
    Filter = 
      'Text File (Unicode encoding)|*.TXT|Text File (Unicode big endian' +
      ' encoding)|*.TXT|Text File (UTF-8 encoding)|*.TXT'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofExtensionDifferent, ofEnableSizing]
    Left = 232
    Top = 8
  end
  object FontDialog: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Siyam Rupali'
    Font.Style = []
    Options = []
    Left = 152
    Top = 8
  end
  object AppEvents: TApplicationEvents
    OnSettingChange = AppEventsSettingChange
    Left = 636
    Top = 252
  end
end
