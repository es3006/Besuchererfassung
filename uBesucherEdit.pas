unit uBesucherEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.Buttons;

type
  TfBesucherEdit = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
    edNachname: TLabeledEdit;
    edVorname: TLabeledEdit;
    edFirma: TLabeledEdit;
    edAusweisNr: TLabeledEdit;
    edGueltigBis: TLabeledEdit;
    cbAusweisart: TComboBox;
    edStrasseHausNr: TLabeledEdit;
    edPLZWohnort: TLabeledEdit;
    cbStaat: TComboBox;
    edKennzeichen: TLabeledEdit;
    edBesuchter: TLabeledEdit;
    btnBesucherSuchen: TButton;
    btnChipkartenausgabeSpeichern: TButton;
    StatusBar1: TStatusBar;
    edAnmeldungVon: TLabeledEdit;
    edAnmeldungBis: TLabeledEdit;
    Label3: TLabel;
    edBemerkungen: TLabeledEdit;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  fBesucherEdit: TfBesucherEdit;

implementation

{$R *.dfm}

end.
