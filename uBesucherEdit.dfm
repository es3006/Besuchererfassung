object fBesucherEdit: TfBesucherEdit
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Daten eines Besuchers bearbeiten'
  ClientHeight = 597
  ClientWidth = 676
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  DesignSize = (
    676
    597)
  PixelsPerInch = 96
  TextHeight = 19
  object Label1: TLabel
    Left = 326
    Top = 200
    Width = 77
    Height = 19
    Caption = 'Ausweisart'
  end
  object Label2: TLabel
    Left = 502
    Top = 200
    Width = 130
    Height = 19
    Caption = 'Ausstellungs-Staat'
  end
  object SpeedButton1: TSpeedButton
    Left = 632
    Top = 32
    Width = 23
    Height = 22
    Caption = '?'
  end
  object Label3: TLabel
    Left = 319
    Top = 459
    Width = 265
    Height = 38
    Caption = 
      'Falls eine Anmeldung vorliegt, tragen Sie hier bitte den Zeitrau' +
      'm ein!'
    WordWrap = True
  end
  object Shape1: TShape
    Left = 16
    Top = 90
    Width = 209
    Height = 14
    Brush.Color = clLime
    Pen.Style = psClear
  end
  object Shape2: TShape
    Left = 16
    Top = 242
    Width = 161
    Height = 14
    Brush.Color = clLime
    Pen.Style = psClear
  end
  object Shape3: TShape
    Left = 192
    Top = 242
    Width = 121
    Height = 14
    Brush.Color = clLime
    Pen.Style = psClear
  end
  object Shape4: TShape
    Left = 326
    Top = 242
    Width = 163
    Height = 14
    Brush.Color = clLime
    Pen.Style = psClear
  end
  object Shape5: TShape
    Left = 495
    Top = 242
    Width = 160
    Height = 14
    Brush.Color = clLime
    Pen.Style = psClear
  end
  object edNachname: TLabeledEdit
    Left = 16
    Top = 72
    Width = 209
    Height = 27
    EditLabel.Width = 88
    EditLabel.Height = 19
    EditLabel.Caption = 'Nachname *'
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -16
    EditLabel.Font.Name = 'Tahoma'
    EditLabel.Font.Style = []
    EditLabel.ParentFont = False
    TabOrder = 0
  end
  object edVorname: TLabeledEdit
    Left = 231
    Top = 72
    Width = 209
    Height = 27
    EditLabel.Width = 64
    EditLabel.Height = 19
    EditLabel.Caption = 'Vorname'
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -16
    EditLabel.Font.Name = 'Tahoma'
    EditLabel.Font.Style = []
    EditLabel.ParentFont = False
    TabOrder = 1
  end
  object edFirma: TLabeledEdit
    Left = 446
    Top = 72
    Width = 209
    Height = 27
    EditLabel.Width = 54
    EditLabel.Height = 19
    EditLabel.Caption = 'Firma *'
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -16
    EditLabel.Font.Name = 'Tahoma'
    EditLabel.Font.Style = []
    EditLabel.ParentFont = False
    TabOrder = 2
  end
  object edAusweisNr: TLabeledEdit
    Left = 16
    Top = 224
    Width = 161
    Height = 27
    CharCase = ecUpperCase
    EditLabel.Width = 89
    EditLabel.Height = 19
    EditLabel.Caption = 'AusweisNr *'
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -16
    EditLabel.Font.Name = 'Tahoma'
    EditLabel.Font.Style = []
    EditLabel.ParentFont = False
    TabOrder = 3
  end
  object edGueltigBis: TLabeledEdit
    Left = 192
    Top = 224
    Width = 121
    Height = 27
    EditLabel.Width = 67
    EditLabel.Height = 19
    EditLabel.Caption = 'G'#252'ltig Bis'
    MaxLength = 10
    TabOrder = 4
    TextHint = 'TT.MM.YYYY'
  end
  object cbAusweisart: TComboBox
    Left = 326
    Top = 224
    Width = 163
    Height = 27
    Style = csDropDownList
    TabOrder = 5
  end
  object edStrasseHausNr: TLabeledEdit
    Left = 16
    Top = 136
    Width = 209
    Height = 27
    EditLabel.Width = 118
    EditLabel.Height = 19
    EditLabel.Caption = 'Strasse / HausNr'
    TabOrder = 6
  end
  object edPLZWohnort: TLabeledEdit
    Left = 231
    Top = 136
    Width = 424
    Height = 27
    EditLabel.Width = 103
    EditLabel.Height = 19
    EditLabel.Caption = 'PLZ / Wohnort'
    TabOrder = 7
  end
  object cbStaat: TComboBox
    Left = 495
    Top = 225
    Width = 160
    Height = 27
    Style = csDropDownList
    TabOrder = 8
  end
  object edKennzeichen: TLabeledEdit
    Left = 16
    Top = 328
    Width = 209
    Height = 27
    CharCase = ecUpperCase
    EditLabel.Width = 119
    EditLabel.Height = 19
    EditLabel.Caption = 'KFZ-Kennzeichen'
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -16
    EditLabel.Font.Name = 'Tahoma'
    EditLabel.Font.Style = []
    EditLabel.ParentFont = False
    TabOrder = 9
  end
  object edBesuchter: TLabeledEdit
    Left = 240
    Top = 328
    Width = 415
    Height = 27
    EditLabel.Width = 112
    EditLabel.Height = 19
    EditLabel.Caption = 'Zu Besuchender'
    TabOrder = 10
  end
  object btnBesucherSuchen: TButton
    Left = 16
    Top = 532
    Width = 137
    Height = 33
    Anchors = [akLeft, akBottom]
    Caption = 'Suchen'
    TabOrder = 11
    ExplicitTop = 617
  end
  object btnChipkartenausgabeSpeichern: TButton
    Left = 518
    Top = 532
    Width = 137
    Height = 33
    Anchors = [akLeft, akBottom]
    Caption = 'Speichern'
    TabOrder = 12
    ExplicitTop = 617
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 578
    Width = 676
    Height = 19
    Panels = <
      item
        Width = 50
      end>
    ExplicitLeft = 360
    ExplicitTop = 288
    ExplicitWidth = 0
  end
  object edAnmeldungVon: TLabeledEdit
    Left = 16
    Top = 470
    Width = 121
    Height = 27
    EditLabel.Width = 115
    EditLabel.Height = 19
    EditLabel.Caption = 'Anmeldung Von'
    MaxLength = 10
    TabOrder = 14
    TextHint = 'TT.MM.YYYY'
  end
  object edAnmeldungBis: TLabeledEdit
    Left = 176
    Top = 470
    Width = 121
    Height = 27
    EditLabel.Width = 107
    EditLabel.Height = 19
    EditLabel.Caption = 'Anmeldung Bis'
    MaxLength = 10
    TabOrder = 15
    TextHint = 'TT.MM.YYYY'
  end
  object edBemerkungen: TLabeledEdit
    Left = 16
    Top = 392
    Width = 639
    Height = 27
    EditLabel.Width = 97
    EditLabel.Height = 19
    EditLabel.Caption = 'Bemerkungen'
    TabOrder = 16
  end
end
