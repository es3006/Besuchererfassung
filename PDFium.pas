unit PDFium;

interface

uses
  System.SysUtils, System.Classes, Winapi.Windows;

type
  FPDF_DOCUMENT = Pointer;
  FPDF_PAGE = Pointer;
  FPDF_BITMAP = Pointer;

const
  pdfiumDLL = 'pdfium.dll';

function FPDF_LoadDocument(file_path: PAnsiChar; password: PAnsiChar): FPDF_DOCUMENT; stdcall; external pdfiumDLL;
procedure FPDF_CloseDocument(document: FPDF_DOCUMENT); stdcall; external pdfiumDLL;
function FPDF_LoadPage(document: FPDF_DOCUMENT; page_index: Integer): FPDF_PAGE; stdcall; external pdfiumDLL;
procedure FPDF_ClosePage(page: FPDF_PAGE); stdcall; external pdfiumDLL;
procedure FPDF_RenderPageBitmap(bitmap: HBITMAP; page: FPDF_PAGE; start_x, start_y, size_x, size_y, rotate, flags: Integer); stdcall; external pdfiumDLL;
procedure FPDF_InitLibrary(); stdcall; external pdfiumDLL;
procedure FPDF_DestroyLibrary(); stdcall; external pdfiumDLL;

implementation

end.

