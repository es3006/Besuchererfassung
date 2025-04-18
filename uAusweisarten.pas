unit uAusweisarten;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, AdvListV, FireDAC.Comp.Client, FireDAC.Stan.Param, System.UITypes,
  Vcl.Mask;

type
  TfAusweisarten = class(TForm)
    lvAusweisarten: TAdvListView;
    edAusweisart: TLabeledEdit;
    btnSpeichern: TButton;
    btnNeueAusweisart: TButton;
    lbTitle: TLabel;
    btnDelete: TButton;
    procedure FormShow(Sender: TObject);
    procedure lvAusweisartenSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure btnNeueAusweisartClick(Sender: TObject);
    procedure btnSpeichernClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure showAusweisartenFromDB;
  public
    { Public-Deklarationen }
  end;

var
  fAusweisarten: TfAusweisarten;
  EDITENTRY, NEWENTRY: boolean;
  SELECTEDID: integer;

implementation

{$R *.dfm}

uses uMain;

procedure TfAusweisarten.btnDeleteClick(Sender: TObject);
begin
  if(ADMIN) then
  begin
    if MessageDlg('Wollen Sie diese Ausweisart wirklich löschen?', mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes then
    begin
      with fMain.FDQuery1 do
      begin
        SQL.Text := 'DELETE FROM ausweisarten WHERE id = :id;';
        ParamByName('id').AsInteger := SELECTEDID;
        try
          ExecSQL;

          EDITENTRY := false;
          SELECTEDID := 0;

          showAusweisartenFromDB;
        except
          on E: Exception do
            ShowMessage('Fehler beim Löschen der Ausweisart: ' + E.Message);
        end;
      end;
    end;
  end
  else
  begin
    showmessage('Sie können diese Ausweisart nicht löschen, da Sie nicht über die nötigen Rechte verfügen!');
  end;
end;






procedure TfAusweisarten.btnNeueAusweisartClick(Sender: TObject);
begin
  NEWENTRY  := true;
  EDITENTRY := false;

  btnDelete.Enabled := false;
  edAusweisart.SetFocus;
  lvAusweisarten.ItemIndex := -1;
  SELECTEDID := 0;
  lbTitle.Caption := 'Neue Ausweisart';
end;






procedure TfAusweisarten.btnSpeichernClick(Sender: TObject);
begin
  //Neue Ausweisart in Datenbank schreiben
  if(NEWENTRY = true) then
  begin
    if(length(trim(edAusweisart.Text)) > 0) then
    begin
      with fMain.FDQuery1 do
      begin
        SQL.Text := 'INSERT INTO ausweisarten (ausweisart) ' +
                    'VALUES (:ausweisart);';
        ParamByName('ausweisart').AsString := edAusweisart.Text;
        try
          ExecSQL;

          showAusweisartenFromDB;

          edAusweisart.Clear;

          NEWENTRY := false;
          EDITENTRY := false;
          SELECTEDID := 0;
          lbTitle.Caption := 'Ausweisarten Übersicht';
        except
          on E: Exception do
            ShowMessage('Fehler beim Einfügen: ' + E.Message);
        end;
      end;
    end
    else
    begin
      showmessage('Bitte geben Sie den Namen für die neue Ausweisart ein!');
    end;
  end;




  if(EDITENTRY = true) AND (NEWENTRY = false) AND (SELECTEDID <> 0) then
  begin
    with fMain.FDQuery1 do
    begin
      SQL.Text := 'UPDATE ausweisarten SET ausweisart = :ausweisart WHERE id = :id;';
      ParamByName('id').AsInteger := SELECTEDID;
      ParamByName('ausweisart').AsString := trim(edAusweisart.Text);
      try
        ExecSQL;

        EDITENTRY := false;
        SELECTEDID := 0;

        showAusweisartenFromDB;

        edAusweisart.Clear;
      except
        on E: Exception do
          ShowMessage('Fehler beim Speichern der Änderungen: ' + E.Message);
      end;
    end;
  end;
  btnDelete.Enabled := false;
  lbTitle.Caption := 'Ausweisarten Übersicht';
end;








procedure TfAusweisarten.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;       // Fenster beim Schließen zerstören
  fAusweisarten := nil;   // Referenz zurücksetzen, damit es neu erzeugt werden kann
end;

procedure TfAusweisarten.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Close;
  end;
end;

procedure TfAusweisarten.FormShow(Sender: TObject);
begin
  NEWENTRY   := false;
  EDITENTRY  := false;
  SELECTEDID := 0;

  showAusweisartenFromDB;
end;



procedure TfAusweisarten.showAusweisartenFromDB;
var
  FDQuery: TFDQuery;
  l: TListItem;
begin
  fMain.FDConnection1.Connected := true;

  lvAusweisarten.Items.Clear;

  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := fMain.FDConnection1;

    FDQuery.SQL.Text := 'SELECT id, ausweisart FROM ausweisarten ORDER BY ausweisart ASC;';
    FDQuery.Open;

    while not FDQuery.Eof do
    begin
        l := lvAusweisarten.Items.Add;

        l.Caption := FDQuery.FieldByName('id').AsString;
        l.SubItems.Add(FDQuery.FieldByName('ausweisart').AsString);

        FDQuery.next;
    end;

  finally
    FDQuery.Free;
  end;

  fMain.FDConnection1.Connected := false;
end;



procedure TfAusweisarten.lvAusweisartenSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  if(Selected) then
  begin
    EDITENTRY := true;
    NEWENTRY  := false;

    btnDelete.Enabled := true;

    SELECTEDID := StrToInt(Item.Caption);
    edAusweisart.Text := Item.SubItems[0];

    lbTitle.Caption := 'Ausweisart bearbeiten';

   // if(ADMIN = true) then
   //   btnDelete.Visible := true;
  end
  else
  begin
    edAusweisart.Clear;

    lbTitle.Caption := 'Ausweisarten Übersicht';

    btnNeueAusweisartClick(nil);
  end;
end;


end.
