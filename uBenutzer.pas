unit uBenutzer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, AdvListV, System.hash, FireDAC.Stan.Param, Vcl.Menus,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteDef, FireDAC.Phys.SQLite, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, System.UITypes, Vcl.Mask;

type
  TfBenutzer = class(TForm)
    btnNeuerBenutzer: TButton;
    btnUebersicht: TButton;
    lbTitle: TLabel;
    edNachname: TLabeledEdit;
    edUsername: TLabeledEdit;
    btnDelete: TButton;
    edUserPW: TLabeledEdit;
    edVorname: TLabeledEdit;
    edEmail: TLabeledEdit;
    edTelefon: TLabeledEdit;
    cbAdmin: TCheckBox;
    cbLogged: TCheckBox;
    btnSpeichern: TButton;
    lvBediener: TAdvListView;
    Shape4: TShape;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    procedure btnNeuerBenutzerClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSpeichernClick(Sender: TObject);
    procedure btnUebersichtClick(Sender: TObject);
    procedure lvBedienerSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure btnDeleteClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    procedure LoadBediener;
    function AnzahlAdminsInDB: integer;
  public
    { Public-Deklarationen }
  end;

var
  fBenutzer: TfBenutzer;
  EDITENTRY, NEWENTRY: boolean;
  SELECTEDBEDIENERID: integer;

implementation

uses uMain;

{$R *.dfm}

procedure TfBenutzer.btnDeleteClick(Sender: TObject);
begin
  if(AnzahlAdminsInDB = 1) then
  begin
    showmessage('Sie können diesen Bediener nicht löschen da dies aktuell der einzige Bediener mit Admin-Rechten ist.'+#13#10+'Wenn Sie diesen Bediener löschen wollen, geben Sie zuerst einem anderen Bediener Admin-Rechte!');
    abort;
  end;

  if MessageDlg('Wollen Sie diesen Bediener wirklich löschen?', mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes then
  begin
    with fMain.FDQuery1 do
    begin
      SQL.Text := 'DELETE FROM bediener WHERE id = :userid;';
      ParamByName('userid').AsInteger := SELECTEDBEDIENERID;
      try
        ExecSQL;

        EDITENTRY := false;
        SELECTEDBEDIENERID := 0;

        LoadBediener;

        btnUebersichtClick(self);
      except
        on E: Exception do
          ShowMessage('Fehler beim Löschen des Bedieners: ' + E.Message);
      end;
    end;
  end;
end;



procedure TfBenutzer.btnNeuerBenutzerClick(Sender: TObject);
begin
  NEWENTRY := true;

  edNachname.Clear;
  edVorname.Clear;
  edUsername.Clear;
  edUserPW.Clear;
  edEmail.Clear;
  edTelefon.Clear;
  cbAdmin.Checked := false;;
  cbLogged.Checked := false;

  lbTitle.Caption := 'Neuen Bediener anlegen';

  edNachname.SetFocus;
  btnDelete.Visible := false;
end;





procedure TfBenutzer.btnSpeichernClick(Sender: TObject);
var
  LastInsertID: integer;
  nachname, vorname, username, userpw: string;
  email, telefon: string;
begin
  nachname := trim(edNachname.Text);
  vorname  := trim(edVorname.Text);
  username := trim(edUsername.Text);
  userpw   := edUserPW.Text;
  email    := trim(edEmail.Text);
  telefon  := trim(edTelefon.Text);

  fMain.FDConnection1.Connected := true;

  //Neuen User in Datenbank schreiben
  if(NEWENTRY = true) then
  begin
    if(length(nachname) > 0) AND (length(vorname) > 0) AND (length(username) > 0) AND (length(userpw) > 0) then
    begin
      with fMain.FDQuery1 do
      begin
        SQL.Text := 'INSERT INTO bediener (username, userpw, nachname, vorname, email, telefon, admin, logged) ' +
                    'VALUES (:username, :passwort, :nachname, :vorname, :email, :telefon, :admin, :logged)';
        ParamByName('username').AsString := username;
        ParamByName('passwort').AsString := THashSHA1.GetHashString(userpw);
        ParamByName('nachname').AsString := nachname;
        ParamByName('vorname').AsString := vorname;
        ParamByName('email').AsString := email;
        ParamByName('telefon').AsString := telefon;
        if(cbAdmin.Checked  = true) then ParamByName('admin').AsInteger  := 1 else ParamByName('admin').AsInteger  := 0;
        if(cbLogged.Checked = true) then ParamByName('logged').AsInteger := 1 else ParamByName('logged').AsInteger := 0;

        try
          ExecSQL; // SQL-Anweisung ausführen
        except
          on E: Exception do
            ShowMessage('Fehler beim Einfügen: ' + E.Message);
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

        LoadBediener;

        edNachname.Clear;
        edVorname.Clear;
        edEmail.Clear;
        edTelefon.Clear;
        edUsername.Clear;
        edUserPW.Clear;
        cbAdmin.Checked := false;
        cbLogged.Checked := false;
        btnUebersichtClick(self);

        NEWENTRY := false;
        EDITENTRY := false;
        SELECTEDBEDIENERID := 0;
      end;
    end
    else
    begin
      showmessage('Bitte füllen Sie alle grün markierten Felder aus!');
    end;
  end;




  if(EDITENTRY = true) AND (NEWENTRY = false) AND (SELECTEDBEDIENERID <> 0) then
  begin
    with fMain.FDQuery1 do
    begin
      //Wenn angemeldeter Admin sich die Adminrechte entziehen will,
      //prüfen ob noch mindestens ein weiterer Admin in der Datenbank steht
      //Wenn kein weiterer Admin in der Datenbank steht, Speichern verhindern
      //und Warnung ausgeben dass mindestens ein Admin in der Datenbank stehen muss

      //Anzahl vorhandener Bediener mit Adminrechten ermitteln
   //   SQL.Text := 'SELECT count(id) AS AnzahlAdmins FROM bediener WHERE admin = :admin;';
   //   ParamByName('admin').AsInteger := 1;
   //   open;
   //   if not IsEmpty then
   //   begin
   //     AdminsCount := FieldByName('AnzahlAdmins').AsInteger;
   //   end;


      if(cbAdmin.Checked = false) AND (BEDIENERID = SELECTEDBEDIENERID) then
      begin
        showmessage('Sie können sich nicht selbst die Admin-Rechte entziehen!');
        cbAdmin.Checked := true;
        abort;
      end;

      if(cbLogged.Checked = true) AND (BEDIENERID = SELECTEDBEDIENERID) then
      begin
        showmessage('Sie können nicht Ihren eigenen Zugang sperren!');
        cbLogged.Checked := false;
        abort;
      end;



      if(length(userpw) = 0) then
      begin
        //Update ohne Passwortänderung
        SQL.Text := 'UPDATE bediener SET username = :username, nachname = :nachname, vorname = :vorname, ' +
                    'email = :email, telefon = :telefon, admin = :admin, logged = :logged ' +
                    'WHERE id = :userid;';
      end
      else
      begin
        //Update mit Passwortänderung
        SQL.Text := 'UPDATE bediener SET username = :username, userpw = :passwort, nachname = :nachname, '+
                    'vorname = :vorname, email = :email, telefon = :telefon, admin = :admin, logged = :logged ' +
                    'WHERE id = :userid;';
        ParamByName('passwort').AsString := THashSHA1.GetHashString(userpw);
      end;

      ParamByName('userid').AsInteger  := SELECTEDBEDIENERID;
      ParamByName('username').AsString := username;
      ParamByName('nachname').AsString := nachname;
      ParamByName('vorname').AsString  := vorname;
      ParamByName('email').AsString    := email;
      ParamByName('telefon').AsString  := telefon;
      if(cbAdmin.Checked = true) then ParamByName('admin').AsInteger := 1 else ParamByName('admin').AsInteger := 0;
      if(cbLogged.Checked = true) then ParamByName('logged').AsInteger := 1 else ParamByName('logged').AsInteger := 0;
      try
        ExecSQL;

        EDITENTRY := false;
        SELECTEDBEDIENERID := 0;

        LoadBediener;

        btnUebersichtClick(self);

        edNachname.Clear;
        edVorname.Clear;
        edEmail.Clear;
        edTelefon.Clear;
        edUsername.Clear;
        edUserPW.Clear;
        cbAdmin.Checked := false;
        cbLogged.Checked := false;
        btnUebersichtClick(self);
      except
        on E: Exception do
          ShowMessage('Fehler beim Speichern der Änderungen: ' + E.Message);
      end;
    end;
  end;

  fMain.FDConnection1.Connected := false;
end;



procedure TfBenutzer.btnUebersichtClick(Sender: TObject);
begin
  NEWENTRY := false;
  lbTitle.Caption := 'Bediener Übersicht';

  lvBediener.Visible := true;

  lvBediener.ItemIndex := -1;
end;



procedure TfBenutzer.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Close;
  end;
end;

procedure TfBenutzer.FormShow(Sender: TObject);
begin
  NEWENTRY := false;
  EDITENTRY := false;
  SELECTEDBEDIENERID := 0;

  LoadBediener;

  cbAdmin.Visible := ADMIN;
  cbLogged.Visible := ADMIN;
end;




procedure TfBenutzer.LoadBediener;
var
  FDQuery: TFDQuery;
  l: TListItem;
begin
  fMain.FDConnection1.Connected := true;

  lvBediener.Items.Clear;

  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := fMain.FDConnection1;

    FDQuery.SQL.Text := 'SELECT id, nachname, vorname, username, email, telefon, admin, logged FROM bediener '+
                        'ORDER BY nachname ASC;';
    FDQuery.Open;

    while not FDQuery.Eof do
    begin
        l := lvBediener.Items.Add;

        l.Caption := FDQuery.FieldByName('id').AsString;
        l.SubItems.Add(FDQuery.FieldByName('nachname').AsString);
        l.SubItems.Add(FDQuery.FieldByName('vorname').AsString);
        l.SubItems.Add(FDQuery.FieldByName('username').AsString);
        l.SubItems.Add(FDQuery.FieldByName('email').AsString);
        l.SubItems.Add(FDQuery.FieldByName('telefon').AsString);
        l.SubItems.Add(FDQuery.FieldByName('admin').AsString);
        l.SubItems.Add(FDQuery.FieldByName('logged').AsString);

        FDQuery.next;
    end;

  finally
    FDQuery.Free;
  end;

  fMain.FDConnection1.Connected := false;
end;





procedure TfBenutzer.lvBedienerSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  if(Selected) then
  begin
    EDITENTRY := true;
    NEWENTRY := false;
    SELECTEDBEDIENERID := StrToInt(Item.Caption);
    edNachname.Text    := Item.SubItems[0];
    edVorname.Text     := Item.SubItems[1];
    edUsername.Text    := Item.SubItems[2];
    edEmail.Text       := Item.SubItems[3];
    edTelefon.Text     := Item.SubItems[4];

    if(Item.SubItems[5] = '1') then cbAdmin.Checked := true else cbAdmin.Checked := false;
    if(Item.SubItems[6] = '1') then cbLogged.Checked := true else cbLogged.Checked := false;

    lbTitle.Caption := 'Bediener bearbeiten';

    if(ADMIN = true) then
      btnDelete.Visible := true;
  end
  else
  begin
    edNachname.Clear;
    edVorname.Clear;
    edUsername.Clear;
    edUserPW.Clear;
    edEmail.Clear;
    edTelefon.Clear;
    cbAdmin.Checked := false;;
    cbLogged.Checked := false;

    lbTitle.Caption := 'Bediener Übersicht';
  end;
end;



function TfBenutzer.AnzahlAdminsInDB: integer;
var
  FDQuery: TFDQuery;
begin
  fMain.FDConnection1.Connected := true;

  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := fMain.FDConnection1;

    FDQuery.SQL.Text := 'SELECT count(id) AS ANZAHLADMINS FROM bediener WHERE admin = 1;';
    FDQuery.Open;

    result := FDQuery.FieldByName('ANZAHLADMINS').AsInteger;
  finally
    FDQuery.Free;
  end;

  fMain.FDConnection1.Connected := false;
end;




end.
