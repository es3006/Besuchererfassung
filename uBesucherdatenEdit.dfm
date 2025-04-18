object fBesucherdatenEdit: TfBesucherdatenEdit
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Besucherdaten bearbeiten'
  ClientHeight = 533
  ClientWidth = 458
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -21
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  DesignSize = (
    458
    533)
  PixelsPerInch = 96
  TextHeight = 25
  object Label1: TLabel
    Left = 231
    Top = 242
    Width = 101
    Height = 25
    Caption = 'Ausweisart'
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
  object Shape10: TShape
    Left = 432
    Top = 267
    Width = 10
    Height = 33
    Brush.Color = clLime
    Pen.Style = psClear
  end
  object Label2: TLabel
    Left = 17
    Top = 384
    Width = 172
    Height = 25
    Caption = 'Ausstellungs-Staat'
  end
  object Shape6: TShape
    Left = 432
    Top = 414
    Width = 10
    Height = 33
    Brush.Color = clLime
    Pen.Style = psClear
  end
  object Shape3: TShape
    Left = 216
    Top = 337
    Width = 10
    Height = 33
    Brush.Color = clLime
    Pen.Style = psClear
  end
  object btnChipkartenausgabeSpeichern: TButton
    Left = 264
    Top = 466
    Width = 176
    Height = 39
    Anchors = [akLeft, akBottom]
    Caption = 'Speichern'
    TabOrder = 7
    OnClick = btnChipkartenausgabeSpeichernClick
    ExplicitTop = 532
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
    Width = 202
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
    Left = 231
    Top = 267
    Width = 202
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
  object StatusBar1: TStatusBar
    Left = 0
    Top = 514
    Width = 458
    Height = 19
    Panels = <
      item
        Width = 50
      end>
    ExplicitTop = 580
  end
  object btnDeleteBesucher: TButton
    Left = 17
    Top = 466
    Width = 175
    Height = 39
    Anchors = [akLeft, akBottom]
    Caption = 'L'#246'schen'
    TabOrder = 9
    OnClick = btnDeleteBesucherClick
    ExplicitTop = 532
  end
  object cbStaat: TComboBox
    Left = 17
    Top = 415
    Width = 417
    Height = 33
    Style = csDropDownList
    ParentShowHint = False
    ShowHint = True
    Sorted = True
    TabOrder = 10
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
    TabOrder = 11
    TextHint = 'TT.MM.YYYY'
    OnExit = edGueltigBisExit
    OnKeyPress = edGueltigBisKeyPress
  end
end
