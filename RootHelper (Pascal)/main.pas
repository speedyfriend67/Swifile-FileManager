program main;
{$mode ObjFPC}

uses BaseUnix, file_operations, sysutils;

var
    i: integer;

procedure Help;
begin
    writeln('Usage: RootHelper [action] [path]');
    writeln('Proundly to be written in Pascal. Write once, run everywhere!');
    writeln;
    writeln('Available [action]s:');
    writeln('del / d [path]                             : Deletes [path]');
    writeln('list / l [path]                            : Shows the content [path]');
    writeln('create / c [path]                          : Creates [path]');
    writeln('createdir / md [path]                      : Creates [path] as a directory');
    writeln('move / mv [path, list must not be odd]     : Moves files (FILES only for now)');
    writeln('copy / cp [path, list must not be odd]     : Copies files (FILES only)');
    writeln('getuid / guid                              : Gets and shows the current UID');
    writeln('getgid / gid                               : Gets and shows the current GID');
    writeln;
    write('[path] can in any number of absolute paths that the program and system can handle,');
    writeln(' in any kind: file and folder.');
    writeln;
    writeln('This is MEANT to be used INTERNALLY by Swifile - a File manager.');
    writeln('Any damages to the file system by you using this? You''re the one who is responsible for it, not us.');
    writeln('This project is a part of Swifile, licensed under the MIT license.');
end;

procedure MoveItems;
begin
    if not (ParamCount - 1) mod 2 = 0 then
        raise Exception.Create('Not enough arguments!')
    else
        i := 2;
        while i < ParamCount do
        begin
            moveItem(ParamStr(i), ParamStr(i + 1));
            inc(i, 2);
        end;
end;

procedure CopyItems;
begin
    if not (ParamCount - 1) mod 2 = 0 then
        raise Exception.Create('Not enough arguments!')
    else
        i := 2;
        while i < ParamCount do
        begin
            copyFile(ParamStr(i), ParamStr(i + 1));
            inc(i, 2);
        end;
end;

begin

    if ParamCount = 0 then begin Help; halt(0); end
    else
        case ParamStr(1) of
            'del', 'd': for i := 2 to ParamCount do removeItem(ParamStr(i));
            'list', 'l': for i := 2 to ParamCount do begin contentsOfDirectory(ParamStr(i)); writeln; end;
            'create', 'c': for i := 2 to ParamCount do createItem(ParamStr(i));
            'createdir', 'md': for i := 2 to ParamCount do CreateDir(ParamStr(i));
            'move', 'mv': MoveItems;
            'copy', 'cp': CopyItems;
            'getuid', 'guid': begin writeln(Format('UID: %d', [FpGetuid()])); halt(0); end;
            'getgid', 'gid': begin writeln(Format('GID: %d', [FpGetgid()])); halt(0); end;
        else
            Help;
            writeln(Format('%s: Unknown action', [ParamStr(1)]));
            halt(1);
        end;

end.
