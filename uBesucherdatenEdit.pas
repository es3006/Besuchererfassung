unit uBesucherdatenEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Data.DB,
  Vcl.ExtCtrls, Vcl.Buttons, FireDAC.Comp.Client, FireDAC.Stan.Param, System.UITypes;

type
  TfBesucherdatenEdit = class(TForm)
    Label1: TLabel;
    Shape1: TShape;
    btnChipkartenausgabeSpeichern: TButton;
    edNachname: TLabeledEdit;
    edVorname: TLabeledEdit;
    edFirma: TLabeledEdit;
    edAusweisNr: TLabeledEdit;
    cbAusweisart: TComboBox;
    edStrasseHausNr: TLabeledEdit;
    edPLZWohnort: TLabeledEdit;
    StatusBar1: TStatusBar;
    btnDeleteBesucher: TButton;
    Shape8: TShape;
    Shape9: TShape;
    Shape10: TShape;
    Label2: TLabel;
    Shape6: TShape;
    cbStaat: TComboBox;
    edGueltigBis: TLabeledEdit;
    Shape3: TShape;
    procedure FormShow(Sender: TObject);
    procedure btnChipkartenausgabeSpeichernClick(Sender: TObject);
    procedure btnDeleteBesucherClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure edGueltigBisExit(Sender: TObject);
    procedure edGueltigBisKeyPress(Sender: TObject; var Key: Char);
  private
    procedure ResetFormular;
    procedure UpdateBesucherInDB;
    procedure LoadBesucherdaten;
    procedure DeleteBesucherFromDB;
  public
    BESUCHERID: integer;
    SuccessLoggedIn: boolean;
  end;

var
  fBesucherdatenEdit: TfBesucherdatenEdit;


implementation

{$R *.dfm}

uses uNewAusstellungsstaat, uFunktionen, uDBFunctions, uMain, uChipkartenausgabe,
     uBesuchersuche, uBesuchererfassung, uBesucheranmeldung, uPasswortabfrage;



procedure TfBesucherdatenEdit.ResetFormular;
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
end;




procedure TfBesucherdatenEdit.btnChipkartenausgabeSpeichernClick(Sender: TObject);
var
  save: boolean;
  nachname, vorname, ausweisnr, gueltigbis: string;
  ausweisart, staat: integer;
begin
  ausweisart := -1;
  staat      := -1;
  save       := true;

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
  if(save = true) then
  begin
    nachname    := trim(edNachname.Text);
    vorname     := trim(edVorname.Text);
    ausweisnr   := trim(edAusweisNr.Text);
    ausweisart  := cbAusweisart.ItemIndex;
    gueltigbis  := trim(edGueltigBis.Text);
    staat       := cbStaat.ItemIndex;

    if(length(nachname)<>0) AND (length(vorname)<>0) AND (length(ausweisnr)<>0) AND (ausweisart<>-1) AND (staat<>-1) AND (length(gueltigbis)<>0) then
    begin
      UpdateBesucherInDB;
    end
    else
    begin
      ShowMessage('Bitte füllen Sie die grün markierten Felder aus!');
    end;
  end;
  close;
end;





procedure TfBesucherdatenEdit.btnDeleteBesucherClick(Sender: TObject);
var
  i: integer;
begin
  i := fMain.lvBesucher.ItemIndex;

  if MessageDlg('Wollen Sie diesen Besucher wirklich löschen?'+#13#10+#13#10+
  'ACHTUNG: mit dem Benutzer werden auch alle, unter seinem Namen gespeicherten Anmeldungen und Chipkartenausgaben gelöscht!',
  mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes then
  begin
      fPasswortabfrage.RETURNTO := 'BesucherdatenEdit';
      fPasswortabfrage.ShowModal;

      if(SuccessLoggedIn = true) then
      begin
       DeleteBesucherFromDB;
      end;
  end;
end;














procedure TfBesucherdatenEdit.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Close;
  end;
end;

procedure TfBesucherdatenEdit.FormShow(Sender: TObject);
begin
  SuccessLoggedIn := false;

  LoadAusweisarten(cbAusweisart);
  LoadStaaten(cbStaat);

  ResetFormular;

  LoadBesucherdaten;
end;




procedure TfBesucherdatenEdit.LoadBesucherdaten;
var
  FDQuery: TFDQuery;
  index: integer;
begin
  FDQuery := TFDQuery.Create(nil);
  try
    with FDQuery do
    begin
      Connection := fMain.FDConnection1;

      SQL.Add('SELECT id, nachname, vorname, firma, strasse_hausnummer, plz_ort, ausweisnummer, ');
      SQL.Add('ausweisart, ausstellungsstaat, gueltigbis ');
      SQL.Add('FROM besucher WHERE id = :besucherID');
      ParamByName('besucherID').AsInteger := BESUCHERID;
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

        edGueltigBis.Text    := ConvertSQLDateToGermanDate(FieldByName('gueltigbis').AsString, false);

        Index := cbStaat.Items.IndexOf(FieldByName('ausstellungsstaat').AsString);
        if Index <> -1 then
        begin
          cbStaat.ItemIndex := Index;
        end;
      end;
    end;
  finally
    FDQuery.Free;
  end;
end;





procedure TfBesucherdatenEdit.UpdateBesucherInDB;
var
  FDQuery: TFDQuery;
  i: integer;
begin
  i := fMain.lvBesucher.ItemIndex;

  fMain.FDConnection1.Connected := true;
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := fMain.FDConnection1;

    with FDQuery do
    begin
      SQL.Add('UPDATE besucher SET nachname = :nachname, vorname = :vorname, firma = :firma, strasse_hausnummer = :strassenr,');
      SQL.Add('plz_ort = :plzort, ausweisnummer = :ausweisnr, ');
      SQL.Add('ausweisart = :ausweisart, ausstellungsstaat = :staat, gueltigbis = :gueltigbis');
      SQL.Add('WHERE id = :besucherID;');
      ParamByName('besucherID').AsInteger := BESUCHERID;
      ParamByName('nachname').AsString    := edNachname.Text;
      ParamByName('vorname').AsString     := edVorname.Text;
      ParamByName('firma').AsString       := edFirma.Text;
      ParamByName('strassenr').AsString   := edStrasseHausNr.Text;
      ParamByName('plzort').AsString      := edPlzWohnort.Text;
      ParamByName('ausweisnr').AsString   := edAusweisnr.Text;
      ParamByName('ausweisart').AsString  := cbAusweisart.Text;
      ParamByName('staat').AsString       := cbStaat.Text;
      ParamByName('gueltigbis').AsString  := ConvertGermanDateToSQLDate(edGueltigBis.Text, false);

      ExecSQL;
    end;
  finally
    FDQuery.Free;
  end;
  fMain.FDConnection1.Connected := false;

  with fMain.lvBesucher.Items[i] do
  begin
    SubItems[0] := edNachname.Text;
    SubItems[1] := edVorname.Text;
    SubItems[2] := edFirma.Text;
    SubItems[3] := edAusweisnr.Text;
    SubItems[4] := cbAusweisart.Text;
    SubItems[5] := cbStaat.Text;
    SubItems[6] := edGueltigBis.Text;
  end;

  close;
end;




procedure TfBesucherdatenEdit.DeleteBesucherFromDB;
var
  FDQuery: TFDQuery;
  deletedAnmeldungen, deletedChipkartenausgabe: integer;
begin
  if(BESUCHERID<>0) then
  begin
    deletedAnmeldungen := 0;
    deletedChipkartenausgabe := 0;


    fMain.FDConnection1.Connected := true;
    FDQuery := TFDQuery.Create(nil);
    try
      FDQuery.Connection := fMain.FDConnection1;

      with FDQuery do
      begin
        SQL.Clear;
        SQL.Add('DELETE FROM besucher WHERE id = :id;');
        ParamByName('id').AsInteger := BESUCHERID;
        ExecSQL;

        SQL.Clear;
        SQL.Add('DELETE FROM besucheranmeldungen WHERE besucherID = :id;');
        ParamByName('id').AsInteger := BESUCHERID;

        try
          FDQuery.ExecSQL;
          deletedAnmeldungen := FDQuery.RowsAffected;
        except
          on E: Exception do
            ShowMessage('Fehler beim Löschen der Anmeldungen des Besuchers: ' + E.Message);
        end;


        SQL.Clear;
        SQL.Add('DELETE FROM chipkartenausgabe WHERE besucherID = :id;');
        ParamByName('id').AsInteger := BESUCHERID;
        try
          FDQuery.ExecSQL;
          deletedChipkartenausgabe := FDQuery.RowsAffected;
        except
          on E: Exception do
            ShowMessage('Fehler beim Löschen der Chipkartenausgaben des Besuchers: ' + E.Message);
        end;
      end;
    finally
      FDQuery.Free;
    end;
    fMain.FDConnection1.Connected := false;

   // ShowMessage('Der Besucher wurde erfolgreich gelöscht.'+#13#10+
   // 'Es wurden '+IntToStr(deletedAnmeldungen)+' Anmeldungen gelöscht.'+#13#10+
   // 'Es wurden ' + IntToStr(deletedChipkartenausgabe)+' Chipkartenausgaben gelöscht');
    fBesucherdatenEdit.Close;
    //fMain.ShowBesucherListe;


    fMain.lvBesucher.DeleteSelected;

    close;
    abort;
  end;
end;



procedure TfBesucherdatenEdit.edGueltigBisExit(Sender: TObject);
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


procedure TfBesucherdatenEdit.edGueltigBisKeyPress(Sender: TObject; var Key: Char);
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




end.
