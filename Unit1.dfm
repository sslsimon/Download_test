object Form1: TForm1
  Left = 192
  Top = 114
  BorderStyle = bsDialog
  Caption = #31243#24207#26356#26032
  ClientHeight = 113
  ClientWidth = 621
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 35
    Height = 16
    Caption = #36335#24452':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Button1: TButton
    Left = 632
    Top = 8
    Width = 75
    Height = 25
    Caption = #36830#25509
    TabOrder = 0
    Visible = False
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 425
    Top = 4
    Width = 75
    Height = 25
    Caption = #19979#36733#26356#26032
    TabOrder = 1
    OnClick = Button2Click
  end
  object Edit1: TEdit
    Left = 48
    Top = 4
    Width = 369
    Height = 21
    ReadOnly = True
    TabOrder = 2
  end
  object Memo1: TMemo
    Left = 0
    Top = 32
    Width = 617
    Height = 57
    ScrollBars = ssBoth
    TabOrder = 3
  end
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 97
    Width = 621
    Height = 16
    Align = alBottom
    TabOrder = 4
  end
  object OpenDialog1: TOpenDialog
    Left = 72
    Top = 64
  end
  object IdFTP1: TIdFTP
    AutoLogin = True
    ProxySettings.ProxyType = fpcmNone
    ProxySettings.Port = 0
    Left = 152
    Top = 64
  end
end
