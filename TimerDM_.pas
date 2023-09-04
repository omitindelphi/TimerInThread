unit TimerDM_;

interface

uses
  SysUtils, Windows, Messages, Classes, ExtCtrls;

const
    WM_UPDATE_HEART = WM_USER + 111;

type
  TTimerDM = class(TDataModule)
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    fMainFormHandle: HWND;
  public
    { Public declarations }
    property MainFormHandle: HWND read fMainFormHandle write fMainFormHandle;
  end;

var
  TimerDM: TTimerDM;

implementation

{$R *.dfm}

procedure TTimerDM.Timer1Timer(Sender: TObject);
begin
    Sysutils.Beep();
    if fMainFormHandle <> 0 then
       PostMessage(fMainFormHandle, WM_UPDATE_HEART, 0, 0);
end;

end.
