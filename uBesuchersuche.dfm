object fBesuchersuche: TfBesuchersuche
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Besuchererfassung'
  ClientHeight = 223
  ClientWidth = 403
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
    403
    223)
  PixelsPerInch = 96
  TextHeight = 25
  object Shape3: TShape
    Left = 24
    Top = 128
    Width = 289
    Height = 14
    Brush.Color = clLime
    Pen.Style = psClear
  end
  object Label1: TLabel
    Left = 24
    Top = 15
    Width = 346
    Height = 50
    Caption = 'Bitte geben Sie die Ausweisnummer des Besuchers ein!'
    WordWrap = True
  end
  object Shape4: TShape
    Left = 372
    Top = 118
    Width = 10
    Height = 33
    Brush.Color = clLime
    Pen.Style = psClear
  end
  object edAusweisNr: TLabeledEdit
    Left = 24
    Top = 118
    Width = 348
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
    TabOrder = 0
    OnKeyPress = edAusweisNrKeyPress
  end
  object btnBesucherSuchen: TButton
    Left = 24
    Top = 164
    Width = 358
    Height = 40
    Anchors = [akLeft, akBottom]
    Caption = 'Weiter'
    TabOrder = 1
    OnClick = btnBesucherSuchenClick
  end
end
