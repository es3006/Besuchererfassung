unit uFirstStart;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, System.UITypes, System.hash,
  FireDAC.Stan.Param, Vcl.Mask;

type
  TfFirstStart = class(TForm)
    edNachname: TLabeledEdit;
    edUsername: TLabeledEdit;
    edUserPW: TLabeledEdit;
    edVorname: TLabeledEdit;
    edEmail: TLabeledEdit;
    edTelefon: TLabeledEdit;
    btnSpeichern: TButton;
    Label1: TLabel;
    Shape3: TShape;
    Shape1: TShape;
    Shape2: TShape;
    Shape4: TShape;
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnSpeichernClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure edNachnameKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  fFirstStart: TfFirstStart;
  NewUserInserted: boolean;

implementation


{$R *.dfm}

uses
  uMain, uFunktionen, uAnmeldung;

procedure TfFirstStart.btnSpeichernClick(Sender: TObject);
var
  LastInsertID: integer;
begin
  fMain.FDConnection1.Connected := true;

  if(length(trim(edNachname.Text)) > 0) AND (length(trim(edVorname.Text)) > 0) AND (length(trim(edUsername.Text)) > 0) AND (length(trim(edUserPW.Text)) > 0) then
  begin
    with fMain.FDQuery1 do
    begin
      SQL.Text := 'INSERT INTO bediener (username, userpw, nachname, vorname, email, telefon, admin, logged) ' +
                  'VALUES (:username, :passwort, :nachname, :vorname, :email, :telefon, :admin, :logged)';
      ParamByName('username').AsString := edUsername.Text;
      ParamByName('passwort').AsString := THashSHA1.GetHashString(trim(edUserPW.Text));
      ParamByName('nachname').AsString := edNachname.Text;
      ParamByName('vorname').AsString  := edVorname.Text;
      ParamByName('email').AsString    := edEmail.Text;
      ParamByName('telefon').AsString  := edTelefon.Text;
      ParamByName('admin').AsInteger   := 0;
      ParamByName('logged').AsInteger  := 0;
      try
        ExecSQL;
        NewUserInserted := true;
      except
        on E: Exception do
          ShowMessage('Fehler beim Anlegen des ersten Bedieners: ' + E.Message);
      end;

      SQL.Text := 'SELECT last_insert_rowid() AS LastID';
      Open;
      LastInsertID := FieldByName('LastID').AsInteger;

      SQL.Clear;
      SQL.Text := 'INSERT INTO einstellungen (bedienerID, lineHeight, lvSelEntryBGColor, lvSelEntryVGColor) ' +
                  'VALUES (:BEDIENERID, :LINEHEIGHT, :BGCOL, :VGCOL)';
      ParamByName('BEDIENERID').AsInteger := LastInsertID;
      ParamByName('LINEHEIGHT').AsInteger := 30;
      ParamByName('BGCOL').AsString       := 'clHighlight';
      ParamByName('VGCOL').AsString       := 'clWhite';
      try
        ExecSQL;
      except
        on E: Exception do
          ShowMessage('Fehler beim Anlegen der Bediener-Einstellungen: ' + E.Message);
      end;
    end;
  end
  else
  begin
    showmessage('Bitte füllen Sie alle grün markierten Eingabefelder aus!');
  end;

  if(NewUserInserted) then
  begin
    fMain.StatusBar1.Panels[0].Text := 'Angemeldet als ' + edVorname.Text + ' ' + edNachname.Text + ' [admin]';
    ADMIN := true;

    fFirstStart.Visible := false;

    with fAnmeldung do
    begin
      LOGGEDIN := true;
      ShowModal;
    end;

    fFirstStart.close;
  end;

  fMain.FDConnection1.Connected := false;
end;




procedure TfFirstStart.edNachnameKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then  // Überprüfung, ob die Enter-Taste gedrückt wurde
  begin
    Key := #0;  // Unterdrücken des normalen Enter-Tasten-Verhaltens
    Perform(WM_NEXTDLGCTL, 0, 0);  // Fokus auf das nächste Steuerelement verschieben
  end;
end;

procedure TfFirstStart.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if NewUserInserted then
  begin
    CanClose := true;
  end
  else
  begin
    if MessageDlg('ACHTUNG, Sie sollten hier auf jeden Fall einen ersten Bediener anlegen da Sie das Programm sonst nicht verwenden können.'+#13#10+#13#10+
    'Wollen Sie jetzt einen Bediener anlegen?', mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes then
    begin
      CanClose := False;
    end
    else
    begin
      fMain.FDConnection1.Connected := false;
      fMain.FDQuery1.Close;

      if(FileExists(DBNAME)) then
      begin
        if DeleteFile(DBNAME) then
        begin
          DeleteFile(DBNAME);
          Application.Terminate
        end
        else
        begin
          ShowMessage('Fehler beim Löschen der Datenbank: ' + DBNAME);
        end;
      end;
    end;
  end;
end;




procedure TfFirstStart.FormCreate(Sender: TObject);
begin
  Application.ShowMainForm := True;
end;

procedure TfFirstStart.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Close;
  end;
end;

procedure TfFirstStart.FormShow(Sender: TObject);
begin
  Label1.Caption := 'Sie starten das Programm zum ersten Mal,'+#13#10+
                    'Geben Sie hier die Zugangsdaten des ersten Bedieners ein. '+#13#10+#13#10+
                    'Dieser Bediener erhält automatisch Admin-Rechte und ist '+#13#10+
                    'somit in der Lage, weitere Bediener anzulegen und '+#13#10+
                    'grundlegende Einstellungen vorzunehmen';
end;

end.
