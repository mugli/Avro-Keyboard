object FrameImageAdd: TFrameImageAdd
  Left = 0
  Top = 0
  Width = 385
  Height = 1250
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Color = clWhite
  ParentBackground = False
  ParentColor = False
  TabOrder = 0
  object PanelTopBar: TPanel
    Left = 3
    Top = 3
    Width = 369
    Height = 54
    BevelOuter = bvNone
    Color = clMoneyGreen
    ParentBackground = False
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 5
      Width = 116
      Height = 13
      Caption = 'Top Bar Background:'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object Label2: TLabel
      Left = 16
      Top = 26
      Width = 34
      Height = 13
      Caption = 'Image:'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object ImagePath_TopBar: TEdit
      Left = 56
      Top = 23
      Width = 266
      Height = 23
      TabOrder = 0
      Text = 'ImagePath_TopBar'
      OnClick = ImagePath_TopBarClick
    end
    object Button_ImagePath_TopBar: TButton
      Left = 328
      Top = 21
      Width = 33
      Height = 25
      Caption = '...'
      TabOrder = 1
      OnClick = Button_ImagePath_TopBarClick
    end
  end
  object PanelAvroIcon: TPanel
    Left = 3
    Top = 63
    Width = 369
    Height = 106
    BevelOuter = bvNone
    Color = clMoneyGreen
    ParentBackground = False
    TabOrder = 1
    object Label3: TLabel
      Left = 8
      Top = 5
      Width = 99
      Height = 13
      Caption = 'Avro Icon Button:'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object Label4: TLabel
      Left = 16
      Top = 26
      Width = 70
      Height = 13
      Caption = 'Normal Image:'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object Label5: TLabel
      Left = 16
      Top = 55
      Width = 95
      Height = 13
      Caption = 'Mouse Over Image:'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object Label6: TLabel
      Left = 16
      Top = 82
      Width = 98
      Height = 13
      Caption = 'Mouse Down Image:'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object AvroIcon: TEdit
      Left = 115
      Top = 23
      Width = 207
      Height = 23
      TabOrder = 0
      Text = 'Edit1'
      OnClick = ImagePath_TopBarClick
    end
    object Button_AvroIcon: TButton
      Left = 328
      Top = 21
      Width = 33
      Height = 25
      Caption = '...'
      TabOrder = 1
      OnClick = Button_ImagePath_TopBarClick
    end
    object AvroIconOver: TEdit
      Left = 115
      Top = 52
      Width = 207
      Height = 23
      TabOrder = 2
      Text = 'Edit1'
      OnClick = ImagePath_TopBarClick
    end
    object Button_AvroIconOver: TButton
      Left = 328
      Top = 50
      Width = 33
      Height = 25
      Caption = '...'
      TabOrder = 3
      OnClick = Button_ImagePath_TopBarClick
    end
    object AvroIconDown: TEdit
      Left = 115
      Top = 79
      Width = 207
      Height = 23
      TabOrder = 4
      Text = 'Edit1'
      OnClick = ImagePath_TopBarClick
    end
    object Button_AvroIconDown: TButton
      Left = 328
      Top = 77
      Width = 33
      Height = 25
      Caption = '...'
      TabOrder = 5
      OnClick = Button_ImagePath_TopBarClick
    end
  end
  object PanelKM_E: TPanel
    Left = 3
    Top = 175
    Width = 369
    Height = 106
    BevelOuter = bvNone
    Color = clMoneyGreen
    ParentBackground = False
    TabOrder = 2
    object Label7: TLabel
      Left = 8
      Top = 5
      Width = 275
      Height = 13
      Caption = 'Keyboard Mode Button (English Keyboard Mode):'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object Label8: TLabel
      Left = 16
      Top = 26
      Width = 70
      Height = 13
      Caption = 'Normal Image:'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object Label9: TLabel
      Left = 16
      Top = 55
      Width = 95
      Height = 13
      Caption = 'Mouse Over Image:'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object Label10: TLabel
      Left = 16
      Top = 82
      Width = 98
      Height = 13
      Caption = 'Mouse Down Image:'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object KMSys: TEdit
      Left = 115
      Top = 23
      Width = 207
      Height = 23
      TabOrder = 0
      Text = 'Edit1'
      OnClick = ImagePath_TopBarClick
    end
    object Button_KMSys: TButton
      Left = 328
      Top = 21
      Width = 33
      Height = 25
      Caption = '...'
      TabOrder = 1
      OnClick = Button_ImagePath_TopBarClick
    end
    object KMSysOver: TEdit
      Left = 115
      Top = 52
      Width = 207
      Height = 23
      TabOrder = 2
      Text = 'Edit1'
      OnClick = ImagePath_TopBarClick
    end
    object Button_KMSysOver: TButton
      Left = 328
      Top = 50
      Width = 33
      Height = 25
      Caption = '...'
      TabOrder = 3
      OnClick = Button_ImagePath_TopBarClick
    end
    object KMSysDown: TEdit
      Left = 115
      Top = 79
      Width = 207
      Height = 23
      TabOrder = 4
      Text = 'Edit1'
      OnClick = ImagePath_TopBarClick
    end
    object Button_KMSysDown: TButton
      Left = 328
      Top = 77
      Width = 33
      Height = 25
      Caption = '...'
      TabOrder = 5
      OnClick = Button_ImagePath_TopBarClick
    end
  end
  object PanelKM_B: TPanel
    Left = 3
    Top = 287
    Width = 369
    Height = 106
    BevelOuter = bvNone
    Color = clMoneyGreen
    ParentBackground = False
    TabOrder = 3
    object Label11: TLabel
      Left = 8
      Top = 5
      Width = 274
      Height = 13
      Caption = 'Keyboard Mode Button (Bangla Keyboard Mode):'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object Label12: TLabel
      Left = 16
      Top = 26
      Width = 70
      Height = 13
      Caption = 'Normal Image:'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object Label13: TLabel
      Left = 16
      Top = 55
      Width = 95
      Height = 13
      Caption = 'Mouse Over Image:'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object Label14: TLabel
      Left = 16
      Top = 82
      Width = 98
      Height = 13
      Caption = 'Mouse Down Image:'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object KMBangla: TEdit
      Left = 115
      Top = 23
      Width = 207
      Height = 23
      TabOrder = 0
      Text = 'Edit1'
      OnClick = ImagePath_TopBarClick
    end
    object Button_KMBangla: TButton
      Left = 328
      Top = 21
      Width = 33
      Height = 25
      Caption = '...'
      TabOrder = 1
      OnClick = Button_ImagePath_TopBarClick
    end
    object KMBanglaOver: TEdit
      Left = 115
      Top = 52
      Width = 207
      Height = 23
      TabOrder = 2
      Text = 'Edit1'
      OnClick = ImagePath_TopBarClick
    end
    object Button_KMBanglaOver: TButton
      Left = 328
      Top = 50
      Width = 33
      Height = 25
      Caption = '...'
      TabOrder = 3
      OnClick = Button_ImagePath_TopBarClick
    end
    object KMBanglaDown: TEdit
      Left = 115
      Top = 79
      Width = 207
      Height = 23
      TabOrder = 4
      Text = 'Edit1'
      OnClick = ImagePath_TopBarClick
    end
    object Button_KMBanglaDown: TButton
      Left = 328
      Top = 77
      Width = 33
      Height = 25
      Caption = '...'
      TabOrder = 5
      OnClick = Button_ImagePath_TopBarClick
    end
  end
  object PanelKL: TPanel
    Left = 3
    Top = 399
    Width = 369
    Height = 106
    BevelOuter = bvNone
    Color = clMoneyGreen
    ParentBackground = False
    TabOrder = 4
    object Label15: TLabel
      Left = 8
      Top = 5
      Width = 140
      Height = 13
      Caption = 'Keyboard Layout Button:'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object Label16: TLabel
      Left = 16
      Top = 26
      Width = 70
      Height = 13
      Caption = 'Normal Image:'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object Label17: TLabel
      Left = 16
      Top = 55
      Width = 95
      Height = 13
      Caption = 'Mouse Over Image:'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object Label18: TLabel
      Left = 16
      Top = 82
      Width = 98
      Height = 13
      Caption = 'Mouse Down Image:'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object KL: TEdit
      Left = 115
      Top = 24
      Width = 207
      Height = 23
      TabOrder = 0
      Text = 'Edit1'
      OnClick = ImagePath_TopBarClick
    end
    object Button_KL: TButton
      Left = 328
      Top = 21
      Width = 33
      Height = 25
      Caption = '...'
      TabOrder = 1
      OnClick = Button_ImagePath_TopBarClick
    end
    object KLOver: TEdit
      Left = 115
      Top = 52
      Width = 207
      Height = 23
      TabOrder = 2
      Text = 'Edit1'
      OnClick = ImagePath_TopBarClick
    end
    object Button_KLOver: TButton
      Left = 328
      Top = 50
      Width = 33
      Height = 25
      Caption = '...'
      TabOrder = 3
      OnClick = Button_ImagePath_TopBarClick
    end
    object KLDown: TEdit
      Left = 115
      Top = 79
      Width = 207
      Height = 23
      TabOrder = 4
      Text = 'Edit1'
      OnClick = ImagePath_TopBarClick
    end
    object Button_KLDown: TButton
      Left = 328
      Top = 77
      Width = 33
      Height = 25
      Caption = '...'
      TabOrder = 5
      OnClick = Button_ImagePath_TopBarClick
    end
  end
  object PanelLV: TPanel
    Left = 3
    Top = 511
    Width = 369
    Height = 106
    BevelOuter = bvNone
    Color = clMoneyGreen
    ParentBackground = False
    TabOrder = 5
    object Label19: TLabel
      Left = 8
      Top = 5
      Width = 124
      Height = 13
      Caption = 'Layout Viewer Button:'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object Label20: TLabel
      Left = 16
      Top = 26
      Width = 70
      Height = 13
      Caption = 'Normal Image:'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object Label21: TLabel
      Left = 16
      Top = 55
      Width = 95
      Height = 13
      Caption = 'Mouse Over Image:'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object Label22: TLabel
      Left = 16
      Top = 82
      Width = 98
      Height = 13
      Caption = 'Mouse Down Image:'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object LayoutV: TEdit
      Left = 115
      Top = 23
      Width = 207
      Height = 23
      TabOrder = 0
      Text = 'Edit1'
      OnClick = ImagePath_TopBarClick
    end
    object Button_LayoutV: TButton
      Left = 328
      Top = 21
      Width = 33
      Height = 25
      Caption = '...'
      TabOrder = 1
      OnClick = Button_ImagePath_TopBarClick
    end
    object LayoutVOver: TEdit
      Left = 115
      Top = 52
      Width = 207
      Height = 23
      TabOrder = 2
      Text = 'Edit1'
      OnClick = ImagePath_TopBarClick
    end
    object Button_LayoutVOver: TButton
      Left = 328
      Top = 50
      Width = 33
      Height = 25
      Caption = '...'
      TabOrder = 3
      OnClick = Button_ImagePath_TopBarClick
    end
    object LayoutVDown: TEdit
      Left = 115
      Top = 79
      Width = 207
      Height = 23
      TabOrder = 4
      Text = 'Edit1'
      OnClick = ImagePath_TopBarClick
    end
    object Button_LayoutVDown: TButton
      Left = 328
      Top = 77
      Width = 33
      Height = 25
      Caption = '...'
      TabOrder = 5
      OnClick = Button_ImagePath_TopBarClick
    end
  end
  object PanelMouse: TPanel
    Left = 0
    Top = 623
    Width = 369
    Height = 106
    BevelOuter = bvNone
    Color = clMoneyGreen
    ParentBackground = False
    TabOrder = 6
    object Label23: TLabel
      Left = 8
      Top = 5
      Width = 111
      Height = 13
      Caption = 'Avro Mouse Button:'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object Label24: TLabel
      Left = 16
      Top = 26
      Width = 70
      Height = 13
      Caption = 'Normal Image:'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object Label25: TLabel
      Left = 16
      Top = 55
      Width = 95
      Height = 13
      Caption = 'Mouse Over Image:'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object Label26: TLabel
      Left = 16
      Top = 82
      Width = 98
      Height = 13
      Caption = 'Mouse Down Image:'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object AvroMouse: TEdit
      Left = 115
      Top = 23
      Width = 207
      Height = 23
      TabOrder = 0
      Text = 'Edit1'
      OnClick = ImagePath_TopBarClick
    end
    object Button_AvroMouse: TButton
      Left = 328
      Top = 21
      Width = 33
      Height = 25
      Caption = '...'
      TabOrder = 1
      OnClick = Button_ImagePath_TopBarClick
    end
    object AvroMouseOver: TEdit
      Left = 115
      Top = 52
      Width = 207
      Height = 23
      TabOrder = 2
      Text = 'Edit1'
      OnClick = ImagePath_TopBarClick
    end
    object Button_AvroMouseOver: TButton
      Left = 328
      Top = 50
      Width = 33
      Height = 25
      Caption = '...'
      TabOrder = 3
      OnClick = Button_ImagePath_TopBarClick
    end
    object AvroMouseDown: TEdit
      Left = 115
      Top = 79
      Width = 207
      Height = 23
      TabOrder = 4
      Text = 'Edit1'
      OnClick = ImagePath_TopBarClick
    end
    object Button_AvroMouseDown: TButton
      Left = 328
      Top = 77
      Width = 33
      Height = 25
      Caption = '...'
      TabOrder = 5
      OnClick = Button_ImagePath_TopBarClick
    end
  end
  object PanelTools: TPanel
    Left = 0
    Top = 735
    Width = 369
    Height = 106
    BevelOuter = bvNone
    Color = clMoneyGreen
    ParentBackground = False
    TabOrder = 7
    object Label27: TLabel
      Left = 8
      Top = 5
      Width = 74
      Height = 13
      Caption = 'Tools Button:'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object Label28: TLabel
      Left = 16
      Top = 26
      Width = 70
      Height = 13
      Caption = 'Normal Image:'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object Label29: TLabel
      Left = 16
      Top = 55
      Width = 95
      Height = 13
      Caption = 'Mouse Over Image:'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object Label30: TLabel
      Left = 16
      Top = 82
      Width = 98
      Height = 13
      Caption = 'Mouse Down Image:'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object Tools: TEdit
      Left = 115
      Top = 23
      Width = 207
      Height = 23
      TabOrder = 0
      Text = 'Edit1'
      OnClick = ImagePath_TopBarClick
    end
    object Button_Tools: TButton
      Left = 328
      Top = 21
      Width = 33
      Height = 25
      Caption = '...'
      TabOrder = 1
      OnClick = Button_ImagePath_TopBarClick
    end
    object ToolsOver: TEdit
      Left = 115
      Top = 52
      Width = 207
      Height = 23
      TabOrder = 2
      Text = 'Edit1'
      OnClick = ImagePath_TopBarClick
    end
    object Button_ToolsOver: TButton
      Left = 328
      Top = 50
      Width = 33
      Height = 25
      Caption = '...'
      TabOrder = 3
      OnClick = Button_ImagePath_TopBarClick
    end
    object ToolsDown: TEdit
      Left = 115
      Top = 79
      Width = 207
      Height = 23
      TabOrder = 4
      Text = 'Edit1'
      OnClick = ImagePath_TopBarClick
    end
    object Button_ToolsDown: TButton
      Left = 328
      Top = 77
      Width = 33
      Height = 25
      Caption = '...'
      TabOrder = 5
      OnClick = Button_ImagePath_TopBarClick
    end
  end
  object PanelHelp: TPanel
    Left = 0
    Top = 959
    Width = 369
    Height = 106
    BevelOuter = bvNone
    Color = clMoneyGreen
    ParentBackground = False
    TabOrder = 8
    object Label31: TLabel
      Left = 8
      Top = 5
      Width = 69
      Height = 13
      Caption = 'Help Button:'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object Label32: TLabel
      Left = 16
      Top = 26
      Width = 70
      Height = 13
      Caption = 'Normal Image:'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object Label33: TLabel
      Left = 16
      Top = 55
      Width = 95
      Height = 13
      Caption = 'Mouse Over Image:'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object Label34: TLabel
      Left = 16
      Top = 82
      Width = 98
      Height = 13
      Caption = 'Mouse Down Image:'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object Help: TEdit
      Left = 115
      Top = 23
      Width = 207
      Height = 23
      TabOrder = 0
      Text = 'Edit1'
      OnClick = ImagePath_TopBarClick
    end
    object Button_Help: TButton
      Left = 328
      Top = 21
      Width = 33
      Height = 25
      Caption = '...'
      TabOrder = 1
      OnClick = Button_ImagePath_TopBarClick
    end
    object HelpOver: TEdit
      Left = 115
      Top = 52
      Width = 207
      Height = 23
      TabOrder = 2
      Text = 'Edit1'
      OnClick = ImagePath_TopBarClick
    end
    object Button_HelpOver: TButton
      Left = 328
      Top = 50
      Width = 33
      Height = 25
      Caption = '...'
      TabOrder = 3
      OnClick = Button_ImagePath_TopBarClick
    end
    object HelpDown: TEdit
      Left = 115
      Top = 79
      Width = 207
      Height = 23
      TabOrder = 4
      Text = 'Edit1'
      OnClick = ImagePath_TopBarClick
    end
    object Button_HelpDown: TButton
      Left = 328
      Top = 77
      Width = 33
      Height = 25
      Caption = '...'
      TabOrder = 5
      OnClick = Button_ImagePath_TopBarClick
    end
  end
  object PanelWeb: TPanel
    Left = 0
    Top = 847
    Width = 369
    Height = 106
    BevelOuter = bvNone
    Color = clMoneyGreen
    ParentBackground = False
    TabOrder = 9
    object Label39: TLabel
      Left = 8
      Top = 5
      Width = 115
      Height = 13
      Caption = 'Web Options Button:'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object Label40: TLabel
      Left = 16
      Top = 26
      Width = 70
      Height = 13
      Caption = 'Normal Image:'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object Label41: TLabel
      Left = 16
      Top = 55
      Width = 95
      Height = 13
      Caption = 'Mouse Over Image:'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object Label42: TLabel
      Left = 16
      Top = 82
      Width = 98
      Height = 13
      Caption = 'Mouse Down Image:'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object Web: TEdit
      Left = 115
      Top = 23
      Width = 207
      Height = 23
      TabOrder = 0
      Text = 'Edit1'
      OnClick = ImagePath_TopBarClick
    end
    object Button_Web: TButton
      Left = 328
      Top = 21
      Width = 33
      Height = 25
      Caption = '...'
      TabOrder = 1
      OnClick = Button_ImagePath_TopBarClick
    end
    object WebOver: TEdit
      Left = 115
      Top = 52
      Width = 207
      Height = 23
      TabOrder = 2
      Text = 'Edit1'
      OnClick = ImagePath_TopBarClick
    end
    object Button_WebOver: TButton
      Left = 328
      Top = 50
      Width = 33
      Height = 25
      Caption = '...'
      TabOrder = 3
      OnClick = Button_ImagePath_TopBarClick
    end
    object WebDown: TEdit
      Left = 115
      Top = 79
      Width = 207
      Height = 23
      TabOrder = 4
      Text = 'Edit1'
      OnClick = ImagePath_TopBarClick
    end
    object Button_WebDown: TButton
      Left = 328
      Top = 77
      Width = 33
      Height = 25
      Caption = '...'
      TabOrder = 5
      OnClick = Button_ImagePath_TopBarClick
    end
  end
  object PanelExit: TPanel
    Left = 0
    Top = 1071
    Width = 369
    Height = 106
    BevelOuter = bvNone
    Color = clMoneyGreen
    ParentBackground = False
    TabOrder = 10
    object Label35: TLabel
      Left = 8
      Top = 5
      Width = 65
      Height = 13
      Caption = 'Exit Button:'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object Label36: TLabel
      Left = 16
      Top = 26
      Width = 70
      Height = 13
      Caption = 'Normal Image:'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object Label37: TLabel
      Left = 16
      Top = 55
      Width = 95
      Height = 13
      Caption = 'Mouse Over Image:'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object Label38: TLabel
      Left = 16
      Top = 82
      Width = 98
      Height = 13
      Caption = 'Mouse Down Image:'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object Exit: TEdit
      Left = 115
      Top = 23
      Width = 207
      Height = 23
      TabOrder = 0
      Text = 'Edit1'
      OnClick = ImagePath_TopBarClick
    end
    object Button_Exit: TButton
      Left = 328
      Top = 21
      Width = 33
      Height = 25
      Caption = '...'
      TabOrder = 1
      OnClick = Button_ImagePath_TopBarClick
    end
    object ExitOver: TEdit
      Left = 115
      Top = 52
      Width = 207
      Height = 23
      TabOrder = 2
      Text = 'Edit1'
      OnClick = ImagePath_TopBarClick
    end
    object Button_ExitOver: TButton
      Left = 328
      Top = 50
      Width = 33
      Height = 25
      Caption = '...'
      TabOrder = 3
      OnClick = Button_ImagePath_TopBarClick
    end
    object ExitDown: TEdit
      Left = 115
      Top = 79
      Width = 207
      Height = 23
      TabOrder = 4
      Text = 'Edit1'
      OnClick = ImagePath_TopBarClick
    end
    object Button_ExitDown: TButton
      Left = 328
      Top = 77
      Width = 33
      Height = 25
      Caption = '...'
      TabOrder = 5
      OnClick = Button_ImagePath_TopBarClick
    end
  end
  object PanelPreview: TPanel
    Left = 0
    Top = 1183
    Width = 369
    Height = 58
    BevelOuter = bvNone
    Color = clMoneyGreen
    ParentBackground = False
    TabOrder = 11
    object Label43: TLabel
      Left = 8
      Top = 5
      Width = 157
      Height = 13
      Caption = 'Preview Image for this skin:'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object Preview: TEdit
      Left = 115
      Top = 23
      Width = 207
      Height = 23
      TabOrder = 0
      Text = 'Preview'
      OnClick = ImagePath_TopBarClick
    end
    object Button_Preview: TButton
      Left = 328
      Top = 21
      Width = 33
      Height = 25
      Caption = '...'
      TabOrder = 1
      OnClick = Button_ImagePath_TopBarClick
    end
  end
  object OpenPictureDialog: TOpenPictureDialog
    Filter = 'Bitmaps (*.bmp)|*.bmp'
    Left = 336
  end
end
