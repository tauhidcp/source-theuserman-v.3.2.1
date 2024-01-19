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

unit uselectcolumn;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, bahasa, encode_decode, IniFiles;

type

  { TFCustomVoucherColumn }

  TFCustomVoucherColumn = class(TForm)
    GSelect: TGroupBox;
    R2Column: TRadioButton;
    R3Column: TRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure R2ColumnClick(Sender: TObject);
    procedure R3ColumnClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FCustomVoucherColumn: TFCustomVoucherColumn;

implementation

{$R *.lfm}

{ TFCustomVoucherColumn }

procedure TFCustomVoucherColumn.FormCreate(Sender: TObject);
begin
  FCustomVoucherColumn.Caption:=Gunakan(CekBahasa(),'TemplateColumn','FTitle');
  FCustomVoucherColumn.GSelect.Caption:=Gunakan(CekBahasa(),'TemplateColumn','SelectColumn');
  FCustomVoucherColumn.R2Column.Caption:=Gunakan(CekBahasa(),'TemplateColumn','2Column');
  FCustomVoucherColumn.R3Column.Caption:=Gunakan(CekBahasa(),'TemplateColumn','3Column');
end;

procedure TFCustomVoucherColumn.FormShow(Sender: TObject);
var
  myinifile   : TIniFile;
begin
  if (FileExists(ExtractFilePath(Application.exename)+'config.ini')) then
 begin
 myinifile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config.ini');
    with myinifile do begin
    if (GSMDecode7Bit(GSMDecode7Bit(ReadString('CONFIG','VoucherColumn','0')))='Dua') then R2Column.Checked:=True else
    if (GSMDecode7Bit(GSMDecode7Bit(ReadString('CONFIG','VoucherColumn','0')))='Tiga') then R3Column.Checked:=True;
    end;
 myinifile.Free;
 end;
end;

procedure TFCustomVoucherColumn.R2ColumnClick(Sender: TObject);
var
  myinifile   : TIniFile;
begin
  if (FileExists(ExtractFilePath(Application.exename)+'config.ini')) then
 begin
 myinifile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config.ini');
    with myinifile do begin
    if R2Column.Checked=True then
    WriteString('CONFIG','VoucherColumn',GSMEncode7Bit(GSMEncode7Bit('Dua')));
    Free;
    end;
 end;
end;

procedure TFCustomVoucherColumn.R3ColumnClick(Sender: TObject);
var
  myinifile   : TIniFile;
begin
  if (FileExists(ExtractFilePath(Application.exename)+'config.ini')) then
 begin
 myinifile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config.ini');
    with myinifile do begin
    if R3Column.Checked=True then
    WriteString('CONFIG','VoucherColumn',GSMEncode7Bit(GSMEncode7Bit('Tiga')));
    Free;
    end;
 end;
end;

end.

