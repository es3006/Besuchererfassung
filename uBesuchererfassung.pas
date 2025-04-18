unit uBesuchererfassung;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Clipbrd,
  Vcl.ExtCtrls, Vcl.Buttons, FireDAC.Comp.Client, FireDAC.Stan.Param, System.UITypes,
  AdvCombo, Data.DB, AdvDateTimePicker;

type
  TfBesuchererfassung = class(TForm)
    btnChipkartenausgabeSpeichern: TButton;
    StatusBar1: TStatusBar;
    Label1: TLabel;
    Label2: TLabel;
    edNachname: TLabeledEdit;
    edVorname: TLabeledEdit;
    edFirma: TLabeledEdit;
    edAusweisNr: TLabeledEdit;
    cbAusweisart: TComboBox;
    edStrasseHausNr: TLabeledEdit;
    edPLZWohnort: TLabeledEdit;
    cbStaat: TComboBox;
    Shape1: TShape;
    Shape8: TShape;
    Shape9: TShape;
    Shape6: TShape;
    Shape10: TShape;
    edGueltigBis: TLabeledEdit;
    Shape2: TShape;
    procedure FormShow(Sender: TObject);
    procedure btnChipkartenausgabeSpeichernClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure edGueltigBisExit(Sender: TObject);
    procedure edGueltigBisKeyPress(Sender: TObject; var Key: Char);
  private
    procedure ResetFormular;
    procedure InsertBesucherInDB;
  public
    BESUCHERID: integer;
    OPENFORM, AUSWEISNUMMER: string;
    { Public-Deklarationen }
  end;

var
  fBesuchererfassung: TfBesuchererfassung;




implementation

{$R *.dfm}



uses
  uFunktionen, uDBFunctions, uMain, uChipkartenausgabe, uBesuchersuche,
  uBesucheranmeldung, uNewAusstellungsstaat;


procedure TfBesuchererfassung.btnChipkartenausgabeSpeichernClick(Sender: TObject);
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
      InsertBesucherInDB;
    end;
  end
  else
  begin
    showmessage('Bitte füllen Sie alle grün markierten Pflichtfelder aus!');
  end;
end;




procedure TfBesuchererfassung.ResetFormular;
begin
  edNachname.Clear;
  edVorname.Clear;
  edFirma.Clear;
  edStrasseHausNr.Clear;
  edPLZWohnort.Clear;
  edAusweisNr.Clear;
  cbAusweisart.ItemIndex := -1;
  cbStaat.ItemIndex := -1;
  edGueltigBis.Clear;
end;




procedure TfBesuchererfassung.InsertBesucherInDB;
var
  FDQuery: TFDQuery;
  LastInsertID: Integer;
  l: TListItem;
begin
  fMain.FDConnection1.Connected := true;
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := fMain.FDConnection1;

    with FDQuery do
    begin
      //Prüfen ob Auseisnummer bereits in der Datenbank steht
      SQL.Text := 'SELECT id FROM besucher WHERE ausweisnummer = :ausweisnr;';
      ParamByName('ausweisnr').AsString     := edAusweisnr.Text;
      Open;


      //Besucher in Datenbank speichern wenn Ausweisnummer noch nicht vorhanden ist
      if FDQuery.IsEmpty then
      begin
        SQL.Text := 'INSERT INTO besucher (nachname, vorname, firma, strasse_hausnummer, plz_ort, ausweisnummer, ausweisart, ausstellungsstaat, gueltigbis, registriert) ' +
                    'VALUES (:nachname, :vorname, :firma, :strassenr, :plzort, :ausweisnr, :ausweisart, :staat, :gueltigbis, :registriert)';
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

        ExecSQL;

        SQL.Text := 'SELECT last_insert_rowid() AS LastID';
        Open;
        LastInsertID := FieldByName('LastID').AsInteger;


        //fMain.ShowBesucherListe;

        l := fMain.lvBesucher.Items.Add;
        l.Caption := IntToStr(LastInsertID);
        l.SubItems.Add(edNachname.Text);
        l.SubItems.Add(edVorname.Text);
        l.SubItems.Add(edFirma.Text);
        l.SubItems.Add(edAusweisnr.Text);
        l.SubItems.Add(cbAusweisart.Text);
        l.SubItems.Add(cbStaat.Text);
        l.SubItems.Add(edGueltigBis.Text);

        fMain.lvBesucher.SortColumn := 1;
        fMain.lvBesucher.Sort;

        FindAndSelectListViewItem(fMain.lvBesucher, IntToStr(LastInsertID), [0]);


        if(OPENFORM = 'Chipkartenausgabe') then
        begin
          fChipkartenausgabe.BESUCHERID := LastInsertID;
          fChipkartenausgabe.Show;
          fBesuchersuche.Close;
          fBesuchererfassung.Close;
          abort
        end;


        if(OPENFORM = 'Anmeldung') then
        begin
          fBesucheranmeldung.BESUCHERID := LastInsertID;
          fBesucheranmeldung.Show;
          fBesuchersuche.Close;
          fBesuchererfassung.Close;
          abort
        end;
      end;
    end;
  finally
    FDQuery.Free;
  end;
  fMain.FDConnection1.Connected := false;
end;












procedure TfBesuchererfassung.edGueltigBisExit(Sender: TObject);
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




procedure TfBesuchererfassung.edGueltigBisKeyPress(Sender: TObject; var Key: Char);
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







procedure TfBesuchererfassung.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Close;
  end;
end;





procedure TfBesuchererfassung.FormShow(Sender: TObject);
begin
  fBesuchersuche.Close;

  ResetFormular;

  LoadAusweisarten(cbAusweisart);
  LoadStaaten(cbStaat);

  btnChipkartenAusgabeSpeichern.Caption := 'Weiter zur ' + OPENFORM;

  edAusweisNr.Text := AUSWEISNUMMER;
  edNachname.SetFocus;
end;








end.
