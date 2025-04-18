object fFirstStart: TfFirstStart
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Erster Start - Programmeinrichtung'
  ClientHeight = 499
  ClientWidth = 495
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -21
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Position = poDesktopCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  DesignSize = (
    495
    499)
  TextHeight = 25
  object Label1: TLabel
    Left = 24
    Top = 16
    Width = 5
    Height = 19
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Shape3: TShape
    Left = 233
    Top = 198
    Width = 10
    Height = 33
    Brush.Color = clLime
    Pen.Style = psClear
  end
  object Shape1: TShape
    Left = 465
    Top = 198
    Width = 10
    Height = 33
    Brush.Color = clLime
    Pen.Style = psClear
  end
  object Shape2: TShape
    Left = 233
    Top = 374
    Width = 10
    Height = 33
    Brush.Color = clLime
    Pen.Style = psClear
  end
  object Shape4: TShape
    Left = 465
    Top = 374
    Width = 10
    Height = 33
    Brush.Color = clLime
    Pen.Style = psClear
  end
  object edNachname: TLabeledEdit
    Left = 24
    Top = 198
    Width = 210
    Height = 33
    Anchors = [akLeft, akBottom]
    EditLabel.Width = 99
    EditLabel.Height = 25
    EditLabel.Caption = 'Nachname'
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -21
    EditLabel.Font.Name = 'Tahoma'
    EditLabel.Font.Style = []
    EditLabel.ParentFont = False
    TabOrder = 0
    Text = ''
    OnKeyPress = edNachnameKeyPress
  end
  object edUsername: TLabeledEdit
    Left = 24
    Top = 374
    Width = 210
    Height = 33
    Anchors = [akLeft, akBottom]
    EditLabel.Width = 94
    EditLabel.Height = 25
    EditLabel.Caption = 'Username'
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -21
    EditLabel.Font.Name = 'Tahoma'
    EditLabel.Font.Style = []
    EditLabel.ParentFont = False
    TabOrder = 4
    Text = ''
    OnKeyPress = edNachnameKeyPress
  end
  object edUserPW: TLabeledEdit
    Left = 256
    Top = 374
    Width = 210
    Height = 33
    Anchors = [akLeft, akBottom]
    EditLabel.Width = 83
    EditLabel.Height = 25
    EditLabel.Caption = 'Passwort'
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -21
    EditLabel.Font.Name = 'Tahoma'
    EditLabel.Font.Style = []
    EditLabel.ParentFont = False
    PasswordChar = '*'
    TabOrder = 5
    Text = ''
    OnKeyPress = edNachnameKeyPress
  end
  object edVorname: TLabeledEdit
    Left = 256
    Top = 198
    Width = 210
    Height = 33
    Anchors = [akLeft, akBottom]
    EditLabel.Width = 84
    EditLabel.Height = 25
    EditLabel.Caption = 'Vorname'
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -21
    EditLabel.Font.Name = 'Tahoma'
    EditLabel.Font.Style = []
    EditLabel.ParentFont = False
    TabOrder = 1
    Text = ''
    OnKeyPress = edNachnameKeyPress
  end
  object edEmail: TLabeledEdit
    Left = 24
    Top = 286
    Width = 217
    Height = 33
    Anchors = [akLeft, akBottom]
    EditLabel.Width = 51
    EditLabel.Height = 25
    EditLabel.Caption = 'Email'
    TabOrder = 2
    Text = ''
    OnKeyPress = edNachnameKeyPress
  end
  object edTelefon: TLabeledEdit
    Left = 256
    Top = 286
    Width = 217
    Height = 33
    Anchors = [akLeft, akBottom]
    EditLabel.Width = 69
    EditLabel.Height = 25
    EditLabel.Caption = 'Telefon'
    TabOrder = 3
    Text = ''
    OnKeyPress = edNachnameKeyPress
  end
  object btnSpeichern: TButton
    Left = 24
    Top = 438
    Width = 449
    Height = 42
    Anchors = [akLeft, akBottom]
    Caption = 'Speichern'
    TabOrder = 6
    OnClick = btnSpeichernClick
  end
end
