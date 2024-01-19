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

unit UDataLimitBW;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, Grids, StdCtrls, Menus, UTambahLimitBW, RouterOSAPI, ssl_openssl, bahasa;

type

  { TFDataLimitBW }

  TFDataLimitBW = class(TForm)
    BClose: TBitBtn;
    BHapus: TBitBtn;
    BTambah: TBitBtn;
    BEdit: TBitBtn;
    LRateLimit: TLabel;
    LID: TLabel;
    LNama: TLabel;
    LSharedUser: TLabel;
    MenuEdit: TMenuItem;
    MenuHapus: TMenuItem;
    PanelBawah: TPanel;
    PanelAtas: TPanel;
    PanelTengah: TPanel;
    GridGroupLimitBW: TStringGrid;
    PopupMenuGLBW: TPopupMenu;
    procedure BCloseClick(Sender: TObject);
    procedure BEditClick(Sender: TObject);
    procedure BHapusClick(Sender: TObject);
    procedure BTambahClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GridGroupLimitBWDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure GridGroupLimitBWPrepareCanvas(sender: TObject; aCol,
      aRow: Integer; aState: TGridDrawState);
    procedure GridGroupLimitBWSelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
    procedure MenuEditClick(Sender: TObject);
    procedure MenuHapusClick(Sender: TObject);
  private
      ROS : TRosApiClient;
      ResListen: TRosApiResult;
    { private declarations }
  public
    { public declarations }
  end;

var
  FDataLimitBW: TFDataLimitBW;

implementation

uses UUtama;

{$R *.lfm}

{ TFDataLimitBW }

procedure TFDataLimitBW.BCloseClick(Sender: TObject);
begin
  FUtama.BackGround.Visible:=True;
  FDataLimitBW.Close;
end;

procedure Split(Delimiter: Char; Str: string; ListOfStrings: TStrings) ;
begin
   ListOfStrings.Clear;
   ListOfStrings.Delimiter       := Delimiter;
   ListOfStrings.StrictDelimiter := True; // Requires D2006 or newer.
   ListOfStrings.DelimitedText   := Str;
end;

function ExtractNumberInString( sChaine: String ): String ;
var
i: Integer;
begin
Result := '';
for i := 1 to length( sChaine ) do
begin
if sChaine[ i ] in ['0'..'9'] then
Result := Result + sChaine[ i ];
end;
end;

procedure TFDataLimitBW.BEditClick(Sender: TObject);
var
  OutPutList : TStringList;
begin
  if (LID.Caption='') then
     MessageDlg(Gunakan(CekBahasa(),'BANDWIDTHLIMITATION','SelectTableWarning'),mtWarning,[mbok],0) else
    begin
    if (LRateLimit.Caption='') then
    begin
    FTambahLimitBW.Limit1.Text:='';
    FTambahLimitBW.Limit2.Text:='';
    end else
    begin
    OutPutList := TStringList.Create;
    Split('/', LRateLimit.Caption, OutPutList);
    FTambahLimitBW.Limit1.Text:=ExtractNumberInString(OutPutList[0]);
    FTambahLimitBW.Limit2.Text:=ExtractNumberInString(OutPutList[1]);
    end;
    FTambahLimitBW.Caption:=Gunakan(CekBahasa(),'ADDBANDWIDTHLIMITATION','EPTitle');
    FTambahLimitBW.PanelAtas.Caption:=Gunakan(CekBahasa(),'ADDBANDWIDTHLIMITATION','EPTitle');
    FTambahLimitBW.BBaru.Caption:=Gunakan(CekBahasa(),'GLOBAL','BClear');
    FTambahLimitBW.LID.Caption:=LID.Caption;
    FTambahLimitBW.ENamaGroup.Text:=LNama.Caption;
    FTambahLimitBW.ESharedUser.Text:=LSharedUser.Caption;
    FTambahLimitBW.BSimpan.Caption:=Gunakan(CekBahasa(),'GLOBAL','BUpdate');
    FTambahLimitBW.Aksi.Caption:='Update';
    FTambahLimitBW.ShowModal;
    end;
    end;

procedure TFDataLimitBW.BHapusClick(Sender: TObject);
var
  pa: array of AnsiString;
  perintah : array[1..2] of String;
  s : String;
  i : integer;
begin
  if (LID.Caption='') then
     MessageDlg(Gunakan(CekBahasa(),'BANDWIDTHLIMITATION','SelectTableWarning'),mtWarning,[mbok],0) else
       if MessageDlg(Gunakan(CekBahasa(),'BANDWIDTHLIMITATION','DelWarning')+' "'+LNama.Caption+'"?',mtConfirmation,[mbyes,mbno],0)=mrYes then
    begin
    // Pecah Perintah Kedalam Array
    perintah[1]:='/ip/hotspot/user/profile/remove';
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

procedure TFDataLimitBW.BTambahClick(Sender: TObject);
begin
    FTambahLimitBW.Caption:=Gunakan(CekBahasa(),'ADDBANDWIDTHLIMITATION','APTitle');
    FTambahLimitBW.PanelAtas.Caption:=Gunakan(CekBahasa(),'ADDBANDWIDTHLIMITATION','APTitle');
    FTambahLimitBW.BBaru.Caption:=Gunakan(CekBahasa(),'GLOBAL','BNew');
    FTambahLimitBW.LID.Caption:='';
    FTambahLimitBW.ENamaGroup.Text:='';
    FTambahLimitBW.ESharedUser.Text:='';
    FTambahLimitBW.Limit1.Text:='';
    FTambahLimitBW.Limit2.Text:='';
    FTambahLimitBW.BSimpan.Caption:=Gunakan(CekBahasa(),'GLOBAL','BSave');
    FTambahLimitBW.Aksi.Caption:='Save';
    FTambahLimitBW.ShowModal;
end;

procedure TFDataLimitBW.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin

end;

procedure TFDataLimitBW.FormCreate(Sender: TObject);
begin
ROS := TRosApiClient.Create;
ResListen := nil;

FDataLimitBW.PanelAtas.Caption:=Gunakan(CekBahasa(),'BANDWIDTHLIMITATION','PTitle');
FDataLimitBW.BTambah.Caption:=Gunakan(CekBahasa(),'GLOBAL','BAdd');
FDataLimitBW.BEdit.Caption:=Gunakan(CekBahasa(),'GLOBAL','BEdit');
FDataLimitBW.BHapus.Caption:=Gunakan(CekBahasa(),'GLOBAL','BDelete');
FDataLimitBW.BClose.Caption:=Gunakan(CekBahasa(),'GLOBAL','BClose');
FDataLimitBW.MenuEdit.Caption:=Gunakan(CekBahasa(),'GLOBAL','BEdit');
FDataLimitBW.MenuHapus.Caption:=Gunakan(CekBahasa(),'GLOBAL','BDelete');
end;

procedure TFDataLimitBW.FormDestroy(Sender: TObject);
begin
  ROS.Free;
end;

procedure TFDataLimitBW.FormShow(Sender: TObject);
var
  Res : TRosApiResult;
  i, j: Integer;
begin
    LID.Caption:='';
    LNama.Caption:='';
    LSharedUser.Caption:='';
    LRateLimit.Caption:='';

  if (FUtama.LTLS.Caption='TRUE') then
     ROS.SSLConnect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption) else
     ROS.Connect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption);

    Res := ROS.Query(['/ip/hotspot/user/profile/print'], True);

    if ROS.LastError <> '' then
    MessageDlg('ERROR : ' + ROS.LastError,mtError,[mbok],0);

    GridGroupLimitBW.RowCount := Res.RowsCount+1;
    // Ukuran Kolom
    GridGroupLimitBW.ColCount := 5;
    FDataLimitBW.GridGroupLimitBW.ColWidths[0]:=10;
    FDataLimitBW.GridGroupLimitBW.ColWidths[1]:=FUtama.Width div 4;
    FDataLimitBW.GridGroupLimitBW.ColWidths[2]:=FUtama.Width div 4;
    FDataLimitBW.GridGroupLimitBW.ColWidths[3]:=FUtama.Width div 4;
    FDataLimitBW.GridGroupLimitBW.ColWidths[4]:=FUtama.Width div 4;
    // Nama Kolom
    GridGroupLimitBW.Cells[0,0] := '';
    GridGroupLimitBW.Cells[1,0] := Gunakan(CekBahasa(),'BANDWIDTHLIMITATION','ID');
    GridGroupLimitBW.Cells[2,0] := Gunakan(CekBahasa(),'BANDWIDTHLIMITATION','GroupName');
    GridGroupLimitBW.Cells[3,0] := Gunakan(CekBahasa(),'BANDWIDTHLIMITATION','SharedUser');
    GridGroupLimitBW.Cells[4,0] := Gunakan(CekBahasa(),'BANDWIDTHLIMITATION','BandwidthLimitation');
    j := 1;
  while not Res.Eof do
  begin
    for i := 1 to Res.RowsCount do
    GridGroupLimitBW.Cells[0,j] := '';
    GridGroupLimitBW.Cells[1,j] := Res.ValueByName['.id'];
    GridGroupLimitBW.Cells[2,j] := Res.ValueByName['name'];
    GridGroupLimitBW.Cells[3,j] := Res.ValueByName['shared-users'];
    GridGroupLimitBW.Cells[4,j] := Res.ValueByName['rate-limit'];
    j := j+1;
    GridGroupLimitBW.Repaint;
    Res.Next;
  end;
  Res.Free;
end;

procedure TFDataLimitBW.GridGroupLimitBWDrawCell(Sender: TObject; aCol,
  aRow: Integer; aRect: TRect; aState: TGridDrawState);
begin
    if ARow mod 2 = 0 then
       GridGroupLimitBW.Canvas.Brush.Color := clSilver
       else begin
       GridGroupLimitBW.SelectedColor:=clHighlight;
       GridGroupLimitBW.Options := GridGroupLimitBW.Options + [goDrawFocusSelected];
       end;
end;

procedure TFDataLimitBW.GridGroupLimitBWPrepareCanvas(sender: TObject; aCol,
  aRow: Integer; aState: TGridDrawState);
begin
  if ARow mod 2 = 0 then
     GridGroupLimitBW.Canvas.Brush.Color := clSilver
     else begin
     GridGroupLimitBW.SelectedColor:=clHighlight;
     GridGroupLimitBW.Options := GridGroupLimitBW.Options + [goDrawFocusSelected];
     end;
  GridGroupLimitBW.Options := GridGroupLimitBW.Options + [goRowSelect];
end;

procedure TFDataLimitBW.GridGroupLimitBWSelectCell(Sender: TObject; aCol,
  aRow: Integer; var CanSelect: Boolean);
begin
  LID.Caption:=GridGroupLimitBW.Cells[1,aRow];
  LNama.Caption:=GridGroupLimitBW.Cells[2,aRow];
  LSharedUser.Caption:=GridGroupLimitBW.Cells[3,aRow];
  LRateLimit.Caption:=GridGroupLimitBW.Cells[4,aRow];
end;

procedure TFDataLimitBW.MenuEditClick(Sender: TObject);
begin
  BEditClick(Sender);
end;

procedure TFDataLimitBW.MenuHapusClick(Sender: TObject);
begin
  BHapusClick(Sender);
end;

end.

