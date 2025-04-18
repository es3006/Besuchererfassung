object fStaaten: TfStaaten
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Staaten'
  ClientHeight = 411
  ClientWidth = 717
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -21
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Position = poMainFormCenter
  OnClose = FormClose
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  DesignSize = (
    717
    411)
  TextHeight = 25
  object lbTitle: TLabel
    Left = 16
    Top = 25
    Width = 188
    Height = 25
    Caption = 'Staaten '#220'bersicht'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lvStaaten: TAdvListView
    Left = 16
    Top = 72
    Width = 684
    Height = 211
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Caption = 'ID'
        MaxWidth = 1
        MinWidth = 1
        Width = 1
      end
      item
        Caption = 'K'#252'rzel'
        Width = 70
      end
      item
        AutoSize = True
        Caption = 'Staat'
      end
      item
        Alignment = taCenter
        Caption = 'Staatenliste'
        Width = 100
      end>
    GridLines = True
    HideSelection = False
    OwnerDraw = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnSelectItem = lvStaatenSelectItem
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
  object edStaat: TLabeledEdit
    Left = 88
    Top = 311
    Width = 241
    Height = 33
    Anchors = [akLeft, akBottom]
    EditLabel.Width = 48
    EditLabel.Height = 25
    EditLabel.Caption = 'Staat'
    TabOrder = 1
    Text = ''
  end
  object btnSpeichern: TButton
    Left = 548
    Top = 362
    Width = 152
    Height = 41
    Anchors = [akRight, akBottom]
    Caption = 'Speichern'
    TabOrder = 2
    OnClick = btnSpeichernClick
  end
  object btnNeuerEintrag: TButton
    Left = 531
    Top = 23
    Width = 169
    Height = 36
    Anchors = [akTop, akRight]
    Caption = 'Neuer Eintrag'
    TabOrder = 3
    OnClick = btnNeuerEintragClick
  end
  object btnDelete: TButton
    Left = 16
    Top = 362
    Width = 145
    Height = 41
    Anchors = [akLeft, akBottom]
    Caption = 'L'#246'schen'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = btnDeleteClick
  end
  object edKuerzel: TLabeledEdit
    Left = 16
    Top = 311
    Width = 56
    Height = 33
    Anchors = [akLeft, akBottom]
    EditLabel.Width = 57
    EditLabel.Height = 25
    EditLabel.Caption = 'K'#252'rzel'
    TabOrder = 5
    Text = ''
  end
  object cbStaatenliste: TCheckBox
    Left = 350
    Top = 319
    Width = 275
    Height = 17
    Anchors = [akRight, akBottom]
    Caption = 'Steht auf der Staatenliste'
    TabOrder = 6
  end
end
