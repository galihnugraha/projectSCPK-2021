function varargout = index(varargin)
% INDEX MATLAB code for index.fig
%      INDEX, by itself, creates a new INDEX or raises the existing
%      singleton*.
%
%      H = INDEX returns the handle to a new INDEX or the handle to
%      the existing singleton*.
%
%      INDEX('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INDEX.M with the given input arguments.
%
%      INDEX('Property','Value',...) creates a new INDEX or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before index_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to index_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help index

% Last Modified by GUIDE v2.5 01-Jul-2021 11:12:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @index_OpeningFcn, ...
                   'gui_OutputFcn',  @index_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before index is made visible.
function index_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to index (see VARARGIN)

% Choose default command line output for index
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

tabel = readtable('Data Nasional 17-18 (Metode Baru).xlsx');
tabel = tabel(2:35,1:9);
tabel = table2cell(tabel);
set(handles.uitable1,'data',tabel);

% UIWAIT makes index wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = index_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tabel = readtable('Data Nasional 17-18 (Metode Baru).xlsx');
tabel = tabel(2:35,2:9);

tabel2017a = table2array(tabel(:,1));
tabel2017b = table2array(tabel(:,3));
tabel2017c = table2array(tabel(:,5));
tabel2017b(:,1) = tabel2017b(:,1)+tabel2017c(:,1);
tabel2017b(:,1) = tabel2017b(:,1)/2;
tabel2017d = table2array(tabel(:,7));
tabel2017d(:,1) = log(tabel2017d(:,1));
data2017 = [tabel2017a tabel2017b tabel2017d];

tabel2018a = table2array(tabel(:,2));
tabel2018b = table2array(tabel(:,4));
tabel2018c = table2array(tabel(:,6));
tabel2018b(:,1) = tabel2018b(:,1)+tabel2018c(:,1);
tabel2018b(:,1) = tabel2018b(:,1)/2;
tabel2018d = table2array(tabel(:,8));
tabel2018d(:,1) = log(tabel2018d(:,1));
data2018 = [tabel2018a tabel2018b tabel2018d];

maxKualitasSatu = 85;  %Maksimal Angka Harapan Hidup
maxKualitasDua = 16.5; %Maksimal Angka Harapan dan Rata-rata Lama Sekolah
maxKualitasTiga = log(26572);  %Maksimal Pendapatan Perkapita (dalam ribuan rupiah)

data2017(:,1) = data2017(:,1) / maxKualitasSatu;
data2017(:,2) = data2017(:,2) / maxKualitasDua;
data2017(:,3) = data2017(:,3) / maxKualitasTiga;

data2018(:,1) = data2018(:,1) / maxKualitasSatu;
data2018(:,2) = data2018(:,2) / maxKualitasDua;
data2018(:,3) = data2018(:,3) / maxKualitasTiga;

relasiAntarKriteria = [ 1 0.25 0.5
                        0 1 2
                        0 0 1];
                    
TFN = {[-100/3 0 100/3]     [3/100 0 -3/100]
       [0 100/3 200/3]      [3/200 3/100 0 ]
       [100/3 200/3 300/3]  [3/300 3/200 3/100 ]
       [200/3 300/3 400/3]  [3/400 3/300 3/200 ]};
   
[RasioKonsistensi] = HitungKonsistensiAHP(relasiAntarKriteria);
 
 if RasioKonsistensi < 0.10
    % Metode Fuzzy AHP
    [bobotAntarKriteria, relasiAntarKriteria] = FuzzyAHP(relasiAntarKriteria, TFN);
    % Hitung nilai skor akhir
    ahp2017 = data2017 * bobotAntarKriteria';
    ahp2018 = data2018 * bobotAntarKriteria';
 end
 
[m n]=size (ahp2017);%matriks m x n dengan ukuran sebanyak variabel ahp2017
[o p]=size (ahp2018);%matriks o x p dengan ukuran sebanyak variabel ahp2018

%membuat matriks kosong status2017 dan status2018
status2017 = strings(1,m);
status2018 = strings(1,o); 

%proses pemberian status untuk AHP 2017
for i = 1:size(ahp2017, 1)
    if ahp2017(i) < 0.65
        status2017(1,i) = 'Kurang';
    elseif ahp2017(i) < 0.75
        status2017(1,i) = 'Sedang';
    elseif ahp2017(i) <= 0.8
        status2017(1,i) = 'Baik';
    else
        status2017(1,i) = 'Sangat Baik';
    end
end

%proses pemberian status untuk AHP 2018
for i = 1:size(ahp2018, 1)    
    if ahp2018(i) < 0.65
        status2018(1,i) = 'Kurang';
    elseif ahp2018(i) < 0.75
        status2018(1,i) = 'Sedang';
    elseif ahp2018(i) <= 0.8
        status2018(1,i) = 'Baik';
    else
        status2018(1,i) = 'Sangat Baik';
    end
end

%Menghitung pertumbuhan index ahp (%)
pertumbuhan = ahp2018 - ahp2017;
pertumbuhan = pertumbuhan / ahp2017;
pertumbuhan = num2cell(pertumbuhan);
pertumbuhan = pertumbuhan(:,14);

status2017=cellstr(status2017);%Mengubah string menjadi cell 
status2017=status2017';%melakukan transpose (agar cell menjadi vertical)

status2018=cellstr(status2018);%Mengubah string menjadi cell 
status2018=status2018';%melakukan transpose (agar cell menjadi vertical)

ahp2017=num2cell(ahp2017);%Mengubah angka (double) menjadi cell
ahp2018=num2cell(ahp2018);%Mengubah angka (double) menjadi cell

%Mengambil kolom nama provinsi dari dataset
x2= readtable('Data Nasional 17-18 (Metode Baru).xlsx');
x2 = table2cell(x2);
x2 = x2(2:35,1);

%Menggabungkan cell ahp dan status
hasil2017 = [ahp2017 status2017];
hasil2018 = [ahp2018 status2018];

%Menggabungkan dengan nama provinsi
hasilakhir = [x2 hasil2017 hasil2018 pertumbuhan];

%disp(ahp2017); fprintf('\n\n'); disp(status2017);
set(handles.uitable2,'data',hasilakhir);



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uitable2,'data','');
