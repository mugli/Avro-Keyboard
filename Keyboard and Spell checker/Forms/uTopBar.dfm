object TopBar: TTopBar
  Left = 256
  Top = 260
  AlphaBlend = True
  BorderIcons = []
  BorderStyle = bsNone
  ClientHeight = 240
  ClientWidth = 533
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
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
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesigned
  ScreenSnap = True
  SnapBuffer = 32
  OnClose = FormClose
  OnCreate = FormCreate
  OnHide = FormHide
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ImgMain: TImage
    Left = 24
    Top = 16
    Width = 361
    Height = 41
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
  end
  object ImgAppIcon: TImage
    Left = 24
    Top = 72
    Width = 33
    Height = 33
    Cursor = crMultiDrag
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    ParentShowHint = False
    ShowHint = True
    OnDblClick = ImgAppIconDblClick
    OnMouseDown = ImgAppIconMouseDown
    OnMouseEnter = ImgAppIconMouseEnter
    OnMouseLeave = ImgAppIconMouseLeave
    OnMouseUp = ImgAppIconMouseUp
  end
  object ImgButtonMode: TImage
    Left = 63
    Top = 72
    Width = 33
    Height = 33
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    ParentShowHint = False
    ShowHint = True
    OnDblClick = ImgButtonModeDblClick
    OnMouseDown = ImgButtonModeMouseDown
    OnMouseEnter = ImgButtonModeMouseEnter
    OnMouseLeave = ImgButtonModeMouseLeave
    OnMouseUp = ImgButtonModeMouseUp
  end
  object ImgButtonLayoutDown: TImage
    Left = 104
    Top = 72
    Width = 33
    Height = 33
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    ParentShowHint = False
    ShowHint = True
    OnDblClick = ImgButtonLayoutDownDblClick
    OnMouseDown = ImgButtonLayoutDownMouseDown
    OnMouseEnter = ImgButtonLayoutDownMouseEnter
    OnMouseLeave = ImgButtonLayoutDownMouseLeave
    OnMouseUp = ImgButtonLayoutDownMouseUp
  end
  object ImgButtonLayout: TImage
    Left = 137
    Top = 72
    Width = 33
    Height = 33
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    ParentShowHint = False
    ShowHint = True
    OnDblClick = ImgButtonLayoutDblClick
    OnMouseDown = ImgButtonLayoutMouseDown
    OnMouseEnter = ImgButtonLayoutMouseEnter
    OnMouseLeave = ImgButtonLayoutMouseLeave
    OnMouseUp = ImgButtonLayoutMouseUp
  end
  object ImgButtonMouse: TImage
    Left = 192
    Top = 72
    Width = 33
    Height = 33
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    ParentShowHint = False
    ShowHint = True
    OnDblClick = ImgButtonMouseDblClick
    OnMouseDown = ImgButtonMouseMouseDown
    OnMouseEnter = ImgButtonMouseMouseEnter
    OnMouseLeave = ImgButtonMouseMouseLeave
    OnMouseUp = ImgButtonMouseMouseUp
  end
  object ImgButtonTools: TImage
    Left = 232
    Top = 72
    Width = 33
    Height = 33
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    ParentShowHint = False
    ShowHint = True
    OnDblClick = ImgButtonToolsDblClick
    OnMouseDown = ImgButtonToolsMouseDown
    OnMouseEnter = ImgButtonToolsMouseEnter
    OnMouseLeave = ImgButtonToolsMouseLeave
    OnMouseUp = ImgButtonToolsMouseUp
  end
  object ImgButtonWWW: TImage
    Left = 272
    Top = 72
    Width = 33
    Height = 33
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    ParentShowHint = False
    ShowHint = True
    OnDblClick = ImgButtonWWWDblClick
    OnMouseDown = ImgButtonWWWMouseDown
    OnMouseEnter = ImgButtonWWWMouseEnter
    OnMouseLeave = ImgButtonWWWMouseLeave
    OnMouseUp = ImgButtonWWWMouseUp
  end
  object ImgButtonHelp: TImage
    Left = 312
    Top = 72
    Width = 33
    Height = 33
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    ParentShowHint = False
    ShowHint = True
    OnDblClick = ImgButtonHelpDblClick
    OnMouseDown = ImgButtonHelpMouseDown
    OnMouseEnter = ImgButtonHelpMouseEnter
    OnMouseLeave = ImgButtonHelpMouseLeave
    OnMouseUp = ImgButtonHelpMouseUp
  end
  object ImgButtonMinimize: TImage
    Left = 352
    Top = 72
    Width = 33
    Height = 33
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    ParentShowHint = False
    ShowHint = True
    OnDblClick = ImgButtonMinimizeDblClick
    OnMouseDown = ImgButtonMinimizeMouseDown
    OnMouseEnter = ImgButtonMinimizeMouseEnter
    OnMouseLeave = ImgButtonMinimizeMouseLeave
    OnMouseUp = ImgButtonMinimizeMouseUp
  end
  object TmrAppIcon: TTimer
    Enabled = False
    Interval = 40
    OnTimer = TmrAppIconTimer
    Left = 24
    Top = 104
  end
  object TmrButtonMode: TTimer
    Enabled = False
    Interval = 40
    OnTimer = TmrButtonModeTimer
    Left = 64
    Top = 104
  end
  object TmrButtonLayoutDown: TTimer
    Enabled = False
    Interval = 40
    OnTimer = TmrButtonLayoutDownTimer
    Left = 104
    Top = 104
  end
  object TmrButtonLayout: TTimer
    Enabled = False
    Interval = 40
    OnTimer = TmrButtonLayoutTimer
    Left = 144
    Top = 104
  end
  object TmrButtonMouse: TTimer
    Enabled = False
    Interval = 40
    OnTimer = TmrButtonMouseTimer
    Left = 192
    Top = 104
  end
  object TmrButtonTools: TTimer
    Enabled = False
    Interval = 40
    OnTimer = TmrButtonToolsTimer
    Left = 232
    Top = 104
  end
  object TmrButtonWWW: TTimer
    Enabled = False
    Interval = 40
    OnTimer = TmrButtonWWWTimer
    Left = 272
    Top = 104
  end
  object TmrButtonHelp: TTimer
    Enabled = False
    Interval = 40
    OnTimer = TmrButtonHelpTimer
    Left = 312
    Top = 104
  end
  object TmrButtonMinimize: TTimer
    Enabled = False
    Interval = 40
    OnTimer = TmrButtonMinimizeTimer
    Left = 352
    Top = 104
  end
  object TransparencyTimer: TTimer
    Enabled = False
    Interval = 10
    OnTimer = TransparencyTimerTimer
    Left = 480
    Top = 192
  end
  object BalloonHint1: TBalloonHint
    HideAfter = 5000
    Left = 336
    Top = 184
  end
  object HintTimer: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = HintTimerTimer
    Left = 448
    Top = 192
  end
end
