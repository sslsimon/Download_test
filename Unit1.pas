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
  Result := MessageBox(application.Handle, pChar(Msg), 'ϵͳ��Ϣ', iValue + MB_APPLMODAL);
end;

//�����ļ��޸�ʱ��
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
begin //����
  tr := TStringlist.Create;
  try
    try
      idftp1.Passive := True;
      idftp1.Host := '192.180.0.98'; //FTP��������ַ
      idftp1.Username := 'guest'; //FTP�������û���
      idftp1.Password := ''; //FTP����������
      idftp1.Connect(); //���ӵ�ftp
     //idftp1.ChangeDir('client'); //���뵽client��Ŀ¼
     //idftp1.ChangeDir('..'); //�ص���һ��Ŀ¼
      Edit1.Text := idftp1.RetrieveCurrentDir; //�õ���ʼĿ¼
      idftp1.List(tr, '', false); //�õ�clientĿ¼�������ļ��б�
      Memo1.Lines.Assign(tr);
    except
      on E: Exception do
      begin
        MessageBox(Self.Handle, Pchar('ϵͳ��ʾ����' + e.Message), Pchar(self.Caption), MB_OK + MB_ICONERROR);
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
begin //����
  // IdFTP1.TransferType := ftASCII; //ftBinary; //ָ��Ϊ�������ļ�   ���ı��ļ�ftASCII
  IDFTP1.TransferType := ftBinary; //���Ĵ�������
  ProgressBar1.Min := 0;
  ProgressBar1.Max := memo1.Lines.Count;
  for i := 0 to  memo1.Lines.Count - 1 do
  begin
     new_file_datetime:= idFTP1.FileDate(memo1.Lines[i]);
     IdFTP1.Get(memo1.Lines[i], 'd:\FTPtest\' + memo1.Lines[i], true);
     SetFileDateTime('d:\FTPtest\' + memo1.Lines[i],new_file_datetime);
    // ShowMessage(IdFTP1.DirectoryListing.Items[i].FileName);
    { ԭ������̣�����ʾ��ѡ
      if FileExists('d:\FTPtest\' + IdFTP1.DirectoryListing.Items[i].FileName) then
        case MsgBox(IdFTP1.DirectoryListing.Items[i].FileName + '�ļ��Ѿ����ڣ�Ҫ������'#13#10'�ǡ�������'#10#13'�񡪡�����'#13#10'ȡ������ȡ������', MB_YESNOCANCEL + MB_ICONINFORMATION) of
          IDYES: begin
             //����˵��: Դ�ļ���Ŀ���ļ�,�Ƿ񸲸�,�Ƿ񴥷��쳣��TrueΪ������)��
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
     ԭ������̽���}
    ProgressBar1.Position := i + 1;
  end;
  MessageBox(Self.Handle, Pchar('ϵͳ��ʾ�������β�����ϡ�'), Pchar(self.Caption), MB_OK + MB_ICONINFORMATION);
  ProgressBar1.Position := 0;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  fi: string;
begin //�ϴ�
  if OpenDialog1.Execute then
  begin
    fi := OpenDialog1.FileName;
    IdFTP1.Put(fi, ExtractFileName(fi)); //�ϴ���
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
var
  tr: Tstrings;
begin //����
 Button1.Click;
{  tr := TStringlist.Create;
  try
    try
      idftp1.Passive := True;
      idftp1.Host := '192.180.0.98'; //FTP��������ַ
      idftp1.Username := 'guest'; //FTP�������û���
      idftp1.Password := ''; //FTP����������
      idftp1.Connect(); //���ӵ�ftp
     //idftp1.ChangeDir('client'); //���뵽client��Ŀ¼
     //idftp1.ChangeDir('..'); //�ص���һ��Ŀ¼
      Edit1.Text := idftp1.RetrieveCurrentDir; //�õ���ʼĿ¼
      idftp1.List(tr, '', true); //�õ�clientĿ¼�������ļ��б�
      Memo1.Lines.Assign(tr);
     // memo1.Lines.Assign(Dir_List);
    except
      on E: Exception do
      begin
        MessageBox(Self.Handle, Pchar('ϵͳ��ʾ����' + e.Message), Pchar(self.Caption), MB_OK + MB_ICONERROR);
         // memo2.Lines.Add('Exception');
      end;
    end;
  finally
    tr.Free;
  end;  }
end;

end.

