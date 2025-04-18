object fBesuchererfassung: TfBesuchererfassung
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Besuchererfassung'
  ClientHeight = 539
  ClientWidth = 458
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -21
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  DesignSize = (
    458
    539)
  PixelsPerInch = 96
  TextHeight = 25
  object Label1: TLabel
    Left = 232
    Top = 242
    Width = 101
    Height = 25
    Caption = 'Ausweisart'
  end
  object Label2: TLabel
    Left = 17
    Top = 383
    Width = 172
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Ausstellungs-Staat'
    ExplicitTop = 539
  end
  object Shape1: TShape
    Left = 216
    Top = 51
    Width = 10
    Height = 33
    Brush.Color = clLime
    Pen.Style = psClear
  end
  object Shape8: TShape
    Left = 432
    Top = 51
    Width = 10
    Height = 33
    Brush.Color = clLime
    Pen.Style = psClear
  end
  object Shape9: TShape
    Left = 216
    Top = 267
    Width = 10
    Height = 33
    Brush.Color = clLime
    Pen.Style = psClear
  end
  object Shape6: TShape
    Left = 432
    Top = 414
    Width = 10
    Height = 33
    Anchors = [akLeft, akBottom]
    Brush.Color = 33023
    Pen.Style = psClear
    ExplicitTop = 549
  end
  object Shape10: TShape
    Left = 432
    Top = 267
    Width = 10
    Height = 33
    Brush.Color = 33023
    Pen.Style = psClear
  end
  object Shape2: TShape
    Left = 216
    Top = 337
    Width = 10
    Height = 33
    Brush.Color = 33023
    Pen.Style = psClear
  end
  object btnChipkartenausgabeSpeichern: TButton
    Left = 16
    Top = 472
    Width = 424
    Height = 37
    Anchors = [akLeft, akBottom]
    Caption = 'Weiter'
    TabOrder = 9
    OnClick = btnChipkartenausgabeSpeichernClick
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 520
    Width = 458
    Height = 19
    Panels = <
      item
        Width = 50
      end>
    ParentShowHint = False
    ShowHint = True
    SimplePanel = True
    SizeGrip = False
  end
  object edNachname: TLabeledEdit
    Left = 16
    Top = 51
    Width = 201
    Height = 33
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
  end
  object edVorname: TLabeledEdit
    Left = 231
    Top = 51
    Width = 201
    Height = 33
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
  end
  object edFirma: TLabeledEdit
    Left = 16
    Top = 121
    Width = 424
    Height = 33
    EditLabel.Width = 53
    EditLabel.Height = 25
    EditLabel.Caption = 'Firma'
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -21
    EditLabel.Font.Name = 'Tahoma'
    EditLabel.Font.Style = []
    EditLabel.ParentFont = False
    TabOrder = 2
  end
  object edAusweisNr: TLabeledEdit
    Left = 16
    Top = 267
    Width = 201
    Height = 33
    EditLabel.Width = 97
    EditLabel.Height = 25
    EditLabel.Caption = 'AusweisNr'
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -21
    EditLabel.Font.Name = 'Tahoma'
    EditLabel.Font.Style = []
    EditLabel.ParentFont = False
    TabOrder = 5
  end
  object cbAusweisart: TComboBox
    Left = 232
    Top = 267
    Width = 201
    Height = 33
    Style = csDropDownList
    TabOrder = 6
  end
  object edStrasseHausNr: TLabeledEdit
    Left = 16
    Top = 193
    Width = 209
    Height = 33
    EditLabel.Width = 157
    EditLabel.Height = 25
    EditLabel.Caption = 'Strasse / HausNr'
    TabOrder = 3
  end
  object edPLZWohnort: TLabeledEdit
    Left = 231
    Top = 193
    Width = 209
    Height = 33
    EditLabel.Width = 136
    EditLabel.Height = 25
    EditLabel.Caption = 'PLZ / Wohnort'
    TabOrder = 4
  end
  object cbStaat: TComboBox
    Left = 17
    Top = 414
    Width = 417
    Height = 33
    Style = csDropDownList
    Anchors = [akLeft, akBottom]
    ParentShowHint = False
    ShowHint = True
    Sorted = True
    TabOrder = 8
  end
  object edGueltigBis: TLabeledEdit
    Left = 17
    Top = 337
    Width = 200
    Height = 33
    EditLabel.Width = 170
    EditLabel.Height = 25
    EditLabel.Caption = 'Ausweis G'#252'ltig bis'
    MaxLength = 10
    TabOrder = 7
    TextHint = 'TT.MM.YYYY'
    OnExit = edGueltigBisExit
    OnKeyPress = edGueltigBisKeyPress
  end
end
