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

unit UTemplateVoucher;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons, ExtDlgs, ubarcodes, IniFiles, bahasa, encode_decode;

type

  { TFTemplateVoucher }

  TFTemplateVoucher = class(TForm)
    BSaveVoucherTemplate: TBitBtn;
    ImgTemplate: TImage;
    Label1: TLabel;
    OpenPicDialog: TOpenPictureDialog;
    PanelAtas: TPanel;
    PanelBawah: TPanel;
    PanelTengah: TPanel;
    RCustomTemplate: TRadioButton;
    RDefaultTemplate: TRadioButton;
    ShapeTemplate: TShape;
    procedure BSaveVoucherTemplateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ImgTemplateClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FTemplateVoucher: TFTemplateVoucher;
    myinifile   : TIniFile;

implementation

{$R *.lfm}

{ TFTemplateVoucher }

procedure TFTemplateVoucher.BSaveVoucherTemplateClick(Sender: TObject);
var
nama : String;
begin
   if (FileExists(ExtractFilePath(Application.exename)+'config.ini')) then
   begin
   if (RDefaultTemplate.Checked=True) then
   begin
   myinifile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config.ini');
      with myinifile do begin
      WriteString('CONFIG','Template',GSMEncode7Bit(GSMEncode7Bit('default')));
      Free;
      end;
      MessageDlg(Gunakan(CekBahasa(),'VOUCHERTEMPLATE','SaveSuccess'),mtInformation,[mbok],0);
   end else if (RCustomTemplate.Checked=True) then begin
   if (OpenPicDialog.FileName='') then MessageDlg(Gunakan(CekBahasa(),'VOUCHERTEMPLATE','NoImage'),mtWarning,[mbok],0) else
   begin
   if (ExtractFileExt(OpenPicDialog.FileName)='') then nama:=OpenPicDialog.FileName+'.png' else nama:=OpenPicDialog.FileName;
   // Copy File ke Folder Template
   CopyFile(nama,ExtractFilePath(Application.ExeName)+'/template/'+extractfilename(nama));
   // Simpan
   myinifile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config.ini');
      with myinifile do begin
      WriteString('CONFIG','Template',GSMEncode7Bit(GSMEncode7Bit(extractfilename(nama))));
      Free;
      end;
      MessageDlg(Gunakan(CekBahasa(),'VOUCHERTEMPLATE','SaveSuccess'),mtInformation,[mbok],0);
   end;
   end;
   end;
end;

procedure TFTemplateVoucher.FormCreate(Sender: TObject);
begin
  FTemplateVoucher.Caption:=Gunakan(CekBahasa(),'VOUCHERTEMPLATE','FTitle');
  FTemplateVoucher.PanelAtas.Caption:=Gunakan(CekBahasa(),'VOUCHERTEMPLATE','FTitle');
  FTemplateVoucher.RDefaultTemplate.Caption:=Gunakan(CekBahasa(),'VOUCHERTEMPLATE','Default');
  FTemplateVoucher.RCustomTemplate.Caption:=Gunakan(CekBahasa(),'VOUCHERTEMPLATE','Custom');
  FTemplateVoucher.Label1.Caption:=Gunakan(CekBahasa(),'VOUCHERTEMPLATE','Info');
  FTemplateVoucher.BSaveVoucherTemplate.Caption:=Gunakan(CekBahasa(),'VOUCHERTEMPLATE','BSave');
end;

procedure TFTemplateVoucher.FormShow(Sender: TObject);
begin
  if (FileExists(ExtractFilePath(Application.exename)+'config.ini')) then
   begin
   myinifile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config.ini');
      with myinifile do begin
      if (ReadString('CONFIG','Template','0')=GSMEncode7Bit(GSMEncode7Bit('default'))) then begin RDefaultTemplate.Checked:=True; ImgTemplate.Picture.Clear; end else
      begin
      RCustomTemplate.Checked:=True;
      ImgTemplate.Picture.LoadFromFile(ExtractFilePath(Application.exename)+'/template/'+GSMDecode7Bit(GSMDecode7Bit(ReadString('CONFIG','Template','0'))));
      end;
      Free;
      end;
   end;
end;

procedure TFTemplateVoucher.ImgTemplateClick(Sender: TObject);
begin
    if RCustomTemplate.Checked=True then
  begin
  if OpenPicDialog.Execute then
  ImgTemplate.Picture.LoadFromFile(OpenPicDialog.FileName);
  end else
  MessageDlg(Gunakan(CekBahasa(),'VOUCHERTEMPLATE','Select')+' '+RCustomTemplate.Caption,mtWarning,[mbok],0);
end;

end.

