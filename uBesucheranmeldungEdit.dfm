object fBesucheranmeldungEdit: TfBesucheranmeldungEdit
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Besucheranmeldung bearbeiten'
  ClientHeight = 611
  ClientWidth = 870
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -21
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 25
  object Panel1: TPanel
    Left = 456
    Top = 0
    Width = 414
    Height = 611
    Align = alRight
    Color = 16774625
    ParentBackground = False
    TabOrder = 0
    DesignSize = (
      414
      611)
    object lbBeschreibung: TLabel
      Left = 29
      Top = 22
      Width = 361
      Height = 100
      Caption = 
        'Sie haben einen Fehler beim erfassen der Anmeldedaten gemacht?  ' +
        '       Hier k'#246'nnen Sie die Anmeldedaten f'#252'r den Besucher bericht' +
        'igen.'
      WordWrap = True
    end
    object Shape3: TShape
      Left = 184
      Top = 233
      Width = 10
      Height = 33
      Brush.Color = clLime
      Pen.Style = psClear
    end
    object Shape2: TShape
      Left = 384
      Top = 324
      Width = 10
      Height = 33
      Brush.Color = clLime
      Pen.Style = psClear
    end
    object Shape5: TShape
      Left = 384
      Top = 233
      Width = 10
      Height = 33
      Brush.Color = clLime
      Pen.Style = psClear
    end
    object btnAnmeldungSpeichern: TButton
      Left = 229
      Top = 548
      Width = 161
      Height = 39
      Anchors = [akLeft, akBottom]
      Caption = 'Speichern'
      TabOrder = 5
      OnClick = btnAnmeldungSpeichernClick
    end
    object edAnmeldungVon: TLabeledEdit
      Left = 29
      Top = 233
      Width = 156
      Height = 33
      EditLabel.Width = 150
      EditLabel.Height = 25
      EditLabel.Caption = 'Anmeldung Von'
      MaxLength = 10
      TabOrder = 0
      TextHint = 'TT.MM.YYYY'
      OnExit = edAnmeldungVonExit
      OnKeyPress = edAnmeldungVonKeyPress
    end
    object edAnmeldungBis: TLabeledEdit
      Left = 229
      Top = 233
      Width = 156
      Height = 33
      EditLabel.Width = 141
      EditLabel.Height = 25
      EditLabel.Caption = 'Anmeldung Bis'
      MaxLength = 10
      TabOrder = 1
      TextHint = 'TT.MM.YYYY'
      OnExit = edAnmeldungVonExit
      OnKeyPress = edAnmeldungVonKeyPress
    end
    object edBesuchter: TLabeledEdit
      Left = 29
      Top = 324
      Width = 356
      Height = 33
      EditLabel.Width = 152
      EditLabel.Height = 25
      EditLabel.Caption = 'Zu Besuchender'
      TabOrder = 2
    end
    object btnDeleteAnmeldung: TButton
      Left = 29
      Top = 548
      Width = 161
      Height = 39
      Anchors = [akLeft, akBottom]
      Caption = 'L'#246'schen'
      TabOrder = 6
      OnClick = btnDeleteAnmeldungClick
    end
    object edKfzKennzeichen: TLabeledEdit
      Left = 29
      Top = 405
      Width = 160
      Height = 33
      EditLabel.Width = 160
      EditLabel.Height = 25
      EditLabel.Caption = 'KFZ-Kennzeichen'
      TabOrder = 3
    end
    object edBemerkungen: TLabeledEdit
      Left = 29
      Top = 481
      Width = 361
      Height = 33
      EditLabel.Width = 130
      EditLabel.Height = 25
      EditLabel.Caption = 'Bemerkungen'
      TabOrder = 4
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 456
    Height = 611
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object lbAusweisArt: TLabel
      Left = 231
      Top = 248
      Width = 101
      Height = 25
      Caption = 'Ausweisart'
      Enabled = False
    end
    object lbStaat: TLabel
      Left = 16
      Top = 389
      Width = 172
      Height = 25
      Caption = 'Ausstellungs-Staat'
      Enabled = False
    end
    object edNachname: TLabeledEdit
      Left = 16
      Top = 51
      Width = 209
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
      Enabled = False
      TabOrder = 0
    end
    object edVorname: TLabeledEdit
      Left = 231
      Top = 51
      Width = 209
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
      Enabled = False
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
      Enabled = False
      TabOrder = 2
    end
    object edAusweisNr: TLabeledEdit
      Left = 16
      Top = 276
      Width = 209
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
      Enabled = False
      TabOrder = 3
    end
    object cbAusweisart: TComboBox
      Left = 231
      Top = 276
      Width = 209
      Height = 33
      Style = csDropDownList
      Enabled = False
      TabOrder = 4
    end
    object edStrasseHausNr: TLabeledEdit
      Left = 16
      Top = 193
      Width = 209
      Height = 33
      EditLabel.Width = 157
      EditLabel.Height = 25
      EditLabel.Caption = 'Strasse / HausNr'
      Enabled = False
      TabOrder = 5
    end
    object edPLZWohnort: TLabeledEdit
      Left = 231
      Top = 193
      Width = 209
      Height = 33
      EditLabel.Width = 136
      EditLabel.Height = 25
      EditLabel.Caption = 'PLZ / Wohnort'
      Enabled = False
      TabOrder = 6
    end
    object cbStaat: TComboBox
      Left = 16
      Top = 416
      Width = 424
      Height = 33
      Style = csDropDownList
      Enabled = False
      TabOrder = 7
    end
    object edGueltigBis: TLabeledEdit
      Left = 16
      Top = 348
      Width = 208
      Height = 33
      EditLabel.Width = 170
      EditLabel.Height = 25
      EditLabel.Caption = 'Ausweis G'#252'ltig bis'
      Enabled = False
      MaxLength = 10
      TabOrder = 8
      TextHint = 'TT.MM.YYYY'
      OnExit = edAnmeldungVonExit
      OnKeyPress = edAnmeldungVonKeyPress
    end
    object edRegistriert: TLabeledEdit
      Left = 16
      Top = 528
      Width = 208
      Height = 33
      EditLabel.Width = 210
      EditLabel.Height = 25
      EditLabel.Caption = 'Besucher angelegt am'
      Enabled = False
      MaxLength = 10
      TabOrder = 9
      TextHint = 'TT.MM.YYYY'
    end
    object cbEditBesucherdaten: TCheckBox
      Left = 16
      Top = 570
      Width = 393
      Height = 35
      Caption = 'Besucherdaten bearbeiten'
      TabOrder = 10
      OnClick = cbEditBesucherdatenClick
    end
    object btnUpdateBesucherdaten: TButton
      Left = 284
      Top = 520
      Width = 156
      Height = 44
      Caption = 'Speichern'
      TabOrder = 11
      Visible = False
      OnClick = btnUpdateBesucherdatenClick
    end
  end
end
