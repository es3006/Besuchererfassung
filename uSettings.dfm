object fSettings: TfSettings
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Einstellungen'
  ClientHeight = 483
  ClientWidth = 604
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poMainFormCenter
  OnClose = FormClose
  OnShow = FormShow
  TextHeight = 19
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 588
    Height = 467
    ActivePage = Programmeinstellungen
    TabOrder = 0
    object Programmeinstellungen: TTabSheet
      Caption = 'Programmeinstellungen'
      object SpeedButton1: TSpeedButton
        Left = 232
        Top = 152
        Width = 25
        Height = 27
        OnClick = SpeedButton1Click
      end
      object SpeedButton2: TSpeedButton
        Left = 232
        Top = 216
        Width = 25
        Height = 27
        OnClick = SpeedButton2Click
      end
      object Label2: TLabel
        Left = 24
        Top = 96
        Width = 243
        Height = 19
        Caption = 'Farbe f'#252'r selektierte Listeneintr'#228'ge'
      end
      object edLineHeight: TLabeledEdit
        Left = 24
        Top = 46
        Width = 121
        Height = 27
        EditLabel.Width = 77
        EditLabel.Height = 19
        EditLabel.Caption = 'Zeilenh'#246'he'
        TabOrder = 0
        Text = '16'
      end
      object udLineHeight: TUpDown
        Left = 143
        Top = 46
        Width = 34
        Height = 27
        Associate = edLineHeight
        Min = 10
        Max = 50
        Position = 16
        TabOrder = 1
      end
      object btnSave: TButton
        Left = 400
        Top = 376
        Width = 161
        Height = 33
        Caption = 'Speichern'
        TabOrder = 2
        OnClick = btnSaveClick
      end
      object edLVSelBGColor: TLabeledEdit
        Left = 24
        Top = 152
        Width = 217
        Height = 27
        AutoSelect = False
        EditLabel.Width = 121
        EditLabel.Height = 19
        EditLabel.Caption = 'Hintergrundfarbe'
        ReadOnly = True
        TabOrder = 3
        Text = ''
      end
      object edLVSelVGColor: TLabeledEdit
        Left = 24
        Top = 216
        Width = 217
        Height = 27
        EditLabel.Width = 67
        EditLabel.Height = 19
        EditLabel.Caption = 'Textfarbe'
        ReadOnly = True
        TabOrder = 4
        Text = ''
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'DSGVO'
      ImageIndex = 1
      object Label1: TLabel
        Left = 24
        Top = 24
        Width = 537
        Height = 113
        AutoSize = False
        Caption = 
          'Geben Sie hier bitte an, nach wie vielen Tagen Benutzerdaten, Ch' +
          'ipkartenausgaben und Besucher-Anmeldungen nach der DSGVO-Verordn' +
          'ung automatisch gel'#246'scht werden sollen.'
        WordWrap = True
      end
      object lbMonJahr: TLabel
        Left = 159
        Top = 187
        Width = 15
        Height = 19
        Caption = '...'
      end
      object edDSGVODelTimeInDays: TLabeledEdit
        Left = 24
        Top = 184
        Width = 129
        Height = 27
        EditLabel.Width = 131
        EditLabel.Height = 19
        EditLabel.Caption = 'L'#246'schzeit in Tagen'
        MaxLength = 4
        NumbersOnly = True
        TabOrder = 0
        Text = '0'
        OnKeyUp = edDSGVODelTimeInDaysKeyUp
      end
      object btnSaveDSGVO: TButton
        Left = 400
        Top = 376
        Width = 161
        Height = 33
        Caption = 'Speichern'
        TabOrder = 1
        OnClick = btnSaveDSGVOClick
      end
      object cbAutoDel: TCheckBox
        Left = 24
        Top = 217
        Width = 305
        Height = 17
        Caption = 'Automatisches l'#246'schen aktivieren'
        TabOrder = 2
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Automatische Datenbanksicherung'
      ImageIndex = 2
      object Label4: TLabel
        Left = 24
        Top = 32
        Width = 361
        Height = 19
        Caption = 'Automatische Datenbanksicherung erstellen'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label5: TLabel
        Left = 24
        Top = 159
        Width = 78
        Height = 19
        Caption = 'Wochentag'
      end
      object Label3: TLabel
        Left = 24
        Top = 72
        Width = 481
        Height = 38
        Caption = 
          'W'#228'hlen Sie hier den Wochentag und die Uhrzeit zu der automatisch' +
          ' '#13'jede Woche eine Datenbanksicherung erstellt werden soll.'
      end
      object cbAutoDBBackupWochentag: TComboBox
        Left = 24
        Top = 184
        Width = 145
        Height = 27
        Style = csDropDownList
        TabOrder = 0
        Items.Strings = (
          ''
          'Sonntag'
          'Montag'
          'Dienstag'
          'Mittwoch'
          'Donnerstag'
          'Freitag'
          'Samstag')
      end
      object edAutoDBBackupStunde: TLabeledEdit
        Left = 192
        Top = 184
        Width = 57
        Height = 27
        EditLabel.Width = 49
        EditLabel.Height = 19
        EditLabel.Caption = 'Stunde'
        MaxLength = 2
        NumbersOnly = True
        TabOrder = 1
        Text = ''
      end
      object edAutoDBBackupMinute: TLabeledEdit
        Left = 272
        Top = 184
        Width = 57
        Height = 27
        EditLabel.Width = 47
        EditLabel.Height = 19
        EditLabel.Caption = 'Minute'
        MaxLength = 2
        NumbersOnly = True
        TabOrder = 2
        Text = ''
      end
      object btnSaveAutoDBBackup: TButton
        Left = 400
        Top = 376
        Width = 161
        Height = 33
        Caption = 'Speichern'
        TabOrder = 3
        OnClick = btnSaveAutoDBBackupClick
      end
    end
  end
  object ColorDialog1: TColorDialog
    Left = 460
    Top = 174
  end
end
