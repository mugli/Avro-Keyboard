object FrameDrag: TFrameDrag
  Left = 0
  Top = 0
  Width = 455
  Height = 308
  TabOrder = 0
  object Label1: TLabel
    Left = 118
    Top = 258
    Width = 25
    Height = 13
    Caption = 'Left:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 318
    Top = 258
    Width = 24
    Height = 13
    Caption = 'Top:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 55
    Top = 286
    Width = 394
    Height = 13
    Caption = 
      'Note: All coordinate values are related to Top-Left corner of To' +
      'p Bar, in Pixel unit.'
  end
  object ScrollBox1: TScrollBox
    Left = 3
    Top = 3
    Width = 446
    Height = 246
    HorzScrollBar.Smooth = True
    HorzScrollBar.Tracking = True
    VertScrollBar.Smooth = True
    VertScrollBar.Tracking = True
    TabOrder = 0
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 1000
      Height = 300
      Color = clWhite
      ParentBackground = False
      TabOrder = 0
      object Background: TImage
        Left = 0
        Top = 0
        Width = 339
        Height = 29
        AutoSize = True
      end
      object AvroIcon: TImage
        Left = 8
        Top = 152
        Width = 26
        Height = 27
        Cursor = crSizeAll
        AutoSize = True
        OnMouseDown = AvroIconMouseDown
        OnMouseMove = AvroIconMouseMove
        OnMouseUp = AvroIconMouseUp
      end
      object KM: TImage
        Left = 40
        Top = 152
        Width = 87
        Height = 29
        Cursor = crSizeAll
        AutoSize = True
        OnMouseDown = AvroIconMouseDown
        OnMouseMove = AvroIconMouseMove
        OnMouseUp = AvroIconMouseUp
      end
      object KL: TImage
        Left = 133
        Top = 151
        Width = 18
        Height = 29
        Cursor = crSizeAll
        AutoSize = True
        OnMouseDown = AvroIconMouseDown
        OnMouseMove = AvroIconMouseMove
        OnMouseUp = AvroIconMouseUp
      end
      object LayoutV: TImage
        Left = 157
        Top = 152
        Width = 28
        Height = 29
        Cursor = crSizeAll
        AutoSize = True
        OnMouseDown = AvroIconMouseDown
        OnMouseMove = AvroIconMouseMove
        OnMouseUp = AvroIconMouseUp
      end
      object AvroMouse: TImage
        Left = 191
        Top = 152
        Width = 28
        Height = 29
        Cursor = crSizeAll
        AutoSize = True
        OnMouseDown = AvroIconMouseDown
        OnMouseMove = AvroIconMouseMove
        OnMouseUp = AvroIconMouseUp
      end
      object Tools: TImage
        Left = 225
        Top = 152
        Width = 28
        Height = 29
        Cursor = crSizeAll
        AutoSize = True
        OnMouseDown = AvroIconMouseDown
        OnMouseMove = AvroIconMouseMove
        OnMouseUp = AvroIconMouseUp
      end
      object Web: TImage
        Left = 259
        Top = 152
        Width = 28
        Height = 29
        Cursor = crSizeAll
        AutoSize = True
        OnMouseDown = AvroIconMouseDown
        OnMouseMove = AvroIconMouseMove
        OnMouseUp = AvroIconMouseUp
      end
      object Help: TImage
        Left = 293
        Top = 152
        Width = 28
        Height = 29
        Cursor = crSizeAll
        AutoSize = True
        OnMouseDown = AvroIconMouseDown
        OnMouseMove = AvroIconMouseMove
        OnMouseUp = AvroIconMouseUp
      end
      object Exit: TImage
        Left = 327
        Top = 152
        Width = 28
        Height = 29
        Cursor = crSizeAll
        AutoSize = True
        OnMouseDown = AvroIconMouseDown
        OnMouseMove = AvroIconMouseMove
        OnMouseUp = AvroIconMouseUp
      end
    end
  end
  object UpDown1: TUpDown
    Left = 230
    Top = 255
    Width = 17
    Height = 21
    Associate = XPos
    Min = -5000
    Max = 5000
    TabOrder = 1
    Thousands = False
  end
  object UpDown2: TUpDown
    Left = 430
    Top = 255
    Width = 21
    Height = 21
    Associate = YPos
    Min = -5000
    Max = 5000
    TabOrder = 2
    Thousands = False
  end
  object XPos: TEdit
    Left = 149
    Top = 255
    Width = 81
    Height = 21
    TabOrder = 3
    Text = '0'
    OnChange = XPosChange
  end
  object YPos: TEdit
    Left = 349
    Top = 255
    Width = 81
    Height = 21
    TabOrder = 4
    Text = '0'
    OnChange = YPosChange
  end
end
