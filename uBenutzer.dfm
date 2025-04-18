object fBenutzer: TfBenutzer
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Benutzerverwaltung'
  ClientHeight = 541
  ClientWidth = 918
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Position = poMainFormCenter
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  DesignSize = (
    918
    541)
  TextHeight = 19
  object lbTitle: TLabel
    Left = 16
    Top = 26
    Width = 197
    Height = 25
    Caption = 'Bediener '#220'bersicht'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Shape4: TShape
    Left = 231
    Top = 367
    Width = 10
    Height = 33
    Anchors = [akLeft, akBottom]
    Brush.Color = clLime
    Pen.Style = psClear
  end
  object Shape1: TShape
    Left = 462
    Top = 367
    Width = 10
    Height = 33
    Anchors = [akLeft, akBottom]
    Brush.Color = clLime
    Pen.Style = psClear
  end
  object Shape2: TShape
    Left = 231
    Top = 447
    Width = 10
    Height = 33
    Anchors = [akLeft, akBottom]
    Brush.Color = clLime
    Pen.Style = psClear
  end
  object Shape3: TShape
    Left = 462
    Top = 447
    Width = 10
    Height = 33
    Anchors = [akLeft, akBottom]
    Brush.Color = clLime
    Pen.Style = psClear
  end
  object btnNeuerBenutzer: TButton
    Left = 698
    Top = 22
    Width = 204
    Height = 36
    Caption = 'Neuer Bediener'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = btnNeuerBenutzerClick
  end
  object btnUebersicht: TButton
    Left = 521
    Top = 22
    Width = 171
    Height = 36
    Caption = #220'bersicht'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = btnUebersichtClick
  end
  object edNachname: TLabeledEdit
    Left = 16
    Top = 367
    Width = 215
    Height = 33
    Anchors = [akLeft, akBottom]
    EditLabel.Width = 90
    EditLabel.Height = 23
    EditLabel.Caption = 'Nachname'
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -19
    EditLabel.Font.Name = 'Tahoma'
    EditLabel.Font.Style = []
    EditLabel.ParentFont = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    Text = ''
  end
  object edUsername: TLabeledEdit
    Left = 16
    Top = 447
    Width = 215
    Height = 33
    Anchors = [akLeft, akBottom]
    EditLabel.Width = 84
    EditLabel.Height = 23
    EditLabel.Caption = 'Username'
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -19
    EditLabel.Font.Name = 'Tahoma'
    EditLabel.Font.Style = []
    EditLabel.ParentFont = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    Text = ''
  end
  object btnDelete: TButton
    Left = 558
    Top = 443
    Width = 169
    Height = 42
    Anchors = [akLeft, akBottom]
    Caption = 'L'#246'schen'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 12
    OnClick = btnDeleteClick
  end
  object edUserPW: TLabeledEdit
    Left = 247
    Top = 447
    Width = 215
    Height = 33
    Anchors = [akLeft, akBottom]
    EditLabel.Width = 73
    EditLabel.Height = 23
    EditLabel.Caption = 'Passwort'
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -19
    EditLabel.Font.Name = 'Tahoma'
    EditLabel.Font.Style = []
    EditLabel.ParentFont = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    PasswordChar = '*'
    TabOrder = 8
    Text = ''
  end
  object edVorname: TLabeledEdit
    Left = 247
    Top = 367
    Width = 215
    Height = 33
    Anchors = [akLeft, akBottom]
    EditLabel.Width = 75
    EditLabel.Height = 23
    EditLabel.Caption = 'Vorname'
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -19
    EditLabel.Font.Name = 'Tahoma'
    EditLabel.Font.Style = []
    EditLabel.ParentFont = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    Text = ''
  end
  object edEmail: TLabeledEdit
    Left = 478
    Top = 367
    Width = 233
    Height = 33
    Anchors = [akLeft, akBottom]
    EditLabel.Width = 45
    EditLabel.Height = 23
    EditLabel.Caption = 'Email'
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -19
    EditLabel.Font.Name = 'Tahoma'
    EditLabel.Font.Style = []
    EditLabel.ParentFont = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    Text = ''
  end
  object edTelefon: TLabeledEdit
    Left = 717
    Top = 367
    Width = 185
    Height = 33
    Anchors = [akLeft, akBottom]
    EditLabel.Width = 62
    EditLabel.Height = 23
    EditLabel.Caption = 'Telefon'
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -19
    EditLabel.Font.Name = 'Tahoma'
    EditLabel.Font.Style = []
    EditLabel.ParentFont = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    Text = ''
  end
  object cbAdmin: TCheckBox
    Left = 16
    Top = 495
    Width = 169
    Height = 34
    Anchors = [akLeft, akBottom]
    Caption = 'Adminrechte'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 9
  end
  object cbLogged: TCheckBox
    Left = 191
    Top = 495
    Width = 290
    Height = 34
    Anchors = [akLeft, akBottom]
    Caption = 'Zugang gesperrt'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 10
  end
  object btnSpeichern: TButton
    Left = 733
    Top = 443
    Width = 169
    Height = 42
    Anchors = [akLeft, akBottom]
    Caption = 'Speichern'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 11
    OnClick = btnSpeichernClick
  end
  object lvBediener: TAdvListView
    Left = 16
    Top = 64
    Width = 886
    Height = 261
    Anchors = [akLeft, akTop, akBottom]
    Columns = <
      item
        Caption = 'ID'
        MaxWidth = 1
        MinWidth = 1
        Width = 1
      end
      item
        Caption = 'Nachname'
        Width = 140
      end
      item
        Caption = 'Vorname'
        Width = 140
      end
      item
        Caption = 'Username'
        Width = 100
      end
      item
        AutoSize = True
        Caption = 'Email'
      end
      item
        Caption = 'Telefon'
        Width = 150
      end
      item
        Alignment = taCenter
        Caption = 'Admin'
        Width = 70
      end
      item
        Alignment = taCenter
        Caption = 'Gesperrt'
        Width = 80
      end>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    GridLines = True
    HideSelection = False
    OwnerDraw = True
    ReadOnly = True
    RowSelect = True
    ParentFont = False
    TabOrder = 2
    ViewStyle = vsReport
    OnSelectItem = lvBedienerSelectItem
    FilterTimeOut = 0
    PrintSettings.DateFormat = 'dd/mm/yyyy'
    PrintSettings.Font.Charset = DEFAULT_CHARSET
    PrintSettings.Font.Color = clWindowText
    PrintSettings.Font.Height = -11
    PrintSettings.Font.Name = 'Tahoma'
    PrintSettings.Font.Style = []
    PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
    PrintSettings.HeaderFont.Color = clWindowText
    PrintSettings.HeaderFont.Height = -11
    PrintSettings.HeaderFont.Name = 'Tahoma'
    PrintSettings.HeaderFont.Style = []
    PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
    PrintSettings.FooterFont.Color = clWindowText
    PrintSettings.FooterFont.Height = -11
    PrintSettings.FooterFont.Name = 'Tahoma'
    PrintSettings.FooterFont.Style = []
    PrintSettings.PageNumSep = '/'
    HeaderFont.Charset = DEFAULT_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -16
    HeaderFont.Name = 'Tahoma'
    HeaderFont.Style = []
    ProgressSettings.ValueFormat = '%d%%'
    ItemHeight = 30
    DetailView.Font.Charset = DEFAULT_CHARSET
    DetailView.Font.Color = clBlue
    DetailView.Font.Height = -11
    DetailView.Font.Name = 'Tahoma'
    DetailView.Font.Style = []
    Version = '1.9.1.1'
  end
end
