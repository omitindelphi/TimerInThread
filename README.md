# TimerInThread
Problem often occuring in reworking legacy code. Timer event requires working message pump, and for that reason transferring legacy objects to thread context or service may have hurdles.

Simple example illustrating using TDataModule and OnTimer event in thread context.

Features:
 - creation and destruction of TDataModule in context of thread, and not GUI MAIN thread
 - deliberate not using of Synchronize and OnTerminate event (as it may become tricky in context of Web Service and other cases)
