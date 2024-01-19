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

unit UTambahUserHotspot;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, RouterOSAPI, ssl_openssl, bahasa;

type

  { TFTambahUserHotspot }

  TFTambahUserHotspot = class(TForm)
    BSimpan: TBitBtn;
    BBaru: TBitBtn;
    CGLBW: TComboBox;
    CBServer: TComboBox;
    EUsername: TEdit;
    EPassword: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    LServer: TLabel;
    LHarga: TLabel;
    LValid: TLabel;
    UserAction: TLabel;
    LID: TLabel;
    MKeterangan: TMemo;
    PanelAtas: TPanel;
    PanelBawah: TPanel;
    PanelTengah: TPanel;
    procedure BBaruClick(Sender: TObject);
    procedure BSimpanClick(Sender: TObject);
    procedure CBServerKeyPress(Sender: TObject; var Key: char);
    procedure CGLBWKeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FTambahUserHotspot: TFTambahUserHotspot;

implementation

uses UUtama, UDataUserHotspot;

{$R *.lfm}

{ TFTambahUserHotspot }


procedure TFTambahUserHotspot.FormShow(Sender: TObject);
var
  Res, Ras : TRosApiResult;
  i : Integer;
  ROS       : TRosApiClient;
begin
      ROS := TRosApiClient.Create;
    CBServer.SetFocus;
    // Koneksi
    if (FUtama.LTLS.Caption='TRUE') then
       ROS.SSLConnect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption) else
       ROS.Connect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption);
    Res := ROS.Query(['/ip/hotspot/user/profile/print'], True);
    Ras := ROS.Query(['/ip/hotspot/print'], True);
    if ROS.LastError <> '' then
    MessageDlg('ERROR : ' + ROS.LastError,mtError,[mbok],0);
    CGLBW.Items.Clear;
    CBServer.Items.Clear;

  while not Res.Eof do
  begin
    for i := 1 to Res.RowsCount do
    begin
      CGLBW.Items.Add(Res.ValueByName['name']);
      Res.Next;
    end;
  end;
    CBServer.Items.Add('all');
  while not Ras.Eof do
  begin
    for i := 1 to Ras.RowsCount do
    begin
      CBServer.Items.Add(Ras.ValueByName['name']);
      Ras.Next;
    end;
  end;
    Res.Free;
    Ras.Free;
    ROS.Free;
  end;

procedure TFTambahUserHotspot.BBaruClick(Sender: TObject);
begin
  EUsername.Text:='';
  EPassword.Text:='';
  CGLBW.Text:=Gunakan(CekBahasa(),'GLOBAL','SelectGroup');
  CBServer.Text:=Gunakan(CekBahasa(),'GLOBAL','Select');
  MKeterangan.Lines.Clear;
end;

procedure TFTambahUserHotspot.BSimpanClick(Sender: TObject);
var
  pa: array of AnsiString;
  perintah : array[1..7] of String;
  i,ulang : integer;
  s,ket : String;
  ROS       : TRosApiClient;
begin
  ROS := TRosApiClient.Create;
      // Koneksi
    if (FUtama.LTLS.Caption='TRUE') then
       ROS.SSLConnect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption) else
       ROS.Connect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption);

    if ((EUsername.Text='') or (EPassword.Text='') or (MKeterangan.Text='') or ((CGLBW.Text='') or (CGLBW.Text=Gunakan(CekBahasa(),'GLOBAL','SelectGroup')) or ((CBServer.Text='') or (CBServer.Text=Gunakan(CekBahasa(),'GLOBAL','Select'))))) then
           MessageDlg(Gunakan(CekBahasa(),'ADDHOTSPOTUSER','WarningBlank'),mtWarning,[mbok],0)
    else begin
    if (UserAction.Caption='Save') then
           begin
    // Pecah Perintah Kedalam Array
    perintah[1]:='/ip/hotspot/user/add';
    perintah[2]:='=name='+EUsername.Text;
    perintah[3]:='=profile='+CGLBW.Text;
    perintah[4]:='=password='+EPassword.Text;
    perintah[5]:='=comment='+MKeterangan.Text;
    perintah[6]:='=server='+CBServer.Text;
    perintah[7]:='=disabled=no';
    ulang := 7;
    ket := Gunakan(CekBahasa(),'ADDHOTSPOTUSER','Save');
    end else
    if (UserAction.Caption='Update') then
    begin
    // Pecah Perintah Kedalam Array
    perintah[1]:='/ip/hotspot/user/set';
    perintah[2]:='=name='+EUsername.Text;
    perintah[3]:='=profile='+CGLBW.Text;
    perintah[4]:='=password='+EPassword.Text;
    perintah[5]:='=comment='+MKeterangan.Text+' : "'+LHarga.Caption+'" '+LValid.Caption;
    perintah[6]:='=server='+CBServer.Text;
    perintah[7]:='=.id='+LID.Caption;
    ulang := 7;
    ket := Gunakan(CekBahasa(),'ADDHOTSPOTUSER','Update');
    end;
    // Menyimpan Perintah Kedalam Variabel pa
    SetLength(pa, 0);
    for i := 1 to ulang do
    begin
      s := Trim(perintah[i]);
      if s <> '' then
      begin
        SetLength(pa, High(pa) + 2);
        pa[High(pa)] := s;
      end;
    end;
    // Eksekusi Perintah
    if High(pa) >= 0 then
      ROS.Execute(pa)
      else
      begin
        MessageDlg('ERROR : ' + ROS.LastError,mtWarning,[mbok],0);
        Exit;
      end;
    // Cek Apakah ada Error
    if ROS.LastError <> '' then
    MessageDlg('ERROR : ' + ROS.LastError,mtError,[mbok],0)
    else
      begin
      MessageDlg(Gunakan(CekBahasa(),'ADDHOTSPOTUSER','SaveSuccess')+' '+ket,mtInformation,[mbok],0);
      FDataUserHotspot.FormShow(Sender);
      end;
      end;
      ROS.Free;
    end;

procedure TFTambahUserHotspot.CBServerKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFTambahUserHotspot.CGLBWKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFTambahUserHotspot.FormCreate(Sender: TObject);
begin
  LServer.Caption:=Gunakan(CekBahasa(),'GENERATEUSER','HotspotServer');
  CBServer.Text:=Gunakan(CekBahasa(),'GLOBAL','Select');
  LServer.Caption:=Gunakan(CekBahasa(),'GENERATEUSER','HotspotServer');
  Label1.Caption:=Gunakan(CekBahasa(),'ADDHOTSPOTUSER','UserLogin');
  Label2.Caption:=Gunakan(CekBahasa(),'ADDHOTSPOTUSER','Password');
  Label3.Caption:=Gunakan(CekBahasa(),'ADDHOTSPOTUSER','BandwidthLimitation');
  Label4.Caption:=Gunakan(CekBahasa(),'ADDHOTSPOTUSER','Comment');
  CGLBW.Text:=Gunakan(CekBahasa(),'GLOBAL','SelectGroup');
end;

end.

