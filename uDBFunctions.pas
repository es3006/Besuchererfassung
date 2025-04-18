unit uDBFunctions;


interface

uses
  System.SysUtils, Vcl.StdCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteDef, FireDAC.Phys.SQLite, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, System.Classes, Vcl.Graphics, Dialogs, DateUtils, ComCtrls,
  System.Zip, System.IOUtils, System.hash;



procedure CreateDatabaseTables;
procedure CreateIndexes;
procedure LoadAusweisarten(cb: TComboBox);
procedure LoadStaaten(cb: TComboBox);
function getBesucherIDByAusweisNr(ausweisnr: string): integer;
procedure LoadUserSettingsFromDB;
procedure LoadAdminSettingsFromDB;
procedure importStaatenInDB(const CSVFileName: string);
function IsOnTheListOfStates(staat: string): boolean;
function getBesucherNameByID(id: integer): string;
procedure DSGVODelOldEntries(tabelle: string; spalte: string);
procedure DSGVODelBesucher;
procedure LoadAusgegebeneChipkarten(cb: TComboBox; sb: TStatusBar);
procedure BackupAllTables;
procedure BackupSQLiteTable(const TableName: string; const BackupDir: string);
procedure ZipDir(const Dir: string);
procedure ImportSQLiteTable(const SQLFileName: string);
procedure ExtractAndImportSQLFiles(const ZipFileName, TargetDir: string);


var
  Ausweisarten: array of string = ['Personalausweis','Reisepass','Truppenausweis','Dienstausweis','Aufenthaltstitel','ID Card'];



implementation





uses
  uMain, uFunktionen;






procedure CreateDatabaseTables;
var
  FDQuery: TFDQuery;
  ausweisart: string;
begin
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := fMain.FDConnection1;

    FDQuery.SQL.Text := 'SELECT name FROM sqlite_master WHERE type="table" AND name="bediener"';
    FDQuery.Open();
    if not FDQuery.IsEmpty then
      Exit
    else
    begin
      FDQuery.SQL.Text := 'CREATE TABLE bediener ( ' +
                          'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
                          'username TEXT NOT NULL, ' +
                          'userpw BLOB NOT NULL, ' +
                          'nachname TEXT NOT NULL, ' +
                          'vorname TEXT NOT NULL, ' +
                          'email TEXT, ' +
                          'telefon TEXT, ' +
                          'admin INTEGER, ' +
                          'logged INTEGER);';
      FDQuery.ExecSQL;
    end;


    FDQuery.SQL.Text := 'INSERT INTO bediener (username, userpw, nachname, vorname, admin, logged) '+
                          'VALUES (:USERNAME, :USERPW, :NACHNAME, :VORNAME, :ADMIN, :LOGGED)';
    FDQuery.ParamByName('USERNAME').AsString := 'esd';
    FDQuery.ParamByName('USERPW').AsString   := THashSHA1.GetHashString('ESD123esd');
    FDQuery.ParamByName('NACHNAME').AsString := 'ESD';
    FDQuery.ParamByName('VORNAME').AsString  := 'ESD';
    FDQuery.ParamByName('ADMIN').AsInteger   := 1;
    FDQuery.ParamByName('LOGGED').AsInteger  := 0;
    FDQuery.ExecSQL;


    FDQuery.SQL.Text := 'SELECT name FROM sqlite_master WHERE type="table" AND name="besucher"';
    FDQuery.Open();
    if not FDQuery.IsEmpty then
      Exit
    else
    begin
      FDQuery.SQL.Text := 'CREATE TABLE besucher (' +
                          'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
                          'nachname TEXT NOT NULL, ' +
                          'vorname TEXT NOT NULL, ' +
                          'firma TEXT, ' +
                          'strasse_hausnummer TEXT, ' +
                          'plz_ort TEXT, ' +
                          'ausweisnummer TEXT NOT NULL, ' +
                          'ausweisart TEXT NOT NULL, ' +
                          'ausstellungsstaat TEXT NOT NULL, ' +
                          'gueltigbis TEXT NOT NULL, ' +
                          'registriert TEXT NOT NULL);';
      FDQuery.ExecSQL;
    end;


    FDQuery.SQL.Text := 'SELECT name FROM sqlite_master WHERE type="table" AND name="chipkartenausgabe"';
    FDQuery.Open();
    if not FDQuery.IsEmpty then
      Exit
    else
    begin
      FDQuery.SQL.Text := 'CREATE TABLE chipkartenausgabe (' +
                          'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
                          'bedienerID INTEGER NOT NULL, ' +
                          'besucherID INTEGER NOT NULL, ' +
                          'ausweisnr TEXT NOT NULL, ' +
                          'chipkartenNr INTEGER NOT NULL, ' +
                          'betreten TEXT NOT NULL, ' +
                          'verlassen TEXT, ' +
                          'besuchter TEXT, ' +
                          'kfzkennzeichen, ' +
                          'bemerkungen TEXT);';
      FDQuery.ExecSQL;
    end;



    FDQuery.SQL.Text := 'SELECT name FROM sqlite_master WHERE type="table" AND name="besucheranmeldungen"';
    FDQuery.Open();
    if not FDQuery.IsEmpty then
      Exit
    else
    begin
      FDQuery.SQL.Text := 'CREATE TABLE besucheranmeldungen (' +
                          'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
                          'bedienerID INTEGER NOT NULL, ' +
                          'besucherID INTEGER NOT NULL, ' +
                          'ausweisnr TEXT NOT NULL, ' +
                          'anmeldung_von TEXT NOT NULL, ' +
                          'anmeldung_bis TEXT NOT NULL, ' +
                          'besuchter TEXT, ' +
                          'kfzkennzeichen TEXT, ' +
                          'bemerkungen TEXT);';
      FDQuery.ExecSQL;
    end;


    FDQuery.SQL.Text := 'SELECT name FROM sqlite_master WHERE type="table" AND name="ausweisarten"';
    FDQuery.Open();
    if not FDQuery.IsEmpty then
      Exit
    else
    begin
      FDQuery.SQL.Text := 'CREATE TABLE ausweisarten (id INTEGER PRIMARY KEY AUTOINCREMENT, ausweisart TEXT NOT NULL)';
      FDQuery.ExecSQL;

      FDQuery.SQL.Text := 'INSERT INTO ausweisarten (ausweisart) VALUES (:ausweisart)';
      FDQuery.Params[0].DataType := ftString;

      FDQuery.Connection.StartTransaction;
      try
        // Schleife zum Einfügen der Ausweisarten
        for Ausweisart in Ausweisarten do
        begin
          FDQuery.ParamByName('ausweisart').AsString := Ausweisart;
          FDQuery.ExecSQL;
        end;

        FDQuery.Connection.Commit;
      except
        FDQuery.Connection.Rollback;
        raise;
      end;
    end;



    FDQuery.SQL.Text := 'SELECT name FROM sqlite_master WHERE type="table" AND name="staaten"';
    FDQuery.Open();
    if not FDQuery.IsEmpty then
      Exit
    else
    begin
      FDQuery.SQL.Text := 'CREATE TABLE staaten (id INTEGER PRIMARY KEY AUTOINCREMENT, kuerzel TEXT, staat TEXT, staatenliste TEXT)';
      FDQuery.ExecSQL;

      if(FileExists('staaten.csv')) then
        importStaatenInDB('staaten.csv');
        DeleteFile('staaten.csv');
    end;


    FDQuery.SQL.Text := 'SELECT name FROM sqlite_master WHERE type="table" AND name="einstellungen"';
    FDQuery.Open();
    if not FDQuery.IsEmpty then
      Exit
    else
    begin
      FDQuery.SQL.Text := 'CREATE TABLE einstellungen (' +
                          'id INTEGER PRIMARY KEY AUTOINCREMENT, '+
                          'bedienerID INTEGER NOT NULL, ' +
                          'lineHeight INTEGER, ' +
                          'lvSelEntryBGColor TEXT, ' +
                          'lvSelEntryVGColor TEXT);';
      FDQuery.ExecSQL;

      FDQuery.SQL.Text := 'INSERT INTO einstellungen (bedienerID, lineHeight, lvSelEntryBGColor, lvSelEntryVGColor) '+
                          'VALUES (:bedienerID, :lineHeight, :lvSelEntryBGColor, :lvSelEntryVGColor)';
      FDQuery.ParamByName('bedienerID').AsInteger := 1;
      FDQuery.ParamByName('lineHeight').AsInteger := 50;
      FDQuery.ParamByName('lvSelEntryBGColor').AsString := '$000080FF'; //Orange
      FDQuery.ParamByName('lvSelEntryVGColor').AsString := 'clWhite';   //Weiss

      FDQuery.ExecSQL;
    end;



    FDQuery.SQL.Text := 'SELECT name FROM sqlite_master WHERE type="table" AND name="admin_einstellungen"';
    FDQuery.Open();
    if not FDQuery.IsEmpty then
      Exit
    else
    begin
      FDQuery.SQL.Text := 'CREATE TABLE admin_einstellungen (' +
                          'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
                          'dsgvoDelTime INTEGER, ' +
                          'dsgvoAutoDel INTEGER, ' +
                          'autoSaveDatabaseWochentag INTEGER, ' +
                          'autoSaveDatabaseStunde INTEGER, ' +
                          'autoSaveDatabaseMinute INTEGER);';
      FDQuery.ExecSQL;


      FDQuery.SQL.Text := 'INSERT INTO admin_einstellungen (dsgvoDelTime, dsgvoAutoDel, autoSaveDatabaseWochentag, autoSaveDatabaseStunde, autoSaveDatabaseMinute) '+
                          'VALUES (:dsgvodeltime, :dsgvoAutoDel, :autoSaveDatabaseWochentag, :autoSaveDatabaseStunde, :autoSaveDatabaseMinute )';
      FDQuery.ParamByName('dsgvodeltime').AsInteger := 1095;
      FDQuery.ParamByName('dsgvoAutoDel').AsInteger := 1;
      FDQuery.ParamByName('autoSaveDatabaseWochentag').AsInteger := 1; //Sonntag
      FDQuery.ParamByName('autoSaveDatabaseStunde').AsInteger := 22;   //22 Uhr
      FDQuery.ParamByName('autoSaveDatabaseMinute').AsInteger := 0;    //0 Minuten

      FDQuery.ExecSQL;
    end;


  finally
    FDQuery.Free;
  end;
end;





//Indexe auf oft abgefragte Spalten erstellen um die Datenbankabfragen zu optimieren
procedure CreateIndexes;
begin
  with fMain.FDConnection1 do
  begin
    ExecSQL('CREATE INDEX IF NOT EXISTS ausweisnummer ON besucher(ausweisnummer);');
    ExecSQL('CREATE INDEX IF NOT EXISTS besucherid ON besucheranmeldungen(besucherid);');
    ExecSQL('CREATE INDEX IF NOT EXISTS chipkartenNr ON chipkartenausgabe(chipkartenNr);');
    ExecSQL('CREATE INDEX IF NOT EXISTS besucherID ON chipkartenausgabe(besucherID);');
    ExecSQL('CREATE INDEX IF NOT EXISTS registriert ON besucher(registriert);');
  end;
end;





procedure LoadAusweisarten(cb: TComboBox);
var
  FDQuery: TFDQuery;
begin
  fMain.FDConnection1.Connected := true;

  cb.Items.Clear;

  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := fMain.FDConnection1;

    FDQuery.SQL.Text := 'SELECT ausweisart FROM ausweisarten ORDER BY ausweisart ASC;';
    FDQuery.Open;

    while not FDQuery.Eof do
    begin
        cb.Items.Add(FDQuery.FieldByName('ausweisart').AsString);
        FDQuery.next;
    end;

  finally
    FDQuery.Free;
  end;

  fMain.FDConnection1.Connected := false;
end;





procedure LoadStaaten(cb: TComboBox);
var
  FDQuery: TFDQuery;
begin
  fMain.FDConnection1.Connected := true;

  cb.Items.Clear;

  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := fMain.FDConnection1;

    FDQuery.SQL.Text := 'SELECT staat FROM staaten ORDER BY staat ASC;';
    FDQuery.Open;

    while not FDQuery.Eof do
    begin
        cb.Items.Add(FDQuery.FieldByName('staat').AsString);
        FDQuery.next;
    end;

  finally
    FDQuery.Free;
  end;

  fMain.FDConnection1.Connected := false;
end;





//Datenbanktabelle "besucher" anhand der Ausweisnr eines Besuchers durchsuchen
//Wenn Ausweisnr in Datenban gefunden wurde, ID des Besuchers zurückgeben
function getBesucherIDByAusweisNr(ausweisnr: string): integer;
var
  FDQuery: TFDQuery;
begin
  fMain.FDConnection1.Connected := true;

  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := fMain.FDConnection1;

    FDQuery.SQL.Text := 'SELECT id FROM besucher WHERE ausweisnummer = :ausweisnr LIMIT 0, 1;';
    FDQuery.ParamByName('ausweisnr').AsString := ausweisnr;
    FDQuery.Open;

    if not FDQuery.IsEmpty then
    begin
      result := FDQuery.FieldByName('id').AsInteger;
    end
    else
    begin
      result := 0;
    end;

  finally
    FDQuery.Free;
  end;

  fMain.FDConnection1.Connected := false;
end;




procedure LoadUserSettingsFromDB;
var
  FDQuery: TFDQuery;
begin
  fMain.FDConnection1.Connected := true;

  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := fMain.FDConnection1;

    FDQuery.SQL.Text := 'SELECT lineHeight, lvSelEntryBGColor, lvSelEntryVGColor FROM einstellungen '+
                        'WHERE bedienerID = :bedienerID LIMIT 0, 1;';
    FDQuery.ParamByName('bedienerid').AsInteger := BEDIENERID;
    FDQuery.Open;

    if not FDQuery.IsEmpty then
    begin
      LINEHEIGHT   := FDQuery.FieldByName('lineHeight').AsInteger;
      LVSELBGCOLOR := StringToColor(FDQuery.FieldByName('lvSelEntryBGColor').AsString);
      LVSELVGCOLOR := StringToColor(FDQuery.FieldByName('lvSelEntryVGColor').AsString);

      with fMain do
      begin
        SetListViewProperties(lvBesucher);
        SetListViewProperties(lvAnmeldungen);
        SetListViewProperties(lvChipkartenausgabe);
      end;
    end;

  finally
    FDQuery.Free;
  end;

  fMain.FDConnection1.Connected := false;
end;




procedure LoadAdminSettingsFromDB;
var
  FDQuery: TFDQuery;
begin
  fMain.FDConnection1.Connected := true;

  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := fMain.FDConnection1;

    FDQuery.SQL.Text := 'SELECT dsgvoDelTime, dsgvoAutoDel, autoSaveDatabaseWochentag, autoSaveDatabaseStunde, autoSaveDatabaseMinute FROM admin_einstellungen LIMIT 0, 1;';
    FDQuery.Open;

    if not FDQuery.IsEmpty then
    begin
      DSGVODELTIME := FDQuery.FieldByName('dsgvoDelTime').AsInteger;
      if(FDQuery.FieldByName('dsgvoAutoDel').AsInteger = 1) then
        DSGVOAUTODEL := true
      else
        DSGVOAUTODEL := false;

      AutoSicherungWochentag := FDQuery.FieldByName('autoSaveDatabaseWochentag').AsInteger;
      AutoSicherungStunde    := FDQuery.FieldByName('autoSaveDatabaseStunde').AsInteger;
      AutoSicherungMinute    := FDQuery.FieldByName('autoSaveDatabaseMinute').AsInteger;
    end;
  finally
    FDQuery.Free;
  end;

  fMain.FDConnection1.Connected := false;
end;











procedure importStaatenInDB(const CSVFileName: string);
var
  FDQuery: TFDQuery;
  StreamReader: TStreamReader;
  Line, SQLInsert: string;
  Values: TStringList;
begin
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := fMain.FDConnection1;

    // CSV-Datei öffnen mit UTF-8-Codierung
    StreamReader := TStreamReader.Create(CSVFileName, TEncoding.UTF8);
    try
      while not StreamReader.EndOfStream do
      begin
        Line := StreamReader.ReadLine;
        Values := TStringList.Create;
        try
          Values.Delimiter := ';';  // Annahme: CSV ist Semikolon-getrennt
          Values.StrictDelimiter := True;
          Values.DelimitedText := Line;

          if Values.Count >= 2 then
          begin
            SQLInsert := 'INSERT INTO staaten (kuerzel, staat, staatenliste) VALUES (' +
                         QuotedStr(Values[0]) + ', ' +
                         QuotedStr(Values[1]) + ', ' +
                         QuotedStr(Values[2]) + ')';
            FDQuery.SQL.Text := SQLInsert;
            FDQuery.ExecSQL;
          end;
        finally
          Values.Free;
        end;
      end;
    finally
      StreamReader.Free;
    end;
  finally
    FDQuery.Free;
  end;
end;




function IsOnTheListOfStates(staat: string): boolean;
var
  FDQuery: TFDQuery;
begin
  result := false;
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := fMain.FDConnection1;
    FDQuery.SQL.Text := 'SELECT staatenliste FROM staaten WHERE staat = :staat';
    FDQuery.ParamByName('staat').AsString := staat;
    FDQuery.Open;

    // Überprüfen, ob Datensätze vorhanden sind
    if not FDQuery.IsEmpty then
    begin
      if(FDQuery.FieldByName('staatenliste').AsString = 'y') then
        result := true
      else
        result := false;
    end;
  finally
    FDQuery.Free;
  end;
end;





function getBesucherNameByID(id: integer): string;
var
  FDQuery: TFDQuery;
begin
  result := '';
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := fMain.FDConnection1;
    FDQuery.SQL.Text := 'SELECT nachname || " " || vorname AS besuchername FROM besucher WHERE id = :id';
    FDQuery.ParamByName('id').AsInteger := id;
    FDQuery.Open;

    if not FDQuery.IsEmpty then
      result := FDQuery.FieldByName('besuchername').AsString
    else
      result := '';
  finally
    FDQuery.Free;
  end;
end;





{
  Hier alles was benötigt wird um die DSGVO umzusetzen
  Test ob Einträge älter als X Tage sind und diese automatisch löschen
}
procedure DSGVODelOldEntries(tabelle: string; spalte: string);
var
  FDQuerySelect, FDQueryDelete: TFDQuery;
  ComparisonDate: TDateTime;
  id: Integer;
  DelCounter: integer;
begin
  DelCounter := 0;


  if DSGVOAUTODEL then
  begin
    ComparisonDate := Now - DSGVODELTIME;

    FDQuerySelect := TFDQuery.Create(nil);
    FDQueryDelete := TFDQuery.Create(nil);
    try
      FDQuerySelect.Connection := fMain.FDConnection1;
      FDQueryDelete.Connection := fMain.FDConnection1;

      // Alle Chipkartenausgaben oder Besucheranmeldungen auslesen, die nach DSGVO abgelaufen sind
      FDQuerySelect.SQL.Text := 'SELECT id FROM '+tabelle+' WHERE '+spalte+' < :ComparisonDate';
      FDQuerySelect.ParamByName('ComparisonDate').AsDateTime := ComparisonDate;
      FDQuerySelect.Open;

      while not FDQuerySelect.Eof do
      begin
        id := FDQuerySelect.FieldByName('id').AsInteger;

        // Chipkartenausgaben oder Besucheranmeldungen löschen
        FDQueryDelete.SQL.Text := 'DELETE FROM '+tabelle+' WHERE id = :CID';
        FDQueryDelete.ParamByName('CID').AsInteger := id;
        FDQueryDelete.ExecSQL;

        inc(DelCounter);

        FDQuerySelect.Next;
      end;
    finally
      FDQuerySelect.Free;
      FDQueryDelete.Free;
    end;
    if(DelCounter>0) then
    begin
      showmessage(IntToStr(DelCounter)+' ' + tabelle + ' nach DSGVO gelöscht.');
      fMain.StatusBar1.Panels[2].Text := IntToStr(DelCounter)+' ' + tabelle + ' nach DSGVO gelöscht.';
      fMain.LoadDataFromDB;
    end;
  end
  else
  begin
    fMain.StatusBar1.Panels[2].Text := 'DSGVO Funktion deaktiviert';
  end;
end;





{
  Hier alle Besucher löschen deren Datum in 'registriert' älter als DSGVODELTIME ist
  und denen weder Chipkartenausgaben noch Besucheranmeldungen zugewiesen sind.
}
procedure DSGVODelBesucher;
var
  FDQuerySelect, FDQueryDelete: TFDQuery;
  ComparisonDate: TDateTime;
  id: Integer;
  DelCounter: Integer;
begin
  DelCounter := 0;

  if DSGVOAUTODEL then
  begin
    ComparisonDate := Now - DSGVODELTIME;

    FDQuerySelect := TFDQuery.Create(nil);
    FDQueryDelete := TFDQuery.Create(nil);
    try
      FDQuerySelect.Connection := fMain.FDConnection1;
      FDQueryDelete.Connection := fMain.FDConnection1;

      FDQuerySelect.SQL.Text :=
        'SELECT b.id FROM besucher b ' +
        'LEFT JOIN besucheranmeldungen ba ON b.id = ba.besucherID ' +
        'LEFT JOIN chipkartenausgabe ca ON b.id = ca.besucherID ' +
        'WHERE b.registriert < :ComparisonDate ' +
        'AND ba.besucherID IS NULL AND ca.besucherID IS NULL;';
      FDQuerySelect.ParamByName('ComparisonDate').AsDateTime := ComparisonDate;
      FDQuerySelect.Open;

      while not FDQuerySelect.Eof do
      begin
        id := FDQuerySelect.FieldByName('id').AsInteger;

        // Besucher löschen
        FDQueryDelete.SQL.Text := 'DELETE FROM besucher WHERE id = :BID;';
        FDQueryDelete.ParamByName('BID').AsInteger := id;
        FDQueryDelete.ExecSQL;

        if FDQueryDelete.RowsAffected > 0 then
          Inc(DelCounter);

        FDQuerySelect.Next;
      end;
    finally
      FDQuerySelect.Free;
      FDQueryDelete.Free;
    end;

    if DelCounter > 0 then
    begin
      ShowMessage(IntToStr(DelCounter) + ' Besucher nach DSGVO gelöscht.');
      fMain.StatusBar1.Panels[2].Text := IntToStr(DelCounter) + ' Besucher nach DSGVO gelöscht.';
      fMain.LoadDataFromDB;
    end;
  end
  else
  begin
    fMain.StatusBar1.Panels[2].Text := 'DSGVO Funktion deaktiviert';
  end;
end;










procedure LoadAusgegebeneChipkarten(cb: TComboBox; sb: TStatusBar);
var
  FDQuery: TFDQuery;
  vergebeneChipkarten: integer;
  s: string;
begin
  vergebeneChipkarten := 0;

  fMain.FDConnection1.Connected := true;

  cb.Items.Clear;

  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := fMain.FDConnection1;

    FDQuery.SQL.Text := 'SELECT chipkartenNr FROM chipkartenausgabe WHERE verlassen = :verlassen ORDER BY chipkartennr ASC;';
    FDQuery.ParamByName('verlassen').AsString := '';
    FDQuery.Open;

    while not FDQuery.Eof do
    begin
        cb.Items.Add(FDQuery.FieldByName('chipkartenNr').AsString);
        inc(vergebeneChipkarten);
        FDQuery.next;
    end;

  finally
    FDQuery.Free;
  end;

  if(vergebeneChipkarten = 1) then
  begin
    s := 'Aktuell ist ' + IntToStr(vergebeneChipkarten) + ' Chipkarte ausgegeben.';
  end
  else if(vergebeneChipkarten = 0) then
  begin
    s := 'Aktuell ist keine Chipkarte ausgegeben.';
  end
  else if(vergebeneChipkarten > 1) then
  begin
    s := 'Aktuell sind ' + IntToStr(vergebeneChipkarten) + ' Chipkarten ausgegeben.';
  end;

  sb.Panels[0].Text := s;


  fMain.FDConnection1.Connected := false;
end;






procedure BackupAllTables;
var
  FDQuery: TFDQuery;
  TableNames: TStringList;
  i: Integer;
  BackupDir: string;
begin
  TableNames := TStringList.Create;
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := fMain.FDConnection1;
    FDQuery.SQL.Text := 'SELECT name FROM sqlite_master WHERE type=''table'' AND name NOT LIKE ''sqlite_%'';';
    FDQuery.Open;

    while not FDQuery.Eof do
    begin
      TableNames.Add(FDQuery.Fields[0].AsString);
      FDQuery.Next;
    end;

    // Erzeuge das Verzeichnis für das aktuelle Datum
    BackupDir := IncludeTrailingPathDelimiter(PATH + 'DBDUMPS') + FormatDateTime('DDMMYYYY', Now);
    if not DirectoryExists(BackupDir) then
    begin
      if not ForceDirectories(BackupDir) then
      begin
        ShowMessage('Fehler beim Erstellen des Verzeichnisses ' + BackupDir);
        Exit;
      end;
    end;

    // Sichere jede Tabelle in das entsprechende Verzeichnis
    for i := 0 to TableNames.Count - 1 do
    begin
      BackupSQLiteTable(TableNames[i], BackupDir);
    end;

    // Packe das Verzeichnis am Ende des Vorgangs
    ZipDir(BackupDir);
  finally
    FDQuery.Free;
    TableNames.Free;
  end;
end;





procedure BackupSQLiteTable(const TableName: string; const BackupDir: string);
var
  FDQuery: TFDQuery;
  SQLFile: TStringList;
  FileName: string;
  i: integer;
  Field: TField;
  FieldType: string;
  InsertSQL, CreateTableSQL: string;
begin
  FDQuery := TFDquery.Create(nil);
  SQLFile := TStringList.Create;
  try
    with FDQuery do
    begin
      Connection := fMain.FDConnection1;
      SQL.Text := Format('SELECT * FROM %s', [TableName]);
      Open;

      // Erzeuge die CREATE TABLE-Anweisung
      CreateTableSQL := Format('DROP TABLE IF EXISTS %s; CREATE TABLE %s (', [TableName, TableName]);
      for i := 0 to FDQuery.FieldCount - 1 do
      begin
        Field := FDQuery.Fields[i];

        // Überprüfen, ob es sich um die id-Spalte handelt
        if (Field.FieldName = 'id') and (Field.DataType in [ftInteger, ftAutoInc]) then
          FieldType := 'INTEGER PRIMARY KEY AUTOINCREMENT'
        else
        begin
        case Field.DataType of
            ftString, ftMemo, ftWideString, ftWideMemo:
              FieldType := 'TEXT';
            ftInteger, ftSmallint, ftWord, ftAutoInc:
              FieldType := 'INTEGER';
            ftFloat, ftCurrency, ftBCD:
              FieldType := 'REAL';
            ftDate, ftTime, ftDateTime, ftTimeStamp:
              FieldType := 'TEXT'; // SQLite speichert Datumswerte als TEXT
            else
              FieldType := 'BLOB';
          end;
        end;

        if i > 0 then
          CreateTableSQL := CreateTableSQL + ', ';

        CreateTableSQL := CreateTableSQL + Format('%s %s', [Field.FieldName, FieldType]);
      end;
      CreateTableSQL := CreateTableSQL + ');';
      SQLFile.Add(CreateTableSQL);

      // Füge die INSERT-Anweisungen hinzu
      FDQuery.First;
      while not FDQuery.Eof do
      begin
        InsertSQL := Format('INSERT INTO %s VALUES (', [TableName]);
        for i := 0 to FDQuery.FieldCount - 1 do
        begin
          if i > 0 then
            InsertSQL := InsertSQL + ', ';

          if FDQuery.Fields[i].IsNull then
            InsertSQL := InsertSQL + 'NULL'
          else
            InsertSQL := InsertSQL + QuotedStr(FDQuery.Fields[i].AsString);
        end;
        InsertSQL := InsertSQL + ');';
        SQLFile.Add(InsertSQL);
        FDQuery.Next;
      end;

      // Speichere die SQL-Anweisungen in einer Datei
      FileName := Format('%s.sql', [TableName]);
      SQLFile.SaveToFile(IncludeTrailingPathDelimiter(BackupDir) + FileName);
    end;
  finally
    FDQuery.Free;
    SQLFile.Free;
  end;
end;







procedure ZipDir(const Dir: string);
var
  ZipFile: TZipFile;
  SearchRec: TSearchRec;
  FilePath: string;
  FullDirPath: string;
begin
  // Sicherstellen, dass der Pfad ohne zusätzliche Leerzeichen oder ungültige Zeichen ist
  FullDirPath := Trim(Dir);

  ZipFile := TZipFile.Create;
  try
    ZipFile.Open(FullDirPath + '.zip', zmWrite);

    // Verzeichnisinhalt durchsuchen und Dateien zur Zip-Datei hinzufügen
    if FindFirst(IncludeTrailingPathDelimiter(FullDirPath) + '*.sql', faAnyFile, SearchRec) = 0 then
    begin
      repeat
        FilePath := IncludeTrailingPathDelimiter(FullDirPath) + SearchRec.Name;
        ZipFile.Add(FilePath, ExtractFileName(FilePath));
      until FindNext(SearchRec) <> 0;
      FindClose(SearchRec);
    end;

    ZipFile.Close;
  finally
    ZipFile.Free;
  end;

  // Nach erfolgreicher Zip-Erstellung Verzeichnis löschen
  if DirectoryExists(FullDirPath) then
    TDirectory.Delete(FullDirPath, True);
end;










procedure ImportSQLiteTable(const SQLFileName: string);
var
  FDQuery: TFDQuery;
  SQLFile: TStringList;
  TableName, InsertSQL: string;
  HighestID: Integer;
begin
  FDQuery := TFDQuery.Create(nil);
  SQLFile := TStringList.Create;
  try
    // 1. Lade die SQL-Datei
    SQLFile.LoadFromFile(SQLFileName);

    // 2. Extrahiere den Tabellennamen aus der CREATE TABLE-Anweisung
    TableName := '';
    if SQLFile.Count > 0 then
    begin
      InsertSQL := SQLFile[0];
      if Pos('CREATE TABLE ', InsertSQL) = 1 then
      begin
        InsertSQL := Copy(InsertSQL, 14, MaxInt);
        TableName := Copy(InsertSQL, 1, Pos(' ', InsertSQL) - 1);
      end;
    end;

    // 3. Führe die SQL-Befehle aus
    FDQuery.Connection := fMain.FDConnection1;
    FDQuery.SQL.Text := SQLFile.Text;
    FDQuery.ExecSQL;

    // 4. Optional: Aktualisiere sqlite_sequence
    if TableName <> '' then
    begin
      FDQuery.SQL.Text := Format('SELECT MAX(id) FROM %s', [TableName]);
      FDQuery.Open;
      HighestID := FDQuery.Fields[0].AsInteger;

      FDQuery.SQL.Text := 'INSERT OR REPLACE INTO sqlite_sequence (name, seq) VALUES (:TableName, :Seq)';
      FDQuery.Params.ParamByName('TableName').AsString := TableName;
      FDQuery.Params.ParamByName('Seq').AsInteger := HighestID;
      FDQuery.ExecSQL;
    end;
  finally
    FDQuery.Free;
    SQLFile.Free;
  end;
end;





procedure ExtractAndImportSQLFiles(const ZipFileName, TargetDir: string);
var
  ZipFile: TZipFile;
  ArchiveDir: string;
  SQLFiles: TStringList;
  SQLQuery: TFDQuery;
  SQLFileContent: TStringList;
  i: Integer;
begin
  ZipFile := TZipFile.Create;
  SQLFiles := TStringList.Create;
  SQLQuery := TFDQuery.Create(nil);
  SQLFileContent := TStringList.Create;

  try
    ZipFile.Open(ZipFileName, zmRead);

    // Extrahiere alle SQL-Dateien aus dem Zip-Archiv
    for i := 0 to ZipFile.FileCount - 1 do
    begin
      if SameText(ExtractFileExt(ZipFile.FileNames[i]), '.sql') then
      begin
        ArchiveDir := IncludeTrailingPathDelimiter(TargetDir);
        ZipFile.Extract(ZipFile.FileNames[i], ArchiveDir);
        SQLFiles.Add(ArchiveDir + ExtractFileName(ZipFile.FileNames[i]));
      end;
    end;

    // Verbinde mit der SQLite-Datenbank
    SQLQuery.Connection := fMain.FDConnection1;
    SQLQuery.Connection.Open;

    // Lese jede SQL-Datei ein und führe den Inhalt aus
    for i := 0 to SQLFiles.Count - 1 do
    begin
      SQLFileContent.LoadFromFile(SQLFiles[i]);

      SQLQuery.SQL.Text := SQLFileContent.Text;
      SQLQuery.ExecSQL;
    end;

    ShowMessage('Import abgeschlossen.');

  finally
    ZipFile.Free;
    SQLFiles.Free;
    SQLQuery.Free;
    SQLFileContent.Free;
  end;
end;




end.
