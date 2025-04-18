unit uChipkartenruecknahme;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, FireDAC.Comp.Client,
  FireDAC.Stan.Param, System.UITypes, Data.DB, Vcl.ComCtrls;

type
  TfChipkartenruecknahme = class(TForm)
    Shape3: TShape;
    btnRuecknahme: TButton;
    Label1: TLabel;
    cbChipkartenNr: TComboBox;
    Label2: TLabel;
    StatusBar1: TStatusBar;
    procedure btnRuecknahmeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure cbChipkartenNrSelect(Sender: TObject);
  private
    procedure Chipkartenruecknahme(KartenNr: string);
  public
    { Public-Deklarationen }
  end;

var
  fChipkartenruecknahme: TfChipkartenruecknahme;

implementation

{$R *.dfm}

uses
  uMain, uFunktionen, uDBFunctions;

procedure TfChipkartenruecknahme.btnRuecknahmeClick(Sender: TObject);
var
  chipkarte: string;
begin
  chipkarte := cbChipKartenNr.Text;

  if(length(chipkarte)>0) then
  begin
    Chipkartenruecknahme(chipkarte);
  end
  else
  begin
    showmessage('Bitte geben Sie eine ChipkartenNr ein!');
  end;
end;





procedure TfChipkartenruecknahme.cbChipkartenNrSelect(Sender: TObject);
begin
  FindAndSelectListViewItem(fMain.lvChipkartenausgabe, cbChipkartenNr.Text, [3]);
end;

procedure TfChipkartenruecknahme.Chipkartenruecknahme(KartenNr: string);
var
  FDQuery: TFDQuery;
  ruecknahme: string;
  i: integer;
begin
  fMain.FDConnection1.Connected := true;

  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := fMain.FDConnection1;
    with FDQuery do
    begin
      //Prüfen ob die Chipkarte mit der eingegebenen ChipkartenNr überhaupt vergeben ist.
      SQL.Add('SELECT id FROM chipkartenausgabe');
      SQL.Add('WHERE chipkartenNr = :chipkartenNr AND verlassen = :verlassen LIMIT 0, 1');
      ParamByName('chipkartenNr').AsString := KartenNr;
      ParamByName('verlassen').AsString := '';
      Open;

      if not FDQuery.IsEmpty then
      begin
        if MessageDlg('Wollen Sie die Chipkarte Nr ' + KartenNr + ' wirklich zurücknehmen?', mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes then
        begin
          ruecknahme := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now);
          SQL.Text   := 'UPDATE chipkartenausgabe SET verlassen = :verlassen ' +
                        'WHERE chipkartennr = :chipkartennr AND verlassen = :verl;';
          ParamByName('chipkartennr').AsString := KartenNr;
          ParamByName('verlassen').AsString    := ruecknahme;
          ParamByName('verl').AsString         := '';
          ExecSQL;

          i := fMain.lvChipkartenausgabe.ItemIndex;
          fMain.lvChipkartenausgabe.Items[i].SubItems[4] := ConvertSQLDateToGermanDate(ruecknahme, true);
        end //messagedlg
        else
        begin
          fChipkartenruecknahme.close;
        end;
      end
      else
      begin
        showmessage('Die Chipkarte mit der Nummer "' + KartenNr + '" ist nicht vergeben');
      end;
    end;
  finally
    FDQuery.Free;
  end;
  fMain.FDConnection1.Connected := false;

  fMain.ShowChipkartenausgabe('Ausgegeben');

  fChipkartenruecknahme.close;
end;







procedure TfChipkartenruecknahme.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Close;
  end;
end;

procedure TfChipkartenruecknahme.FormShow(Sender: TObject);
begin
  LoadAusgegebeneChipkarten(cbChipkartenNr, StatusBar1);
  cbChipkartenNr.ItemIndex := -1;
  cbChipkartenNr.SetFocus;
end;

end.
