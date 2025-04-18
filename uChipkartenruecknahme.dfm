object fChipkartenruecknahme: TfChipkartenruecknahme
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Chipkartenr'#252'cknahme'
  ClientHeight = 289
  ClientWidth = 370
  Color = clTeal
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
    370
    289)
  PixelsPerInch = 96
  TextHeight = 25
  object Shape3: TShape
    Left = 334
    Top = 165
    Width = 10
    Height = 33
    Brush.Color = clLime
    Pen.Style = psClear
  end
  object Label1: TLabel
    Left = 24
    Top = 24
    Width = 320
    Height = 75
    Caption = 
      'Bitte w'#228'hlen Sie die Nummer der Chipkarte, die Sie zur'#252'cknehmen ' +
      'wollen!'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label2: TLabel
    Left = 24
    Top = 134
    Width = 131
    Height = 25
    Caption = 'Chipkarten-Nr'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object btnRuecknahme: TButton
    Left = 24
    Top = 204
    Width = 320
    Height = 36
    Anchors = [akLeft, akBottom]
    Caption = 'R'#252'cknahme'
    TabOrder = 0
    OnClick = btnRuecknahmeClick
  end
  object cbChipkartenNr: TComboBox
    Left = 24
    Top = 165
    Width = 310
    Height = 33
    Style = csDropDownList
    TabOrder = 1
    OnSelect = cbChipkartenNrSelect
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 264
    Width = 370
    Height = 25
    Panels = <
      item
        Width = 300
      end>
    SizeGrip = False
  end
end
