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

unit UDataUserHotspotAktif;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, Grids, StdCtrls, RouterOSAPI, ssl_openssl, bahasa;

type

  { TFDataUserHotspotAktif }

  TFDataUserHotspotAktif = class(TForm)
    BClose: TBitBtn;
    BDelete: TBitBtn;
    BRefresh: TBitBtn;
    GridUserHotspotAktif: TStringGrid;
    LNama: TLabel;
    LID: TLabel;
    PanelAtas: TPanel;
    PanelBawah: TPanel;
    PanelTengah: TPanel;
    procedure BCloseClick(Sender: TObject);
    procedure BDeleteClick(Sender: TObject);
    procedure BRefreshClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GridUserHotspotAktifDrawCell(Sender: TObject; aCol,
      aRow: Integer; aRect: TRect; aState: TGridDrawState);
    procedure GridUserHotspotAktifPrepareCanvas(sender: TObject; aCol,
      aRow: Integer; aState: TGridDrawState);
    procedure GridUserHotspotAktifSelectCell(Sender: TObject; aCol,
      aRow: Integer; var CanSelect: Boolean);
  private
          ROS : TRosApiClient;
      ResListen: TRosApiResult;
    { private declarations }
  public
    { public declarations }
  end;

var
  FDataUserHotspotAktif: TFDataUserHotspotAktif;

implementation

uses UUtama;

{$R *.lfm}

{ TFDataUserHotspotAktif }

procedure TFDataUserHotspotAktif.BCloseClick(Sender: TObject);
begin
  FUtama.BackGround.Visible:=True;
  FDataUserHotspotAktif.Close;
end;

procedure TFDataUserHotspotAktif.BDeleteClick(Sender: TObject);
var
  pa: array of AnsiString;
  perintah : array[1..2] of String;
  s : String;
  i : integer;
begin
  if (LID.Caption='') then
     MessageDlg(Gunakan(CekBahasa(),'ACTIVEUSER','SelectTableWarning'),mtWarning,[mbok],0) else
       if MessageDlg(Gunakan(CekBahasa(),'ACTIVEUSER','DelWarning')+' "'+LNama.Caption+'"?',mtConfirmation,[mbyes,mbno],0)=mrYes then
    begin
    // Pecah Perintah Kedalam Array
    perintah[1]:='/ip/hotspot/active/remove';
    perintah[2]:='=.id='+LID.Caption;
    // Menyimpan Perintah Kedalam Variabel pa
    SetLength(pa, 0);
    for i := 1 to 2 do
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
      FormShow(Sender);
      end;
      end else Abort;
    end;

procedure TFDataUserHotspotAktif.BRefreshClick(Sender: TObject);
begin
  FDataUserHotspotAktif.FormShow(Sender);
end;

procedure TFDataUserHotspotAktif.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin

end;

procedure TFDataUserHotspotAktif.FormCreate(Sender: TObject);
begin
ROS := TRosApiClient.Create;
ResListen := nil;
FDataUserHotspotAktif.PanelAtas.Caption:=Gunakan(CekBahasa(),'ACTIVEUSER','FTitle');
FDataUserHotspotAktif.BRefresh.Caption:=Gunakan(CekBahasa(),'ACTIVEUSER','BRefresh');
FDataUserHotspotAktif.BClose.Caption:=Gunakan(CekBahasa(),'GLOBAL','BClose');
FDataUserHotspotAktif.BDelete.Caption:=Gunakan(CekBahasa(),'GLOBAL','BDelete');
end;

procedure TFDataUserHotspotAktif.FormDestroy(Sender: TObject);
begin
  ROS.Free;
end;

procedure TFDataUserHotspotAktif.FormShow(Sender: TObject);
var
  Res : TRosApiResult;
  i, j: Integer;
begin

   LID.Caption:='';
   LNama.Caption:='';

    if (FUtama.LTLS.Caption='TRUE') then
       ROS.SSLConnect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption) else
       ROS.Connect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption);

    Res := ROS.Query(['/ip/hotspot/active/print'], True);

    if ROS.LastError <> '' then
    MessageDlg('ERROR : ' + ROS.LastError,mtError,[mbok],0);

    GridUserHotspotAktif.RowCount := Res.RowsCount+1;
    // Ukuran Kolom
    GridUserHotspotAktif.ColCount := 8;
    FDataUserHotspotAktif.GridUserHotspotAktif.ColWidths[0]:=10;
    FDataUserHotspotAktif.GridUserHotspotAktif.ColWidths[1]:=FUtama.Width div 7;
    FDataUserHotspotAktif.GridUserHotspotAktif.ColWidths[2]:=FUtama.Width div 7;
    FDataUserHotspotAktif.GridUserHotspotAktif.ColWidths[3]:=FUtama.Width div 7;
    FDataUserHotspotAktif.GridUserHotspotAktif.ColWidths[4]:=FUtama.Width div 7;
    FDataUserHotspotAktif.GridUserHotspotAktif.ColWidths[5]:=FUtama.Width div 7;
    FDataUserHotspotAktif.GridUserHotspotAktif.ColWidths[6]:=FUtama.Width div 7;
    FDataUserHotspotAktif.GridUserHotspotAktif.ColWidths[7]:=FUtama.Width div 7;
    // Nama Kolom
    GridUserHotspotAktif.Cells[0,0] := '';
    GridUserHotspotAktif.Cells[1,0] := Gunakan(CekBahasa(),'ACTIVEUSER','ID');
    GridUserHotspotAktif.Cells[2,0] := Gunakan(CekBahasa(),'ACTIVEUSER','Server');
    GridUserHotspotAktif.Cells[3,0] := Gunakan(CekBahasa(),'ACTIVEUSER','UserLogin');
    GridUserHotspotAktif.Cells[4,0] := Gunakan(CekBahasa(),'ACTIVEUSER','Address');
    GridUserHotspotAktif.Cells[5,0] := Gunakan(CekBahasa(),'ACTIVEUSER','Uptime');
    GridUserHotspotAktif.Cells[6,0] := Gunakan(CekBahasa(),'ACTIVEUSER','MacAddress');
    GridUserHotspotAktif.Cells[7,0] := Gunakan(CekBahasa(),'ACTIVEUSER','LoginBy');
    j := 1;
  while not Res.Eof do
  begin
    for i := 1 to Res.RowsCount do
    GridUserHotspotAktif.Cells[0,j] := '';
    GridUserHotspotAktif.Cells[1,j] := Res.ValueByName['.id'];
    GridUserHotspotAktif.Cells[2,j] := Res.ValueByName['server'];
    GridUserHotspotAktif.Cells[3,j] := Res.ValueByName['user'];
    GridUserHotspotAktif.Cells[4,j] := Res.ValueByName['address'];
    GridUserHotspotAktif.Cells[5,j] := Res.ValueByName['uptime'];
    GridUserHotspotAktif.Cells[6,j] := Res.ValueByName['mac-address'];
    GridUserHotspotAktif.Cells[7,j] := Res.ValueByName['login-by'];
    j := j+1;
    GridUserHotspotAktif.Repaint;
    Res.Next;
  end;
  Res.Free;
end;

procedure TFDataUserHotspotAktif.GridUserHotspotAktifDrawCell(Sender: TObject;
  aCol, aRow: Integer; aRect: TRect; aState: TGridDrawState);
begin
    if ARow mod 2 = 0 then
       GridUserHotspotAktif.Canvas.Brush.Color := clSilver
       else begin
       GridUserHotspotAktif.SelectedColor:=clHighlight;
       GridUserHotspotAktif.Options := GridUserHotspotAktif.Options + [goDrawFocusSelected];
       end;
end;

procedure TFDataUserHotspotAktif.GridUserHotspotAktifPrepareCanvas(
  sender: TObject; aCol, aRow: Integer; aState: TGridDrawState);
begin
  if ARow mod 2 = 0 then
     GridUserHotspotAktif.Canvas.Brush.Color := clSilver
     else begin
     GridUserHotspotAktif.SelectedColor:=clHighlight;
     GridUserHotspotAktif.Options := GridUserHotspotAktif.Options + [goDrawFocusSelected];
     end;
  GridUserHotspotAktif.Options := GridUserHotspotAktif.Options + [goRowSelect];
end;

procedure TFDataUserHotspotAktif.GridUserHotspotAktifSelectCell(
  Sender: TObject; aCol, aRow: Integer; var CanSelect: Boolean);
begin
  LID.Caption:=GridUserHotspotAktif.Cells[1,aRow];
  LNama.Caption:=GridUserHotspotAktif.Cells[3,aRow];
end;

end.

