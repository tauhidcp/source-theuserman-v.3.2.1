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

unit UGenerateUserHotspot;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, ComCtrls, EditBtn, RouterOSAPI, ssl_openssl, encode_decode,bahasa, inifiles;

type

  { TFGenerateUserHotspot }

  TFGenerateUserHotspot = class(TForm)
    BBaru: TBitBtn;
    BGenerate: TBitBtn;
    CBServer: TComboBox;
    CkNum: TCheckBox;
    CkUp: TCheckBox;
    CkLow: TCheckBox;
    CSamaUser: TCheckBox;
    CkPrefix: TCheckBox;
    CPanjangUser: TComboBox;
    CPanjangPass: TComboBox;
    CGLBW: TComboBox;
    CLimitWaktu: TComboBox;
    EValid: TEdit;
    EPrefix: TEdit;
    EPrice: TEdit;
    EJmlWaktu: TEdit;
    EJumlahUser: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    LCharComb: TLabel;
    LServer: TLabel;
    Lday: TLabel;
    MKeterangan: TMemo;
    PanelTengah: TPanel;
    PanelAtas: TPanel;
    PanelBawah: TPanel;
    ProgressBar: TProgressBar;
    procedure BBaruClick(Sender: TObject);
    procedure BGenerateClick(Sender: TObject);
    procedure CBServerKeyPress(Sender: TObject; var Key: char);
    procedure CGLBWKeyPress(Sender: TObject; var Key: char);
    procedure CharComKeyPress(Sender: TObject; var Key: char);
    procedure CkPrefixChange(Sender: TObject);
    procedure CLimitWaktuKeyPress(Sender: TObject; var Key: char);
    procedure CPanjangPassKeyPress(Sender: TObject; var Key: char);
    procedure CPanjangUserKeyPress(Sender: TObject; var Key: char);
    procedure CSamaUserChange(Sender: TObject);
    procedure DateValidKeyPress(Sender: TObject; var Key: char);
    procedure EValidKeyPress(Sender: TObject; var Key: char);
    procedure EJmlWaktuKeyPress(Sender: TObject; var Key: char);
    procedure EJumlahUserKeyPress(Sender: TObject; var Key: char);
    procedure EPrefixKeyPress(Sender: TObject; var Key: char);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PanelBawahClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FGenerateUserHotspot: TFGenerateUserHotspot;
  myinifile   : TIniFile;

implementation
uses UUtama, UDataUserHotspot;
{$R *.lfm}

{ TFGenerateUserHotspot }

procedure TFGenerateUserHotspot.FormShow(Sender: TObject);
var
  Res,Ras : TRosApiResult;
  i : Integer;
  ROS       : TRosApiClient;
  begin
    EPrefix.Hide;
    CPanjangUser.Left:=216;
    CPanjangUser.Width:=152;
    ROS := TRosApiClient.Create;
    CBServer.SetFocus;
    ProgressBar.Visible:=False;
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
    CkLow.Checked:=False;
    CkUp.Checked:=False;
    CkNum.Checked:=False;
    // Cek Apakah ada Validity atau tidak
    myinifile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config.ini');
    with myinifile do
    begin
    if GSMDecode7Bit(GSMDecode7Bit(ReadString('CONFIG','Validity','0')))='YES' then
       begin
       FGenerateUserHotspot.Height:=500;
       Label8.Show;
       Lday.Show;
       EValid.Show;
       end else
       begin
       FGenerateUserHotspot.Height:=465;
       Label8.hide;
       EValid.hide;
       Lday.Hide;
       end;
    end;
  end;

procedure TFGenerateUserHotspot.PanelBawahClick(Sender: TObject);
begin

end;

procedure TFGenerateUserHotspot.CSamaUserChange(Sender: TObject);
begin
  if (CSamaUser.Checked=True) then
  begin
  CPanjangPass.Text:=Gunakan(CekBahasa(),'GENERATEUSER','SameAs');
  CPanjangPass.Enabled:=False;
  end else
  if (CSamaUser.Checked=False) then
  begin
  CPanjangPass.Text:=Gunakan(CekBahasa(),'GLOBAL','Select');
  CPanjangPass.Enabled:=True;
  end;
end;

procedure TFGenerateUserHotspot.DateValidKeyPress(Sender: TObject; var Key: char
  );
begin
 key:=#0;
end;

procedure TFGenerateUserHotspot.EValidKeyPress(Sender: TObject; var Key: char);
begin
 if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFGenerateUserHotspot.EJmlWaktuKeyPress(Sender: TObject; var Key: char
  );
begin
    if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFGenerateUserHotspot.EJumlahUserKeyPress(Sender: TObject;
  var Key: char);
begin
if not (key in['0'..'9',#8,#13,#32]) then
 begin
 key:=#0;
 end;
end;

procedure TFGenerateUserHotspot.EPrefixKeyPress(Sender: TObject; var Key: char);
begin
 if Length(EPrefix.Text) > 1 then
 begin
 if not (key in[#8]) then
  key:=#0;
 end;
end;

procedure TFGenerateUserHotspot.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CPanjangUser.Text:=Gunakan(CekBahasa(),'GLOBAL','Select');
  CPanjangPass.Text:=Gunakan(CekBahasa(),'GLOBAL','Select');
  CGLBW.Text:=Gunakan(CekBahasa(),'GLOBAL','SelectGroup');
  CLimitWaktu.Text:=Gunakan(CekBahasa(),'GLOBAL','Select');
  CSamaUser.Checked:=False;
  CkPrefix.Checked:=False;
  EPrefix.Text:='';
  EPrice.Text:='';
  EValid.Text:='';
  EPrefix.Hide;
  MKeterangan.Lines.Clear;
  EJmlWaktu.Text:='';
  EJumlahUser.Text:='';
end;

procedure TFGenerateUserHotspot.FormCreate(Sender: TObject);
begin
  FGenerateUserHotspot.Caption:=Gunakan(CekBahasa(),'GENERATEUSER','FTitle');
  FGenerateUserHotspot.PanelAtas.Caption:=Gunakan(CekBahasa(),'GENERATEUSER','FTitle');
  FGenerateUserHotspot.Label1.Caption:=Gunakan(CekBahasa(),'GENERATEUSER','UserLen');
  FGenerateUserHotspot.Label2.Caption:=Gunakan(CekBahasa(),'GENERATEUSER','PassLen');
  FGenerateUserHotspot.Label3.Caption:=Gunakan(CekBahasa(),'GENERATEUSER','BWLimitGroup');
  FGenerateUserHotspot.Label4.Caption:=Gunakan(CekBahasa(),'GENERATEUSER','TimeLimit');
  FGenerateUserHotspot.Label5.Caption:=Gunakan(CekBahasa(),'GENERATEUSER','Comment');
  FGenerateUserHotspot.Label6.Caption:=Gunakan(CekBahasa(),'GENERATEUSER','NumberOfUser');
  FGenerateUserHotspot.CSamaUser.Caption:='= '+Gunakan(CekBahasa(),'GENERATEUSER','LoginName');

  FGenerateUserHotspot.Lday.Caption:=Gunakan(CekBahasa(),'GENERATEUSER','Day');
  FGenerateUserHotspot.LServer.Caption:=Gunakan(CekBahasa(),'GENERATEUSER','HotspotServer');
  FGenerateUserHotspot.Label7.Caption:=Gunakan(CekBahasa(),'GENERATEUSER','Price');
  FGenerateUserHotspot.Label8.Caption:=Gunakan(CekBahasa(),'GENERATEUSER','Validity');
  FGenerateUserHotspot.CkPrefix.Caption:=Gunakan(CekBahasa(),'GENERATEUSER','Pref');

  FGenerateUserHotspot.BBaru.Caption:=Gunakan(CekBahasa(),'GLOBAL','BNew');
  FGenerateUserHotspot.BGenerate.Caption:=Gunakan(CekBahasa(),'GENERATEUSER','BGenerate');
  FGenerateUserHotspot.CLimitWaktu.Items.Clear;
  FGenerateUserHotspot.CLimitWaktu.Items.Add(Gunakan(CekBahasa(),'GENERATEUSER','Minutes'));
  FGenerateUserHotspot.CLimitWaktu.Items.Add(Gunakan(CekBahasa(),'GENERATEUSER','Hours'));
  FGenerateUserHotspot.CLimitWaktu.Items.Add(Gunakan(CekBahasa(),'GENERATEUSER','Days'));

  FGenerateUserHotspot.CPanjangUser.Items.Clear;
  FGenerateUserHotspot.CPanjangUser.Items.Add('3 '+Gunakan(CekBahasa(),'GENERATEUSER','Char'));
  FGenerateUserHotspot.CPanjangUser.Items.Add('4 '+Gunakan(CekBahasa(),'GENERATEUSER','Char'));
  FGenerateUserHotspot.CPanjangUser.Items.Add('5 '+Gunakan(CekBahasa(),'GENERATEUSER','Char'));
  FGenerateUserHotspot.CPanjangUser.Items.Add('6 '+Gunakan(CekBahasa(),'GENERATEUSER','Char'));

  FGenerateUserHotspot.CPanjangPass.Items.Clear;
  FGenerateUserHotspot.CPanjangPass.Items.Add('0 '+Gunakan(CekBahasa(),'GENERATEUSER','Char'));
  FGenerateUserHotspot.CPanjangPass.Items.Add('3 '+Gunakan(CekBahasa(),'GENERATEUSER','Char'));
  FGenerateUserHotspot.CPanjangPass.Items.Add('4 '+Gunakan(CekBahasa(),'GENERATEUSER','Char'));
  FGenerateUserHotspot.CPanjangPass.Items.Add('5 '+Gunakan(CekBahasa(),'GENERATEUSER','Char'));
  FGenerateUserHotspot.CPanjangPass.Items.Add('6 '+Gunakan(CekBahasa(),'GENERATEUSER','Char'));

  FGenerateUserHotspot.CBServer.Text:=Gunakan(CekBahasa(),'GLOBAL','Select');
  FGenerateUserHotspot.CPanjangUser.Text:=Gunakan(CekBahasa(),'GLOBAL','Select');
  FGenerateUserHotspot.CPanjangPass.Text:=Gunakan(CekBahasa(),'GLOBAL','Select');
  FGenerateUserHotspot.CGLBW.Text:=Gunakan(CekBahasa(),'GLOBAL','SelectGroup');
  FGenerateUserHotspot.CLimitWaktu.Text:=Gunakan(CekBahasa(),'GLOBAL','Select');

  FGenerateUserHotspot.LCharComb.Caption:=Gunakan(CekBahasa(),'GENERATEUSER','CharComb');
  FGenerateUserHotspot.CkNum.Caption:=Gunakan(CekBahasa(),'GENERATEUSER','Number');
  FGenerateUserHotspot.CkUp.Caption:=Gunakan(CekBahasa(),'GENERATEUSER','Upper');
  FGenerateUserHotspot.CkLow.Caption:=Gunakan(CekBahasa(),'GENERATEUSER','Lower');

end;

function RandomPassword(PLen: Integer; Stat : string): string;
var
  str: string;
begin
  Randomize;
  case Stat of
       'random'     : str := 'abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
       'num'        : str := '9876543210';
       'upper'      : str := 'NOPQRSTUVWXYZABCDEFGHIJKLM';
       'lower'      : str := 'nopqrstuvwxyzabcdefghijklm';
       'numupper'   : str := '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
       'numlower'   : str := '0123456789abcdefghijklmnopqrstuvwxyz';
       'upperlower' : str := 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
  end;
  Result := '';
  repeat
    Result := Result + str[Random(Length(str)) + 1];
  until (Length(Result) = PLen)
end;

function RandomUser(PLen: Integer; Stat : string): string;
var
  str: string;
begin
  Randomize;
  case Stat of
         'random'     : str := 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
         'num'        : str := '0123456789';
         'upper'      : str := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
         'lower'      : str := 'abcdefghijklmnopqrstuvwxyz';
         'numupper'   : str := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
         'numlower'   : str := 'abcdefghijklmnopqrstuvwxyz0123456789';
         'upperlower' : str := 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    end;
  Result := '';
  repeat
    Result := Result + str[Random(Length(str)) + 1];
  until (Length(Result) = PLen)
end;

procedure Split(Delimiter: Char; Str: string; ListOfStrings: TStrings) ;
begin
   ListOfStrings.Clear;
   ListOfStrings.Delimiter       := Delimiter;
   ListOfStrings.StrictDelimiter := True; // Requires D2006 or newer.
   ListOfStrings.DelimitedText   := Str;
end;

procedure TFGenerateUserHotspot.BGenerateClick(Sender: TObject);
var
  pa: array of AnsiString;
  perintah : array[1..8] of String;
  i,jam, j : integer;
  s,waktu,ket,tgl,user,pass      : String;
  OutPutList, ListOutput: TStringList;
  ROS       : TRosApiClient;
  begin
    ROS := TRosApiClient.Create;
    // Koneksi
    if (FUtama.LTLS.Caption='TRUE') then
         ROS.SSLConnect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption) else
         ROS.Connect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption);

    if (((CkNum.Checked=False) and (CkUp.Checked=False) and (CkLow.Checked=False)) or (EJumlahUser.Text='') or (EJmlWaktu.Text='') or (MKeterangan.Text='') or (EPrice.Text='') or ((CGLBW.Text='') or (CGLBW.Text=Gunakan(CekBahasa(),'GLOBAL','SelectGroup'))) or ((CLimitWaktu.Text='') or (CLimitWaktu.Text=Gunakan(CekBahasa(),'GLOBAL','Select'))) or ((CBServer.Text='') or (CBServer.Text=Gunakan(CekBahasa(),'GLOBAL','Select'))) or ((CPanjangUser.Text='') or (CPanjangUser.Text=Gunakan(CekBahasa(),'GLOBAL','Select')) or (CPanjangPass.Text=Gunakan(CekBahasa(),'GLOBAL','Select')))) then
           MessageDlg(Gunakan(CekBahasa(),'GENERATEUSER','WarningBlank'),mtWarning,[mbok],0)
    else begin
    if (StrToInt(EJumlahUser.Text) > 100) then
        MessageDlg(Gunakan(CekBahasa(),'GENERATEUSER','WarningMax'),mtWarning,[mbok],0)
    else begin
     // Cek Validity
    myinifile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config.ini');
    with myinifile do
    begin
    if GSMDecode7Bit(GSMDecode7Bit(ReadString('CONFIG','Validity','0')))='YES' then
       begin

       if not (EValid.Text='') then begin
       tgl := EValid.Text;
       end else
       begin
       MessageDlg(Gunakan(CekBahasa(),'GENERATEUSER','WarningBlank'),mtWarning,[mbok],0);
       Exit;
       end;

       if (StrToInt(EValid.Text)<366) then begin
       tgl := EValid.Text;
       end else
       begin
       MessageDlg(Gunakan(CekBahasa(),'GENERATEUSER','ValidityMax'),mtWarning,[mbok],0);
       Exit;
       end;

       end else
       begin
       tgl := '';
       end;
    end;
    // Cek Waktu
    if (CLimitWaktu.ItemIndex=0) then
        waktu := '00:'+EJmlWaktu.Text+':00';
    if (CLimitWaktu.ItemIndex=1) then
        waktu := EJmlWaktu.Text+':00:00';
    if (CLimitWaktu.ItemIndex=2) then
       begin
        jam := StrToInt(EJmlWaktu.Text)*24;
        waktu := IntToStr(jam)+':00:00';
       end;
    // Pecah String
    OutPutList := TStringList.Create;
    Split(' ', CPanjangUser.Text, OutPutList);

    ListOutput := TStringList.Create;
    Split(' ', CPanjangPass.Text, ListOutput);

    ProgressBar.Max:= StrToInt(EJumlahUser.Text);
    ProgressBar.Visible:=True;

    ket := MKeterangan.Text+' : "'+EPrice.Text+'" '+tgl;

    for j := 1 to StrToInt(EJumlahUser.Text) do begin
    ProgressBar.Position:=j;

    // Cek Prefix,Uppercase,Lowercase dan Password Sama
    if (CkPrefix.Checked=True) then
    begin
    if (CSamaUser.Checked=True) then begin

    if ((CkNum.Checked=True) and (CkUp.Checked=True) and (CkLow.Checked=True)) then
       begin
       user := EPrefix.Text+RandomUser(StrToInt(OutPutList[0]),'random');
       pass := user;
       end;
    if ((CkNum.Checked=True) and (CkUp.Checked=True) and (CkLow.Checked=False)) then
       begin
       user := EPrefix.Text+RandomUser(StrToInt(OutPutList[0]),'numupper');
       pass := user;
       end;
    if ((CkNum.Checked=True) and (CkUp.Checked=False) and (CkLow.Checked=False)) then
       begin
       user := EPrefix.Text+RandomUser(StrToInt(OutPutList[0]),'num');
       pass := user;
       end;
    if ((CkNum.Checked=False) and (CkUp.Checked=True) and (CkLow.Checked=False)) then
       begin
       user := EPrefix.Text+RandomUser(StrToInt(OutPutList[0]),'upper');
       pass := user;
       end;
    if ((CkNum.Checked=False) and (CkUp.Checked=False) and (CkLow.Checked=True)) then
       begin
       user := EPrefix.Text+RandomUser(StrToInt(OutPutList[0]),'lower');
       pass := user;
       end;
    if ((CkNum.Checked=True) and (CkUp.Checked=False) and (CkLow.Checked=True)) then
       begin
       user := EPrefix.Text+RandomUser(StrToInt(OutPutList[0]),'numlower');
       pass := user;
       end;
    if ((CkNum.Checked=False) and (CkUp.Checked=True) and (CkLow.Checked=True)) then
       begin
       user := EPrefix.Text+RandomUser(StrToInt(OutPutList[0]),'upperlower');
       pass := user;
       end;

    end else
    begin

    if ((CkNum.Checked=True) and (CkUp.Checked=True) and (CkLow.Checked=True)) then
       begin
       user := EPrefix.Text+RandomUser(StrToInt(OutPutList[0]),'random');
       if (StrToInt(ListOutput[0])=0) then pass := '' else
       pass := RandomPassword(StrToInt(ListOutput[0]),'random');
       end;
    if ((CkNum.Checked=True) and (CkUp.Checked=True) and (CkLow.Checked=False)) then
       begin
       user := EPrefix.Text+RandomUser(StrToInt(OutPutList[0]),'numupper');
       if (StrToInt(ListOutput[0])=0) then pass := '' else
       pass := RandomPassword(StrToInt(ListOutput[0]),'numupper');
       end;
    if ((CkNum.Checked=True) and (CkUp.Checked=False) and (CkLow.Checked=False)) then
       begin
       user := EPrefix.Text+RandomUser(StrToInt(OutPutList[0]),'num');
       if (StrToInt(ListOutput[0])=0) then pass := '' else
       pass := RandomPassword(StrToInt(ListOutput[0]),'num');
       end;
    if ((CkNum.Checked=False) and (CkUp.Checked=True) and (CkLow.Checked=False)) then
       begin
       user := EPrefix.Text+RandomUser(StrToInt(OutPutList[0]),'upper');
       if (StrToInt(ListOutput[0])=0) then pass := '' else
       pass := RandomPassword(StrToInt(ListOutput[0]),'upper');
       end;
    if ((CkNum.Checked=False) and (CkUp.Checked=False) and (CkLow.Checked=True)) then
       begin
       user := EPrefix.Text+RandomUser(StrToInt(OutPutList[0]),'lower');
       if (StrToInt(ListOutput[0])=0) then pass := '' else
       pass := RandomPassword(StrToInt(ListOutput[0]),'lower');
       end;
    if ((CkNum.Checked=True) and (CkUp.Checked=False) and (CkLow.Checked=True)) then
       begin
       user := EPrefix.Text+RandomUser(StrToInt(OutPutList[0]),'numlower');
       if (StrToInt(ListOutput[0])=0) then pass := '' else
       pass := RandomPassword(StrToInt(ListOutput[0]),'numlower');
       end;
    if ((CkNum.Checked=False) and (CkUp.Checked=True) and (CkLow.Checked=True)) then
       begin
       user := EPrefix.Text+RandomUser(StrToInt(OutPutList[0]),'upperlower');
       if (StrToInt(ListOutput[0])=0) then pass := '' else
       pass := RandomPassword(StrToInt(ListOutput[0]),'upperlower');
       end;

    end;
    end else begin
    if (CSamaUser.Checked=True) then begin

    if ((CkNum.Checked=True) and (CkUp.Checked=True) and (CkLow.Checked=True)) then
       begin
       user := RandomUser(StrToInt(OutPutList[0]),'random');
       pass := user;
       end;
    if ((CkNum.Checked=True) and (CkUp.Checked=True) and (CkLow.Checked=False)) then
       begin
       user := RandomUser(StrToInt(OutPutList[0]),'numupper');
       pass := user;
       end;
    if ((CkNum.Checked=True) and (CkUp.Checked=False) and (CkLow.Checked=False)) then
       begin
       user := RandomUser(StrToInt(OutPutList[0]),'num');
       pass := user;
       end;
    if ((CkNum.Checked=False) and (CkUp.Checked=True) and (CkLow.Checked=False)) then
       begin
       user := RandomUser(StrToInt(OutPutList[0]),'upper');
       pass := user;
       end;
    if ((CkNum.Checked=False) and (CkUp.Checked=False) and (CkLow.Checked=True)) then
       begin
       user := RandomUser(StrToInt(OutPutList[0]),'lower');
       pass := user;
       end;
    if ((CkNum.Checked=True) and (CkUp.Checked=False) and (CkLow.Checked=True)) then
       begin
       user := RandomUser(StrToInt(OutPutList[0]),'numlower');
       pass := user;
       end;
    if ((CkNum.Checked=False) and (CkUp.Checked=True) and (CkLow.Checked=True)) then
       begin
       user := RandomUser(StrToInt(OutPutList[0]),'upperlower');
       pass := user;
       end;

    end else
    begin

    if ((CkNum.Checked=True) and (CkUp.Checked=True) and (CkLow.Checked=True)) then
       begin
       user := RandomUser(StrToInt(OutPutList[0]),'random');
       if (StrToInt(ListOutput[0])=0) then pass := '' else
       pass := RandomPassword(StrToInt(ListOutput[0]),'random');
       end;
    if ((CkNum.Checked=True) and (CkUp.Checked=True) and (CkLow.Checked=False)) then
       begin
       user := RandomUser(StrToInt(OutPutList[0]),'numupper');
       if (StrToInt(ListOutput[0])=0) then pass := '' else
       pass := RandomPassword(StrToInt(ListOutput[0]),'numupper');
       end;
    if ((CkNum.Checked=True) and (CkUp.Checked=False) and (CkLow.Checked=False)) then
       begin
       user := RandomUser(StrToInt(OutPutList[0]),'num');
       if (StrToInt(ListOutput[0])=0) then pass := '' else
       pass := RandomPassword(StrToInt(ListOutput[0]),'num');
       end;
    if ((CkNum.Checked=False) and (CkUp.Checked=True) and (CkLow.Checked=False)) then
       begin
       user := RandomUser(StrToInt(OutPutList[0]),'upper');
       if (StrToInt(ListOutput[0])=0) then pass := '' else
       pass := RandomPassword(StrToInt(ListOutput[0]),'upper');
       end;
    if ((CkNum.Checked=False) and (CkUp.Checked=False) and (CkLow.Checked=True)) then
       begin
       user := RandomUser(StrToInt(OutPutList[0]),'lower');
       if (StrToInt(ListOutput[0])=0) then pass := '' else
       pass := RandomPassword(StrToInt(ListOutput[0]),'lower');
       end;
    if ((CkNum.Checked=True) and (CkUp.Checked=False) and (CkLow.Checked=True)) then
       begin
       user := RandomUser(StrToInt(OutPutList[0]),'numlower');
       if (StrToInt(ListOutput[0])=0) then pass := '' else
       pass := RandomPassword(StrToInt(ListOutput[0]),'numlower');
       end;
    if ((CkNum.Checked=False) and (CkUp.Checked=True) and (CkLow.Checked=True)) then
       begin
       user := RandomUser(StrToInt(OutPutList[0]),'upperlower');
       if (StrToInt(ListOutput[0])=0) then pass := '' else
       pass := RandomPassword(StrToInt(ListOutput[0]),'upperlower');
       end;

    end;
    end;

    // Pecah Perintah Kedalam Array
    perintah[1]:='/ip/hotspot/user/add';
    perintah[2]:='=name='+user;
    perintah[3]:='=profile='+CGLBW.Text;
    perintah[4]:='=password='+pass;
    perintah[5]:='=comment='+ket;
    perintah[6]:='=limit-uptime='+waktu;
    perintah[7]:='=server='+CBServer.Text;
    perintah[8]:='=disabled=no';
    // Menyimpan Perintah Kedalam Variabel pa
    SetLength(pa, 0);
    for i := 1 to 8 do
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
    Sleep(10);
    end;
    // Cek Apakah ada Error
    if ROS.LastError <> '' then
    MessageDlg('ERROR : ' + ROS.LastError,mtError,[mbok],0)
    else
      begin
      MessageDlg(Gunakan(CekBahasa(),'GENERATEUSER','SaveSuccess_1')+' '+EJumlahUser.Text+' '+Gunakan(CekBahasa(),'GENERATEUSER','SaveSuccess_2'),mtInformation,[mbok],0);
      FDataUserHotspot.FormShow(Sender);
      ProgressBar.Visible:=False;
      end;
      end;
      end;
      ROS.Free;
    end;

procedure TFGenerateUserHotspot.CBServerKeyPress(Sender: TObject; var Key: char
  );
begin
  key:=#0;
end;

procedure TFGenerateUserHotspot.CGLBWKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFGenerateUserHotspot.CharComKeyPress(Sender: TObject; var Key: char);
begin

end;

procedure TFGenerateUserHotspot.CkPrefixChange(Sender: TObject);
begin
  if CkPrefix.Checked=True then
  begin
  CPanjangUser.Left:=256;
  CPanjangUser.Width:=112;
  EPrefix.Text:='';
  EPrefix.Show;
  end else
  if CkPrefix.Checked=False then
  begin
  EPrefix.Text:='';
  CPanjangUser.Left:=216;
  CPanjangUser.Width:=152;
  EPrefix.Hide;
  end;
end;

procedure TFGenerateUserHotspot.CLimitWaktuKeyPress(Sender: TObject;
  var Key: char);
begin
  key:=#0;
end;

procedure TFGenerateUserHotspot.CPanjangPassKeyPress(Sender: TObject;
  var Key: char);
begin
  key:=#0;
end;

procedure TFGenerateUserHotspot.CPanjangUserKeyPress(Sender: TObject;
  var Key: char);
begin
  key:=#0;
end;

procedure TFGenerateUserHotspot.BBaruClick(Sender: TObject);
begin
  CPanjangUser.Text:=Gunakan(CekBahasa(),'GLOBAL','Select');
  CPanjangPass.Text:=Gunakan(CekBahasa(),'GLOBAL','Select');
  CGLBW.Text:=Gunakan(CekBahasa(),'GLOBAL','SelectGroup');
  CLimitWaktu.Text:=Gunakan(CekBahasa(),'GLOBAL','Select');
  CBServer.Text:=Gunakan(CekBahasa(),'GLOBAL','Select');
  CSamaUser.Checked:=False;
  CkPrefix.Checked:=False;
  EPrefix.Text:='';
  EPrice.Text:='';
  EValid.Text:='';
  EPrefix.Hide;
  MKeterangan.Lines.Clear;
  EJmlWaktu.Text:='';
  EJumlahUser.Text:='';
  CkNum.Checked:=False;
  CkLow.Checked:=False;
  CkUp.Checked:=False;
end;

end.

