object Form1: TForm1
  Left = 0
  Top = 0
  Margins.Left = 5
  Margins.Top = 5
  Margins.Right = 5
  Margins.Bottom = 5
  Caption = 'Avro Unicode to Bijoy Converter'
  ClientHeight = 449
  ClientWidth = 864
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Tahoma'
  Font.Style = []
  Icon.Data = {
    0000010001001010000001002000680400001600000028000000100000002000
    0000010020000000000000040000120B0000120B000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000070CA768F80D690BF80D690BF81D691BF80D690BF81D791BF66C063965EBC
    5700000000000000000000000000000000000000000000000000000000005DBB
    540070CE7CC37CDD99FF7CDD99FF7CDD99FF7CDD9AFF77D184DE60BB56240000
    00000000000000000000000000000000000000000000000000000000000059B6
    4A006AC76DC374D488FF74D488FF74D488FF6FCB77FC59B54929000000000000
    00000000000000000000000000000000000000000000000000000000000053B0
    3E0066C161C374CE7EFF76CF7FFF74CE7EFF74CE7EFE67BE5CA54DAA310B0000
    00000000000000000000000000000000000000000000000000009ED08F094EAB
    330068BD5CC37CCC7DFF8ACF86FD81CE81FF7CCC7DFF75CA76FE69BF5FD154AC
    385148A42506000000000000000048A4240048A4241265B9547B88C6767F49A5
    26006DBB59C374BF63DE4DA62B2F73BD5FC889CD81FF83CA7BFF78C670FF68BF
    5FFE5DB64CF15CB448C75DB449BB5DB54AD060B952F95FB54CCF47A3230F44A0
    1C0086C16E9947A01F2400000000459F1B1370B754B38FCB80FE86C878FF7AC3
    6BFF5FB64DFF54B140FF54B141FF5FB54BFE59AD3BB9439E1A170000000083BE
    6600000000000000000000000000000000003F9A100057A62E4C7EBD62AC7EBE
    64DF77BB5DE861AF41DB61AE3FA7479D19493F990F0100000000000000000000
    000000000000000000000000000000000000000000003C960900369303003A95
    05033A9505073A95050200000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000FFFF
    0000FFFF0000FFFF0000FFFF0000FFFF000080FF000080FF000081FF000080FE
    0000803800008000000090010000FC030000FF1F0000FFFF0000FFFF0000}
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 144
  DesignSize = (
    864
    449)
  TextHeight = 21
  object Label1: TLabel
    Left = 12
    Top = 12
    Width = 299
    Height = 21
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Caption = 'Type or Paste Unicode Bangla text here:'
  end
  object Label8: TLabel
    Left = 237
    Top = 417
    Width = 150
    Height = 21
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Caption = 'All Rights Reserved.'
  end
  object Label_OmicronLab: TLabel
    Left = 108
    Top = 417
    Width = 120
    Height = 20
    Cursor = crHandPoint
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Caption = 'OmicronLab.'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'Verdana'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    OnClick = Label_OmicronLabClick
  end
  object Label4: TLabel
    Left = 12
    Top = 417
    Width = 91
    Height = 21
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Caption = 'Copyright '#169
  end
  object MEMO1: TMemo
    Left = 12
    Top = 36
    Width = 831
    Height = 158
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Siyam Rupali'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object MEMO2: TMemo
    Left = 12
    Top = 249
    Width = 831
    Height = 158
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'Kalpurush ANSI'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object Button1: TButton
    Left = 12
    Top = 203
    Width = 275
    Height = 37
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Caption = 'Convert to Bijoy encoding >>'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = Button1Click
  end
  object Progress: TProgressBar
    Left = 408
    Top = 416
    Width = 435
    Height = 19
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 3
    Visible = False
  end
  object AppEvents: TApplicationEvents
    OnSettingChange = AppEventsSettingChange
    Left = 720
    Top = 192
  end
end
