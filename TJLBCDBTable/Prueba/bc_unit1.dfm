object Form1: TForm1
  Left = 252
  Top = 164
  Width = 563
  Height = 315
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
  object tb1: TJLBCDBStringGrid
    Left = 16
    Top = 80
    Width = 489
    Height = 185
    TabOrder = 0
    DataSource = t1
  end
  object Button1: TButton
    Left = 88
    Top = 24
    Width = 89
    Height = 33
    Caption = 'Button1'
    TabOrder = 1
    OnClick = Button1Click
  end
  object t1: TJLBCDBTable
    FileName = 'tablas\prueba.ini'
    Left = 16
    Top = 16
  end
end
