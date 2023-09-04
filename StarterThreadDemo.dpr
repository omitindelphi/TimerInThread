program StarterThreadDemo;

uses
  Forms,
  StarterThreadDemoForm_ in 'StarterThreadDemoForm_.pas' {StarterThreadDemoForm},
  TimerDM_ in 'TimerDM_.pas' {DataModule1: TDataModule},
  MessagePumpSleepThread in 'MessagePumpSleepThread.pas',
  DMTimerThread in 'DMTimerThread.pas',
  DMTimerHeartThread in 'DMTimerHeartThread.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TStarterThreadDemoForm, StarterThreadDemoForm);
  Application.Run;
end.
