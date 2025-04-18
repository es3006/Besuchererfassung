unit uBesucheranmeldungEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, System.UITypes,
  FireDAC.Comp.Client, FireDAC.Stan.Param, Data.DB;

type
  TfBesucheranmeldungEdit = class(TForm)
    Panel1: TPanel;
    lbBeschreibung: TLabel;
    Shape3: TShape;
    Shape2: TShape;
    btnAnmeldungSpeichern: TButton;
    edAnmeldungVon: TLabeledEdit;
    edAnmeldungBis: TLabeledEdit;
    edBesuchter: TLabeledEdit;
    btnDeleteAnmeldung: TButton;
    Shape5: TShape;
    edKfzKennzeichen: TLabeledEdit;
    edBemerkungen: TLabeledEdit;
    Panel2: TPanel;
    lbAusweisArt: TLabel;
    lbStaat: TLabel;
    edNachname: TLabeledEdit;
    edVorname: TLabeledEdit;
    edFirma: TLabeledEdit;
    edAusweisNr: TLabeledEdit;
    cbAusweisart: TComboBox;
    edStrasseHausNr: TLabeledEdit;
    edPLZWohnort: TLabeledEdit;
    cbStaat: TComboBox;
    edGueltigBis: TLabeledEdit;
    edRegistriert: TLabeledEdit;
    cbEditBesucherdaten: TCheckBox;
    btnUpdateBesucherdaten: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edAnmeldungVonExit(Sender: TObject);
    procedure edAnmeldungVonKeyPress(Sender: TObject; var Key: Char);
    procedure btnAnmeldungSpeichernClick(Sender: TObject);
    procedure btnDeleteAnmeldungClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure cbEditBesucherdatenClick(Sender: TObject);
    procedure btnUpdateBesucherdatenClick(Sender: TObject);
  private
    procedure LoadBesucherAnmeldedaten;
    procedure ResetFormular;
    procedure UpdateBesucheranmeldungInDB;
    procedure DeleteBesucheranmeldungFromDB;
    procedure UpdateBesucherInDB(besucherid: integer);
  public
    ANMELDUNGID, BESUCHERID: integer;
  end;

var
  fBesucheranmeldungEdit: TfBesucheranmeldungEdit;

implementation

{$R *.dfm}

uses uMain, uFunktionen, uDBFunctions, uBesucheranmeldung;


procedure TfBesucheranmeldungEdit.FormCreate(Sender: TObject);
begin
  lbBeschreibung.Caption := 'Sie haben einen Fehler beim erfassen der Anmeldedaten gemacht?'+#13#10+#13#10+
  'Hier können Sie die Anmeldedaten für den Besucher berichtigen oder die Anmeldung löschen.';
end;




procedure TfBesucheranmeldungEdit.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Close;
  end;
end;

procedure TfBesucheranmeldungEdit.FormShow(Sender: TObject);
begin
  ResetFormular;

  if(ANMELDUNGID<>0) then
  begin
    LoadAusweisarten(cbAusweisart);
    LoadStaaten(cbStaat);
    LoadBesucherAnmeldedaten;
    edAnmeldungVon.SetFocus;
    edAnmeldungVon.SelLength := 0;
  end;

  cbEditBesucherdaten.Checked := false;
  cbEditBesucherdatenClick(nil);
end;




procedure TfBesucheranmeldungEdit.LoadBesucherAnmeldedaten;
var
  FDQuery: TFDQuery;
  index: integer;
begin
  FDQuery := TFDQuery.Create(nil);
  try
    with FDQuery do
    begin
      Connection := fMain.FDConnection1;

      SQL.Clear;
      SQL.Text := 'SELECT B.id, B.nachname, B.vorname, B.firma, B.strasse_hausnummer, B.plz_ort, B.ausweisnummer, ' +
                  'B.ausweisart, B.ausstellungsstaat, B.gueltigbis, B.registriert, ' +
                  'A.anmeldung_von, A.anmeldung_bis, A.besuchter, A.kfzkennzeichen, A.bemerkungen ' +
                  'FROM besucher AS B LEFT JOIN besucheranmeldungen AS A ON A.besucherID = B.id ' +
                  'WHERE A.id = :anmeldungID LIMIT 0, 1;';
      ParamByName('anmeldungID').AsInteger := ANMELDUNGID;
      Open;

      if not FDQuery.IsEmpty then
      begin
        //Besucherdaten
        BESUCHERID           := FieldByName('id').AsInteger;
        edNachname.Text      := FieldByName('nachname').AsString;
        edVorname.Text       := FieldByName('vorname').AsString;
        edFirma.Text         := FieldByName('firma').AsString;
        edStrasseHausNr.Text := FieldByName('strasse_hausnummer').AsString;
        edPlzWohnort.Text    := FieldByName('plz_ort').AsString;
        edAusweisNr.Text     := FieldByName('ausweisnummer').AsString;


        Index := cbAusweisart.Items.IndexOf(FieldByName('ausweisart').AsString);
        if Index <> -1 then
        begin
          cbAusweisart.ItemIndex := Index;
        end;

        edGueltigBis.Text := ConvertSQLDateToGermanDate(FieldByName('gueltigbis').AsString, false);

        Index := cbStaat.Items.IndexOf(FieldByName('ausstellungsstaat').AsString);
        if Index <> -1 then
        begin
          cbStaat.ItemIndex := Index;
        end;

        edRegistriert.Text := ConvertSQLDateToGermanDate(FieldByName('registriert').AsString, false);


        //Besucheranmeldedaten
        edAnmeldungVon.Text := ConvertSQLDateToGermanDate(FDQuery.FieldByName('anmeldung_von').AsString, false);
        edAnmeldungBis.Text := ConvertSQLDateToGermanDate(FDQuery.FieldByName('anmeldung_bis').AsString, false);
        edBesuchter.Text    := FieldByName('besuchter').AsString;
        edKfzKennzeichen.Text := FieldByName('kfzkennzeichen').AsString;
        edBemerkungen.Text := FieldByName('bemerkungen').AsString;
      end;
    end;
  finally
    FDQuery.Free;
  end;
end;








procedure TfBesucheranmeldungEdit.UpdateBesucheranmeldungInDB;
var
  FDQuery: TFDQuery;
  von, bis, besuchter: string;
  i: integer;
begin
  von := trim(edAnmeldungVon.Text);
  bis := trim(edAnmeldungBis.Text);
  besuchter := trim(edBesuchter.Text);

  if(von<>'') AND (bis<>'') AND (besuchter<>'') then
  begin
    fMain.FDConnection1.Connected := true;
    FDQuery := TFDQuery.Create(nil);
    try
      FDQuery.Connection := fMain.FDConnection1;

      with FDQuery do
      begin
        // Initialisieren der FormatSettings
        FormatSettings := TFormatSettings.Create;
        FormatSettings.ShortDateFormat := 'dd.mm.yyyy';
        FormatSettings.DateSeparator := '.';

        von := FormatDateTime('YYYY-MM-DD', StrToDate(edAnmeldungVon.Text));
        bis := FormatDateTime('YYYY-MM-DD', StrToDate(edAnmeldungBis.Text));

        //Änderungen der Anmeldedaten in Datenbank speichern
        SQL.Clear;
        SQL.Text := 'UPDATE besucheranmeldungen SET bedienerID = :bedienerid, besucherID = :besucherid, ' +
                    'anmeldung_von = :von, anmeldung_bis = :bis, besuchter = :besuchter, ' +
                    'kfzkennzeichen = :kennzeichen, bemerkungen = :bemerkungen ' +
                    'WHERE id = :id;';
        ParamByName('id').AsInteger         := ANMELDUNGID;
        ParamByName('bedienerid').AsInteger := uMain.BEDIENERID;
        ParamByName('besucherid').AsInteger := BESUCHERID;
        ParamByName('von').AsString         := von;
        ParamByName('bis').AsString         := bis;
        ParamByName('besuchter').AsString   := edBesuchter.Text;
        ParamByName('kennzeichen').AsString := edKfzKennzeichen.Text;
        ParamByName('bemerkungen').AsString := edBemerkungen.Text;
        ExecSQL;
      end;
    finally
      FDQuery.Free;
    end;
    fMain.FDConnection1.Connected := false;

    //ShowMessage('Die Änderungen an der Anmeldung wurde erfolgreich gespeichert');

    //Eintrag in fMain.lvAnmeldungen aktualisieren
    i := fMain.lvAnmeldungen.ItemIndex;

    with fMain.lvAnmeldungen.Items[i] do
    begin
     // SubItems[1] := edAusweisnr.Text;
      SubItems[2] := edFirma.Text;
      SubItems[3] := edAnmeldungVon.Text;
      SubItems[4] := edAnmeldungBis.Text;
      SubItems[5] := edBesuchter.Text;
      SubItems[6] := edKfzKennzeichen.Text;
      SubItems[7] := edBemerkungen.Text;
    end;

    fBesucheranmeldungEdit.Close;

    abort;
  end
  else
  begin
    showmessage('Bitte füllen Sie die grün markierten Felder aus!');
  end;
end;






procedure TfBesucheranmeldungEdit.DeleteBesucheranmeldungFromDB;
var
  FDQuery: TFDQuery;
  i: integer;
begin
  if(ANMELDUNGID<>0) then
  begin
    fMain.FDConnection1.Connected := true;
    FDQuery := TFDQuery.Create(nil);
    try
      FDQuery.Connection := fMain.FDConnection1;

      with FDQuery do
      begin
        SQL.Add('DELETE FROM besucheranmeldungen WHERE id = :id;');
        ParamByName('id').AsInteger := ANMELDUNGID;
        ExecSQL;
      end;
    finally
      FDQuery.Free;
    end;
    fMain.FDConnection1.Connected := false;

    i := fMain.lvAnmeldungen.ItemIndex;
    fMain.lvAnmeldungen.Items[i].Delete;
    fMain.lvAnmeldungen.Update;

    fBesucheranmeldungEdit.Close;

    abort;
  end;
end;



procedure TfBesucheranmeldungEdit.ResetFormular;
begin
  edNachname.Clear;
  edVorname.Clear;
  edFirma.Clear;
  edStrasseHausNr.Clear;
  edPLZWohnort.Clear;
  edAusweisNr.Clear;
  cbAusweisart.ItemIndex := -1;
  edGueltigBis.Clear;
  cbStaat.ItemIndex := -1;
  edRegistriert.Clear;

  edAnmeldungVon.Clear;
  edAnmeldungBis.Clear;
  edBesuchter.Clear;
  edKfzKennzeichen.Clear;
  edBemerkungen.Clear;
end;






procedure TfBesucheranmeldungEdit.btnAnmeldungSpeichernClick(Sender: TObject);
begin
  UpdateBesucheranmeldungInDB;
end;







procedure TfBesucheranmeldungEdit.btnDeleteAnmeldungClick(Sender: TObject);
begin
  if MessageDlg('Wollen Sie diese Anmeldung wirklich löschen?', mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes then
  begin
    DeleteBesucheranmeldungFromDB;
  end;
end;







procedure TfBesucheranmeldungEdit.btnUpdateBesucherdatenClick(Sender: TObject);
var
  nachname, vorname, ausweisnr, ausweisart, staat, gueltigbis: string;
  save: boolean;
begin
  save         := true;

  nachname     := trim(edNachname.Text);
  vorname      := trim(edVorname.Text);
  ausweisnr    := trim(edAusweisNr.Text);

  ausweisart   := cbAusweisart.Text;
  staat        := cbStaat.Text;
  gueltigbis   := edGueltigBis.Text;

  //prüfen ob Pflichtfelder  (grün markiert) ausgefüllt wurden
  if(length(nachname)>0) AND (length(vorname)>0) AND (length(ausweisnr)>0) then
  begin
    //prüfen ob Pflichtfelder (orange markiert) ausgefüllt wurden
    if (length(ausweisart)>0) AND (staat<>'') AND (length(gueltigbis)>0) then
    begin
      if IsOnTheListOfStates(cbStaat.Items[cbStaat.ItemIndex]) then
      begin
        if MessageDlg('ACHTUNG: ' + cbStaat.Items[cbStaat.ItemIndex]+' steht auf der Staatenliste!'+#13#10+#13#10+
        'Wollen Sie den Besucher trotzdem speichern?', mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes then
        begin
          save := true;
        end
        else
        begin
          save := false;
        end;
      end;
    end
    else
    begin
      showmessage('Bitte denken Sie daran, die Ausweisart, den Ausstellungsstaat und das Ausweis Gültigkeitsdatum nachzutragen!');
    end;

    if(save = true) then
    begin
      UpdateBesucherInDB(BESUCHERID);
    end;
  end
  else
  begin
    showmessage('Bitte füllen Sie alle grün markierten Pflichtfelder aus!');
  end;




  cbEditBesucherdaten.Checked := false;
  cbEditBesucherdatenClick(nil);
end;





procedure TfBesucheranmeldungEdit.UpdateBesucherInDB(besucherid: integer);
var
  FDQuery: TFDQuery;
begin
  if(besucherID > 0) then
  begin
    fMain.FDConnection1.Connected := true;
    FDQuery := TFDQuery.Create(nil);
    try
      FDQuery.Connection := fMain.FDConnection1;

      with FDQuery do
      begin
        SQL.Text := 'UPDATE besucher SET nachname = :nachname, vorname = :vorname, firma = :firma, ' +
                    'strasse_hausnummer = :strassenr, plz_ort = :plzort, ausweisnummer = :ausweisnr, ' +
                    'ausweisart = :ausweisart, ausstellungsstaat = :staat, gueltigbis = :gueltigbis, ' +
                    'registriert = :registriert WHERE id = :besucherid;';
        ParamByName('nachname').AsString      := edNachname.Text;
        ParamByName('vorname').AsString       := edVorname.Text;
        ParamByName('firma').AsString         := edFirma.Text;
        ParamByName('strassenr').AsString     := edStrasseHausNr.Text;
        ParamByName('plzort').AsString        := edPlzWohnort.Text;
        ParamByName('ausweisnr').AsString     := edAusweisnr.Text;
        ParamByName('ausweisart').AsString    := cbAusweisart.Text;
        ParamByName('staat').AsString         := cbStaat.Text;
        ParamByName('gueltigbis').AsString    := ConvertGermanDateToSQLDate(edGueltigBis.Text, false);
        ParamByName('registriert').AsString   := ConvertGermanDateToSQLDate(DateToStr(now), false);
        ParamByName('besucherid').AsInteger   := besucherid;

        ExecSQL;
      end;
    finally
      FDQuery.Free;
    end;
    fMain.FDConnection1.Connected := false;
  end
  else
  begin
    showmessage('Es wurde keine BesucherID übergeben!');
  end;
end;






procedure TfBesucheranmeldungEdit.cbEditBesucherdatenClick(Sender: TObject);
begin
  if(cbEditBesucherdaten.Checked) then
  begin
    edNachname.Enabled := true;
    edVorname.Enabled := true;
    edFirma.Enabled := true;
    edStrasseHausNr.Enabled := true;
    edPlzWohnort.Enabled := true;
    edAusweisNr.Enabled := true;
    cbAusweisArt.Enabled := true;
    lbAusweisArt.Enabled := true;
    edGueltigBis.Enabled := true;
    cbStaat.Enabled := true;
    lbStaat.Enabled := true;
    btnUpdateBesucherdaten.Visible := true;
  end
  else
  begin
    edNachname.Enabled := false;
    edVorname.Enabled := false;
    edFirma.Enabled := false;
    edStrasseHausNr.Enabled := false;
    edPlzWohnort.Enabled := false;
    edAusweisNr.Enabled := false;
    cbAusweisArt.Enabled := false;
    lbAusweisArt.Enabled := false;
    edGueltigBis.Enabled := false;
    cbStaat.Enabled := false;
    lbStaat.Enabled := false;
    btnUpdateBesucherdaten.Visible := false;
  end;
end;

procedure TfBesucheranmeldungEdit.edAnmeldungVonExit(Sender: TObject);
var
  DateValue: TDateTime;
begin
  if(length(trim(TLabeledEdit(Sender).Text))>0) then
  begin
    if not TryStrToDate(TLabeledEdit(Sender).Text, DateValue) then
    begin
      ShowMessage('Bitte geben Sie ein gültiges Datum im Format TT.MM.JJJJ ein.');
      TLabeledEdit(Sender).SetFocus;
    end;
  end;
end;




procedure TfBesucheranmeldungEdit.edAnmeldungVonKeyPress(Sender: TObject; var Key: Char);
var
  Text: string;
begin
  // Erlaubte Zeichen: Ziffern und die Backspace-Taste
  if not CharInSet(Key, ['0'..'9', #8]) then
  begin
    Key := #0;
    Exit;
  end;

  Text := TLabeledEdit(Sender).Text;

  // Automatisches Einfügen von Punkten nach Tag und Monat
  if CharInSet(Key, ['0'..'9']) and (Length(Text) in [1, 4]) then
  begin
    Text := Text + Key + '.';
    TLabeledEdit(Sender).Text := Text;
    TLabeledEdit(Sender).SelStart := Length(Text);
    Key := #0;
  end;
end;




end.
