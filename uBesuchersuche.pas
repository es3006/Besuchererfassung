unit uBesuchersuche;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfBesuchersuche = class(TForm)
    edAusweisNr: TLabeledEdit;
    Shape3: TShape;
    btnBesucherSuchen: TButton;
    Label1: TLabel;
    Shape4: TShape;
    procedure FormShow(Sender: TObject);
    procedure btnBesucherSuchenClick(Sender: TObject);
    procedure edAusweisNrKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private-Deklarationen }
  public
    RETURNTO: string;
  end;

var
  fBesuchersuche: TfBesuchersuche;

implementation

{$R *.dfm}

uses
  uDBFunctions, uBesuchererfassung, uBesucheranmeldung, uChipkartenausgabe;

procedure TfBesuchersuche.btnBesucherSuchenClick(Sender: TObject);
var
  ausweisnr: string;
  besucherID: integer;
begin
  ausweisnr  := trim(edAusweisNr.Text);
  besucherID := getBesucherIDByAusweisNr(ausweisnr);

  if(besucherID <> 0) then
  begin
    if(RETURNTO = 'Chipkartenausgabe') then
    begin
      fChipkartenausgabe.BESUCHERID := besucherID;
      fChipkartenausgabe.edAusweisNr.Text := ausweisnr;
      fChipkartenausgabe.ShowModal;
      fBesuchersuche.Close;
      abort
    end;

    if(RETURNTO = 'Anmeldung') then
    begin
      fBesucheranmeldung.BESUCHERID := besucherID;
      fBesucheranmeldung.ShowModal;
      fBesuchersuche.Close;
      abort
    end;
  end
  else
  begin
    //Neuer Besucher
    fBesuchererfassung.OPENFORM  := RETURNTO;
    fBesuchererfassung.AUSWEISNUMMER := ausweisnr;
    fBesuchererfassung.ShowModal;
  end;
end;





procedure TfBesuchersuche.edAusweisNrKeyPress(Sender: TObject; var Key: Char);
begin
  if(Key = #13) then
  begin
    key := #0;
    btnBesucherSuchenClick(nil);
  end;

  if Key = #27 then
  begin
    Close;
  end;
end;




procedure TfBesuchersuche.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Close;
  end;
end;

procedure TfBesuchersuche.FormShow(Sender: TObject);
begin
  edAusweisNr.Clear;
  edAusweisNr.SetFocus;
end;

end.
