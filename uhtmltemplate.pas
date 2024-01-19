{

TheUserman : Simple User Manager (userman) Mikrotik

Author        : Ahmad Tauhid
Description   : Aplikasi manajemen user hotspot mikrotik
Date          : 01/05/2018
Version       : 3.2.1 stable (codename : Ramadhan)
Web Blog      : http://theuserman.blogspot.co.id

Dibangun menggunakan Bahasa Pemrograman Objek Pascal dan dicompile dengan IDE Lazarus v1.6.4.

Aplikasi ini merupakan implementasi dari MikroTik RouterOS API Client yang ditulis oleh Pavel Skuratovich (chupaka@gmail.com)

Free JPDF Pascal yang ditulis oleh Jean Patrick (jpsoft-sac-pa@hotmail.com) digunakan untuk membuat file PDF

Jika ada hal yang ingin ditanyakan silahkan hubungi kami melalui (ahmad.tauhid.cp@gmail.com)

License : anda dapat memodifikasi source code ini tapi tidak diperkenankan menghapus informasi author ini.
          jadilah orang yang cerdas dan hargailah jerih payah kami.

}

unit uhtmltemplate;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, ExtCtrls, bahasa, encode_decode, IniFiles;

type

  { TFHTMLTemplate }

  TFHTMLTemplate = class(TForm)
    BHapus: TBitBtn;
    BSimpan: TBitBtn;
    GroupHeader: TGroupBox;
    GroupRow: TGroupBox;
    GroupFooter: TGroupBox;
    MemoHeader: TMemo;
    MemoRow: TMemo;
    MemoFooter: TMemo;
    Panel1: TPanel;
    procedure BHapusClick(Sender: TObject);
    procedure BSimpanClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FHTMLTemplate: TFHTMLTemplate;

implementation

{$R *.lfm}

{ TFHTMLTemplate }

procedure TFHTMLTemplate.BHapusClick(Sender: TObject);
begin
  MemoHeader.Lines.Clear;
  MemoRow.Lines.Clear;
  MemoFooter.Lines.Clear;
end;

procedure TFHTMLTemplate.BSimpanClick(Sender: TObject);
var
  myinifile   : TIniFile;
begin
  if (MemoHeader.Lines.Text='') or (MemoRow.Lines.Text='') or (MemoFooter.Lines.Text='') then
  MessageDlg(Gunakan(CekBahasa(),'HTMLTEMPLATE','WarningError'),mtWarning,[mbok],0) else
     begin
     if (FileExists(ExtractFilePath(Application.exename)+'config.ini')) then
       begin
         myinifile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config.ini');
          with myinifile do begin
          WriteString('HTMLTEMPLATE','Header',GSMEncode7Bit(MemoHeader.Text));
          WriteString('HTMLTEMPLATE','Row',GSMEncode7Bit(MemoRow.Text));
          WriteString('HTMLTEMPLATE','Footer',GSMEncode7Bit(MemoFooter.Text));
          end;
       myinifile.Free;
       end;
     FormShow(Sender);
     end;
end;

procedure TFHTMLTemplate.FormCreate(Sender: TObject);
begin
  FHTMLTemplate.Caption:=Gunakan(CekBahasa(),'HTMLTEMPLATE','FTitle');
  FHTMLTemplate.GroupHeader.Caption:=Gunakan(CekBahasa(),'HTMLTEMPLATE','GHeader');
  FHTMLTemplate.GroupRow.Caption:=Gunakan(CekBahasa(),'HTMLTEMPLATE','GRow');
  FHTMLTemplate.GroupFooter.Caption:=Gunakan(CekBahasa(),'HTMLTEMPLATE','GFooter');
  FHTMLTemplate.BHapus.Caption:=Gunakan(CekBahasa(),'HTMLTEMPLATE','BHapus');
  FHTMLTemplate.BSimpan.Caption:=Gunakan(CekBahasa(),'HTMLTEMPLATE','BSimpan');
end;

procedure TFHTMLTemplate.FormShow(Sender: TObject);
var
  myinifile   : TIniFile;
begin
  BSimpan.SetFocus;
  if (FileExists(ExtractFilePath(Application.exename)+'config.ini')) then
 begin
 myinifile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config.ini');
    with myinifile do begin
    MemoHeader.Lines.Text:=GSMDecode7Bit(ReadString('HTMLTEMPLATE','Header','0'));
    MemoRow.Lines.Text:=GSMDecode7Bit(ReadString('HTMLTEMPLATE','Row','0'));
    MemoFooter.Lines.Text:=GSMDecode7Bit(ReadString('HTMLTEMPLATE','Footer','0'));
    end;
 myinifile.Free;
 end;
end;

end.

