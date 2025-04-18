unit uAnmeldung;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.hash, Vcl.StdCtrls, Vcl.ExtCtrls, FireDAC.Stan.Param,
  Vcl.Imaging.jpeg, Vcl.Imaging.pngimage, Vcl.Mask;

type
  TfAnmeldung = class(TForm)
    edUsername: TLabeledEdit;
    edUserPW: TLabeledEdit;
    btnAnmelden: TButton;
    Image1: TImage;
    procedure btnAnmeldenClick(Sender: TObject);
    procedure edUsernameKeyPress(Sender: TObject; var Key: Char);
    procedure edUserPWKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    procedure ShakeForm;
  public
    LOGGEDIN: boolean;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  fAnmeldung: TfAnmeldung;



implementation

{$R *.dfm}

uses uMain, uFunktionen;




procedure TfAnmeldung.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle   := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := GetDesktopWindow;
end;



procedure TfAnmeldung.btnAnmeldenClick(Sender: TObject);
var
  s: string;
  LOGGED: integer;
begin
  with fMain.FDQuery1 do
  begin
    SQL.Text := 'SELECT id, username, vorname || " " || nachname AS Bedienername, admin, logged  '+
                'FROM bediener WHERE username = :USERNAME AND '+
                'userpw = :PASSWORT LIMIT 0, 1';
    ParamByName('USERNAME').AsString := trim(edUsername.Text);
    ParamByName('PASSWORT').AsString := THashSHA1.GetHashString(trim(edUserPW.Text)); ;
    Open();

    if(RecordCount = 1) then
    begin
      BEDIENERID       := fMain.FDQuery1.FieldByName('id').AsInteger;
      BEDIENERUSERNAME := fMain.FDQuery1.FieldByName('username').AsString;
      LOGGED           := fMain.FDQuery1.FieldByName('logged').AsInteger;

      if(LOGGED = 1) then
      begin
        PlayResourceMP3('WRONGPW', 'TEMP\LoginError.wav');
        ShakeForm;

        abort;
      end;

      if(fMain.FDQuery1.FieldByName('admin').AsInteger = 1) then s := ' [admin]' else s := ' [Bediener]';
      fMain.StatusBar1.Panels[0].Text := 'Angemeldet als ' + fMain.FDQuery1.FieldByName('Bedienername').AsString + s;

      if(fMain.FDQuery1.FieldByName('admin').AsInteger = 1) then ADMIN := true else ADMIN := false;

      PlayResourceMP3('WHOOSH', 'TEMP\Whoosh.wav');
      LOGGEDIN := true;

      fAnmeldung.close;
      exit;
    end
    else
    begin
      PlayResourceMP3('WRONGPW', 'TEMP\LoginError.wav');
      ShakeForm;
      LOGGEDIN := false;
      edUsername.SetFocus;
    end;
    Close;
  end;
end;




procedure TfAnmeldung.edUsernameKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    edUserPW.SetFocus;
  end;
end;

procedure TfAnmeldung.edUserPWKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    btnAnmeldenClick(self);
  end;
end;

procedure TfAnmeldung.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if(LOGGEDIN = false) then
    Application.Terminate;
end;

procedure TfAnmeldung.FormCreate(Sender: TObject);
begin
  LOGGEDIN := false;
end;

procedure TfAnmeldung.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Close;
  end;
end;

procedure TfAnmeldung.FormShow(Sender: TObject);
begin
  edUsername.Clear;
  edUserPW.Clear;
  edUsername.SetFocus;
end;



procedure TfAnmeldung.ShakeForm;
const
  ShakeCount  = 10;  // Anzahl der Schüttelbewegungen (5 nach links und 5 nach rechts)
  ShakeOffset = 10; // Abstand, um den die Form verschoben wird
  ShakeDelay  = 15;  // Wartezeit in Millisekunden zwischen den Schüttelbewegungen
var
  OriginalLeft: Integer;
  I: Integer;
begin
  OriginalLeft := Self.Left;
  for I := 1 to ShakeCount do
  begin
    if I mod 2 = 0 then
      Self.Left := OriginalLeft + ShakeOffset
    else
      Self.Left := OriginalLeft - ShakeOffset;
    Sleep(ShakeDelay);
    Application.ProcessMessages; // Ermöglicht das Aktualisieren der GUI
  end;
  Self.Left := OriginalLeft; // Zurück zur ursprünglichen Position
end;













end.
