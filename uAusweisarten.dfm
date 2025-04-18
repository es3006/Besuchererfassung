object fAusweisarten: TfAusweisarten
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Ausweisarten'
  ClientHeight = 511
  ClientWidth = 679
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
    679
    511)
  TextHeight = 25
  object lbTitle: TLabel
    Left = 16
    Top = 25
    Width = 248
    Height = 25
    Caption = 'Ausweisarten '#220'bersicht'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lvAusweisarten: TAdvListView
    Left = 16
    Top = 72
    Width = 646
    Height = 362
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Caption = 'ID'
        MaxWidth = 1
        MinWidth = 1
        Width = 1
      end
      item
        AutoSize = True
        Caption = 'Ausweisart'
      end>
    GridLines = True
    HideSelection = False
    OwnerDraw = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnSelectItem = lvAusweisartenSelectItem
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
  object edAusweisart: TLabeledEdit
    Left = 16
    Top = 465
    Width = 345
    Height = 33
    Anchors = [akLeft, akBottom]
    EditLabel.Width = 101
    EditLabel.Height = 25
    EditLabel.Caption = 'Ausweisart'
    TabOrder = 1
    Text = ''
  end
  object btnSpeichern: TButton
    Left = 534
    Top = 460
    Width = 128
    Height = 40
    Anchors = [akRight, akBottom]
    Caption = 'Speichern'
    TabOrder = 2
    OnClick = btnSpeichernClick
  end
  object btnNeueAusweisart: TButton
    Left = 444
    Top = 19
    Width = 218
    Height = 40
    Anchors = [akTop, akRight]
    Caption = 'Neue Ausweisart'
    TabOrder = 3
    OnClick = btnNeueAusweisartClick
  end
  object btnDelete: TButton
    Left = 399
    Top = 460
    Width = 129
    Height = 40
    Anchors = [akRight, akBottom]
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
end
