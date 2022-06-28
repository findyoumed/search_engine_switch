;https://digiconfactory.tistory.com/entry/%EC%98%A4%ED%86%A0%ED%95%AB%ED%82%A4-GUI-%EC%9D%B8%ED%84%B0%EB%84%B7-%EA%B2%80%EC%83%89%EC%B0%BD?category=916403?category=916403
;������Ű GUI ���ͳ� �˻�â ����� - Autohotkey ���̵� 3

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Reload�� �˾�â�� �ȳ�������
#SingleInstance, Force
; AHK GUI
; sub-commands : add, show, submit
; object : edit, button
; basic gui script
; vSearchKeyword -> %SearchKeyword% it is a variable

; GoogleSearch meaning execute subroutine GoogleSearch

; vVariable: %Variable% ������ ����Ѵ�
; gLabel: Label�̶�� subroutine (�Լ����� ��)
; Label -> �ؽ�Ʈ�� �� Label�� �ƴ϶� �����ƾ�� �ǹ�

; font ���� ���ϸ� default
Gui, Font, s11 cF9F1D6, ���� ���

Gui, Add, Text, x10 y10 , �˻��� �Է�(F4)
Gui, Add, Edit, multi y+5 w310 cBlack vSearchKeyword,
Gui, Add, Button, x10 y+20 Default gNaverSearch, ���̹�`n(Enter)
Gui, Add, Button, x+10 Default gGoogleSearch, ����`n(SftEnt)
Gui, Add, Button, x+10 Default gYoutubeSearch, ��Ʃ��`n(CtrlEnt)
Gui, Add, Button, x+10 Default gSearchAll, ���`n(AltEnt)

; +AlwaysOnTop -> �ֻ��
; -AlwaysOnTop -> ������
;Gui, +AlwaysOnTop
; hex color
;;Gui, Color, 2170E4
Gui, Color, 00C73C

; w200 -> width 200px h200 -> height 200px
; x300 y300 -> ��ǥ�� �ǹ� ��ũ�� ���� ��ܿ��� x�� 300px, y�� 300px
Gui, Show, x800 y700 w330 h200, ������ �˻� v1.0
;�ѱ� ������ �ϱ�
GetLanguage()
If (GetLanguage() = 0)
Send, {VK15}
;Msgbox % GetLanguage()

; Ʈ���� �����ܿ� �߰��ϱ�
Menu, Tray, Add, (Pause) �˻�â ����, GUIShow
Menu, Tray, Add, (F4) �˻��� �ʱ�ȭ, SearchShow
Menu, Tray, Add, (^Esc) �����ϱ�, GuiClose
Menu, Tray, Tip, Search Engines
return
; <-- ahk basic control HotKey -->

; reload script
$F5::
IfWinActive, ������ �˻�
{
Reload
}
else
{
send {F5}
}
return

; edit script
$F3::
IfWinActive, ������ �˻�
{
Edit
}
else
{
send {F3}
}
return


$F4::
IfWinActive, ������ �˻�
{
GuiControl, Focus, text
send, {ctrldown}a{ctrlup}{Delete}
}
else
{
send {F4}
}
return

; exit out
;;^q::ExitApp
^ESC::ExitApp
$ESC::
IfWinActive, ������ �˻�
{
GUI, Hide
}
else
{
send {ESC}
}
return

$Pause::
{
GUI, Show
GetLanguage()
If (GetLanguage() = 0)
Send, {VK15}
;Msgbox % GetLanguage()
}
; <-- Gui Instance Control -->

GUIShow()
{
GUI, Show
}

; tp show GUI
; Ctrl + Shift + s
; GuiClose�� ������� ���� ���
; ^+s::Gui, Show

; remove Gui from memory
; Ctrl + Shift + d
;^+d::Gui, Destroy

SearchShow:
Gui, Show
return


; sub routine for google, youtube, naver etc.
; Nohide - after submit Gui stays
GoogleSearch:
 Gui, Submit, Nohide
 Run, https://www.google.com/search?q=%SearchKeyword%
 return

YoutubeSearch:
 Gui, Submit, Nohide
 if (SearchKeyword <> null)
 Run, https://www.youtube.com/results?search_query=%SearchKeyword%
 else
 Run, https://www.youtube.com/
 return

NaverSearch:
 Gui, Submit, Nohide
 if (SearchKeyword <> null)
 Run, https://search.naver.com/search.naver?query=%SearchKeyword%
 else
 Run, https://www.naver.com
 return

SearchAll:
 gosub, YoutubeSearch
 gosub, GoogleSearch
 gosub, NaverSearch
  return

; �����ƾ�� ����Ű ������ �����ϴ�
;;
$Enter::
IfWinActive, ������ �˻�
 gosub, NaverSearch
else
 send, {enter}
return

+Enter::
IfWinActive, ������ �˻�
 gosub, GoogleSearch
else
 send, {shiftdown}{Enter}{shiftup}
return

^Enter::
IfWinActive, ������ �˻�
gosub, YoutubeSearch
else
 send, {ctrldown}{Enter}{ctrlup}
return


!Enter::
IfWinActive, ������ �˻�
gosub, SearchAll
else
 send, {altdown}{Enter}{altup}
return


; �����ư x �� Ŭ���� ����
GuiClose:
 ExitApp
 return

GetLanguage() ;~ ����� ���ִٸ� 0�� ��µǰ�, �ѱ��� ��� 1�� ��ϴ�.
{
IfEqual, hWnd,, WinGet, hWnd, ID, A
DefaultIMEWnd := DllCall( "imm32\ImmGetDefaultIMEWnd", "UInt", hWnd)
DetectSaved = %A_DetectHiddenWindows%
DetectHiddenWindows, On
SendMessage, 0x283, 5, 0,, ahk_id %DefaultIMEWnd%
IfNotEqual, A_DetectHiddenWindows, %DetectSaved%, DetectHiddenWindows, %DetectSaved%
Return ErrorLevel
}
