object fPasswortabfrage: TfPasswortabfrage
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Passwortabfrage'
  ClientHeight = 224
  ClientWidth = 349
  Color = 8388863
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -21
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poMainFormCenter
  OnShow = FormShow
  TextHeight = 25
  object Label1: TLabel
    Left = 32
    Top = 24
    Width = 94
    Height = 25
    Caption = 'Username'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbUsername: TLabel
    Left = 32
    Top = 49
    Width = 106
    Height = 25
    Caption = 'Username'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object edUserPW: TLabeledEdit
    Left = 32
    Top = 112
    Width = 289
    Height = 33
    EditLabel.Width = 83
    EditLabel.Height = 25
    EditLabel.Caption = 'Passwort'
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWhite
    EditLabel.Font.Height = -21
    EditLabel.Font.Name = 'Tahoma'
    EditLabel.Font.Style = []
    EditLabel.ParentFont = False
    PasswordChar = '*'
    TabOrder = 0
    Text = ''
    OnKeyPress = edUserPWKeyPress
  end
  object btnAnmelden: TButton
    Left = 32
    Top = 152
    Width = 289
    Height = 41
    Caption = 'Weiter'
    TabOrder = 1
    OnClick = btnAnmeldenClick
  end
end
