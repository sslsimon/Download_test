unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdFTP, ComCtrls, IdExplicitTLSClientServerBase;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Memo1: TMemo;
    OpenDialog1: TOpenDialog;
    IdFTP1: TIdFTP;
    ProgressBar1: TProgressBar;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    function MsgBox(Msg: string; iValue: integer): integer;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
uses IdFTPList, IdFTPCommon;
{$R *.dfm}

function TForm1.MsgBox(Msg: string; iValue: integer): integer;
begin
  Result := MessageBox(application.Handle, pChar(Msg), '系统信息', iValue + MB_APPLMODAL);
end;

//设置文件修改时间
Function SetFileDateTime(FileName : String; NewDateTime : TDateTime): Boolean;
var FileHandle: Integer;
    FileTime: TFileTime;
    LFT: TFileTime;
    LST: TSystemTime;
begin
  Result := False;
try
  DecodeDate(NewDateTime, LST.wYear, LST.wMonth, LST.wDay);
  DecodeTime(NewDateTime, LST.wHour, LST.wMinute, LST.wSecond, LST.wMilliSeconds);
  IF SystemTimeToFileTime(LST, LFT) Then
  begin
    IF LocalFileTimeToFileTime(LFT, FileTime) Then
    begin
      FileHandle := FileOpen(FileName, fmOpenReadWrite or fmShareExclusive);
      IF SetFileTime(FileHandle, NIL, NIL, @FileTime) Then Result := True;
    end;
  end;
finally
  FileClose(FileHandle);
end;  
end; 

procedure TForm1.Button1Click(Sender: TObject);
var
  tr: Tstrings;
begin //连接
  tr := TStringlist.Create;
  try
    try
      idftp1.Passive := True;
      idftp1.Host := '192.180.0.98'; //FTP服务器地址
      idftp1.Username := 'guest'; //FTP服务器用户名
      idftp1.Password := ''; //FTP服务器密码
      idftp1.Connect(); //连接到ftp
     //idftp1.ChangeDir('client'); //进入到client子目录
     //idftp1.ChangeDir('..'); //回到上一级目录
      Edit1.Text := idftp1.RetrieveCurrentDir; //得到初始目录
      idftp1.List(tr, '', false); //得到client目录下所有文件列表
      Memo1.Lines.Assign(tr);
    except
      on E: Exception do
      begin
        MessageBox(Self.Handle, Pchar('系统提示您：' + e.Message), Pchar(self.Caption), MB_OK + MB_ICONERROR);
         // memo2.Lines.Add('Exception');
      end;
    end;
  finally
    tr.Free;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  Dir_List: TStringList;
  i: integer;
  new_file_datetime:TDateTime;
begin //下载
  // IdFTP1.TransferType := ftASCII; //ftBinary; //指定为二进制文件   或文本文件ftASCII
  IDFTP1.TransferType := ftBinary; //更改传输类型
  ProgressBar1.Min := 0;
  ProgressBar1.Max := memo1.Lines.Count;
  for i := 0 to  memo1.Lines.Count - 1 do
  begin
     new_file_datetime:= idFTP1.FileDate(memo1.Lines[i]);
     IdFTP1.Get(memo1.Lines[i], 'd:\FTPtest\' + memo1.Lines[i], true);
     SetFileDateTime('d:\FTPtest\' + memo1.Lines[i],new_file_datetime);
    // ShowMessage(IdFTP1.DirectoryListing.Items[i].FileName);
    { 原处理过程，带提示可选
      if FileExists('d:\FTPtest\' + IdFTP1.DirectoryListing.Items[i].FileName) then
        case MsgBox(IdFTP1.DirectoryListing.Items[i].FileName + '文件已经存在，要续传吗？'#13#10'是——续传'#10#13'否——覆盖'#13#10'取消——取消操作', MB_YESNOCANCEL + MB_ICONINFORMATION) of
          IDYES: begin
             //参数说明: 源文件，目标文件,是否覆盖,是否触发异常（True为不触发)。
              IdFTP1.Get(IdFTP1.DirectoryListing.Items[i].FileName, 'd:\FTPtest\' + IdFTP1.DirectoryListing.Items[i].FileName, False, True);
            end;
          IDNO: begin
              IdFTP1.Get(IdFTP1.DirectoryListing.Items[i].FileName, 'd:\FTPtest\' + IdFTP1.DirectoryListing.Items[i].FileName, true);
            end;
          IDCANCEL:
            begin
            end;
        end
      else
        IdFTP1.Get(IdFTP1.DirectoryListing.Items[i].FileName, 'd:\FTPtest\' + IdFTP1.DirectoryListing.Items[i].FileName);
    end;
     原处理过程结束}
    ProgressBar1.Position := i + 1;
  end;
  MessageBox(Self.Handle, Pchar('系统提示您：本次操作完毕。'), Pchar(self.Caption), MB_OK + MB_ICONINFORMATION);
  ProgressBar1.Position := 0;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  fi: string;
begin //上传
  if OpenDialog1.Execute then
  begin
    fi := OpenDialog1.FileName;
    IdFTP1.Put(fi, ExtractFileName(fi)); //上传，
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
var
  tr: Tstrings;
begin //连接
 Button1.Click;
{  tr := TStringlist.Create;
  try
    try
      idftp1.Passive := True;
      idftp1.Host := '192.180.0.98'; //FTP服务器地址
      idftp1.Username := 'guest'; //FTP服务器用户名
      idftp1.Password := ''; //FTP服务器密码
      idftp1.Connect(); //连接到ftp
     //idftp1.ChangeDir('client'); //进入到client子目录
     //idftp1.ChangeDir('..'); //回到上一级目录
      Edit1.Text := idftp1.RetrieveCurrentDir; //得到初始目录
      idftp1.List(tr, '', true); //得到client目录下所有文件列表
      Memo1.Lines.Assign(tr);
     // memo1.Lines.Assign(Dir_List);
    except
      on E: Exception do
      begin
        MessageBox(Self.Handle, Pchar('系统提示您：' + e.Message), Pchar(self.Caption), MB_OK + MB_ICONERROR);
         // memo2.Lines.Add('Exception');
      end;
    end;
  finally
    tr.Free;
  end;  }
end;

end.

