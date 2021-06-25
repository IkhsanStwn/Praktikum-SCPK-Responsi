function varargout = SAW(varargin)
% SAW MATLAB code for SAW.fig
%      SAW, by itself, creates a new SAW or raises the existing
%      singleton*.
%
%      H = SAW returns the handle to a new SAW or the handle to
%      the existing singleton*.
%
%      SAW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SAW.M with the given input arguments.
%
%      SAW('Property','Value',...) creates a new SAW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SAW_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SAW_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SAW

% Last Modified by GUIDE v2.5 25-Jun-2021 20:45:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SAW_OpeningFcn, ...
                   'gui_OutputFcn',  @SAW_OutputFcn, ...
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


% --- Executes just before SAW is made visible.
function SAW_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SAW (see VARARGIN)

%proses import data set
global data;%variabel global data
data.Mydata = xlsread('DATA RUMAH');
data.Mydata = [data.Mydata(:,1) data.Mydata(:,3) data.Mydata(:,4) data.Mydata(:,5) data.Mydata(:,6) data.Mydata(:,7) data.Mydata(:,8)];
set(handles.dataRumah,'Data',data.Mydata);%menampilkan isi data.Mydata ke tabel dataRumah

% Choose default command line output for SAW
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SAW wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SAW_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in prosesbtn.
function prosesbtn_Callback(hObject, eventdata, handles)
% hObject    handle to prosesbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%menyalin data yg akan dihitung dari Mydata ke Mydata1
global data;
data.Mydata1 = [data.Mydata(:,2) data.Mydata(:,3) data.Mydata(:,4) data.Mydata(:,5) data.Mydata(:,6) data.Mydata(:,7)];

k = [0,1,1,1,1,1];%atribut tiap-tiap kriteria, dimana nilai 1=atrribut keuntungan, dan  0= atribut biaya
w = [0.30,0.20,0.23,0.10,0.07,0.10];%bobot untuk masing-masing kriteria

%tahapan 1, normalisasi matriks
[m n] = size(data.Mydata1);%matriks m x n dengan ukuran sebanyak variabel Mydata1
R = zeros(m,n);%membuat matriks R, 
V = zeros(m,1);%membuat matriks V,

for j=1:n,
    if k(j)==1, %statement utk kriteria dengan atribut keuntungan
        R(:,j) = data.Mydata1(:,j)./max(data.Mydata1(:,j));
    else %%statement utk kriteria dengan atribut biaya
        R(:,j) = min(data.Mydata1(:,j))./data.Mydata1(:,j);
    end;
end;

disp(min(data.Mydata1(:,1)));

%tahapan 2, proses perankingan
for i=1:m,
    V(i,:) = sum(w.*R(i,:));
end;

%membuat matriks dataHasil untuk menyimpan data no rumah dan nilai V
data.dataHasil = [data.Mydata(:,1) V];

%pengurutan perankingan dari nilai V terbesar ke terkecil
data.dataHasil1 = data.dataHasil;%menyalin isi dataHasil ke matrik dataHasil1 utk proses Urut
for i=m:-1:1,
    for j=1:i-1,
       if data.dataHasil1(j,2)<data.dataHasil1(j+1,2),
           T = data.dataHasil1(j,:);
           data.dataHasil1(j,:) = data.dataHasil1(j+1,:);
           data.dataHasil1(j+1,:) = T; 
       end;
   end;
end;
set(handles.hasil,'Data',data.dataHasil1(1:20,:));%menampilkan isi dataHasil ke tabel hasil
