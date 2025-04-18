unit uChipkartenausgabeEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  FireDAC.Comp.Client, Vcl.Buttons, FireDAC.Stan.Param, Data.DB, System.UITypes;

type
  TfChipkartenausgabeEdit = class(TForm)
    Panel1: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    lbBetreten: TLabel;
    Label6: TLabel;
    lbVerlassen: TLabel;
    Label5: TLabel;
    lbChipkartenNr: TLabel;
    btnChipkartenausgabeSpeichern: TButton;
    edBesuchter: TLabeledEdit;
    Shape2: TShape;
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
    procedure btnChipkartenausgabeSpeichernClick(Sender: TObject);
    procedure edBetretenExit(Sender: TObject);
    procedure edBetretenKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure edBesuchterKeyPress(Sender: TObject; var Key: Char);
    procedure btnUpdateBesucherdatenClick(Sender: TObject);
    procedure cbEditBesucherdatenClick(Sender: TObject);
    procedure edGueltigBisExit(Sender: TObject);
    procedure edGueltigBisKeyPress(Sender: TObject; var Key: Char);
  private
    procedure UpdateChipkartenausgabeInDB;
    procedure ShowChipkartenausgabenRuecknahmen;
    procedure LoadBesucherdaten(besucherID: integer);
    procedure UpdateBesucherInDB(besucherid: integer);
  public
    ID, BESUCHERID: integer;
  end;

var
  fChipkartenausgabeEdit: TfChipkartenausgabeEdit;

implementation

{$R *.dfm}

uses uMain, uFunktionen, uDBFunctions;



procedure TfChipkartenausgabeEdit.btnChipkartenausgabeSpeichernClick(Sender: TObject);
begin
  UpdateChipkartenausgabeInDB;
end;




procedure TfChipkartenausgabeEdit.btnUpdateBesucherdatenClick(Sender: TObject);
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





procedure TfChipkartenausgabeEdit.UpdateBesucherInDB(besucherid: integer);
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







procedure TfChipkartenausgabeEdit.cbEditBesucherdatenClick(Sender: TObject);
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

procedure TfChipkartenausgabeEdit.edBesuchterKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then  // Überprüfung, ob die Enter-Taste gedrückt wurde
  begin
    Key := #0;  // Unterdrücken des normalen Enter-Tasten-Verhaltens
    Perform(WM_NEXTDLGCTL, 0, 0);  // Fokus auf das nächste Steuerelement verschieben
  end;
end;

procedure TfChipkartenausgabeEdit.edBetretenExit(Sender: TObject);
var
  DateValue: TDateTime;
  FormatSettings: TFormatSettings;
begin
  if(length(trim(TLabeledEdit(Sender).Text))>0) then
  begin
    // Initialisieren der FormatSettings
    FormatSettings := TFormatSettings.Create;
    FormatSettings.ShortDateFormat := 'dd.mm.yyyy';
    FormatSettings.DateSeparator := '.';

    if not TryStrToDate(TLabeledEdit(Sender).Text, DateValue, FormatSettings) then
    begin
      ShowMessage('Bitte geben Sie ein gültiges Datum im Format TT.MM.JJJJ ein.');
      TLabeledEdit(Sender).SetFocus;
    end;
  end;
end;





procedure TfChipkartenausgabeEdit.edBetretenKeyPress(Sender: TObject; var Key: Char);
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



procedure TfChipkartenausgabeEdit.edGueltigBisExit(Sender: TObject);
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




procedure TfChipkartenausgabeEdit.edGueltigBisKeyPress(Sender: TObject; var Key: Char);
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




procedure TfChipkartenausgabeEdit.FormCreate(Sender: TObject);
begin
  Label3.Caption := 'Hier können Sie die Angaben einer Chipkartenausgabe ändern!';
end;



procedure TfChipkartenausgabeEdit.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Close;
  end;
end;

procedure TfChipkartenausgabeEdit.FormShow(Sender: TObject);
begin
  LoadAusweisarten(cbAusweisart);
  LoadStaaten(cbStaat);

  edBesuchter.SetFocus;

  if(BESUCHERID <> 0) then
  begin
    LoadBesucherdaten(BESUCHERID);

    ShowChipkartenausgabenRuecknahmen;
  end;

  cbEditBesucherdaten.Checked := false;
  cbEditBesucherdatenClick(nil);
end;






procedure TfChipkartenausgabeEdit.LoadBesucherdaten(besucherID: integer);
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





procedure TfChipkartenausgabeEdit.ShowChipkartenausgabenRuecknahmen;
var
  FDQuery: TFDQuery;
begin
  FDQuery := TFDQuery.Create(nil);
  try
    with FDQuery do
    begin
      Connection := fMain.FDConnection1;

      SQL.Clear;
      SQL.Text := 'SELECT chipkartenNr, betreten, verlassen, besuchter, kfzkennzeichen, bemerkungen ' +
                  'FROM chipkartenausgabe WHERE id = :ID LIMIT 0, 1;';
      ParamByName('ID').AsInteger := ID;
      Open;

      if not FDQuery.IsEmpty then
      begin
        lbChipkartenNr.Caption := FieldByName('chipkartenNr').AsString;
        lbBetreten.Caption := ConvertSQLDateToGermanDate(FDQuery.FieldByName('betreten').AsString, true)+' Uhr';
        if(ConvertSQLDateToGermanDate(FDQuery.FieldByName('verlassen').AsString) <> '') then
          lbVerlassen.Caption := ConvertSQLDateToGermanDate(FDQuery.FieldByName('verlassen').AsString, true)+ ' Uhr'
        else
          lbVerlassen.Caption := '';

        edBesuchter.Text      := FieldByName('besuchter').AsString;
        edKfzKennzeichen.Text := FieldByName('kfzkennzeichen').AsString;
        edBemerkungen.Text    := FieldByName('bemerkungen').AsString;
      end;
    end;
  finally
    FDQuery.Free;
  end;
end;





procedure TfChipkartenausgabeEdit.UpdateChipkartenausgabeInDB;
var
  FDQuery: TFDQuery;
  i: integer;
begin
  fMain.FDConnection1.Connected := true;
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := fMain.FDConnection1;

    with FDQuery do
    begin
      SQL.Add('UPDATE chipkartenausgabe SET besuchter = :besuchter, kfzkennzeichen = :kennzeichen, '+
              'bemerkungen = :bemerkungen WHERE id = :id;');
      ParamByName('id').AsInteger := ID;
      ParamByName('besuchter').AsString   := edBesuchter.Text;
      ParamByName('kennzeichen').AsString := edKfzKennzeichen.Text;
      ParamByName('bemerkungen').AsString := edBemerkungen.Text;
      ExecSQL;
    end;
  finally
    FDQuery.Free;
  end;
  fMain.FDConnection1.Connected := false;

  i := fMain.lvChipkartenausgabe.ItemIndex;
  with fMain.lvChipkartenausgabe.Items[i] do
  begin
    SubItems[9] := edKfzKennzeichen.Text;
    SubItems[10] := edBesuchter.Text;
  end;

  close;
end;




end.
