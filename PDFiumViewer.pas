unit PDFiumViewer;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Graphics, Winapi.Windows, PDFium;

type
  TPDFiumViewer = class(TCustomControl)
  private
    FDocument: FPDF_DOCUMENT;
    FPage: FPDF_PAGE;
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LoadFromFile(const FileName: string);
  end;

procedure Register;

implementation

constructor TPDFiumViewer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDocument := nil;
  FPage := nil;
  FPDF_InitLibrary();
end;

destructor TPDFiumViewer.Destroy;
begin
  if FPage <> nil then
    FPDF_ClosePage(FPage);
  if FDocument <> nil then
    FPDF_CloseDocument(FDocument);
  FPDF_DestroyLibrary();
  inherited Destroy;
end;

procedure TPDFiumViewer.LoadFromFile(const FileName: string);
begin
  if FPage <> nil then
    FPDF_ClosePage(FPage);
  if FDocument <> nil then
    FPDF_CloseDocument(FDocument);

  FDocument := FPDF_LoadDocument(PAnsiChar(AnsiString(FileName)), nil);
  if FDocument = nil then
    raise Exception.Create('Cannot load PDF document.');

  FPage := FPDF_LoadPage(FDocument, 0);
  if FPage = nil then
  begin
    FPDF_CloseDocument(FDocument);
    FDocument := nil;
    raise Exception.Create('Cannot load PDF page.');
  end;

  Invalidate;
end;

procedure TPDFiumViewer.Paint;
var
  Bitmap: HBITMAP;
  BitmapDC: HDC;
begin
  if FPage = nil then Exit;

  BitmapDC := CreateCompatibleDC(0);
  Bitmap := CreateCompatibleBitmap(Canvas.Handle, Width, Height);
  SelectObject(BitmapDC, Bitmap);

  FPDF_RenderPageBitmap(Bitmap, FPage, 0, 0, Width, Height, 0, 0);
  BitBlt(Canvas.Handle, 0, 0, Width, Height, BitmapDC, 0, 0, SRCCOPY);

  DeleteObject(Bitmap);
  DeleteDC(BitmapDC);
end;

procedure Register;
begin
  RegisterComponents('Samples', [TPDFiumViewer]);
end;

end.

