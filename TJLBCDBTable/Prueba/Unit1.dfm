object Form1: TForm1
  Left = 190
  Top = 105
  Width = 630
  Height = 332
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 104
    Top = 8
    Width = 105
    Height = 33
    Caption = 'Crear tabla nueva'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 224
    Top = 16
    Width = 105
    Height = 33
    Caption = 'Crear registro'
    TabOrder = 1
    OnClick = Button2Click
  end
  object tb1: TJLBCDBStringGrid
    Left = 48
    Top = 72
    Width = 545
    Height = 209
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goColMoving, goThumbTracking]
    TabOrder = 2
    DataSource = t1
    ColWidths = (
      64
      101
      163
      64
      64)
  end
  object Button3: TButton
    Left = 352
    Top = 16
    Width = 97
    Height = 41
    Caption = 'Tabla'
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 104
    Top = 40
    Width = 105
    Height = 25
    Caption = 'Button4'
    TabOrder = 4
    OnClick = Button4Click
  end
  object t1: TJLBCDBTable
    FileName = 'tablas\prueba.ini'
  end
end
