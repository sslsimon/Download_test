object Form1: TForm1
  Left = 192
  Top = 114
  Width = 870
  Height = 640
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 390
    Top = 8
    Width = 31
    Height = 13
    Caption = 'Label1'
  end
  object Button1: TButton
    Left = 32
    Top = 512
    Width = 75
    Height = 25
    Caption = #36830#25509
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 216
    Top = 512
    Width = 75
    Height = 25
    Caption = #19979#36733
    TabOrder = 1
    OnClick = Button2Click
  end
  object Edit1: TEdit
    Left = 8
    Top = 3
    Width = 369
    Height = 21
    TabOrder = 2
    Text = 'Edit1'
  end
  object Memo1: TMemo
    Left = 8
    Top = 32
    Width = 785
    Height = 225
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssBoth
    TabOrder = 3
  end
  object ProgressBar1: TProgressBar
    Left = 32
    Top = 448
    Width = 769
    Height = 17
    TabOrder = 4
  end
  object OpenDialog1: TOpenDialog
    Left = 256
    Top = 208
  end
  object IdFTP1: TIdFTP
    AutoLogin = True
    ProxySettings.ProxyType = fpcmNone
    ProxySettings.Port = 0
    Left = 616
    Top = 312
  end
end
