unit uStaaten;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, AdvListV, FireDAC.Comp.Client, FireDAC.Stan.Param, System.UITypes,
  Vcl.Mask;

type
  TfStaaten = class(TForm)
    lbTitle: TLabel;
    lvStaaten: TAdvListView;
    edStaat: TLabeledEdit;
    btnSpeichern: TButton;
    btnNeuerEintrag: TButton;
    btnDelete: TButton;
    edKuerzel: TLabeledEdit;
    cbStaatenliste: TCheckBox;
    procedure btnNeuerEintragClick(Sender: TObject);
    procedure lvStaatenSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnSpeichernClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure showStaatenFromDB;
  public
    { Public-Deklarationen }
  end;

var
  fStaaten: TfStaaten;
  EDITENTRY, NEWENTRY: boolean;
  SELECTEDID: integer;



implementation

{$R *.dfm}


uses uMain;



procedure TfStaaten.btnDeleteClick(Sender: TObject);
begin
  if(ADMIN) then
  begin
    if MessageDlg('Wollen Sie diesen Eintrag wirklich löschen?', mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes then
    begin
      with fMain.FDQuery1 do
      begin
        SQL.Text := 'DELETE FROM staaten WHERE id = :id;';
        ParamByName('id').AsInteger := SELECTEDID;
        try
          ExecSQL;

          EDITENTRY := false;
          SELECTEDID := 0;

          showStaatenFromDB;
        except
          on E: Exception do
            ShowMessage('Fehler beim Löschen des Eintrages: ' + E.Message);
        end;
      end;
    end;
  end
  else
  begin
    showmessage('Sie können diesen Eintrag nicht löschen, da Sie nicht über die nötigen Rechte verfügen!');
  end;
end;






procedure TfStaaten.btnNeuerEintragClick(Sender: TObject);
begin
  NEWENTRY  := true;
  EDITENTRY := false;

  btnDelete.Enabled := false;
  edKuerzel.SetFocus;
  lvStaaten.ItemIndex := -1;
  SELECTEDID := 0;
  lbTitle.Caption := 'Neuer Eintrag';
end;







procedure TfStaaten.btnSpeichernClick(Sender: TObject);
begin
  if(NEWENTRY = true) then
  begin
    if(length(trim(edStaat.Text)) > 0) then
    begin
      with fMain.FDQuery1 do
      begin
        SQL.Text := 'INSERT INTO staaten (kuerzel, staat, staatenliste) ' +
                    'VALUES (:kuerzel, :staat, :staatenliste);';
        ParamByName('kuerzel').AsString := edKuerzel.Text;
        ParamByName('staat').AsString := edKuerzel.Text;
        if(cbStaatenliste.Checked = true) then
          ParamByName('staatenliste').AsString := 'y'
        else
          ParamByName('staatenliste').AsString := '';

        try
          ExecSQL;

          showStaatenFromDB;

          edKuerzel.Clear;
          edStaat.Clear;
          cbStaatenliste.Checked := false;

          NEWENTRY := false;
          EDITENTRY := false;
          SELECTEDID := 0;
          lbTitle.Caption := 'Staaten Übersicht';
        except
          on E: Exception do
            ShowMessage('Fehler beim Einfügen: ' + E.Message);
        end;
      end;
    end
    else
    begin
      showmessage('Bitte geben Sie den Namen für den neuen Eintrag ein!');
    end;
  end;




  if(EDITENTRY = true) AND (NEWENTRY = false) AND (SELECTEDID <> 0) then
  begin
    with fMain.FDQuery1 do
    begin
      SQL.Text := 'UPDATE staaten SET kuerzel = :kuerzel, staat = :staat, staatenliste = :staatenliste WHERE id = :id;';
      ParamByName('id').AsInteger := SELECTEDID;
      ParamByName('kuerzel').AsString := trim(edKuerzel.Text);
      ParamByName('staat').AsString := trim(edStaat.Text);
      if(cbStaatenliste.Checked = true) then
        ParamByName('staatenliste').AsString := 'y'
      else
        ParamByName('staatenliste').AsString := '';

      try
        ExecSQL;

        EDITENTRY := false;
        SELECTEDID := 0;

        showStaatenFromDB;

        edKuerzel.Clear;
        edStaat.Clear;
        cbStaatenliste.Checked := false;
      except
        on E: Exception do
          ShowMessage('Fehler beim Speichern der Änderungen: ' + E.Message);
      end;
    end;
  end;
  btnDelete.Enabled := false;
  lbTitle.Caption := 'Staaten Übersicht';
end;








procedure TfStaaten.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;   // Fenster beim Schließen zerstören
  fSTaaten := nil;    // Referenz zurücksetzen, damit es neu erzeugt werden kann
end;

procedure TfStaaten.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Close;
  end;
end;

procedure TfStaaten.FormShow(Sender: TObject);
begin
  NEWENTRY   := false;
  EDITENTRY  := false;
  SELECTEDID := 0;

  showStaatenFromDB;
end;

procedure TfStaaten.lvStaatenSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  if(Selected) then
  begin
    EDITENTRY := true;
    NEWENTRY  := false;

    btnDelete.Enabled := true;

    SELECTEDID     := StrToInt(Item.Caption);
    edKuerzel.Text := Item.SubItems[0];
    edStaat.Text   := Item.SubItems[1];
    if Item.SubItems[2] = 'y' then
      cbStaatenliste.Checked := true
    else
      cbStaatenliste.Checked := false;

    lbTitle.Caption := 'Eintrag bearbeiten';

   // if(ADMIN = true) then
   //   btnDelete.Visible := true;
  end
  else
  begin
    edKuerzel.Clear;
    edStaat.Clear;
    cbStaatenliste.Checked := false;;

    lbTitle.Caption := 'Staaten Übersicht';
  end;
end;





procedure TfStaaten.showStaatenFromDB;
var
  FDQuery: TFDQuery;
  l: TListItem;
begin
  fMain.FDConnection1.Connected := true;

  lvStaaten.Items.Clear;

  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := fMain.FDConnection1;

    FDQuery.SQL.Text := 'SELECT id, kuerzel, staat, staatenliste FROM staaten ORDER BY staat ASC;';
    FDQuery.Open;

    while not FDQuery.Eof do
    begin
        l := lvStaaten.Items.Add;

        l.Caption := FDQuery.FieldByName('id').AsString;
        l.SubItems.Add(FDQuery.FieldByName('kuerzel').AsString);
        l.SubItems.Add(FDQuery.FieldByName('staat').AsString);
        l.SubItems.Add(FDQuery.FieldByName('staatenliste').AsString);

        FDQuery.next;
    end;

  finally
    FDQuery.Free;
  end;

  fMain.FDConnection1.Connected := false;
end;

end.
