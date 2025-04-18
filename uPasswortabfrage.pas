unit uPasswortabfrage;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, System.hash, FireDAC.Stan.Param,
  Vcl.Mask;

type
  TfPasswortabfrage = class(TForm)
    edUserPW: TLabeledEdit;
    btnAnmelden: TButton;
    Label1: TLabel;
    lbUsername: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btnAnmeldenClick(Sender: TObject);
    procedure edUserPWKeyPress(Sender: TObject; var Key: Char);
  private
    { Private-Deklarationen }
  public
    LOGGEDIN: boolean;
    RETURNTO: string;
  end;

var
  fPasswortabfrage: TfPasswortabfrage;

implementation

{$R *.dfm}

uses
  uMain, uAnmeldung, uBesucherdatenEdit;

procedure TfPasswortabfrage.btnAnmeldenClick(Sender: TObject);
begin
  with fMain.FDQuery1 do
  begin
    SQL.Text := 'SELECT id FROM bediener WHERE username = :USERNAME AND '+
                'userpw = :PASSWORT LIMIT 0, 1';
    ParamByName('USERNAME').AsString := lbUsername.Caption;
    ParamByName('PASSWORT').AsString := THashSHA1.GetHashString(trim(edUserPW.Text)); ;
    Open();

    if(RecordCount = 1) then
    begin
      fBesucherdatenEdit.SuccessLoggedIn := true;
      fPasswortabfrage.close;
    end
    else
    begin
      showmessage('Sie haben ein falsches Passwort eingegeben!');
      fBesucherdatenEdit.SuccessLoggedIn := False;
    end;

    Close;
  end;
end;




procedure TfPasswortabfrage.edUserPWKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then  // Überprüfung, ob die Enter-Taste gedrückt wurde
  begin
    Key := #0;  // Unterdrücken des normalen Enter-Tasten-Verhaltens
    Perform(WM_NEXTDLGCTL, 0, 0);  // Fokus auf das nächste Steuerelement verschieben
    btnAnmeldenClick(nil);
  end;
end;

procedure TfPasswortabfrage.FormShow(Sender: TObject);
begin
  LOGGEDIN := false;
  edUserPW.SetFocus;
  lbUsername.Caption := BEDIENERUSERNAME;
end;

end.
