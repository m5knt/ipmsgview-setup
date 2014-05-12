/*
 * ipmsgview-setup
 *   copyright 2014 Yukio Kaneda @m5knt
 */

!define TITLE "IPmsgView"
!define APP   "IPmsgView"
!define VER   "2.18.0"
!define OUTPUT "${APP}-setup-${VER}.exe"

; start menu root
!define STARTMENU     "$SMPROGRAMS\$StartMenuFolder"
; environment 
!define SYSENV        'HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"'
!define ENV           'HKCU "Environment"'
; application registry
!define REG_APP       "Software\${APP}"
; uninstall registry
!define REG_UNINSTALL "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP}"
!define PUBLISHER     ""
!define WEBSITE_LINK  "https://github.com/m5knt/ipmsgview-setup"

/*
 *
 */

!include "x64.nsh"
!include "MUI2.nsh"
!include "FileFunc.nsh"
!include "LogicLib.nsh"
!include "WinMessages.nsh"

/*
 *
 */

Var StartMenuFolder

Name "${TITLE}"
OutFile "${OUTPUT}"
RequestExecutionLevel none ; http://nsis.sourceforge.net/Reference/RequestExecutionLevel

; see http://nsis.sourceforge.net/Docs/Modern%20UI%202/Readme.html
!define SKIN "nsis-skin"
	!define MUI_ICON "${SKIN}\icon.ico"
	!define MUI_UNICON "${SKIN}\icon-uninstall.ico"
	!define MUI_HEADERIMAGE_BITMAP "${SKIN}\header.bmp"
	!define MUI_HEADERIMAGE_BITMAP_NOSTRETCH
	!define MUI_HEADERIMAGE_BITMAP_RTL "${SKIN}\header-r.bmp"
	!define MUI_HEADERIMAGE_BITMAP_RTL_NOSTRETCH
	!define MUI_HEADERIMAGE_UNBITMAP "${SKIN}\header-uninstall.bmp"
	!define MUI_HEADERIMAGE_UNBITMAP_NOSTRETCH
	!define MUI_HEADERIMAGE_UNBITMAP_RTL "${SKIN}\header-uninstall-r.bmp"
	!define MUI_HEADERIMAGE_UNBITMAP_RTL_NOSTRETCH
	!define MUI_HEADER_TRANSPARENT_TEXT "${APP}"
	!define MUI_WELCOMEFINISHPAGE_BITMAP "${SKIN}\welcome.bmp"
	!define MUI_WELCOMEFINISHPAGE_BITMAP_NOSTRETCH
	!define MUI_UNWELCOMEFINISHPAGE_BITMAP "${SKIN}\welcome-uninstall.bmp"
	!define MUI_UNWELCOMEFINISHPAGE_BITMAP_NOSTRETCH

!define MUI_ABORTWARNING
!define MUI_STARTMENUPAGE_REGISTRY_ROOT "HKCU"
!define MUI_STARTMENUPAGE_REGISTRY_KEY "${REG_APP}"
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "Start Menu Folder"
!define MUI_STARTMENUPAGE_DEFAULTFOLDER "${APP}"
!define MUI_LANGDLL_REGISTRY_ROOT "HKCU"
!define MUI_LANGDLL_REGISTRY_KEY "${REG_APP}"
!define MUI_LANGDLL_REGISTRY_VALUENAME "Language"

;!define MUI_WELCOMEPAGE_TEXT
;!define MUI_FINISHPAGE_TITLE
;!define MUI_FINISHPAGE_TEXT
!define MUI_FINISHPAGE_BUTTON "OK"
;!define MUI_FINISHPAGE_CANCEL_ENABLED
;!define MUI_FINISHPAGE_TEXT_REBOOT
;!define MUI_FINISHPAGE_TEXT_REBOOTNOW
;!define MUI_FINISHPAGE_TEXT_REBOOTLATER
;!define MUI_FINISHPAGE_REBOOTLATER_DEFAULT 
;!define MUI_FINISHPAGE_NOREBOOTSUPPORT

; インストール手順定義
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "LICENSE"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_STARTMENU Application "$StartMenuFolder"
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_COMPONENTS
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

/*
 *
 */

!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "Japanese"

LangString DescIPmsgView ${LANG_ENGLISH} "IPmsg log viewer"
LangString DescIPmsgView ${LANG_JAPANESE} "IPmsg のログビューア"
LangString UninstallFirst ${LANG_ENGLISH} "${APP} is already installed. Uninstall the existing version?"
LangString UninstallFirst ${LANG_JAPANESE} "${APP} は既にインストールされていますが再インストールを行いますか?"

/*
 *
 */

Function .onInit
    StrCpy $INSTDIR "$PROGRAMFILES32\${APP}"
	!insertmacro MUI_LANGDLL_DISPLAY
    Call UninstallPrev
FunctionEnd

Function UninstallPrev
    ReadRegStr $R0 HKLM "${REG_UNINSTALL}" "UninstallString"
    StrCmp $R0 "" fin 0
    IfSilent uninstall
    MessageBox MB_OKCANCEL "$(UninstallFirst)" IDOK uninstall
        Abort
    uninstall:
        nsExec::Exec '$R0 _?=$INSTDIR'
    fin:
FunctionEnd

Function un.onInit
  !insertmacro MUI_UNGETLANGUAGE
FunctionEnd
 
/*
 *
 */

Section
    SetOutPath "$INSTDIR"
    WriteRegStr HKCU "${REG_APP}" "" "$OUTDIR"
    WriteUninstaller "$OUTDIR\Uninstall.exe"
    File "${SKIN}\icon.ico"
    ; File "license.rtf"
    WriteRegStr HKLM "${REG_UNINSTALL}" "DisplayIcon" "$\"$OUTDIR\icon.ico$\""
    WriteRegStr HKLM "${REG_UNINSTALL}" "DisplayName" "${TITLE} ${VER}"
    WriteRegStr HKLM "${REG_UNINSTALL}" "DisplayVersion" "${VER}"
    WriteRegStr HKLM "${REG_UNINSTALL}" "Comments" ""
    WriteRegStr HKLM "${REG_UNINSTALL}" "Publisher" "${PUBLISHER}"
    WriteRegStr HKLM "${REG_UNINSTALL}" "UninstallString" "$\"$OUTDIR\Uninstall.exe$\" /S"
    WriteRegStr HKLM "${REG_UNINSTALL}" "InstallLocation" "$\"$INSTDIR$\""
    WriteRegStr HKLM "${REG_UNINSTALL}" "InstallSource" "$\"$EXEDIR$\""
    WriteRegStr HKLM "${REG_UNINSTALL}" "HelpLink" "${WEBSITE_LINK}"
    WriteRegStr HKLM "${REG_UNINSTALL}" "Contact" "${WEBSITE_LINK}"
    WriteRegStr HKLM "${REG_UNINSTALL}" "URLInfoAbout" "${WEBSITE_LINK}"
    WriteRegStr HKLM "${REG_UNINSTALL}" "URLUpdateInfo" "${WEBSITE_LINK}"
    WriteRegDWord HKLM "${REG_UNINSTALL}" "NoModify" 1
    WriteRegDWord HKLM "${REG_UNINSTALL}" "NoRepair" 1
SectionEnd

/*
 *
 */

Section "IPmsgView" SecIPmsgView
    SetOutPath "$INSTDIR\ipmsgview"
    File /r "ipmsgview\*"
	!insertmacro MUI_STARTMENU_WRITE_BEGIN Application
		CreateDirectory "${STARTMENU}"
        CreateShortCut "${STARTMENU}\IPmsgView.lnk" "$OUTDIR\ipmsgview.exe"
        CreateShortCut "${STARTMENU}\readme-jp.lnk" "$OUTDIR\readme.txt"
        CreateShortCut "${STARTMENU}\manual-jp.lnk" "$OUTDIR\IPmsgView.chm"
	!insertmacro MUI_STARTMENU_WRITE_END
SectionEnd

Section "-un.IPmsgView"
	RMDir /r "$INSTDIR\ipmsgview"
SectionEnd

/*
 *
 */

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SecIPmsgView} $(DescIPmsgView)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

/*
 *
 */

Section 
	${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2
	IntFmt $0 "0x%08X" $0
    WriteRegDWord HKLM "${REG_UNINSTALL}" "EstimatedSize" "$0" ;KB
SectionEnd

/*
 *
 */

Section "Uninstall"
    !insertmacro MUI_STARTMENU_GETFOLDER Application $StartMenuFolder
    RMDir /r "${STARTMENU}"
    /**/
    Delete "$INSTDIR\icon.ico"
    Delete "$INSTDIR\LICENSE"
    Delete "$INSTDIR\Uninstall.exe"
    RMDir /r /* /REBOOTOK */ "$INSTDIR"
    /**/
    DeleteRegKey HKLM "${REG_UNINSTALL}"
    DeleteRegKey /ifempty HKCU "${REG_APP}"
SectionEnd

/*
 *
 */

