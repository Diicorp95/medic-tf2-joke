unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MMSystem, ExtCtrls;

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
