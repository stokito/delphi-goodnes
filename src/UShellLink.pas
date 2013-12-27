unit UShellLink;

(**

ShowComand
SW_HIDE	Hides the window and activates another window.
SW_MAXIMIZE	Maximizes the specified window.
SW_MINIMIZE	Minimizes the specified window and activates the next top-level window in the Z order.
SW_RESTORE	Activates and displays the window. If the window is minimized or maximized, Windows restores it to its original size and position. An application should specify this flag when restoring a minimized window.
SW_SHOW	Activates the window and displays it in its current size and position.
SW_SHOWDEFAULT	Sets the show state based on the SW_ flag specified in the STARTUPINFO structure passed to the CreateProcess function by the program that started the application.
SW_SHOWMAXIMIZED	Activates the window and displays it as a maximized window.
SW_SHOWMINIMIZED	Activates the window and displays it as a minimized window.
SW_SHOWMINNOACTIVE	Displays the window as a minimized window. The active window remains active.
SW_SHOWNA	Displays the window in its current state. The active window remains active.
SW_SHOWNOACTIVATE	Displays a window in its most recent size and position. The active window remains active.
SW_SHOWNORMAL	Activates and displays a window. If the window is minimized or maximized, Windows restores it to its original size and position. An application should specify this flag when displaying the window for the first time.

*)

interface

uses
  SysUtils, Windows, Graphics, ShellAPI, ShlObj, ComObj, ActiveX, ShellCtrls;

type
  TShellLink = class
  private
    FFileName: TFileName;
    FObject: IUnknown;
    FSLink: IShellLink;
    FPFile: IPersistFile;
    function GetArguments: string;
    function GetDescription: string;
    function GetHotKey: Word;
    function GetIcon: TIcon;
    function GetPath: TFileName;
    function GetShowCommand: Integer;
    function GetWorkingDirectory: TFileName;

    procedure SetArguments(const Value: string);
    procedure SetDescription(const Value: string);
    procedure SetHotKey(const Value: Word);
    procedure SetPath(const Value: TFileName);
    procedure SetShowCommand(const Value: Integer);
    procedure SetWorkingDirectory(const Value: TFileName);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Load;
    procedure Save;
    procedure GetIconLocation(out Location: TFileName; out Index: Integer);
    procedure SetIconLocation(Location: TFileName; Index: Integer);
    property Path: TFileName read GetPath write SetPath;
    property Arguments: string read GetArguments write SetArguments;
    property WorkingDirectory: TFileName read GetWorkingDirectory write SetWorkingDirectory;
    property Description: string read GetDescription write SetDescription;
    property Icon: TIcon read GetIcon;
    property HotKey: Word read GetHotKey write SetHotKey;
    property ShowCommand: Integer read GetShowCommand write SetShowCommand;
  published
    property FileName: TFileName read FFileName write FFileName;
  end;


implementation

{ TShellLink }

constructor TShellLink.Create;
begin
  FObject := CreateComObject(CLSID_ShellLink);
  FPFile := FObject as IPersistFile;
  FSLink := FObject as IShellLink;
end;

destructor TShellLink.Destroy;
begin
  FSLink := nil;
  FPFile := nil;
  FObject := nil;
end;

procedure TShellLink.Load;
begin
  FPFile.Load(PWChar(WideString(FileName)), 0);
end;

procedure TShellLink.Save;
begin
  FPFile.Save(PWChar(WideString(FileName)), False);
end;

function TShellLink.GetArguments: string;
var
  PArguments: array[0..MAX_PATH] of Char;
begin
  FSLink.GetArguments(PArguments, SizeOf(PArguments));
  Result := PArguments;
end;

function TShellLink.GetDescription: string;
var
  PDescription: array[0..MAX_PATH] of Char;
begin
  FSLink.GetDescription(PDescription, SizeOf(PDescription));
  Result := PDescription;
end;

function TShellLink.GetPath: TFileName;
var
  PPath: array[0..MAX_PATH] of Char;
  FindData: TWIN32FINDDATA;
begin
  FSLink.GetPath(PPath, SizeOf(PPath), FindData, SLGP_UNCPRIORITY);
  Result := PPath;
end;

function TShellLink.GetWorkingDirectory: TFileName;
var
  PWorkingDirectory: array[0..MAX_PATH] of Char;
begin
  FSLink.GetWorkingDirectory(PWorkingDirectory, SizeOf(PWorkingDirectory));
  Result := PWorkingDirectory;
end;

function TShellLink.GetHotKey: Word;
begin
  FSLink.GetHotKey(Result);
end;

procedure TShellLink.GetIconLocation(out Location: TFileName; out Index: Integer);
var
  PIconLocation: array[0..MAX_PATH] of Char;
begin
  FSLink.GetIconLocation(PIconLocation, SizeOf(PIconLocation), Index);
  Location := PIconLocation;
end;

function TShellLink.GetIcon: TIcon;
(**
  Иконка задаётся следующим образом:
  1) В поле IconLocation может быть задан путь к ico файлу
  2) В поле IconLocation может быть задан путь к exe или dll файлу внутри
     которого лежат иконки. Иконок может быть несколько поэтому указывается ещё
     индекс иконки в поле IconIndex
  3) Если обьект - программа а поле IconLocation пустое то по умолчанию
     путём к иконке IconLocation считается сама программа объект
  4) Если обьект - не программа а например папка то по идее должна братся
     иконка по умолчанию для таких типов файлов. Сдесь этот случай не учитывается

  Обратите внимание что каждый раз создаётся новая иконка и нужно её удалять.
*)
var
  AIcon: TIcon;
  IconLocation, IconExtension: TFileName;
  IconIndex: Integer;
begin
  GetIconLocation(IconLocation, IconIndex);
  if IconLocation = '' then
  begin
    if LowerCase(ExtractFileExt(Path)) = '.exe' then
    begin
      AIcon := TIcon.Create;
      AIcon.Handle := ExtractIcon(0, PChar(Path), IconIndex);
      Result := AIcon;
    end
    else
      Result := nil;
  end
  else
  begin
    AIcon := TIcon.Create;
    IconExtension := LowerCase(ExtractFileExt(IconLocation));
    if (IconExtension = '.exe') or (IconExtension = '.dll') then
      AIcon.Handle := ExtractIcon(0, PChar(IconLocation), IconIndex)
    else
      AIcon.LoadFromFile(IconLocation);
    Result := AIcon;
  end;
end;

procedure TShellLink.SetPath(const Value: TFileName);
begin
  FSLink.SetPath(PChar(Value));
end;

procedure TShellLink.SetWorkingDirectory(const Value: TFileName);
begin
  FSLink.SetWorkingDirectory(PChar(Value));
end;

procedure TShellLink.SetArguments(const Value: string);
begin
  FSLink.SetArguments(PChar(Value));
end;

procedure TShellLink.SetDescription(const Value: string);
begin
  FSLink.SetDescription(PChar(Value));
end;

function TShellLink.GetShowCommand: Integer;
begin
  FSLink.GetShowCmd(Result);
end;

procedure TShellLink.SetHotKey(const Value: Word);
begin
  FSLink.SetHotkey(Value);
end;

procedure TShellLink.SetShowCommand(const Value: Integer);
begin
  FSLink.SetShowCmd(Value);
end;

procedure TShellLink.SetIconLocation(Location: TFileName; Index: Integer);
begin
  FSLink.SetIconLocation(PChar(Location), Index)
end;

end.
