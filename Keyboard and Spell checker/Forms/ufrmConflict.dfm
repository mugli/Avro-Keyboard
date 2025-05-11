object frmConflict: TfrmConflict
  Left = 0
  Top = 0
  Margins.Left = 5
  Margins.Top = 5
  Margins.Right = 5
  Margins.Bottom = 5
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsToolWindow
  Caption = 'Which one to keep?'
  ClientHeight = 267
  ClientWidth = 753
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Tahoma'
  Font.Style = []
  Icon.Data = {
    0000010001001010000001000800680500001600000028000000100000002000
    0000010008000000000000010000000000000000000000010000000100000000
    00003E3E3E000A277B0018277C00143A7F0042424200092E8D000D2F94001B2A
    9500182D9C00093093000A319900193196000C38AE001A32A900083CB5000B3C
    BA001D34B400103AB500133BBE002E2FB200352EB8002234B7002930B2002E33
    BC003131BB000841870008429B000A4D9F00124A98000F41A0000E41BE001549
    B7002541B4000570A9000A72AC000B6EB4000F6FB7001364BB001A66BF00126C
    BB000E79B5001F3BC8001A3ECF003D2FC1003931C4003236CE003834CA00283C
    D300402FC3004030C5000846C2000A4FC2000D41CA000A45D4000A47D9000A48
    D9001343D6001B40D300194AD0001048DF00324BC9002646D600285DD0000F6A
    C900067FC1001177C400176DD8001D72D200187ED7001472DD001F7CDB002164
    C8000B4CE5000C4EEE00114BE7001D7DF9000486BA00048CC200078FC900098F
    CD000596CE00188BDF0003A1D8000B94E3000D9AE800109CE0002880F6002E81
    F8003F84F6000AA9E20001B2E60004B8EA0002BDEC0004B9F1005C87E9004F86
    F4004B89F5005D8FF5006A89E2007D94E9006E95F4007F9BF30002C7F60001CD
    F60000D2FA0000D8FF00909FF0008EA1F2009DA9F200A0A8F100ADAFF200ABB0
    F300B6B6F300B8B6F100C2BCF200CBC3F300D1CAF40000000000000000000000
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
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000FFFFFF000505
    0505050505050505050101010505054C4C4C4C4C4C4C4C4C4C4326434C050558
    4A4A4A4938363749490F5B33570505594B3C350D0B060A0D101B6A3459050560
    3912071C41534E1A02226A1F6105055F121E536A5E5E6A684D69681362050563
    2067543B2B3A406A5B515D136505056455462B0E09110E684F245D116605056B
    3E30161D230C085D50245D116C05056E302E165D6A4F036842285C166D05056F
    2E2E18676704296921265A17700505722F2E2D44695D694519275A1772050573
    2D322D2D3F523F2D2D4856157305057431323232323232322D3D472C74050575
    7575757575757575757575757505050505050505050505050505050505050000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  Position = poDesktopCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 144
  TextHeight = 21
  object Label2: TLabel
    Left = 12
    Top = 17
    Width = 91
    Height = 29
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Caption = 'Replace:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 12
    Top = 77
    Width = 56
    Height = 29
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Caption = 'With:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 288
    Top = 117
    Width = 48
    Height = 21
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Caption = 'Label4'
  end
  object Label5: TLabel
    Left = 48
    Top = 119
    Width = 61
    Height = 21
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Caption = 'Current:'
  end
  object Label6: TLabel
    Left = 48
    Top = 197
    Width = 74
    Height = 21
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Caption = 'Imported:'
  end
  object EditR_P: TEdit
    Left = 348
    Top = 12
    Width = 207
    Height = 44
    Cursor = crArrow
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    TabStop = False
    BevelInner = bvNone
    Color = clBtnFace
    Font.Charset = ANSI_CHARSET
    Font.Color = clBtnText
    Font.Height = -32
    Font.Name = 'SolaimanLipi'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 2
  end
  object EditR: TEdit
    Left = 132
    Top = 12
    Width = 207
    Height = 37
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    TabStop = False
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 3
    Text = 'EditR'
  end
  object EditWC_P: TEdit
    Left = 348
    Top = 107
    Width = 207
    Height = 44
    Cursor = crArrow
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    TabStop = False
    BevelInner = bvNone
    Color = clBtnFace
    Font.Charset = ANSI_CHARSET
    Font.Color = clBtnText
    Font.Height = -32
    Font.Name = 'SolaimanLipi'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 4
  end
  object EditWC: TEdit
    Left = 132
    Top = 105
    Width = 207
    Height = 37
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    TabStop = False
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 5
    Text = 'Edit1'
  end
  object EditWI_P: TEdit
    Left = 348
    Top = 185
    Width = 207
    Height = 44
    Cursor = crArrow
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    TabStop = False
    BevelInner = bvNone
    Color = clBtnFace
    Font.Charset = ANSI_CHARSET
    Font.Color = clBtnText
    Font.Height = -32
    Font.Name = 'SolaimanLipi'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 6
  end
  object EditWI: TEdit
    Left = 132
    Top = 185
    Width = 207
    Height = 37
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    TabStop = False
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 7
    Text = 'Edit1'
  end
  object butImported: TButton
    Left = 588
    Top = 185
    Width = 141
    Height = 52
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Caption = 'Keep imported'
    TabOrder = 1
    OnClick = butImportedClick
  end
  object butCurrent: TButton
    Left = 588
    Top = 102
    Width = 141
    Height = 53
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Caption = 'Keep current'
    TabOrder = 0
    OnClick = butCurrentClick
  end
end
