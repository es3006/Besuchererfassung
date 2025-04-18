unit uNewAusstellungsstaat;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, FireDAC.Comp.Client,
  FireDAC.Stan.Param, System.UITypes, Data.DB;

type
  TfNewAusstellungsstaat = class(TForm)
    Shape3: TShape;
    Label1: TLabel;
    edStaat: TLabeledEdit;
    btnAddState: TButton;
    procedure btnAddStateClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edStaatKeyPress(Sender: TObject; var Key: Char);
  private
    function StaatSchonVorhanden(staat: string): boolean;
  public
    { Public-Deklarationen }
  end;

var
  fNewAusstellungsstaat: TfNewAusstellungsstaat;

implementation

{$R *.dfm}

uses uMain, uBesuchererfassung, uDBFunctions;

procedure TfNewAusstellungsstaat.btnAddStateClick(Sender: TObject);
var
  staat: string;
  FDQuery: TFDQuery;
  Index: integer;
begin
  staat := trim(edStaat.Text);

  if(staat <> '') then
  begin
    if(StaatSchonVorhanden(staat) = false) then
    begin
      //Neuen Staat in Datenbanktabelle staaten speichern
      fMain.FDConnection1.Connected := true;
      FDQuery := TFDQuery.Create(nil);
      try
        FDQuery.Connection := fMain.FDConnection1;
        with FDQuery do
        begin
          SQL.Text := 'INSERT INTO staaten (staat) VALUES (:staat);';
          ParamByName('staat').AsString := edStaat.Text;
          ExecSQL;
        end;
      finally
        FDQuery.Free;
      end;
      fMain.FDConnection1.Connected := false;


      //Liste der Staaten in ComboBox auf Form Besuchererfassung neu laden
      LoadStaaten(fBesuchererfassung.cbStaat);

      //Neu eingegebenen Staat in ComboBox auswählen
      Index := fBesuchererfassung.cbStaat.Items.IndexOf(staat);
      if Index <> -1 then
        fBesuchererfassung.cbStaat.ItemIndex := Index;

      //Form schließen
      fNewAusstellungsstaat.Close;
    end
    else
    begin
      showmessage('Dieser Staat steht bereits in der Datenbank');
    end;
  end;
end;




procedure TfNewAusstellungsstaat.edStaatKeyPress(Sender: TObject; var Key: Char);
begin
  if(Key = #13) then
  begin
    key := #0;
    btnAddStateClick(nil);
  end;

  if Key = #27 then
  begin
    Close;
  end;
end;

procedure TfNewAusstellungsstaat.FormShow(Sender: TObject);
begin
  edStaat.Clear;
  edStaat.SetFocus;
end;

function TfNewAusstellungsstaat.StaatSchonVorhanden(staat: string): boolean;
var
  FDQuery: TFDQuery;
begin
  fMain.FDConnection1.Connected := true;
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := fMain.FDConnection1;
    with FDQuery do
    begin
      //Prüfen ob die Chipkarte mit der eingegebenen ChipkartenNr überhaupt vergeben ist.
      SQL.Add('SELECT id FROM staaten WHERE staat = :staat LIMIT 0, 1');
      ParamByName('staat').AsString := staat;
      Open;
      if FDQuery.IsEmpty then result := false else result := true;
    end;
  finally
    FDQuery.Free;
  end;
  fMain.FDConnection1.Connected := false;
end;


end.
