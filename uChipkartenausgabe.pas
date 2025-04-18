unit uChipkartenausgabe;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, FireDAC.Comp.Client,
  Vcl.Buttons, FireDAC.Stan.Param, Vcl.ComCtrls, Data.DB, System.UITypes;

type
  TfChipkartenausgabe = class(TForm)
    Panel1: TPanel;
    lbBeschreibung: TLabel;
    lbChipkartenStatus: TLabel;
    Shape1: TShape;
    Shape2: TShape;
    edChipkartenNr: TLabeledEdit;
    btnChipkartenausgabeSpeichern: TButton;
    edBesuchter: TLabeledEdit;
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
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure btnChipkartenausgabeSpeichernClick(Sender: TObject);
    procedure edChipkartenNrKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edGueltigBisKeyPress(Sender: TObject; var Key: Char);
    procedure edGueltigBisExit(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure edChipkartenNrKeyPress(Sender: TObject; var Key: Char);
    procedure cbEditBesucherdatenClick(Sender: TObject);
    procedure btnUpdateBesucherdatenClick(Sender: TObject);
  private
    procedure ResetFormular;
    procedure InsertChipkartenausgabeInDB(besucherID: integer);
    procedure UpdateBesucherInDB(besucherid: integer);
  public
    BESUCHERID: integer;
    procedure LoadBesucherdaten(besucherID: integer);
  end;

var
  fChipkartenausgabe: TfChipkartenausgabe;


implementation

{$R *.dfm}

uses
  uMain, uFunktionen, uDBFunctions;



procedure TfChipkartenausgabe.btnChipkartenausgabeSpeichernClick(Sender: TObject);
var
  ChipkartenNr, besuchter: string;
begin
  if(BESUCHERID <> 0) then
  begin
    chipkartenNr := trim(edChipkartenNr.Text);
    besuchter    := trim(edBesuchter.Text);

    if(chipkartenNr <> '') AND (besuchter <> '') then
    begin
      InsertChipkartenausgabeInDB(BESUCHERID);
    end
    else
    begin
      showmessage('Bitte füllen Sie die grün markierten Felder aus!');
      abort;
    end;


    fChipkartenausgabe.close;
  end;
end;












procedure TfChipkartenausgabe.InsertChipkartenausgabeInDB(besucherID: integer);
var
  FDQuery: TFDQuery;
  von: string;
  LastInsertID: integer;
begin
  fMain.FDConnection1.Connected := true;
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := fMain.FDConnection1;
    with FDQuery do
    begin
      von := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now);

      SQL.Text := 'INSERT INTO chipkartenausgabe (bedienerid, besucherid, ausweisnr,  chipkartennr, betreten, verlassen, besuchter, kfzkennzeichen, bemerkungen) ' +
                  'VALUES (:bedienerid, :besucherid, :ausweisnr, :chipkartennr, :betreten, :verlassen, :besuchter, :kfzkennzeichen, :bemerkungen)';
      ParamByName('bedienerid').AsInteger    := BEDIENERID;
      ParamByName('besucherid').AsInteger    := besucherID;
      ParamByName('ausweisnr').AsString      := edAusweisNr.Text;
      ParamByName('chipkartennr').AsString   := edChipkartenNr.Text;
      ParamByName('betreten').AsString       := von;
      ParamByName('verlassen').AsString      := '';
      ParamByName('besuchter').AsString      := edBesuchter.Text;
      ParamByName('kfzkennzeichen').AsString := edKfzKennzeichen.Text;
      ParamByName('bemerkungen').AsString    := edBemerkungen.Text;

      ExecSQL;

      SQL.Text := 'SELECT last_insert_rowid() AS LastID';
      Open;
      LastInsertID := FieldByName('LastID').AsInteger;

      fMain.PageControl1.ActivePageIndex := 2;
      fMain.rbHeute.Checked := true;
      fMain.rbHeuteClick(nil);
    end;
  finally
    FDQuery.Free;
  end;
  fMain.FDConnection1.Connected := false;
end;







procedure TfChipkartenausgabe.ResetFormular;
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

  edChipkartenNr.Clear;
  edBesuchter.Clear;
  edKfzKennzeichen.Clear;
  edBemerkungen.Clear;
end;





procedure TfChipkartenausgabe.btnUpdateBesucherdatenClick(Sender: TObject);
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







procedure TfChipkartenausgabe.UpdateBesucherInDB(besucherid: integer);
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








procedure TfChipkartenausgabe.cbEditBesucherdatenClick(Sender: TObject);
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

procedure TfChipkartenausgabe.edChipkartenNrKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then  // Überprüfung, ob die Enter-Taste gedrückt wurde
  begin
    Key := #0;  // Unterdrücken des normalen Enter-Tasten-Verhaltens
    Perform(WM_NEXTDLGCTL, 0, 0);  // Fokus auf das nächste Steuerelement verschieben
  end;
end;

procedure TfChipkartenausgabe.edChipkartenNrKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  FDQuery: TFDQuery;
begin
  fMain.FDConnection1.Connected := true;
  if(length(trim(edChipkartenNr.Text))>0) then
  begin
    fMain.FDConnection1.Connected := true;
    FDQuery := TFDQuery.Create(nil);
    try
      FDQuery.Connection := fMain.FDConnection1;
      FDQuery.SQL.Add('SELECT id AS anzahl FROM chipkartenausgabe');
      FDQuery.SQL.Add('WHERE chipkartenNr = :chipkartenNr AND verlassen = :verlassen;');
      FDQuery.ParamByName('chipkartenNr').AsInteger := StrToInt(edChipkartenNr.Text);
      FDQuery.ParamByName('verlassen').AsString := '';
      FDQuery.Open;
      if(FDQuery.FieldByName('anzahl').AsInteger > 0) then
      begin
        lbChipkartenStatus.Font.Color := clRed;
        lbChipkartenStatus.Caption := '(ausgegeben)';
        btnChipkartenausgabeSpeichern.Enabled := false;
      end
      else
      begin
        lbChipkartenStatus.Font.Color := clGreen;
        lbChipkartenStatus.Caption := '(verfügbar)';
        btnChipkartenausgabeSpeichern.Enabled := true;
      end;
    finally
      FDQuery.Free;
    end;
    fMain.FDConnection1.Connected := false;
  end
  else
  begin
    lbChipkartenStatus.Caption := '';
    btnChipkartenausgabeSpeichern.Enabled := false;
  end;
  fMain.FDConnection1.Connected := false;
end;




procedure TfChipkartenausgabe.edGueltigBisExit(Sender: TObject);
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




procedure TfChipkartenausgabe.edGueltigBisKeyPress(Sender: TObject; var Key: Char);
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






procedure TfChipkartenausgabe.FormCreate(Sender: TObject);
begin
  lbBeschreibung.Caption := 'Tragen Sie hier bitte die Nummer der Chipkarte ein, '+
                    'die Sie an den Besucher ausgeben! '+ #13#10 + #13#10 +
                    'Geben Sie außerdem den zu Besuchenden an!';
end;

procedure TfChipkartenausgabe.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Close;
  end;
end;

procedure TfChipkartenausgabe.FormShow(Sender: TObject);
begin
  ResetFormular;

  LoadAusweisarten(cbAusweisart);
  LoadStaaten(cbStaat);
  lbChipkartenStatus.Caption := '';

  edChipkartenNr.SetFocus;

  if(BESUCHERID <> 0) then
  begin
    LoadBesucherdaten(BESUCHERID);
  end;

  cbEditBesucherdaten.Checked := false;
  cbEditBesucherdatenClick(nil);
end;









procedure TfChipkartenausgabe.SpeedButton1Click(Sender: TObject);
begin
  showmessage('Geben Sie einen der mit einem Stern markierten Werte ein und klicken Sie auf den Suchen Button um das Formular mit den Daten der gefundenen Person automatisch zu füllen.'+#13#10+#13#10+'Farblich markierte Felder sind Pflichtfelder');
end;







procedure TfChipkartenausgabe.LoadBesucherdaten(besucherID: integer);
var
  FDQuery: TFDQuery;
  index: integer;
begin
  FDQuery := TFDQuery.Create(nil);
  try
    with FDQuery do
    begin
      Connection := fMain.FDConnection1;

      fMain.FDConnection1.Connected := true;

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
    fMain.FDConnection1.Connected := false;
  end;
end;









end.
