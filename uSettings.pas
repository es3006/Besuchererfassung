unit uSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param, System.UITypes, AsgCombo,
  ColorCombo, Vcl.Buttons, AdvEdit, AdvEdBtn, AdvDirectoryEdit, Vcl.Mask;

type
  TfSettings = class(TForm)
    PageControl1: TPageControl;
    Programmeinstellungen: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    edDSGVODelTimeInDays: TLabeledEdit;
    btnSaveDSGVO: TButton;
    edLineHeight: TLabeledEdit;
    udLineHeight: TUpDown;
    btnSave: TButton;
    edLVSelBGColor: TLabeledEdit;
    ColorDialog1: TColorDialog;
    SpeedButton1: TSpeedButton;
    edLVSelVGColor: TLabeledEdit;
    SpeedButton2: TSpeedButton;
    Label2: TLabel;
    cbAutoDel: TCheckBox;
    lbMonJahr: TLabel;
    TabSheet1: TTabSheet;
    Label4: TLabel;
    Label5: TLabel;
    cbAutoDBBackupWochentag: TComboBox;
    edAutoDBBackupStunde: TLabeledEdit;
    edAutoDBBackupMinute: TLabeledEdit;
    btnSaveAutoDBBackup: TButton;
    Label3: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnSaveDSGVOClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure edDSGVODelTimeInDaysKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnSaveAutoDBBackupClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure LoadUserSettingsFromDB;
    procedure LoadAdminSettingsFromDB;
    procedure SaveUserSettingToDB(FieldName, FieldValue: string);
    procedure SaveAdminSettingToDB(FieldName, FieldValue: string);
    procedure ShowDaysMontsYearsByDays;
  public
    { Public-Deklarationen }
  end;

var
  fSettings: TfSettings;

implementation

{$R *.dfm}

uses
  uMain, uFunktionen, uChipkartenausgabe, uBesuchersuche, uBesuchererfassung,
  uBesucheranmeldung;



procedure TfSettings.btnSaveAutoDBBackupClick(Sender: TObject);
begin
  if(cbAutoDBBackupWochentag.ItemIndex < 1) then
  begin
    showmessage('Bitte wählen Sie den Wochentag, an dem die automatische Sicherung der Datenbank vorgenommen werden soll!');
    exit;
  end;

  if(trim(edAutoDBBackupStunde.Text) = '') OR (StrToInt(Trim(edAutoDBBackupStunde.Text)) > 23) then
  begin
    showmessage('Bitte wählen Sie die Stunde, an dem die automatische Sicherung der Datenbank vorgenommen werden soll!'+#13#10+'Die Zahl sollte zwischen 1 und 23 liegen!');
    exit;
  end;

  if(trim(edAutoDBBackupStunde.Text) = '') OR (StrToInt(Trim(edAutoDBBackupStunde.Text)) > 23) then
  begin
    showmessage('Bitte wählen Sie die Minute, an dem die automatische Sicherung der Datenbank vorgenommen werden soll!'+#13#10+'Die Zahl sollte zwischen 0 und 59 liegen!');
    exit;
  end;

  SaveAdminSettingToDB('autoSaveDatabaseWochentag', IntToStr(cbAutoDBBackupWochentag.ItemIndex));
  SaveAdminSettingToDB('autoSaveDatabaseStunde', edAutoDBBackupStunde.Text);
  SaveAdminSettingToDB('autoSaveDatabaseMinute', edAutoDBBackupMinute.Text);

  AutoSicherungWochentag := cbAutoDBBackupWochentag.ItemIndex;
  AutoSicherungStunde := StrToInt(edAutoDBBackupStunde.Text);
  AutoSicherungMinute := StrToInt(edAutoDBBackupMinute.Text);

  fMain.UpdateNextBackupInfo(cbAutoDBBackupWochentag.ItemIndex, StrToInt(edAutoDBBackupStunde.Text), strToInt(edAutoDBBackupMinute.Text), Now);
  uMain.LASTBACKUP := 0;
end;



procedure TfSettings.btnSaveClick(Sender: TObject);
begin
  SaveUserSettingToDB('LineHeight', edLineHeight.Text);
  SaveUserSettingToDB('lvSelEntryBGColor', edLVSelBGColor.Text);
  SaveUserSettingToDB('lvSelEntryVGColor', edLVSelVGColor.Text);

  LINEHEIGHT   := udLineHeight.Position;
  LVSELBGCOLOR := StringToColor(edLVSelBGColor.Text);
  LVSELVGCOLOR := StringToColor(edLVSelVGColor.Text);

  with fMain do
  begin
    SetListViewProperties(lvBesucher);
    SetListViewProperties(lvAnmeldungen);
    SetListViewProperties(lvChipkartenausgabe);
  end;
  close;
end;




procedure TfSettings.btnSaveDSGVOClick(Sender: TObject);
begin
  if(cbAutoDel.Checked = true) then
  begin
    DSGVOAUTODEL := true;
    SaveAdminSettingToDB('dsgvoAutoDel', '1');
  end
  else
  begin
    DSGVOAUTODEL := false;
    SaveAdminSettingToDB('dsgvoAutoDel', '0');
  end;
  SaveAdminSettingToDB('dsgvoDelTime', edDSGVODelTimeInDays.Text);
end;





procedure TfSettings.edDSGVODelTimeInDaysKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  ShowDaysMontsYearsByDays;
end;







procedure TfSettings.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;   // Fenster beim Schließen zerstören
  fSettings := nil;   // Referenz zurücksetzen, damit es neu erzeugt werden kann
end;

procedure TfSettings.FormShow(Sender: TObject);
begin
  Label1.Caption := 'Geben Sie hier bitte an, nach wie vielen Tagen Benutzerdaten automatisch nach den maßgaben der DSGVO gelöscht werden sollen.'+#13#10+#13#10+
                    'Mehr dazu finden Sie in der Hilfe';

  LoadUserSettingsFromDB;

  if(ADMIN = true) then
  begin
    TabSheet2.TabVisible := true; //DSGVO
    TabSheet1.TabVisible := true; //Auto Database Backup
    LoadAdminSettingsFromDB;
  end
  else
  begin
    TabSheet2.TabVisible := false; //DSGVO
    TabSheet1.TabVisible := false; //Auto Database Nackup
    PageControl1.ActivePageIndex := 0;
    LoadUserSettingsFromDB;
  end;
end;





procedure TfSettings.LoadUserSettingsFromDB;
var
  FDQuery: TFDQuery;
begin
  fMain.FDConnection1.Connected := true;

  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := fMain.FDConnection1;

    FDQuery.SQL.Clear;
    FDQuery.SQL.Add('SELECT lineHeight, lvSelEntryBGColor, lvSelEntryVGColor ');
    FDQuery.SQL.Add('FROM einstellungen WHERE bedienerID = :bedienerid LIMIT 0, 1;');
    FDQuery.ParamByName('bedienerid').AsInteger := BEDIENERID;
    FDQuery.Open;

    if not FDQuery.IsEmpty then
    begin
      udLineHeight.Position := FDQuery.FieldByName('lineHeight').AsInteger;
      edLVSelBGColor.Text  := FDQuery.FieldByName('lvSelEntryBGColor').AsString;
      edLVSelBGColor.Color := StringToColor(edLVSelBGColor.Text);
      edLVSelBGColor.Font.Color := edLVSelBGColor.Color;

      edLVSelVGColor.Text  := FDQuery.FieldByName('lvSelEntryVGColor').AsString;
      edLVSelVGColor.Color := StringToColor(edLVSelVGColor.Text);
      edLVSelVGColor.Font.Color := edLVSelVGColor.Color;

      LINEHEIGHT   := udLineHeight.Position;
      LVSELBGCOLOR := edLVSelBGColor.Color;
      LVSELVGCOLOR := edLVSelVGColor.Color;
    end;

  finally
    FDQuery.Free;
  end;

  fMain.FDConnection1.Connected := false;
end;





procedure TfSettings.SaveUserSettingToDB(FieldName, FieldValue: string);
var
  FDQuery: TFDQuery;
begin
  fMain.FDConnection1.Connected := true;
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := fMain.FDConnection1;

    with FDQuery do
    begin
      SQL.Text := 'UPDATE einstellungen SET '+FieldName+' = :value WHERE bedienerID = :bedienerid';
      ParamByName('bedienerid').AsInteger := BEDIENERID;
      ParamByName('value').AsString := FieldValue;
      ExecSQL;
    end;
  finally
    FDQuery.Free;
  end;
  fMain.FDConnection1.Connected := false;
end;




procedure TfSettings.SpeedButton1Click(Sender: TObject);
begin
  if ColorDialog1.Execute then
  begin
    edLVSelBGColor.Text       := ColorToString(ColorDialog1.Color);
    edLVSelBGColor.Color      := StringToColor(edLVSelBGColor.Text);
    edLVSelBGColor.Font.Color := edLVSelBGColor.Color;
  end;
end;




procedure TfSettings.SpeedButton2Click(Sender: TObject);
begin
  if ColorDialog1.Execute then
  begin
    edLVSelVGColor.Text       := ColorToString(ColorDialog1.Color);
    edLVSelVGColor.Color      := StringToColor(edLVSelVGColor.Text);
    edLVSelVGColor.Font.Color := edLVSelVGColor.Color;
  end;
end;






procedure TfSettings.LoadAdminSettingsFromDB;
var
  FDQuery: TFDQuery;
begin
  fMain.FDConnection1.Connected := true;

  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := fMain.FDConnection1;

    FDQuery.SQL.Clear;
    FDQuery.SQL.Add('SELECT dsgvoDelTime, dsgvoAutoDel, autoSaveDatabaseWochentag, autoSaveDatabaseStunde, autoSaveDatabaseMinute FROM admin_einstellungen LIMIT 0, 1;');
    FDQuery.Open;

    if not FDQuery.IsEmpty then
    begin
      edDSGVODelTimeInDays.Text := IntToStr(FDQuery.FieldByName('dsgvoDelTime').AsInteger);
      DSGVODELTIME := FDQuery.FieldByName('dsgvoDelTime').AsInteger;

      if FDQuery.FieldByName('dsgvoAutoDel').AsInteger = 1 then
      begin
        cbAutoDel.Checked := true;
        DSGVOAUTODEL := true;
      end
      else
      begin
        cbAutoDel.Checked := false;
        DSGVOAUTODEL := false;
      end;

      cbAutoDBBackupWochentag.ItemIndex := FDQuery.FieldByName('autoSaveDatabaseWochentag').AsInteger;
      edAutoDBBackupStunde.Text := FDQuery.FieldByName('autoSaveDatabaseStunde').AsString;
      edAutoDBBackupMinute.Text := FDQuery.FieldByName('autoSaveDatabaseMinute').AsString;
    end;

  finally
    FDQuery.Free;
  end;

  fMain.FDConnection1.Connected := false;

  ShowDaysMontsYearsByDays;
end;





procedure TfSettings.SaveAdminSettingToDB(FieldName, FieldValue: string);
var
  FDQuery: TFDQuery;
begin
  fMain.FDConnection1.Connected := true;
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := fMain.FDConnection1;

    with FDQuery do
    begin
      SQL.Text := 'UPDATE admin_einstellungen SET '+FieldName+' = :value';
      ParamByName('value').AsString := FieldValue;
      ExecSQL;
    end;
  finally
    FDQuery.Free;
  end;
  fMain.FDConnection1.Connected := false;
end;




procedure TfSettings.ShowDaysMontsYearsByDays;
var
  Days, Years, Months, RemainingDays: Integer;
  sT, sM, sJ: string;
begin
  if TryStrToInt(edDSGVODelTimeInDays.Text, Days) then
  begin
    DaysToYearsMonthsDays(Days, Years, Months, RemainingDays);

    if Days   = 1 then sT := 'Tag'   else sT := 'Tage';
    if Months = 1 then sM := 'Monat' else sM := 'Monate';
    if Years  = 1 then sJ := 'Jahr'  else sJ := 'Jahre';

    lbMonJahr.Caption := Format('%d '+sJ+', %d ' + sM + ', %d ' + sT, [Years, Months, RemainingDays]);
  end;
end;




end.
