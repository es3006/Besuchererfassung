object fChipkartenausgabeEdit: TfChipkartenausgabeEdit
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Chipkartenausgabe bearbeiten'
  ClientHeight = 611
  ClientWidth = 933
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
    Left = 464
    Top = 0
    Width = 469
    Height = 611
    Align = alRight
    Color = 16774625
    ParentBackground = False
    TabOrder = 0
    DesignSize = (
      469
      611)
    object Label3: TLabel
      Left = 22
      Top = 22
      Width = 395
      Height = 81
      AutoSize = False
      Caption = 'Chipkartenausgabe Text'
      WordWrap = True
    end
    object Label4: TLabel
      Left = 22
      Top = 186
      Width = 196
      Height = 25
      Caption = 'Chipkarten-Ausgabe:'
    end
    object lbBetreten: TLabel
      Left = 247
      Top = 186
      Width = 18
      Height = 25
      Caption = '...'
    end
    object Label6: TLabel
      Left = 22
      Top = 217
      Width = 207
      Height = 25
      Caption = 'Chipkarten-R'#252'ckgabe:'
    end
    object lbVerlassen: TLabel
      Left = 247
      Top = 217
      Width = 18
      Height = 25
      Caption = '...'
    end
    object Label5: TLabel
      Left = 22
      Top = 155
      Width = 125
      Height = 25
      Caption = 'Chipkarte Nr:'
    end
    object lbChipkartenNr: TLabel
      Left = 248
      Top = 155
      Width = 21
      Height = 25
      Caption = '...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Shape2: TShape
      Left = 357
      Top = 316
      Width = 10
      Height = 33
      Brush.Color = clLime
      Pen.Style = psClear
    end
    object btnChipkartenausgabeSpeichern: TButton
      Left = 25
      Top = 548
      Width = 337
      Height = 38
      Anchors = [akLeft, akBottom]
      Caption = 'Speichern'
      TabOrder = 0
      OnClick = btnChipkartenausgabeSpeichernClick
    end
    object edBesuchter: TLabeledEdit
      Left = 25
      Top = 316
      Width = 333
      Height = 33
      EditLabel.Width = 152
      EditLabel.Height = 25
      EditLabel.Caption = 'Zu Besuchender'
      TabOrder = 1
    end
    object edKfzKennzeichen: TLabeledEdit
      Left = 25
      Top = 405
      Width = 160
      Height = 33
      EditLabel.Width = 160
      EditLabel.Height = 25
      EditLabel.Caption = 'KFZ-Kennzeichen'
      TabOrder = 2
    end
    object edBemerkungen: TLabeledEdit
      Left = 25
      Top = 481
      Width = 336
      Height = 33
      EditLabel.Width = 130
      EditLabel.Height = 25
      EditLabel.Caption = 'Bemerkungen'
      TabOrder = 3
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 464
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
      OnExit = edGueltigBisExit
      OnKeyPress = edGueltigBisKeyPress
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
