object frmSpellPopUp: TfrmSpellPopUp
  Left = 0
  Top = 0
  Margins.Left = 5
  Margins.Top = 5
  Margins.Right = 5
  Margins.Bottom = 5
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Avro Spell Check'
  ClientHeight = 432
  ClientWidth = 641
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
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 144
  TextHeight = 21
  object Label1: TLabel
    Left = 12
    Top = 12
    Width = 173
    Height = 21
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Caption = 'Not found in dictionary:'
  end
  object Label2: TLabel
    Left = 12
    Top = 102
    Width = 203
    Height = 21
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Caption = '&Select from  Suggestion(s):'
  end
  object Label3: TLabel
    Left = 12
    Top = 339
    Width = 93
    Height = 21
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Caption = 'Change &to:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object But_Cancel: TButton
    Left = 456
    Top = 374
    Width = 164
    Height = 37
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Cancel = True
    Caption = 'Close'
    TabOrder = 6
    OnClick = But_CancelClick
  end
  object But_Options: TButton
    Left = 456
    Top = 311
    Width = 164
    Height = 37
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Caption = 'Options...'
    TabOrder = 5
    OnClick = But_OptionsClick
  end
  object But_Ignore: TButton
    Left = 456
    Top = 12
    Width = 164
    Height = 38
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Caption = '&Ignore once'
    TabOrder = 0
    OnClick = But_IgnoreClick
  end
  object But_IgnoreAll: TButton
    Left = 456
    Top = 53
    Width = 164
    Height = 37
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Caption = 'I&gnore all'
    TabOrder = 1
    OnClick = But_IgnoreAllClick
  end
  object But_AddToDict: TButton
    Left = 456
    Top = 93
    Width = 164
    Height = 38
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Caption = '&Add to dictionary'
    TabOrder = 2
    OnClick = But_AddToDictClick
  end
  object But_Change: TButton
    Left = 456
    Top = 173
    Width = 164
    Height = 37
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Caption = '&Change once'
    Enabled = False
    TabOrder = 3
    OnClick = But_ChangeClick
  end
  object But_ChangeAll: TButton
    Left = 456
    Top = 213
    Width = 164
    Height = 38
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Caption = 'Change a&ll'
    Enabled = False
    TabOrder = 4
    OnClick = But_ChangeAllClick
  end
  object CheckLessPreffered: TCheckBox
    Left = 143
    Top = 314
    Width = 291
    Height = 25
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Caption = 'Always Show full suggestion list'
    TabOrder = 7
    OnClick = CheckLessPrefferedClick
  end
  object List: TListBox
    Left = 12
    Top = 131
    Width = 422
    Height = 174
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Siyam Rupali'
    Font.Style = []
    ItemHeight = 37
    ParentFont = False
    TabOrder = 8
    OnClick = ListClick
    OnDblClick = ListDblClick
    OnKeyUp = ListKeyUp
  end
  object Edit_NotFound: TEdit
    Left = 12
    Top = 41
    Width = 422
    Height = 45
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    TabStop = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -24
    Font.Name = 'Siyam Rupali'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 9
  end
  object Edit_ChangeTo: TEdit
    Left = 12
    Top = 368
    Width = 422
    Height = 45
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Siyam Rupali'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 10
    OnChange = Edit_ChangeToChange
    OnKeyUp = Edit_ChangeToKeyUp
  end
end
