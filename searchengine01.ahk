;https://digiconfactory.tistory.com/entry/%EC%98%A4%ED%86%A0%ED%95%AB%ED%82%A4-GUI-%EC%9D%B8%ED%84%B0%EB%84%B7-%EA%B2%80%EC%83%89%EC%B0%BD?category=916403?category=916403
;오토핫키 GUI 인터넷 검색창 만들기 - Autohotkey 가이드 3

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Reload시 팝업창이 안나오게함
#SingleInstance, Force
; AHK GUI
; sub-commands : add, show, submit
; object : edit, button
; basic gui script
; vSearchKeyword -> %SearchKeyword% it is a variable

; GoogleSearch meaning execute subroutine GoogleSearch

; vVariable: %Variable% 변수로 사용한다
; gLabel: Label이라는 subroutine (함수같은 것)
; Label -> 텍스트의 그 Label이 아니라 서브루틴을 의미

; font 설정 안하면 default
Gui, Font, s11 cF9F1D6, 맑은 고딕

Gui, Add, Text, x10 y10 , 검색어 입력(F4)
Gui, Add, Edit, multi y+5 w310 cBlack vSearchKeyword,
Gui, Add, Button, x10 y+20 Default gNaverSearch, 네이버`n(Enter)
Gui, Add, Button, x+10 Default gGoogleSearch, 구글`n(SftEnt)
Gui, Add, Button, x+10 Default gYoutubeSearch, 유튜브`n(CtrlEnt)
Gui, Add, Button, x+10 Default gSearchAll, 모두`n(AltEnt)

; +AlwaysOnTop -> 최상단
; -AlwaysOnTop -> 가려짐
;Gui, +AlwaysOnTop
; hex color
;;Gui, Color, 2170E4
Gui, Color, 00C73C

; w200 -> width 200px h200 -> height 200px
; x300 y300 -> 좌표를 의미 스크린 좌측 상단에서 x가 300px, y가 300px
Gui, Show, x800 y700 w330 h200, 웹에서 검색 v1.0
;한글 나오게 하기
GetLanguage()
If (GetLanguage() = 0)
Send, {VK15}
;Msgbox % GetLanguage()

; 트레이 아이콘에 추가하기
Menu, Tray, Add, (Pause) 검색창 띄우기, GUIShow
Menu, Tray, Add, (F4) 검색어 초기화, SearchShow
Menu, Tray, Add, (^Esc) 종료하기, GuiClose
Menu, Tray, Tip, Search Engines
return
; <-- ahk basic control HotKey -->

; reload script
$F5::
IfWinActive, 웹에서 검색
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
IfWinActive, 웹에서 검색
{
Edit
}
else
{
send {F3}
}
return


$F4::
IfWinActive, 웹에서 검색
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
IfWinActive, 웹에서 검색
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
; GuiClose를 사용하지 않을 경우
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

; 서브루틴에 단축키 지정이 가능하다
;;
$Enter::
IfWinActive, 웹에서 검색
 gosub, NaverSearch
else
 send, {enter}
return

+Enter::
IfWinActive, 웹에서 검색
 gosub, GoogleSearch
else
 send, {shiftdown}{Enter}{shiftup}
return

^Enter::
IfWinActive, 웹에서 검색
gosub, YoutubeSearch
else
 send, {ctrldown}{Enter}{ctrlup}
return


!Enter::
IfWinActive, 웹에서 검색
gosub, SearchAll
else
 send, {altdown}{Enter}{altup}
return


; 종료버튼 x 를 클릭시 실행
GuiClose:
 ExitApp
 return

GetLanguage() ;~ 영어로 되있다면 0이 출력되고, 한글일 경우 1로 뜹니다.
{
IfEqual, hWnd,, WinGet, hWnd, ID, A
DefaultIMEWnd := DllCall( "imm32\ImmGetDefaultIMEWnd", "UInt", hWnd)
DetectSaved = %A_DetectHiddenWindows%
DetectHiddenWindows, On
SendMessage, 0x283, 5, 0,, ahk_id %DefaultIMEWnd%
IfNotEqual, A_DetectHiddenWindows, %DetectSaved%, DetectHiddenWindows, %DetectSaved%
Return ErrorLevel
}
