unit PDFiumWrapper;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Graphics, Winapi.Windows, Winapi.Messages, pdfium;

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
end;

destructor TPDFiumViewer.Destroy;
begin
  if FPage <> nil then
    FPDF_ClosePage(FPage);
  if FDocument <> nil then
    FPDF_CloseDocument(FDocument);
  inherited Destroy;
end;

procedure TPDFiumViewer.LoadFromFile(const FileName: string);
var
  FileHandle: THandle;
  FileSize: DWORD;
  FileMapping: THandle;
  FileBase: Pointer;
begin
  if FPage <> nil then
    FPDF_ClosePage(FPage);
  if FDocument <> nil then
    FPDF_CloseDocument(FDocument);

  FileHandle := CreateFile(PChar(FileName), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  if FileHandle = INVALID_HANDLE_VALUE then
    raise Exception.Create('Cannot open file.');

  FileSize := GetFileSize(FileHandle, nil);
  if FileSize = INVALID_FILE_SIZE then
  begin
    CloseHandle(FileHandle);
    raise Exception.Create('Cannot get file size.');
  end;

  FileMapping := CreateFileMapping(FileHandle, nil, PAGE_READONLY, 0, FileSize, nil);
  if FileMapping = 0 then
  begin
    CloseHandle(FileHandle);
    raise Exception.Create('Cannot create file mapping.');
  end;

  FileBase := MapViewOfFile(FileMapping, FILE_MAP_READ, 0, 0, FileSize);
  if FileBase = nil then
  begin
    CloseHandle(FileMapping);
    CloseHandle(FileHandle);
    raise Exception.Create('Cannot map view of file.');
  end;

  FPDF_InitLibrary();
  FDocument := FPDF_LoadMemDocument(FileBase, FileSize, nil);
  if FDocument = nil then
  begin
    UnmapViewOfFile(FileBase);
    CloseHandle(FileMapping);
    CloseHandle(FileHandle);
    raise Exception.Create('Cannot load PDF document.');
  end;

  FPage := FPDF_LoadPage(FDocument, 0);
  if FPage = nil then
  begin
    FPDF_CloseDocument(FDocument);
    UnmapViewOfFile(FileBase);
    CloseHandle(FileMapping);
    CloseHandle(FileHandle);
    raise Exception.Create('Cannot load PDF page.');
  end;

  Invalidate;

  UnmapViewOfFile(FileBase);
  CloseHandle(FileMapping);
  CloseHandle(FileHandle);
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

