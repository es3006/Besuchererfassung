unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, AdvListV, Vcl.Menus,
  Vcl.StdCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteDef, FireDAC.Phys.SQLite, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, AdvPageControl, Vcl.ExtCtrls, Clipbrd, ShellApi,
  FireDAC.Phys.SQLiteWrapper.Stat, Vcl.Mask, DateUtils;

type
  TfMain = class(TForm)
    MainMenu1: TMainMenu;
    Datei1: TMenuItem;
    Beenden1: TMenuItem;
    Benutzerverwaltung1: TMenuItem;
    Benutzerverwalten1: TMenuItem;
    StatusBar1: TStatusBar;
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    DataSource1: TDataSource;
    Hilfe1: TMenuItem;
    berdasProgramm1: TMenuItem;
    Programmhilfe1: TMenuItem;
    Einstellungen1: TMenuItem;
    Ausweisarten1: TMenuItem;
    Ausstellungsstaaten1: TMenuItem;
    N3: TMenuItem;
    Einstellungen2: TMenuItem;
    PageControl1: TAdvPageControl;
    AdvTabSheet1: TAdvTabSheet;
    lvBesucher: TAdvListView;
    AdvTabSheet2: TAdvTabSheet;
    lvAnmeldungen: TAdvListView;
    AdvTabSheet4: TAdvTabSheet;
    lvChipkartenausgabe: TAdvListView;
    Panel1: TPanel;
    rbHeute: TRadioButton;
    rbAktuellerMonat: TRadioButton;
    rbAktuellesJahr: TRadioButton;
    rbAlles: TRadioButton;
    Panel2: TPanel;
    rbAbgelaufeneAnmeldungen: TRadioButton;
    rbAktuelleAnmeldungen: TRadioButton;
    rbZukuenftigeAnmeldungen: TRadioButton;
    rbAlleAnmeldungen: TRadioButton;
    Timer1: TTimer;
    N1: TMenuItem;
    Bedienerwechseln1: TMenuItem;
    Panel3: TPanel;
    Button5: TButton;
    edBesucherSuche: TLabeledEdit;
    N2: TMenuItem;
    DatenschutzGrundverordnung1: TMenuItem;
    N4: TMenuItem;
    rbAusgegeben: TRadioButton;
    Panel4: TPanel;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Datenbank1: TMenuItem;
    Importieren1: TMenuItem;
    Exportieren1: TMenuItem;
    OpenDialog1: TOpenDialog;
    N5: TMenuItem;
    Sicherungerstellen1: TMenuItem;
    HinweiszumSchutzpersonenbezogenerDaten1: TMenuItem;
    TimerBackup: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Benutzerverwalten1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Beenden1Click(Sender: TObject);
    procedure Programmhilfe1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Ausweisarten1Click(Sender: TObject);
    procedure Ausstellungsstaaten1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure berdasProgramm1Click(Sender: TObject);
    procedure rbHeuteClick(Sender: TObject);
    procedure rbAktuellerMonatClick(Sender: TObject);
    procedure rbAktuellesJahrClick(Sender: TObject);
    procedure rbAllesClick(Sender: TObject);
    procedure rbAktuelleAnmeldungenClick(Sender: TObject);
    procedure rbAbgelaufeneAnmeldungenClick(Sender: TObject);
    procedure rbZukuenftigeAnmeldungenClick(Sender: TObject);
    procedure rbAlleAnmeldungenClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure lvAnmeldungenDblClick(Sender: TObject);
    procedure lvBesucherDblClick(Sender: TObject);
    procedure lvChipkartenausgabeDblClick(Sender: TObject);
    procedure lvBesucherSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure Einstellungen2Click(Sender: TObject);
    procedure Bedienerwechseln1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure lvBesucherCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
    procedure lvBesucherColumnClick(Sender: TObject; Column: TListColumn);
    procedure edBesucherSucheKeyPress(Sender: TObject; var Key: Char);
    procedure lvChipkartenausgabeSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure DatenschutzGrundverordnung1Click(Sender: TObject);
    procedure rbAusgegebenClick(Sender: TObject);
    procedure Importieren1Click(Sender: TObject);
    procedure Exportieren1Click(Sender: TObject);
    procedure Sicherungerstellen1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure HinweiszumSchutzpersonenbezogenerDaten1Click(Sender: TObject);
    procedure TimerBackupTimer(Sender: TObject);
  private
    procedure AdjustListViewColumns(lv: TAdvListView);
    procedure DSGVO;
  public
    procedure LoadDataFromDB;
    procedure ShowAnmeldungen(art: string = 'Aktuell');
    procedure ShowBesucherListe;
    procedure ShowChipkartenausgabe(art: string = 'Heute');
    procedure UpdateNextBackupInfo(Wochentag, ZielStunde, ZielMinute: Integer; Referenzzeit: TDateTime);
  end;

var
  fMain: TfMain;
  BEDIENERID: integer;
  BEDIENERUSERNAME: string;
  FIRSTSTART, FIRSTSTARTABBRUCH, ENCRYPTDB, ADMIN, DSGVOAUTODEL: boolean;
  PATH, DBNAME, DBBACKUPDIR: string;
  GlobalFormatSettings: TFormatSettings;
  LVSELBGCOLOR, LVSELVGCOLOR: TColor;
  LINEHEIGHT, DSGVODELTIME: Integer;
  LastFoundIndex: Integer = -1;
  ColumnToSort: Integer;
  LastSorted: Integer;
  SortDir: Integer;
  LASTBACKUP: TDateTime;
  AutoSicherungWochentag , AutoSicherungStunde, AutoSicherungMinute: integer;

const
  ENCRYPTIONKEY = 'mdklwuje90321iks,2moijlwödmeu3290dnu2i1p,sdim1239'; //zum verschlüsseln der Datenbank
  PROGRAMMVERSION = '1.0.0.5';


implementation

{$R *.dfm}
{$R MyResources.RES}

uses uBenutzer, uDBFunctions, uFunktionen, uAnmeldung, uFirstStart, uHilfe, uChipkartenausgabe,
  uBesuchererfassung, uStaaten, uAusweisarten, uStaatenliste, uBesuchersuche,
  uChipkartenruecknahme, uAbout, uBesucheranmeldung, uBesucheranmeldungEdit,
  uBesucherdatenEdit, uChipkartenausgabeEdit, uSettings;







procedure TfMain.Ausstellungsstaaten1Click(Sender: TObject);
begin
  if not Assigned(fStaaten) then
    fStaaten := TfStaaten.Create(Self);

  fStaaten.Show;
end;

procedure TfMain.Ausweisarten1Click(Sender: TObject);
begin
  if not Assigned(fAusweisarten) then
    fAusweisarten := TfAusweisarten.Create(Self);

  fAusweisarten.Show;
end;






procedure TfMain.Bedienerwechseln1Click(Sender: TObject);
begin
  with fAnmeldung do
  begin
    LOGGEDIN := true;
    ShowModal;
  end;
  LoadUserSettingsFromDB;
end;







procedure TfMain.Beenden1Click(Sender: TObject);
begin
  close;
end;







procedure TfMain.Benutzerverwalten1Click(Sender: TObject);
begin
  fBenutzer.show;
end;






procedure TfMain.berdasProgramm1Click(Sender: TObject);
begin
  fAbout.ShowModal;
end;






procedure TfMain.Button1Click(Sender: TObject);
begin
  PlayResourceMP3('CLICK', 'TEMP\click.wav');
  fBesuchersuche.RETURNTO := 'Chipkartenausgabe';
  fBesuchersuche.ShowModal;
end;






procedure TfMain.Button2Click(Sender: TObject);
begin
  PlayResourceMP3('CLICK', 'TEMP\click.wav');

  PageControl1.ActivePageIndex := 0;
  fBesuchersuche.RETURNTO := 'Anmeldung';
  fBesuchersuche.ShowModal;
end;







procedure TfMain.Button3Click(Sender: TObject);
begin
  PlayResourceMP3('CLICK', 'TEMP\click.wav');

  PageControl1.ActivePageIndex := 2;
  rbAusgegeben.Checked := true;
  ShowChipkartenausgabe('Ausgegeben');

  fChipkartenruecknahme.showModal;
end;







procedure TfMain.Button4Click(Sender: TObject);
begin
  PlayResourceMP3('BLING', 'TEMP\bling.wav');

  with fAnmeldung do
  begin
    LOGGEDIN := false;
    ShowModal;
  end;
  LoadUserSettingsFromDB;

  DSGVO;
end;






procedure TfMain.Button5Click(Sender: TObject);
begin
  ShowBesucherListe
end;






procedure TfMain.edBesucherSucheKeyPress(Sender: TObject; var Key: Char);
const
  SpaltenArray: array[0..3] of Integer = (1, 2, 3, 4);  //Nachname, Vorname, Firma, AusweisNr
begin
  if(Key = #13) then
  begin
    Key := #0;
    FindAndSelectListViewItem(lvBesucher, edBesucherSuche.text, SpaltenArray);
  end;
end;







procedure TfMain.Einstellungen2Click(Sender: TObject);
begin
  if not Assigned(fSettings) then
    fSettings := TfSettings.Create(Self);

  fSettings.Show;
end;







procedure TfMain.Exportieren1Click(Sender: TObject);
begin
  BackupAllTables;
  ShowMessage('Datenbanktabellen wurden im Verzeichnis "DBDUMPS" gesichert');
end;








procedure TfMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if(FDConnection1.Connected) then FDConnection1.Connected := false; //Verbindung zur Datenbank trennen
  DeleteFiles(PATH+'TEMP\*.*'); //Temp Verzeichnis leeren
end;







procedure TfMain.FormCreate(Sender: TObject);
var
  ResourceName, FileName: string;
begin
  BEDIENERID := 0;
  ADMIN      := false;
  PATH       := ExtractFilePath(ParamStr(0));
  DBNAME     := 'besucherverwaltung.s3db';
  ENCRYPTDB  := false;
  FIRSTSTART := false;

  Application.ShowMainForm := True;

  CreateDirectoryIfNotExists(PATH+'TEMP');

//DLL Dateien aus Resource extrahieren
  if not (fileexists(PATH + 'sqlite3.dll')) then
  begin
    ResourceName := 'SQLITE3DLL64BIT';
    FileName := ExtractFilePath(Application.ExeName) + 'sqlite3.dll';
    SaveResourceToFile(ResourceName, FileName);
  end;

  if not (fileexists(PATH + 'ssleay32.dll')) then
  begin
    ResourceName := 'SSLEAY32';
    FileName := ExtractFilePath(Application.ExeName) + 'ssleay32.dll';
    SaveResourceToFile(ResourceName, FileName);
  end;

  if not (fileexists(PATH + 'libeay32.dll')) then
  begin
    ResourceName := 'LIBEAY32';
    FileName := ExtractFilePath(Application.ExeName) + 'libeay32.dll';
    SaveResourceToFile(ResourceName, FileName);
  end;


//PDF Dateien aus Resource extrahieren
  if not (fileexists(PATH + 'dsgvo.pdf')) then
  begin
    ResourceName := 'DSGVO';
    FileName := ExtractFilePath(Application.ExeName) + 'dsgvo.pdf';
    SaveResourceToFile(ResourceName, FileName);
  end;

  if not (fileexists(PATH + 'Hinweis zum Schutz personenbezogener Daten.pdf')) then
  begin
    ResourceName := 'DSGVOHINWEIS';
    FileName := ExtractFilePath(Application.ExeName) + 'Hinweis zum Schutz personenbezogener Daten.pdf';
    SaveResourceToFile(ResourceName, FileName);
  end;


//HTML Dateien aus Resource extrahieren
  if not (fileexists(PATH + 'hilfe.html')) then
  begin
    ResourceName := 'HILFE';
    FileName := ExtractFilePath(Application.ExeName) + 'hilfe.html';
    SaveResourceToFile(ResourceName, FileName);
  end;


  //Wenn FirstStart abgebrochen wurde und so kein Admin angelegt werden konnte,
  //die Datenbankdatei löschen
  if(FileExists(DBNAME)) then
  begin
    if IsFileZeroSize(DBNAME) then
    begin
      DeleteFile(DBNAME);
    end;
  end;


  //Wenn Datenbank noch nicht vorhanden Formular zum anlegen eines neuen Nutzers anzeigen
  if not FileExists(DBNAME) then
  begin
    FIRSTSTART := true;

    if not (fileexists(PATH + 'staaten.csv')) then
    begin
      ResourceName := 'STAATEN'; // Der Name der Ressource, wie in der .rc-Datei definiert
      FileName := ExtractFilePath(Application.ExeName) + 'staaten.csv'; // Zielpfad im Programmverzeichnis
      SaveResourceToFile(ResourceName, FileName);
    end;
  end;

  FDConnection1.Connected := False; // Sicherstellen, dass die Verbindung geschlossen ist
  FDConnection1.DriverName := 'SQLite';
  FDConnection1.Params.Values['Database'] := DBNAME; // Datenbankname/Pfad
  FDConnection1.Params.Values['CharacterSet'] := 'utf8';
  if(ENCRYPTDB) then
  begin
    FDConnection1.Params.Values['EncryptionMode'] := 'Aes128'; // Verschlüsselung (optional)
    FDConnection1.Params.Values['Password'] := ENCRYPTIONKEY; // Passwort (optional)
  end;

  FDConnection1.Open(); // Verbindung öffnen



  // Initialisieren der Sortier-Parameter
  ColumnToSort := -1; // Initial keine Spalte sortiert
  SortDir      :=  0; // Aufsteigende Sortierung
  LastSorted   := -1; // Keine letzte Sortierung

  //Für automatisches erstellen einer wöchentlichen Sicherung
  LASTBACKUP := 0; // Anfangszustand: nie ausgeführt
end;




procedure TfMain.FormResize(Sender: TObject);
begin
  AdjustListViewColumns(lvBesucher);
  AdjustListViewColumns(lvAnmeldungen);
  AdjustListViewColumns(lvChipkartenausgabe);
end;

procedure TfMain.FormShow(Sender: TObject);
begin
  Caption := 'ESD-Besuchererfassung by Enrico Sadlowski 2024  v' + GetAppVersion;

  // Globale FormatSettings konfigurieren
  GlobalFormatSettings := TFormatSettings.Create;
  GlobalFormatSettings.DateSeparator   := '-';
  GlobalFormatSettings.TimeSeparator   := ':';
  GlobalFormatSettings.ShortDateFormat := 'yyyy-mm-dd';
  GlobalFormatSettings.LongTimeFormat  := 'hh:nn:ss';

  PageControl1.ActiveFont.Color := clWhite;

  if(FIRSTSTART) then
  begin
    CreateDatabaseTables;
    CreateIndexes;
    fFirstStart.ShowModal;
  end
  else
  begin
    fAnmeldung.ShowModal;
  end;

  LoadAdminSettingsFromDB;
  LoadUserSettingsFromDB;

  DSGVO;

  LoadDataFromDB;

  UpdateNextBackupInfo(AutoSicherungWochentag, AutoSicherungStunde, AutoSicherungMinute, now);
end;



procedure TfMain.HinweiszumSchutzpersonenbezogenerDaten1Click(Sender: TObject);
begin
  ShellExecute(0, 'open', PChar('Hinweis zum Schutz personenbezogener Daten.pdf'), nil, nil, SW_SHOWNORMAL);
end;

procedure TfMain.Importieren1Click(Sender: TObject);
begin
  opendialog1.InitialDir := IncludeTrailingPathDelimiter(PATH + 'DBDUMPS');
  if opendialog1.execute  then
  begin
    ExtractAndImportSQLFiles(opendialog1.Filename, 'TEMP'); //Gezipte Tabellen importieren
  end;
end;

procedure TfMain.LoadDataFromDB;
begin
  PageControl1.ActivePageIndex := 0;
  ShowBesucherListe;
  rbAktuelleAnmeldungen.Checked := true;
  ShowAnmeldungen;
  rbHeute.Checked := true;
  ShowChipkartenausgabe('Heute');
end;



procedure TfMain.DatenschutzGrundverordnung1Click(Sender: TObject);
begin
  ShellExecute(0, 'open', PChar('dsgvo.pdf'), nil, nil, SW_SHOWNORMAL);
end;

procedure TfMain.DSGVO;
begin
  //Alte Einträge nach DSGVO löschen
  DSGVODelOldEntries('chipkartenausgabe', 'betreten');
  DSGVODelOldEntries('besucheranmeldungen', 'anmeldung_bis');

  //Besucher nach DSGVO nur löschen wenn registriert < DSGVODELTIME und Keine Chipkartenausgaben oder Anmeldungen zugeordnet sind
  DSGVODelBesucher;
end;




procedure TfMain.lvAnmeldungenDblClick(Sender: TObject);
var
  i: integer;
begin
  i := lvAnmeldungen.ItemIndex;
  if(i<>-1) then
  begin
    fBesucheranmeldungEdit.ANMELDUNGID := StrToInt(lvAnmeldungen.Items[i].Caption);
    fBesucheranmeldungEdit.ShowModal;
  end;
end;




procedure TfMain.lvBesucherColumnClick(Sender: TObject; Column: TListColumn);
begin
  lvColumnClickForSort(Sender, Column);
end;

procedure TfMain.lvBesucherCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  lvCompareForSort(Sender, Item1, Item2, Data, Compare);
end;

procedure TfMain.lvBesucherDblClick(Sender: TObject);
var
  i: integer;
begin
  i := lvBesucher.ItemIndex;
  if(i<>-1) then
  begin
    fBesucherdatenEdit.BESUCHERID := StrToInt(lvBesucher.Items[i].Caption);
    fBesucherdatenEdit.ShowModal;
  end;
end;






procedure TfMain.lvBesucherSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
var
  i: integer;
begin
  i := lvBesucher.ItemIndex;
  if(i<>-1) then
  begin
    Clipboard.AsText := lvBesucher.Items[i].SubItems[3];
  end;
end;







procedure TfMain.lvChipkartenausgabeDblClick(Sender: TObject);
var
  i: integer;
begin
  i := lvChipkartenausgabe.ItemIndex;
  if(i<>-1) then
  begin
    with fChipkartenausgabeEdit do
    begin
      ID := StrToInt(lvChipkartenausgabe.Items[i].Caption);
      BESUCHERID := StrToInt(lvChipkartenausgabe.Items[i].SubItems[0]);
      ShowModal;
    end;
  end;
end;

procedure TfMain.lvChipkartenausgabeSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
var
  i: integer;
begin
  i := lvChipkartenausgabe.ItemIndex;
  if(i<>-1) then
  begin
    Clipboard.AsText := lvChipkartenausgabe.Items[i].SubItems[2]; //ChipkartenNr in Clipboard schreiben
  end;
end;




procedure TfMain.Programmhilfe1Click(Sender: TObject);
begin
  fHilfe.Show;
end;








procedure TfMain.rbAlleAnmeldungenClick(Sender: TObject);
begin
  ShowAnmeldungen('Alle');
end;

procedure TfMain.rbZukuenftigeAnmeldungenClick(Sender: TObject);
begin
  ShowAnmeldungen('Zukuenftige');
end;

procedure TfMain.rbAbgelaufeneAnmeldungenClick(Sender: TObject);
begin
  ShowAnmeldungen('Abgelaufen');
end;

procedure TfMain.rbAktuelleAnmeldungenClick(Sender: TObject);
begin
  ShowAnmeldungen('Aktuell');
end;


procedure TfMain.rbHeuteClick(Sender: TObject);
begin
  ShowChipkartenausgabe('Heute');
end;

procedure TfMain.rbAktuellerMonatClick(Sender: TObject);
begin
  ShowChipkartenausgabe('Monat');
end;

procedure TfMain.rbAktuellesJahrClick(Sender: TObject);
begin
  ShowChipkartenausgabe('Jahr');
end;

procedure TfMain.rbAllesClick(Sender: TObject);
begin
  ShowChipkartenausgabe('Alles');
end;




procedure TfMain.rbAusgegebenClick(Sender: TObject);
begin
  ShowChipkartenausgabe('Ausgegeben');
end;

{
  Liste aller Besucher in ListView anzeigen
}
procedure TfMain.ShowBesucherListe;
var
  FDQuery: TFDQuery;
  l: TListItem;
begin
  // Setzen der Sortier-Parameter zurück
  ColumnToSort := -1;
  SortDir      := 0;
  LastSorted   := -1;

  lvBesucher.Items.Clear;

  FDConnection1.Connected := true;
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := FDConnection1;
    FDQuery.SQL.Clear;
    FDQuery.SQL.Add('SELECT id, nachname, vorname, firma, ausweisnummer, ausweisart, ausstellungsstaat, gueltigbis');
    FDQuery.SQL.Add('FROM besucher');
    FDQuery.SQL.Add('ORDER BY nachname ASC, firma ASC');
    FDQuery.Open;

    while not FDQuery.Eof do
    begin
      l := lvBesucher.Items.Add;
      l.Caption := FDQuery.FieldByName('id').AsString;
      l.SubItems.Add(FDQuery.FieldByName('nachname').AsString);
      l.SubItems.Add(FDQuery.FieldByName('vorname').AsString);
      l.SubItems.Add(FDQuery.FieldByName('firma').AsString);
      l.SubItems.Add(FDQuery.FieldByName('ausweisnummer').AsString);
      l.SubItems.Add(FDQuery.FieldByName('ausweisart').AsString);
      l.SubItems.Add(FDQuery.FieldByName('ausstellungsstaat').AsString);
      l.SubItems.Add(ConvertSQLDateToGermanDate(FDQuery.FieldByName('gueltigbis').AsString, false));

      FDQuery.next;
    end;
  finally
    FDQuery.Free;
  end;
  FDConnection1.Connected := false;
end;







procedure TfMain.ShowAnmeldungen(art: string = 'Aktuell');
var
  FDQuery: TFDQuery;
  l: TListItem;
  CurrentDate: string;
  DBDate, GermanDate: string;
begin
  FDConnection1.Connected := true;

  CurrentDate := FormatDateTime('YYYY-MM-DD', Now);

  lvAnmeldungen.Items.Clear;

  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := FDConnection1;

    FDQuery.SQL.Clear;
    FDQuery.SQL.Add('SELECT A.id, A.ausweisNr, B.nachname || '' '' || B.vorname AS besucher, B.firma, A.anmeldung_von, A.anmeldung_bis, A.besuchter, A.kfzkennzeichen, A.bemerkungen');
    FDQuery.SQL.Add('FROM besucheranmeldungen AS A LEFT JOIN besucher AS B On B.id = A.besucherID');


    if(art = 'Aktuell') then
    begin
      CurrentDate := FormatDateTime('YYYY-MM-DD', Now);
      FDQuery.SQL.Add('WHERE A.anmeldung_von <= :CurrentDate AND A.anmeldung_bis >= :CurrentDate');
      FDQuery.SQL.Add('ORDER BY A.anmeldung_von DESC');
      FDQuery.ParamByName('CurrentDate').AsString := CurrentDate;
    end
    else if(art = 'Zukuenftige') then
    begin
      CurrentDate := FormatDateTime('YYYY-MM-DD', Now);
      FDQuery.SQL.Add('WHERE A.anmeldung_von > :CurrentDate AND A.anmeldung_bis > :CurrentDate');
      FDQuery.SQL.Add('ORDER BY A.anmeldung_von DESC');
      FDQuery.ParamByName('CurrentDate').AsString := CurrentDate;
    end
    else if(art = 'Abgelaufen') then
    begin
      CurrentDate := FormatDateTime('YYYY-MM-DD', Now);
      FDQuery.SQL.Add('WHERE A.anmeldung_bis < :CurrentDate');
      FDQuery.SQL.Add('ORDER BY A.anmeldung_von DESC');
      FDQuery.ParamByName('CurrentDate').AsString := CurrentDate;
    end
    else if(art = 'Alle') then
    begin
      FDQuery.SQL.Add('ORDER BY A.anmeldung_von DESC');
    end;


    FDQuery.Open;

    while not FDQuery.Eof do
    begin
      l := lvAnmeldungen.Items.Add;
      l.Caption := FDQuery.FieldByName('id').AsString;
      l.SubItems.Add(FDQuery.FieldByName('besucher').AsString);
      l.SubItems.Add(FDQuery.FieldByName('ausweisnr').AsString);
      l.SubItems.Add(FDQuery.FieldByName('firma').AsString);

      DBDate := FDQuery.FieldByName('anmeldung_von').AsString; // Beispiel für ein Datum im Format YYYY-MM-DD HH:NN:SS
      GermanDate := ConvertSQLDateToGermanDate(DBDate, false);
      l.SubItems.Add(GermanDate);

      DBDate := FDQuery.FieldByName('anmeldung_bis').AsString; // Beispiel für ein Datum im Format YYYY-MM-DD HH:NN:SS
      GermanDate := ConvertSQLDateToGermanDate(DBDate, false);
      l.SubItems.Add(GermanDate);

      l.SubItems.Add(FDQuery.FieldByName('besuchter').AsString);
      l.SubItems.Add(FDQuery.FieldByName('kfzkennzeichen').AsString);
      l.SubItems.Add(FDQuery.FieldByName('bemerkungen').AsString);

      FDQuery.next;
    end;

  finally
    FDQuery.Free;
  end;

  FDConnection1.Connected := false;
end;





{
  Alle ausgegebenen und zurückgenommenen Chipkarten in ListView anzeigen
  Heute, Aktueller Monat, Aktuelles Jahr, Alles
}
procedure TfMain.ShowChipkartenausgabe(art: string = 'Heute');
var
  FDQuery: TFDQuery;
  l: TListItem;
  DBDate, DEDate: string;
begin
  FDConnection1.Connected := true;

  lvChipkartenausgabe.Items.Clear;

  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := FDConnection1;

    FDQuery.SQL.Clear;
    FDQuery.SQL.Text := 'SELECT C.id, C.ausweisnr, C.chipkartenNr, C.betreten, C.verlassen, C.besuchter, C.kfzkennzeichen, C.bemerkungen, ' +
                        'B.id AS BesucherID, B.nachname, B.vorname, B.firma, B.ausweisnummer, B.gueltigbis, ' +
                        'A.nachname || '' '' || substr(A.vorname, 1, 1) || ''.'' AS bediener ' +
                        'FROM chipkartenausgabe AS C LEFT JOIN besucher AS B On B.id = C.besucherid ' +
                        'LEFT JOIN bediener AS A ON A.id = C.bedienerID ';

    if(art = 'Ausgegeben') then
    begin
      FDQuery.SQL.Add('WHERE C.verlassen = :verlassen');
      FDQuery.SQL.Add('ORDER BY C.betreten ASC');
      FDQuery.ParamByName('verlassen').AsString := '';
    end
    else if(art = 'Heute') then
    begin
      FDQuery.SQL.Add('WHERE DATE(C.betreten) = :CurrentDate');
      FDQuery.SQL.Add('ORDER BY C.betreten ASC, C.verlassen ASC');
      FDQuery.ParamByName('CurrentDate').AsString := FormatDateTime('YYYY-MM-DD', date);
    end
    else if(art = 'Monat') then
    begin
      FDQuery.SQL.Add('WHERE STRFTIME(''%Y-%m'', C.betreten) = :CurrentMonth');
      FDQuery.SQL.Add('ORDER BY C.betreten ASC, C.verlassen ASC');
      FDQuery.ParamByName('CurrentMonth').AsString := FormatDateTime('YYYY-MM', date);
    end
    else if(art = 'Jahr') then
    begin
      FDQuery.SQL.Add('WHERE STRFTIME(''%Y'', C.betreten) = :CurrentYear');
      FDQuery.SQL.Add('ORDER BY C.betreten ASC, C.verlassen ASC');
      FDQuery.ParamByName('CurrentYear').AsString := FormatDateTime('YYYY', date);
    end
    else if(art = 'Alles') then
    begin
      FDQuery.SQL.Add('ORDER BY C.betreten ASC, C.verlassen ASC');
    end;



    FDQuery.Open;

    while not FDQuery.Eof do
    begin
      l := lvChipkartenausgabe.Items.Add;
      l.Caption := FDQuery.FieldByName('id').AsString;
      l.SubItems.Add(FDQuery.FieldByName('BesucherID').AsString);
      l.SubItems.Add(FDQuery.FieldByName('bediener').AsString);
      l.SubItems.Add(FDQuery.FieldByName('chipkartennr').AsString);

      //Betreten SQL DateTime in Deutsches Format umwandeln
      DBDate := FDQuery.FieldByName('betreten').AsString;
      DEDate := ConvertSQLDateToGermanDate(DBDate, true);
      l.SubItems.Add(DEDate);

      //Verlassen SQL DateTime in Deutsches Format umwandeln
      if(FDQuery.FieldByName('verlassen').AsString <> '') then
      begin
        DBDate := FDQuery.FieldByName('verlassen').AsString;
        DEDate := ConvertSQLDateToGermanDate(DBDate, true);
        l.SubItems.Add(DEDate);
      end
      else
      begin
        l.SubItems.Add('');
      end;

      l.SubItems.Add(FDQuery.FieldByName('nachname').AsString);
      l.SubItems.Add(FDQuery.FieldByName('vorname').AsString);
      l.SubItems.Add(FDQuery.FieldByName('ausweisnr').AsString);
      l.SubItems.Add(FDQuery.FieldByName('firma').AsString);
      l.SubItems.Add(FDQuery.FieldByName('kfzkennzeichen').AsString);
      l.SubItems.Add(FDQuery.FieldByName('besuchter').AsString);

      FDQuery.next;
    end;

  finally
    FDQuery.Free;
  end;

  FDConnection1.Connected := false;
end;








procedure TfMain.Sicherungerstellen1Click(Sender: TObject);
var
  DBBACKUPDIR: string;
begin
  DBBACKUPDIR := IncludeTrailingPathDelimiter(PATH + 'DBDUMPS');
  BackupSQLiteDatabase(DBNAME, DBBACKUPDIR);
end;



procedure TfMain.Timer1Timer(Sender: TObject);
begin
  StatusBar1.Panels[1].Text := FormatDateTime('DD.MM.YYYY HH:NN', now, GlobalFormatSettings);
end;




procedure TfMain.TimerBackupTimer(Sender: TObject);
var
  Jetzt: TDateTime;
  Jahr, Monat, Tag, Stunde, Minute, Sekunde, Millisekunde: Word;
  IstZeit, SollZeit, MinutenDiff: Integer;
  DBBACKUPDIR: string;
begin
  Jetzt := Now;
  DecodeDateTime(Jetzt, Jahr, Monat, Tag, Stunde, Minute, Sekunde, Millisekunde);

  if (DayOfWeek(Jetzt) = AutoSicherungWochentag) then
  begin
    // Zeitvergleich mit Toleranz von ±1 Minute
    SollZeit := AutoSicherungStunde * 60 + AutoSicherungMinute;
    IstZeit  := Stunde * 60 + Minute;
    MinutenDiff := Abs(SollZeit - IstZeit);

    if (MinutenDiff <= 1)
      and ((LASTBACKUP = 0) or (WeekOf(LASTBACKUP) <> WeekOf(Jetzt))) then
    begin
      DBBACKUPDIR := IncludeTrailingPathDelimiter(PATH + 'DBDUMPS');
      BackupSQLiteDatabase(DBNAME, DBBACKUPDIR);

      LASTBACKUP := Jetzt;

      UpdateNextBackupInfo(AutoSicherungWochentag, AutoSicherungStunde, AutoSicherungMinute, Now + 1);
    end;
  end;
end;




procedure TfMain.UpdateNextBackupInfo(Wochentag, ZielStunde, ZielMinute: Integer; Referenzzeit: TDateTime);
var
  ZielDatum: TDateTime;
  TageBisZiel: Integer;
begin
  // Wieviele Tage bis zum nächsten Zielwochentag?
  TageBisZiel := Wochentag - DayOfWeek(Referenzzeit);
  if TageBisZiel < 0 then
    TageBisZiel := TageBisZiel + 7
  else if TageBisZiel = 0 then
  begin
    // Heute ist Zieltag → Uhrzeit vergleichen
    if (HourOf(Referenzzeit) > ZielStunde) or
       ((HourOf(Referenzzeit) = ZielStunde) and (MinuteOf(Referenzzeit) >= ZielMinute)) then
      TageBisZiel := 7; // nächste Woche
  end;

  ZielDatum := Trunc(Referenzzeit) + TageBisZiel;
  ZielDatum := EncodeDateTime(YearOf(ZielDatum), MonthOf(ZielDatum), DayOf(ZielDatum),
                              ZielStunde, ZielMinute, 0, 0);

  StatusBar1.Panels[2].Text := 'Nächste Sicherung: ' + FormatDateTime('ddd, dd.mm.yyyy hh:nn', ZielDatum);
end;


procedure TfMain.AdjustListViewColumns(lv: TAdvListView);
var
  i, TotalWidth, RemainingWidth: Integer;
begin
  // Verhindere Division durch Null
  if lv.Columns.Count = 0 then
    Exit;

  // Berechne die Gesamtbreite des ListView-Inhalts
  TotalWidth := lv.ClientWidth;

  // Verteile die Breite gleichmäßig auf alle Spalten
  RemainingWidth := TotalWidth div lv.Columns.Count;

  for i := 0 to lv.Columns.Count - 1 do
  begin
    lv.Columns[i].Width := RemainingWidth;
  end;

  // Adjust last column to fill any remaining space due to integer division rounding
  lv.Columns[lv.Columns.Count - 1].Width := TotalWidth - (RemainingWidth * (lv.Columns.Count - 1));
end;






end.
