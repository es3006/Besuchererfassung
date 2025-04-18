unit uFunktionen;

interface

uses
  Windows, System.SysUtils, Dialogs, AdvListV, System.IOUtils,
  System.Classes, Vcl.Controls, Vcl.Forms, Vcl.ComCtrls, Vcl.StdCtrls,
  ShellApi, MMSystem;

function GetAppVersion: string;
function ConvertGermanDateToSQLDate(const GermanDate: string; ShowTime: boolean = false): string;
function ConvertSQLDateToGermanDate(const SQLDate: string; ShowTime: boolean = true): string;
procedure SetListViewProperties(AListView: TAdvListView);
function IsFileZeroSize(const FileName: string): Boolean;
procedure FindAndSelectListViewItem(lv: TAdvListView; const SearchText: string; const Spalten: array of Integer);
procedure lvColumnClickForSort(Sender: TObject; Column: TListColumn);
procedure lvCompareForSort(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
procedure DaysToYearsMonthsDays(Days: Integer; out Years, Months, RemainingDays: Integer);
procedure SaveResourceToFile(ResourceName, FileName: string);
procedure BackupSQLiteDatabase(const DBFilePath, BackupFolderPath: string);
function DeleteFiles(const AFile: string): boolean;
procedure PlayResourceMP3(ResEntryName, TempFileName: string);
procedure CreateDirectoryIfNotExists(const Dir: string);
procedure LogBackup(const BackupFileName: string);



implementation


uses
  uMain;



//Version des Programms ermitteln
function GetAppVersion: string;
var
  InfoSize, Wnd: DWORD;
  VerBuf: Pointer;
  VerData: Pointer;
  VerLen: UINT;
  VerKey: string;
  FileName: string;
begin
  Result := '';
  FileName := ParamStr(0);
  InfoSize := GetFileVersionInfoSize(PChar(FileName), Wnd);

  if InfoSize = 0 then Exit;

  GetMem(VerBuf, InfoSize);
  try
    if GetFileVersionInfo(PChar(FileName), 0, InfoSize, VerBuf) then
    begin
      VerKey := '\';
      if VerQueryValue(VerBuf, PChar(VerKey), VerData, VerLen) then
      begin
        with TVSFixedFileInfo(VerData^) do
        begin
          Result := Format('%d.%d.%d.%d',
            [HiWord(dwFileVersionMS), LoWord(dwFileVersionMS),
             HiWord(dwFileVersionLS), LoWord(dwFileVersionLS)]);
        end;
      end;
    end;
  finally
    FreeMem(VerBuf);
  end;
end;




{
  Aktuelle Version um ein deutsches Dateum im Format DD.MM.YY oder DD.MM.YYYY HH:NN:SS in ein
  SQL-Datum im Format YYYY-MM-DD oder YYYY-MM-DD HH:NN:SS umzuwandeln

  Aufruf mit
  ConvertGermanDateToSQLDate('30.06.1975'); //Nur Datum
  ConvertGermanDateToSQLDate('30.06.1975 10:30:20'); //Datum und Zeit
}
function ConvertGermanDateToSQLDate(const GermanDate: string; ShowTime: boolean = false): string;
var
  DateValue: TDateTime;
  FormatedDate: string;
begin
  if(GermanDate = '') then
  begin
    result := '';
    exit;
  end;

  // Prüfen und Konvertieren des Datumsformats von DD.MM.YYYY HH:NN:SS zu einem TDateTime-Wert
  if TryStrToDateTime(GermanDate, DateValue) then
  begin
    if(ShowTime = true) then
      FormatedDate := FormatDateTime('yyyy-mm-dd hh:nn', DateValue)
    else
      FormatedDate := FormatDateTime('yyyy-mm-dd', DateValue);

    Result := FormatedDate;
  end
  else
  begin
    // Bei Fehler wird ein leerer String zurückgegeben
    Result := '';
    ShowMessage('Ungültiges Datumsformat: ' + GermanDate);
    abort;
  end;
end;




function ConvertSQLDateToGermanDate(const SQLDate: string; ShowTime: boolean = true): string;
var
  DateValue: TDateTime;
  FormattedDate: string;
  FormatSettings: TFormatSettings;
begin
  if(SQLDate = '') then
  begin
    result := '';
    exit;
  end;

  // Spezifische FormatSettings für das ISO-Format konfigurieren
  FormatSettings := TFormatSettings.Create;
  FormatSettings.DateSeparator := '-';
  FormatSettings.TimeSeparator := ':';
  FormatSettings.ShortDateFormat := 'yyyy-mm-dd';
  FormatSettings.LongTimeFormat := 'hh:nn:ss';

  // Konvertieren des Datumsformats von YYYY-MM-DD HH:NN:SS zu einem TDateTime-Wert
  if TryStrToDateTime(SQLDate, DateValue, FormatSettings) then
  begin
    // Deutsche FormatSettings konfigurieren
    FormatSettings.DateSeparator   := '.';
    FormatSettings.ShortDateFormat := 'dd.mm.yyyy';
    FormatSettings.LongTimeFormat  := 'hh:nn';

    // Das Datum im Format DD.MM.YYYY HH:NN formatiert
    if(ShowTime = true) then
      FormattedDate := FormatDateTime('dd.mm.yyyy hh:nn', DateValue, FormatSettings)
    else
      FormattedDate := FormatDateTime('dd.mm.yyyy', DateValue, FormatSettings);

    Result := FormattedDate;
  end
  else
  begin
    // Bei Fehler wird ein leerer String zurückgegeben
    Result := '';
    ShowMessage('Ungültiges Datumsformat: ' + SQLDate);
    Abort;
  end;
end;







procedure SetListViewProperties(AListView: TAdvListView);
begin
  AListView.ItemHeight := LINEHEIGHT;
  AListView.SelectionColor := LVSELBGCOLOR;
  AListView.SelectionTextColor := LVSELVGCOLOR;
end;





function IsFileZeroSize(const FileName: string): Boolean;
var
  FileInfo: TSearchRec;
begin
  Result := False;
  if FindFirst(FileName, faAnyFile, FileInfo) = 0 then
  try
    Result := FileInfo.Size = 0;
  finally
    FindClose(FileInfo);
  end;
end;





procedure FindAndSelectListViewItem(lv: TAdvListView; const SearchText: string; const Spalten: array of Integer);
var
  i, j: Integer;
  ListItem: TListItem;
  Found: Boolean;
begin
  // Starte die Suche ab dem nächsten Eintrag nach dem zuletzt gefundenen Index
  for i := LastFoundIndex + 1 to lv.Items.Count - 1 do
  begin
    ListItem := lv.Items[i];
    Found := False;

    // Durchsuche die angegebenen Spalten
    for j := 0 to High(Spalten) do
    begin
      if (Spalten[j] = 0) then
      begin
        if AnsiLowerCase(ListItem.Caption) = AnsiLowerCase(SearchText) then
        begin
          Found := True;
          Break;
        end;
      end
      else
      begin
        if AnsiLowerCase(ListItem.SubItems[Spalten[j] - 1]) = AnsiLowerCase(SearchText) then
        begin
          Found := True;
          Break;
        end;
      end;
    end;

    // Wenn der Suchtext in einer der Spalten gefunden wurde
    if Found then
    begin
      lv.ItemIndex := i;
      ListItem.Selected := True;
      ListItem.MakeVisible(False); // Stelle sicher, dass der Eintrag sichtbar ist
      LastFoundIndex := i; // Aktualisiere den Index des zuletzt gefundenen Eintrags
      Exit;
    end;
  end;

  // Wenn kein weiterer Eintrag gefunden wurde, starte die Suche von Anfang an
  if LastFoundIndex <> -1 then
  begin
    LastFoundIndex := -1;
    FindAndSelectListViewItem(lv, SearchText, Spalten); // Erneuter Aufruf der Prozedur
  end;
end;






procedure lvColumnClickForSort(Sender: TObject; Column: TListColumn);
begin
  ColumnToSort := Column.Index;
  if ColumnToSort = LastSorted then
    SortDir := 1 - SortDir
  else
    SortDir := 0;
  LastSorted := ColumnToSort;

  // Nur sortieren, wenn es durch Benutzerinteraktion ausgelöst wurde
  if Sender is TCustomListView then
    (Sender as TCustomListView).AlphaSort;
end;




procedure lvCompareForSort(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
var
  TempStr, TextToSort1, TextToSort2: String;
begin
  // Sicherstellen, dass ColumnToSort innerhalb des gültigen Bereichs liegt
  if (ColumnToSort < 0) or (ColumnToSort >= (Sender as TListView).Columns.Count) then
  begin
    Compare := 0;
    Exit;
  end;

  // Texte zuweisen
  if ColumnToSort = 0 then
  begin
    TextToSort1 := Item1.Caption;
    TextToSort2 := Item2.Caption;
  end
  else
  begin
    TextToSort1 := Item1.SubItems[ColumnToSort - 1];
    TextToSort2 := Item2.SubItems[ColumnToSort - 1];
  end;

  // Je nach Sortierrichtung evtl. Texte vertauschen
  if SortDir <> 0 then
  begin
    TempStr := TextToSort1;
    TextToSort1 := TextToSort2;
    TextToSort2 := TempStr;
  end;

  // Texte je nach Tag der Spalte unterschiedlich vergleichen
  case (Sender as TListView).Columns[ColumnToSort].Tag of
    1: Compare := StrToIntDef(TextToSort1,0) - StrToIntDef(TextToSort2,0);
    2:
      begin
        Compare := 0;
        if StrToFloat(TextToSort1) > StrToFloat(TextToSort2) then
          Compare := 1;
        if StrToFloat(TextToSort1) < StrToFloat(TextToSort2) then
          Compare := -1;
      end;
    3:
      begin
        Compare := 0;
        if StrToDateTime(TextToSort1) > StrToDateTime(TextToSort2) then
          Compare := 1;
        if StrToDateTime(TextToSort1) < StrToDateTime(TextToSort2) then
          Compare := -1;
      end;
    else
      Compare := CompareText(TextToSort1, TextToSort2);
  end;
end;







//Einen Integer in Monate und Jahre umrechnen
procedure DaysToYearsMonthsDays(Days: Integer; out Years, Months, RemainingDays: Integer);
const
  DaysInYear = 365.25; // Durchschnittliche Tage pro Jahr (inklusive Schaltjahre)
  DaysInMonth = 30.4375; // Durchschnittliche Tage pro Monat
begin
  // Berechne Jahre, Monate und verbleibende Tage
  Years := Days div Trunc(DaysInYear);
  Days := Days mod Trunc(DaysInYear);
  Months := Days div Trunc(DaysInMonth);
  RemainingDays := Days mod Trunc(DaysInMonth);
end;






procedure SaveResourceToFile(ResourceName, FileName: string);
var
  ResStream: TResourceStream;
  FileStream: TFileStream;
begin
  ResStream := TResourceStream.Create(HInstance, ResourceName, RT_RCDATA); // RT_RCDATA ist ein gängiger Typ für benutzerdefinierte Ressourcen
  try
    FileStream := TFileStream.Create(FileName, fmCreate);
    try
      FileStream.CopyFrom(ResStream, 0); // Kopiere den Ressourceninhalt in die Datei
    finally
      FileStream.Free;
    end;
  finally
    ResStream.Free;
  end;
end;








procedure BackupSQLiteDatabase(const DBFilePath, BackupFolderPath: string);
var
  BackupFileName: string;
begin
  // Erzeuge den Dateinamen für die Sicherungskopie mit Datum und Uhrzeit
  BackupFileName := FormatDateTime('yymmddhhnn', Now) + '_'+ BEDIENERUSERNAME + '_' + DBNAME;

  // Erzeuge das Verzeichnis für das aktuelle Datum
  if not DirectoryExists(BackupFolderPath) then
  begin
    if not ForceDirectories(BackupFolderPath) then
    begin
      ShowMessage('Fehler beim Erstellen des Verzeichnisses ' + BackupFolderPath);
      Exit;
    end;
  end;


  try
    //Backup der Datenbank erstellen
    TFile.Copy(DBFilePath, TPath.Combine(BackupFolderPath, BackupFileName), True);

    //Name der Sicherung in logfile schreiben
    LogBackup(BackupFileName);

    //Ton ausgeben
    PlayResourceMP3('BACKUPDB', 'TEMP\backupDB.WAV');
  except
    on E: Exception do
      ShowMessage('Fehler beim Erstellen der Sicherung: ' + E.Message);
  end;
end;




function DeleteFiles(const AFile: string): boolean;
var
  sh: SHFileOpStruct;
begin
  ZeroMemory(@sh, SizeOf(sh));
  with sh do
  begin
    Wnd := Application.Handle;
    wFunc := FO_DELETE;
    pFrom := PChar(AFile +#0);
    fFlags := FOF_SILENT or FOF_NOCONFIRMATION;
  end;
  result := SHFileOperation(sh) = 0;
end;






procedure PlayResourceMP3(ResEntryName, TempFileName: string);
var
  ResStream: TResourceStream;
  MemStream: TMemoryStream;
begin
  // Prüfen, ob die Datei bereits vorhanden ist
  if not FileExists(TempFileName) then
  begin
    // Datei aus der Resource holen und speichern
    ResStream := TResourceStream.Create(HInstance, ResEntryName, RT_RCDATA);
    try
      MemStream := TMemoryStream.Create;
      try
        MemStream.LoadFromStream(ResStream);
        MemStream.SaveToFile(TempFileName);
      finally
        MemStream.Free;
      end;
    finally
      ResStream.Free;
    end;
  end;

  // Datei abspielen
  PlaySound(PChar(TempFileName), 0, SND_FILENAME or SND_ASYNC);
end;




procedure CreateDirectoryIfNotExists(const Dir: string);
begin
  if not DirectoryExists(Dir) then
  begin
    if ForceDirectories(Dir) then
    else
      ShowMessage('Fehler beim Erstellen des Verzeichnisses: ' + Dir + #13#10+'Bitte erstellen Sie das Verzeichnis "' + Dir + '" von Hand');
  end;
end;



procedure LogBackup(const BackupFileName: string);
var
  LogFile: TextFile;
  LogPath: string;
  art: string;
begin
  LogPath := IncludeTrailingPathDelimiter(PATH + 'DBDUMPS') + 'backup.log';
  AssignFile(LogFile, LogPath);

  if FileExists(LogPath) then
    Append(LogFile)
  else
    Rewrite(LogFile);

  WriteLn(LogFile, FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + ' - Backup erstellt: ' + BackupFileName);
  CloseFile(LogFile);
end;






end.
