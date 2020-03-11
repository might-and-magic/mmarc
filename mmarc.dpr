program mmarc;

{$APPTYPE CONSOLE}

uses
	SysUtils, StrUtils, RSLod, RSLodEdt;

var
	method : string;
	methodNumber : integer;
	archiveFile : string;

procedure help;
begin
	WriteLn('Usage:');
	WriteLn('mmarc extract <archive_file> <folder> [file_to_extract_1] [file_to_extract_2] [...]');
	WriteLn('mmarc list <archive_file>');
	WriteLn('mmarc add <archive_file> <file_to_add_1> [file_to_add_2] [...]');
	WriteLn('mmarc delete <archive_file> <file_to_delete_1> [file_to_delete_2] [...]');
	WriteLn('mmarc rename <archive_file> <old_file_name> <new_file_name>');
	WriteLn('mmarc create <archive_file> <archive_file_type> <folder> [file_to_add_1] [file_to_add_2] [...]');
	WriteLn('mmarc merge <archive_file> <archive_file_2>');
	WriteLn('mmarc optimize <archive_file>');
	WriteLn('mmarc help');
	WriteLn('Read https://github.com/might-and-magic/mmarc for more details.');
end;

procedure showError(const str : string);
begin
	WriteLn('Error: ' + str);
	help;
end;

function getIndexByFileName(const fileName : string; const arc : TRSMMArchive) : integer;
var
	fFiles : TRSMMFiles;
	fileCountMinusOne : integer;
	i : integer;
begin
	Result := -1; // if file is not found, returns -1
	try
		fFiles := arc.RawFiles;
		fileCountMinusOne := fFiles.Count - 1;
		for i := 0 to fileCountMinusOne do
		begin
			if LowerCase(fileName) = LowerCase(fFiles.Name[i]) then
			begin
				Result := i;
				exit;
			end;
		end;
	except
		on E : Exception do
			WriteLn(E.Message);
	end;
end;

procedure extractAll(const arc : TRSMMArchive; const folder : string);
var
	fileCountMinusOne : integer;
	i : integer;
begin
	try
		fileCountMinusOne := arc.RawFiles.Count - 1;
		for i := 0 to fileCountMinusOne do
			arc.Extract(i, folder);
	except
		on E : Exception do
			WriteLn(E.Message);
	end;
end;

procedure extract;
var
	folder : string;
	i : integer;
	fileName : string;
	arc : TRSMMArchive;
	fileIndex : integer;
begin
	try
		folder := ParamStr(3);
		if folder = '' then
			showError('You must specify a folder')
		else
		begin
			arc := RSLoadMMArchive(archiveFile);

			fileName := ParamStr(4);
			if fileName = '' then // file_to_extract_1 is empty, extract all
				extractAll(arc, folder);

			for i := 4 to ParamCount do
			begin
				fileName := ParamStr(i);
				if fileName <> '' then
				begin
					fileIndex := getIndexByFileName(fileName, arc);

					if fileIndex = -1 then
						WriteLn('Warning: file ' + fileName + ' is not found in the archive and therefore skipped')
					else
						arc.Extract(fileIndex, folder);

					if fileIndex <> -1 then
						arc.Extract(fileIndex, folder);
				end;
			end;
			arc.RawFiles.Rebuild();
		end;
	except
		on E : Exception do
			WriteLn(E.Message);
	end;
end;

procedure list;
var
	arc : TRSMMArchive;
	fFiles : TRSMMFiles;
	fileCountMinusOne : integer;
	i : integer;
begin
	try
		arc := RSLoadMMArchive(archiveFile);
		fFiles := arc.RawFiles;
		fileCountMinusOne := fFiles.Count - 1;
		for i := 0 to fileCountMinusOne do
			WriteLn(fFiles.Name[i]);
	except
		on E : Exception do
			WriteLn(E.Message);
	end;
end;

procedure add;
var
	fileName : string;
	arc : TRSMMArchive;
	i : integer;
begin
	try
		fileName := ParamStr(3);
		if fileName = '' then
			showError('You must specify at least one file to add')
		else
		begin
			arc := RSLoadMMArchive(archiveFile);

			for i := 3 to ParamCount do
			begin
				fileName := ParamStr(i);
				if fileName <> '' then
				begin
					arc.Add(fileName);
				end;
			end;
			arc.RawFiles.Rebuild();
		end;
	except
		on E : Exception do
			WriteLn(E.Message);
	end;
end;

procedure delete;
var
	aa : string;
begin
	try
		WriteLn('delete');
	except
		on E : Exception do
			WriteLn(E.Message);
	end;
end;

procedure rename;
var
	aa : string;
begin
	try
		WriteLn('rename');
	except
		on E : Exception do
			WriteLn(E.Message);
	end;
end;

procedure create;
var
	folder : string;
begin
	try
		folder := ParamStr(3);
		if folder = '' then
			showError('You must specify a folder')
		else
		begin
			WriteLn('create');
		end;
	except
		on E : Exception do
			WriteLn(E.Message);
	end;
end;

procedure merge;
var
	aa : string;
begin
	try
		WriteLn('merge');
	except
		on E : Exception do
			WriteLn(E.Message);
	end;
end;

procedure optimize;
var
	aa : string;
begin
	try
		WriteLn('optimize');
	except
		on E : Exception do
			WriteLn(E.Message);
	end;
end;

function trimChar(const str: string): string;
var
	n: integer;
begin
	n := 1;
	while (n <= Length(str)) and (str[n] = '-') do
		Inc(n);
	SetString(Result, PChar(@str[n]), Length(str) - n + 1);
end;

begin

	// to do: check if method = `fvsrb`, methodNumber = ?

	method := trimChar(ParamStr(1));
	methodNumber := AnsiIndexStr(method, ['extract', 'e', 'list', 'l', 'add', 'a', 'delete', 'd', 'rename', 'r', 'create', 'c', 'merge', 'm', 'optimize', 'o', 'help', 'h', '']);
	archiveFile := ParamStr(2);
	if (archiveFile = '') And (methodNumber < 16) then // < 16 : method is not `help`
		showError('You must specify an archive file')
	else
	begin
		Case methodNumber of
			0: extract;
			1: extract;
			2: list;
			3: list;
			4: add;
			5: add;
			6: delete;
			7: delete;
			8: rename;
			9: rename;
			10: create;
			11: create;
			12: merge;
			13: merge;
			14: optimize;
			15: optimize;
			16: help;
			17: help;
			18: help;
		else
			showError('Unknown method: ' + method);
		end;
	end;
end.


// TRSMMArchive
// constructor Create; override;
// destructor Destroy; override;

// function Add(const Name: string; Data: TStream; Size: int = -1; pal: int = 0): int; overload; virtual;
// function Add(const Name: string; Data: TRSByteArray; pal: int = 0): int; overload; // virtual;
// function Add(const FileName: string; pal: int = 0): int; overload; // virtual;
// function Add(const FileName: string; Data: string): int; overload; // virtual;
// function Extract(Index: int; const Dir: string; Overwrite: Boolean = true): string; overload; virtual;
// function Extract(Index: int; Output: TStream): string; overload; virtual;
// function Extract(Index: int): TObject; overload; virtual;
// function ExtractArrayOrBmp(Index: int; var Arr: TRSByteArray): TBitmap; virtual;
// function ExtractArray(Index: int): TRSByteArray;
// function ExtractString(Index: int): string;
// function GetExtractName(Index: int): string; virtual;
// function BackupFile(Index: int; Overwrite:Boolean): Boolean;
// function CloneForProcessing(const NewFile: string; FilesCount: int = 0): TRSMMArchive; virtual;
// procedure Load(const FileName: string); override;
// procedure SaveAs(const FileName: string); override;

// property RawFiles: TRSMMFiles read FFiles;
// property BackupOnAdd: Boolean read FBackupOnAdd write FBackupOnAdd;
// property BackupOnAddOverwrite: Boolean read FBackupOnAddOverwrite write FBackupOnAddOverwrite;
// property BackupOnDelete: Boolean read FBackupOnDelete write FBackupOnDelete;
// property BackupOnDeleteOverwrite: Boolean read FBackupOnDeleteOverwrite write FBackupOnDeleteOverwrite;


// TRSMMFiles
// constructor Create;
// destructor Destroy; override;
// procedure New(const FileName: string; const Options: TRSMMFilesOptions);
// procedure Load(const FileName: string);
// procedure AssignStream(fs: TStream);  // hackish way to load from foreign stream
// procedure DoSave;  // force save
// procedure Save;
// procedure SaveAs(const FileName: string);
// procedure Rebuild;
// procedure Close;
// function CloneForProcessing(const NewFile: string; FilesCount: int): TRSMMFiles;
// procedure MergeTo(Files: TRSMMFiles);
// function Add(const Name: string; Data: TStream; Size: int = -1;
//    Compression: TCompressionLevel = clDefault; UnpackedSize: int = -1): int;
// procedure Delete(i:int); overload;
// procedure Delete(const Name: string); overload;
// procedure Delete(const Name: PChar); overload;
// function Rename(Index: int; const NewName: string): int;
// procedure CheckName(const Name: string);
// function FindFile(const Name: string; var Index: int): Boolean; overload;
// function FindFile(const Name: PChar; var Index: int): Boolean; overload;
// function GetAsIsFileStream(Index: int; IgnoreWrite: Boolean = false): TStream;
// procedure FreeAsIsFileStream(Index: int; Stream: TStream);
// procedure RawExtract(i: int; a: TStream);
// procedure ReserveFilesCount(n: int);
// function CheckFileChanged: Boolean;
// property Name[i: int]: PChar read GetName;
// property Address[i: int]: uint read GetAddress;
// property Size[i: int]: int read GetSize;
// property UnpackedSize[i: int]: int read GetUnpackedSize;
// property IsPacked[i: int]: Boolean read GetIsPacked;
// property UserData[i: int]: ptr read GetUserData;
// property Count: int read FCount;
// property ArchiveSize: uint read FFileSize;
// property Options: TRSMMFilesOptions read FOptions;
// property UserDataSize: int read FUserDataSize write SetUserDataSize;
// property WriteOnDemand: Boolean read FWriteOnDemand write SetWriteOnDemand;
// property FileName: string read FOutFile;
// property Sorted: Boolean read FSorted;
// property IgnoreUnzipErrors: Boolean read FIgnoreUnzipErrors write FIgnoreUnzipErrors;
// property OnReadHeader: TRSMMFilesReadHeaderEvent read FOnReadHeader write FOnReadHeader;
// property OnWriteHeader: TRSMMFilesWriteHeaderEvent read FOnWriteHeader write FOnWriteHeader;
// property OnGetFileSize: TRSMMFilesGetFileSizeEvent read FOnGetFileSize write FOnGetFileSize;
// property OnSetFileSize: TRSMMFilesSetFileSizeEvent read FOnSetFileSize write FOnSetFileSize;
// property OnBeforeReplaceFile: TRSMMFilesFileEvent read FOnBeforeReplaceFile write FOnBeforeReplaceFile;
// property OnBeforeDeleteFile: TRSMMFilesFileEvent read FOnBeforeDeleteFile write FOnBeforeDeleteFile;
// property OnAfterRenameFile: TRSMMFilesFileEvent read FOnAfterRenameFile write FOnAfterRenameFile;