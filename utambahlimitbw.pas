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

unit UTambahLimitBW;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, RouterOSAPI, ssl_openssl, bahasa, inifiles, encode_decode;

type

  { TFTambahLimitBW }

  TFTambahLimitBW = class(TForm)
    BSimpan: TBitBtn;
    BBaru: TBitBtn;
    Aksi: TLabel;
    Limit1: TEdit;
    Limit2: TEdit;
    ENamaGroup: TEdit;
    ESharedUser: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    slash: TLabel;
    LID: TLabel;
    PanelAtas: TPanel;
    PanelBawah: TPanel;
    PanelTengah: TPanel;
    slash1: TLabel;
    slash2: TLabel;
    procedure BBaruClick(Sender: TObject);
    procedure BSimpanClick(Sender: TObject);
    procedure ESharedUserKeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Limit1KeyPress(Sender: TObject; var Key: char);
    procedure Limit2KeyPress(Sender: TObject; var Key: char);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FTambahLimitBW: TFTambahLimitBW;

implementation

uses UUtama, UDataLimitBW;

{$R *.lfm}

{ TFTambahLimitBW }

procedure TFTambahLimitBW.BBaruClick(Sender: TObject);
begin
  ENamaGroup.Text:='';
  ESharedUser.Text:='';
  Limit1.Text:='';
  Limit2.Text:='';
end;

procedure TFTambahLimitBW.BSimpanClick(Sender: TObject);
var
  pa: array of AnsiString;
  perintah : array[1..6] of String;
  i,ulang : integer;
  s,ket : String;
  ROS       : TRosApiClient;
  myinifile   : TIniFile;
begin
    ROS := TRosApiClient.Create;
        // Koneksi
    if (FUtama.LTLS.Caption='TRUE') then
       ROS.SSLConnect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption) else
       ROS.Connect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption);
    if ((ENamaGroup.Text='') or (ESharedUser.Text='') or (Limit1.Text='') or (Limit2.Text='')) then
           MessageDlg(Gunakan(CekBahasa(),'ADDBANDWIDTHLIMITATION','WarningBlank'),mtWarning,[mbok],0)
    else begin
    if (Aksi.Caption='Save') then
           begin
    // Pecah Perintah Kedalam Array
    perintah[1]:='/ip/hotspot/user/profile/add';
    perintah[2]:='=name='+ENamaGroup.Text;
    perintah[3]:='=shared-users='+ESharedUser.Text;
    perintah[4]:='=rate-limit='+Limit1.Text+'K/'+Limit2.Text+'K';
    // Cek Apakah ada Validity atau tidak
    myinifile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config.ini');
    with myinifile do
    begin
    if GSMDecode7Bit(GSMDecode7Bit(ReadString('CONFIG','Validity','0')))='YES' then
       begin
       perintah[5]:='=on-login={'+sLineBreak+':if ( [ /ip hotspot user get $user comment ] != "" ) do={'+sLineBreak+' :local datex [/ip hotspot user get $user comment ]'+sLineBreak+':local pecah [:toarray [:pick $datex ([:find $datex ":"]+1) [:len $datex]]]'+sLineBreak+':local tgl [:pick $pecah 1]'+sLineBreak+':if ([:len $tgl] != 0) do={'+sLineBreak+':local komen [:pick $datex 0 [:find $datex ":"]]'+sLineBreak+':local harga [:pick $pecah 0]'+sLineBreak+':local date [ /system clock get date ]'+sLineBreak+':local days $tgl'+sLineBreak+':local mdays  {31;28;31;30;31;30;31;31;30;31;30;31}'+sLineBreak+':local months {"jan"=1;"feb"=2;"mar"=3;"apr"=4;"may"=5;"jun"=6;"jul"=7;"aug"=8;"sep"=9;"oct"=10;"nov"=11;"dec"=12}'+sLineBreak+':local monthr  {"jan";"feb";"mar";"apr";"may";"jun";"jul";"aug";"sep";"oct";"nov";"dec"}'+sLineBreak+':local dd  [:tonum [:pick $date 4 6]]'+sLineBreak+':local yy [:tonum [:pick $date 7 11]]'+sLineBreak+':local month [:pick $date 0 3]'+sLineBreak+':local mm (:$months->$month)'+sLineBreak+':set dd ($dd+$days)'+sLineBreak+':local dm [:pick $mdays ($mm-1)]'+sLineBreak+':if ($mm=2 && (($yy&3=0 && ($yy/100*100 != $yy)) || $yy/400*400=$yy) ) do={ :set dm 29 }'+sLineBreak+':while ($dd>$dm) do={'+sLineBreak+':set dd ($dd-$dm)'+sLineBreak+':set mm ($mm+1)'+sLineBreak+':if ($mm>12) do={'+sLineBreak+':set mm 1'+sLineBreak+':set yy ($yy+1)'+sLineBreak+'}'+sLineBreak+':set dm [:pick $mdays ($mm-1)]'+sLineBreak+':if ($mm=2 &&  (($yy&3=0 && ($yy/100*100 != $yy)) || $yy/400*400=$yy) ) do={ :set dm 29 }'+sLineBreak+'};'+sLineBreak+':local res "$[:pick $monthr ($mm-1)]/"'+sLineBreak+':if ($dd<10) do={ :set res ($res."0") }'+sLineBreak+':set $res "$res$dd/$yy"'+sLineBreak+'[ /ip hotspot user set $user comment="$komen : \"$harga\" $res" ]'+sLineBreak+'}'+sLineBreak+'}'+sLineBreak+'}';
       ulang := 5;
       end else
       begin
       ulang := 4;
       end;
    end;
    // End Validity Check
    ket := Gunakan(CekBahasa(),'ADDBANDWIDTHLIMITATION','Save');
    end else
    if (Aksi.Caption='Update') then
    begin
    // Pecah Perintah Kedalam Array
    perintah[1]:='/ip/hotspot/user/profile/set';
    perintah[2]:='=name='+ENamaGroup.Text;
    perintah[3]:='=shared-users='+ESharedUser.Text;
    perintah[4]:='=rate-limit='+Limit1.Text+'K/'+Limit2.Text+'K';
    // Cek Apakah ada Validity atau tidak
    myinifile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config.ini');
    with myinifile do
    begin
    if GSMDecode7Bit(GSMDecode7Bit(ReadString('CONFIG','Validity','0')))='YES' then
       begin
       perintah[5]:='=on-login={'+sLineBreak+':if ( [ /ip hotspot user get $user comment ] != "" ) do={'+sLineBreak+' :local datex [/ip hotspot user get $user comment ]'+sLineBreak+':local pecah [:toarray [:pick $datex ([:find $datex ":"]+1) [:len $datex]]]'+sLineBreak+':local tgl [:pick $pecah 1]'+sLineBreak+':if ([:len $tgl] != 0) do={'+sLineBreak+':local komen [:pick $datex 0 [:find $datex ":"]]'+sLineBreak+':local harga [:pick $pecah 0]'+sLineBreak+':local date [ /system clock get date ]'+sLineBreak+':local days $tgl'+sLineBreak+':local mdays  {31;28;31;30;31;30;31;31;30;31;30;31}'+sLineBreak+':local months {"jan"=1;"feb"=2;"mar"=3;"apr"=4;"may"=5;"jun"=6;"jul"=7;"aug"=8;"sep"=9;"oct"=10;"nov"=11;"dec"=12}'+sLineBreak+':local monthr  {"jan";"feb";"mar";"apr";"may";"jun";"jul";"aug";"sep";"oct";"nov";"dec"}'+sLineBreak+':local dd  [:tonum [:pick $date 4 6]]'+sLineBreak+':local yy [:tonum [:pick $date 7 11]]'+sLineBreak+':local month [:pick $date 0 3]'+sLineBreak+':local mm (:$months->$month)'+sLineBreak+':set dd ($dd+$days)'+sLineBreak+':local dm [:pick $mdays ($mm-1)]'+sLineBreak+':if ($mm=2 && (($yy&3=0 && ($yy/100*100 != $yy)) || $yy/400*400=$yy) ) do={ :set dm 29 }'+sLineBreak+':while ($dd>$dm) do={'+sLineBreak+':set dd ($dd-$dm)'+sLineBreak+':set mm ($mm+1)'+sLineBreak+':if ($mm>12) do={'+sLineBreak+':set mm 1'+sLineBreak+':set yy ($yy+1)'+sLineBreak+'}'+sLineBreak+':set dm [:pick $mdays ($mm-1)]'+sLineBreak+':if ($mm=2 &&  (($yy&3=0 && ($yy/100*100 != $yy)) || $yy/400*400=$yy) ) do={ :set dm 29 }'+sLineBreak+'};'+sLineBreak+':local res "$[:pick $monthr ($mm-1)]/"'+sLineBreak+':if ($dd<10) do={ :set res ($res."0") }'+sLineBreak+':set $res "$res$dd/$yy"'+sLineBreak+'[ /ip hotspot user set $user comment="$komen : \"$harga\" $res" ]'+sLineBreak+'}'+sLineBreak+'}'+sLineBreak+'}';
       perintah[6]:='=.id='+LID.Caption;
       ulang := 6;
       end else
       begin
       perintah[5]:='=.id='+LID.Caption;
       ulang := 5;
       end;
    end;
    // End Validity Check
    ket := Gunakan(CekBahasa(),'ADDBANDWIDTHLIMITATION','Update');
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
      MessageDlg(Gunakan(CekBahasa(),'ADDBANDWIDTHLIMITATION','SaveSuccess')+' '+ket,mtInformation,[mbok],0);
      FDataLimitBW.FormShow(Sender);
      end;
      end;
     ROS.Free;
    end;

procedure TFTambahLimitBW.ESharedUserKeyPress(Sender: TObject; var Key: char);
begin
  if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFTambahLimitBW.FormCreate(Sender: TObject);
begin
  FTambahLimitBW.Label1.Caption:=Gunakan(CekBahasa(),'ADDBANDWIDTHLIMITATION','GroupName');
  FTambahLimitBW.Label2.Caption:=Gunakan(CekBahasa(),'ADDBANDWIDTHLIMITATION','SharedUser');
  FTambahLimitBW.Label3.Caption:=Gunakan(CekBahasa(),'ADDBANDWIDTHLIMITATION','BandwidthLimit');
end;

procedure TFTambahLimitBW.FormShow(Sender: TObject);
begin
  ENamaGroup.SetFocus;
end;

procedure TFTambahLimitBW.Limit1KeyPress(Sender: TObject; var Key: char);
begin
  if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFTambahLimitBW.Limit2KeyPress(Sender: TObject; var Key: char);
begin
  if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

end.

