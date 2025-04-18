unit ExtractDLL;

interface

procedure ExtractWebView2Loader;

implementation

uses
  System.SysUtils, System.Classes, Windows;

procedure ExtractWebView2Loader;
var
  ResStream: TResourceStream;
  FileStream: TFileStream;
  FileName: string;
begin
  FileName := ExtractFilePath(ParamStr(0)) + 'WebView2Loader.dll';

  if not FileExists(FileName) then
  begin
    ResStream := TResourceStream.Create(HInstance, 'WEBVIEW2LOADER', RT_RCDATA);
    try
      FileStream := TFileStream.Create(FileName, fmCreate);
      try
        FileStream.CopyFrom(ResStream, 0);
      finally
        FileStream.Free;
      end;
    finally
      ResStream.Free;
    end;
  end;
end;

initialization
  ExtractWebView2Loader;

end.

