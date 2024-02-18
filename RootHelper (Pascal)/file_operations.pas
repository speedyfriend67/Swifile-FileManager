unit file_operations;
{$mode ObjFPC}{$H+}

interface

uses
    baseunix, classes, strutils, sysutils;

procedure contentsOfDirectory(path: string);
procedure removeItem(path: string);
procedure createItem(path: string);
procedure copyFile(fromPath, toPath: string);
procedure moveItem(fromPath, toPath: string);

implementation

procedure contentsOfDirectory(path: string);
var
    i: integer;
    f: TSearchRec;

begin
    if not EndsStr('/', path) then
        path += '/';
    
    if StartsStr('.', path) then
        raise Exception.Create('Cannot use relative path!');
    
    if DirectoryExists(path) then
    begin
        if FindFirst(path + '*', faAnyFile and faDirectory, f) = 0 then
        begin
            repeat
                with f do begin
                    case Name of
                        '.', '..': continue;
                    else
                        writeln(Name);
                    end;
                end;
            until FindNext(f) <> 0;
            FindClose(f);
        end;
    end
    else
        raise Exception.Create(Format('%s: Not a directory', [path]));
end;

procedure removeItem(path: string);
begin
    if not DirectoryExists(path) then
        DeleteFile(path)
    else
        RmDir(path);
end;

procedure createItem(path: string);
var
    tfOut: TextFile;
begin
    if FileExists(path) then
        raise Exception.Create(Format('%s: Already exists.', [path]));
    AssignFile(tfOut, path);
    ReWrite(tfOut);
    write(tfOut, '');
    CloseFile(tfOut);
    FpChown(path, 501, 501); // sets the owner to mobile. Errors not handled.
end;

procedure copyFile(fromPath, toPath: string);
var
    memBuffer: TMemoryStream;
begin
    memBuffer := TMemoryStream.Create;
    memBuffer.LoadFromFile(fromPath);
    memBuffer.SaveToFile(toPath);
    memBuffer.Free;
end;

procedure moveItem(fromPath, toPath: string);
begin
    copyFile(fromPath, toPath);
    DeleteFile(fromPath);
end;

end.

