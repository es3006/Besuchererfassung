unit uBesucheranmeldung;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, System.UITypes,
  FireDAC.Comp.Client, FireDAC.Stan.Param, Data.DB, Vcl.ComCtrls;

type
  TfBesucheranmeldung = class(TForm)
    Panel1: TPanel;
    Label3: TLabel;
    Shape1: TShape;
    btnAnmeldungSpeichern: TButton;
    edAnmeldungVon: TLabeledEdit;
    edAnmeldungBis: TLabeledEdit;
    edBesuchter: TLabeledEdit;
    edBemerkungen: TLabeledEdit;
    Shape4: TShape;
    Shape6: TShape;
    edKfzKennzeichen: TLabeledEdit;
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
    procedure FormShow(Sender: TObject);
    procedure btnAnmeldungSpeichernClick(Sender: TObject);
    procedure edAnmeldungVonExit(Sender: TObject);
    procedure edAnmeldungVonKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure edBesuchterKeyPress(Sender: TObject; var Key: Char);
    procedure btnUpdateBesucherdatenClick(Sender: TObject);
    procedure cbEditBesucherdatenClick(Sender: TObject);
  private
    procedure ResetFormular;
    procedure InsertBesucheranmeldungInDB;
    procedure LoadBesucherdaten(besucherID: integer);
    procedure UpdateBesucherInDB(besucherid: integer);
  public
    BESUCHERID: integer;
  end;

var
  fBesucheranmeldung: TfBesucheranmeldung;

implementation

{$R *.dfm}

uses uMain, uFunktionen, uDBFunctions;

procedure TfBesucheranmeldung.btnAnmeldungSpeichernClick(Sender: TObject);
var
  DateValue: TDateTime;
begin
  if Trim(edAnmeldungVon.Text) = '' then
  begin
    ShowMessage('Bitte geben Sie in das Feld "Anmeldung Von"'+#13#10+'ein gültiges Datum ein.');
    edAnmeldungVon.SetFocus;
    Exit;
  end;

  if not TryStrToDate(edAnmeldungVon.Text, DateValue) then
  begin
    ShowMessage('"' + edAnmeldungVon.Text + '" ist keine gültige Datumsangabe.');
    edAnmeldungVon.SetFocus;
    Exit;
  end;


  if(length(trim(edAnmeldungBis.Text))=0) then
  begin
    edAnmeldungBis.Text := edAnmeldungVon.Text;
  end;

  InsertBesucheranmeldungInDB;
end;






procedure TfBesucheranmeldung.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Close;
  end;
end;

procedure TfBesucheranmeldung.FormShow(Sender: TObject);
begin
  ResetFormular;

  if(BESUCHERID<>0) then
  begin
    LoadAusweisarten(cbAusweisart);
    LoadStaaten(cbStaat);
    LoadBesucherdaten(BESUCHERID);   //dbFunctions.pas
    edAnmeldungVon.SetFocus;
  end;

  cbEditBesucherdaten.Checked := false;
  cbEditBesucherdatenClick(nil);
end;







procedure TfBesucheranmeldung.InsertBesucheranmeldungInDB;
var
  FDQuery: TFDQuery;
  LastInsertID: Integer;
  von, bis, besuchter: string;
  AnmeldungVonDatum, AktuellesDatum: TDateTime;
begin
  von       := trim(edAnmeldungVon.Text);
  bis       := trim(edAnmeldungBis.Text);
  besuchter := trim(edBesuchter.Text);

  AnmeldungVonDatum := StrToDateTime(von);
  AktuellesDatum := Date;

  if(von<>'') AND (bis<>'') AND (besuchter<>'') then
  begin
    fMain.FDConnection1.Connected := true;
    FDQuery := TFDQuery.Create(nil);
    try
      FDQuery.Connection := fMain.FDConnection1;

      with FDQuery do
      begin
        von := FormatDateTime('YYYY-MM-DD', StrToDate(edAnmeldungVon.Text));
        bis := FormatDateTime('YYYY-MM-DD', StrToDate(edAnmeldungBis.Text));

        //Besucher in Datenbank speichern
        SQL.Text := 'INSERT INTO besucheranmeldungen (bedienerID, besucherID, ausweisnr, anmeldung_von, anmeldung_bis, besuchter, kfzkennzeichen, bemerkungen) ' +
                    'VALUES (:bedienerid, :besucherid, :ausweisnr, :von, :bis, :besuchter, :kfzkennzeichen, :bemerkungen)';
        ParamByName('bedienerid').AsInteger    := uMain.BEDIENERID;
        ParamByName('besucherid').AsInteger    := BESUCHERID;
        ParamByName('ausweisnr').AsString      := edAusweisNr.Text;
        ParamByName('von').AsString            := von;
        ParamByName('bis').AsString            := bis;
        ParamByName('besuchter').AsString      := edBesuchter.Text;
        ParamByName('kfzkennzeichen').AsString := edKfzKennzeichen.Text;
        ParamByName('bemerkungen').AsString    := edBemerkungen.Text;

        ExecSQL;

        SQL.Text := 'SELECT last_insert_rowid() AS LastID';
        Open;
        LastInsertID := FieldByName('LastID').AsInteger;
      end;
    finally
      FDQuery.Free;
    end;
    fMain.FDConnection1.Connected := false;

    if(LastInsertID<>0) then
    begin
      with fMain do
      begin
        //fMain.lvAnmeldungen sichtbar machen
        PageControl1.ActivePageIndex := 1;



        //Je nachdem ob das Anmeldedatum aktuell ist, in der Zukunft oder der Vergangenheit liegt, CheckBox auswählen
        if(AnmeldungVonDatum > AktuellesDatum) then
        begin
          rbZukuenftigeAnmeldungen.Checked := true;
          rbZukuenftigeAnmeldungenClick(self);
        end
        else if(AnmeldungVonDatum < AktuellesDatum) then
        begin
          rbAbgelaufeneAnmeldungen.Checked := true;
          rbAbgelaufeneAnmeldungenClick(self);
        end
        else
        begin
          rbAktuelleAnmeldungen.Checked := true;
          rbAktuelleAnmeldungenClick(self);
        end;
        lvAnmeldungen.Update;
        lvAnmeldungen.SortColumn := 3; //nach Anmeldung Von sortieren
        lvAnmeldungen.Sort;
        FindAndSelectListViewItem(fMain.lvAnmeldungen, IntToStr(LastInsertID), [0]);
      end;


      fBesucheranmeldung.Close;
      abort;
    end;
  end
  else
  begin
    showmessage('Bitte füllen Sie die grün markierten Felder aus!');
  end;
end;







procedure TfBesucheranmeldung.LoadBesucherdaten(besucherID: integer);
var
  FDQuery: TFDQuery;
  index: integer;
begin
  FDQuery := TFDQuery.Create(nil);
  try
    with FDQuery do
    begin
      Connection := fMain.FDConnection1;

      SQL.Add('SELECT nachname, vorname, firma, strasse_hausnummer, plz_ort, ausweisnummer,');
      SQL.Add('ausweisart, ausstellungsstaat, gueltigbis, registriert');
      SQL.Add('FROM besucher WHERE id = :besucherid LIMIT 0, 1');
      ParamByName('besucherid').AsInteger := BESUCHERID;
      Open;

      if not FDQuery.IsEmpty then
      begin
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

        Index := cbStaat.Items.IndexOf(FieldByName('ausstellungsstaat').AsString);
        if Index <> -1 then
        begin
          cbStaat.ItemIndex := Index;
        end;


        edGueltigBis.Text  := ConvertSQLDateToGermanDate(FieldByName('gueltigbis').AsString, false);
        edRegistriert.Text := ConvertSQLDateToGermanDate(FieldByName('registriert').AsString, false);
      end;
    end;
  finally
    FDQuery.Free;
  end;
end;




procedure TfBesucheranmeldung.ResetFormular;
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

  edAnmeldungVon.Clear;
  edAnmeldungBis.Clear;
  edBesuchter.Clear;
  edKfzKennzeichen.Clear;
  edBemerkungen.Clear;
end;






procedure TfBesucheranmeldung.btnUpdateBesucherdatenClick(Sender: TObject);
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





procedure TfBesucheranmeldung.UpdateBesucherInDB(besucherid: integer);
var
  FDQuery: TFDQuery;
  i: Integer;
begin
  if(besucherID > 0) then
  begin
    i := fMain.lvBesucher.ItemIndex;

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


        with fMain.lvBesucher.Items[i] do
        begin
          SubItems[0] := edNachname.Text;
          SubItems[1] := edVorname.Text;
          SubItems[2] := edFirma.Text;
          SubItems[3] := edAusweisNr.Text;
          SubItems[4] := cbAusweisArt.Text;
          SubItems[5] := cbStaat.Text;
          SubItems[6] := edGueltigBis.Text;
        end;
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





procedure TfBesucheranmeldung.cbEditBesucherdatenClick(Sender: TObject);
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

procedure TfBesucheranmeldung.edAnmeldungVonExit(Sender: TObject);
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


procedure TfBesucheranmeldung.edAnmeldungVonKeyPress(Sender: TObject; var Key: Char);
var
  Text: string;
begin
  if Key = #13 then  // Überprüfung, ob die Enter-Taste gedrückt wurde
  begin
    Key := #0;  // Unterdrücken des normalen Enter-Tasten-Verhaltens
    Perform(WM_NEXTDLGCTL, 0, 0);  // Fokus auf das nächste Steuerelement verschieben
  end;

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




procedure TfBesucheranmeldung.edBesuchterKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then  // Überprüfung, ob die Enter-Taste gedrückt wurde
  begin
    Key := #0;  // Unterdrücken des normalen Enter-Tasten-Verhaltens
    Perform(WM_NEXTDLGCTL, 0, 0);  // Fokus auf das nächste Steuerelement verschieben
  end;
end;

end.
