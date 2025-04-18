unit uDSGVO;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.OleCtrls, SHDocVw, AdvCustomControl,
  AdvWebBrowser;

type
  TfDSGVO = class(TForm)
    AdvWebBrowser1: TAdvWebBrowser;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
  private

  public
    { Public-Deklarationen }
  end;

var
  fDSGVO: TfDSGVO;

implementation

{$R *.dfm}


uses
  uMain;

procedure TfDSGVO.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Close;
  end;
end;




procedure TfDSGVO.FormShow(Sender: TObject);
begin
  AdvWebBrowser1.Navigate('file:///WebView2Loader_x64.dll');
end;

end.
