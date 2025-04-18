object fNewAusstellungsstaat: TfNewAusstellungsstaat
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Neuen Ausweis - Ausstellungsstatt hinzuf'#252'gen'
  ClientHeight = 260
  ClientWidth = 424
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -21
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  DesignSize = (
    424
    260)
  PixelsPerInch = 96
  TextHeight = 25
  object Shape3: TShape
    Left = 399
    Top = 162
    Width = 10
    Height = 33
    Brush.Color = clLime
    Pen.Style = psClear
  end
  object Label1: TLabel
    Left = 24
    Top = 24
    Width = 392
    Height = 89
    Caption = 
      'Bitte geben Sie den Namen des Staates ein, den Sie zu den Auswei' +
      's Ausstellungsstaaten hinzuf'#252'gen wollen!'
    WordWrap = True
  end
  object edStaat: TLabeledEdit
    Left = 24
    Top = 162
    Width = 375
    Height = 33
    EditLabel.Width = 48
    EditLabel.Height = 25
    EditLabel.Caption = 'Staat'
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -21
    EditLabel.Font.Name = 'Tahoma'
    EditLabel.Font.Style = []
    EditLabel.ParentFont = False
    TabOrder = 0
    OnKeyPress = edStaatKeyPress
  end
  object btnAddState: TButton
    Left = 24
    Top = 211
    Width = 385
    Height = 33
    Anchors = [akLeft, akBottom]
    Caption = 'Hinzuf'#252'gen'
    TabOrder = 1
    OnClick = btnAddStateClick
  end
end
