function varargout = project(varargin)
%This function takes the data in the "project.txt" and finds the voltages of nodes
%Data must have following rule:
%Data will have a ground labeled as node 0.
%And other nodes will be labeled consecutively from 1 to n.
%The elements will be entered in a single row.
%The first column is the unique identifier for the element whose first letter indicates the element type:
%R,I or V and the rest is an integer.
%The second and the third columns denote the node numbers of the element.
%The last column denotes the value of the element in Ohms,Amperes or Volts.
%NodeNumber@SecondColumn < NodeNumber@ThirdColumn.
%Positive value for the current source means that the current is entering the Node@SecondColumn.
%Positive value for the voltage source means: Voltage of Node@SecondColumn < Voltage of Node@ThirdColumn.

% DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @project_OpeningFcn, ...
                   'gui_OutputFcn',  @project_OutputFcn, ...
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
% DO NOT EDIT

function [ x ] = FindX( t )
%An algorithm for Modified Node Analysis 

G = zeros(max([t.Var2;t.Var3]));
B = zeros(max([t.Var2;t.Var3]) , 1);

z1=zeros(max([t.Var2;t.Var3]),1);
z2=[ ];
i=0;

for k=1:height(t)
    %Take the first letter of data columns
    
    IsR = t.Var1{k} == 'R'  ;
    IsR = IsR (: , 1) ;
    
    if IsR== 1
        %First letter is R
        if t.Var2(k) == 0
            G(t.Var3(k),t.Var3(k)) = G(t.Var3(k),t.Var3(k)) + (1/t.Var4(k));
        else 
            G(t.Var2(k),t.Var3(k)) = G(t.Var2(k),t.Var3(k)) - (1/t.Var4(k));
            G(t.Var3(k),t.Var2(k)) = G(t.Var3(k),t.Var2(k)) - (1/t.Var4(k));
            G(t.Var2(k),t.Var2(k)) = G(t.Var2(k),t.Var2(k)) + (1/t.Var4(k));
            G(t.Var3(k),t.Var3(k)) = G(t.Var3(k),t.Var3(k)) + (1/t.Var4(k));
        end
    end
    
    IsV = t.Var1{k} == 'V'  ;
    IsV = IsV (: , 1) ;
    
    if IsV == 1
        %First letter is V
         i=i+1;
         z2(i,1)=abs(t.Var4(k));
         if t.Var2(k) == 0
             B(t.Var3(k),i)=1;
                if t.Var4(k)< 0 ;
                   B(t.Var3(k),i)=-1;
                end
         else
             B(t.Var2(k),i)= -1;
             B(t.Var3(k),i)= 1;
                if t.Var4(k)< 0 ;
                    B(t.Var2(k),i)=  1;
                    B(t.Var3(k),i)= -1;
                end
         end
         B = [B,[zeros(max([t.Var2;t.Var3]),1)]];
    end
    
    IsI = t.Var1{k} == 'I'  ;
    IsI = IsI (: , 1) ;
    
    if IsI == 1
        %First letter is I
        if t.Var2(k) == 0
            z1(t.Var3(k),1)= z1(t.Var3(k),1)+(-1) * t.Var4(k);
        else 
            z1(t.Var2(k),1) = z1(t.Var2(k),1) + t.Var4(k);
            z1(t.Var3(k),1) = z1(t.Var2(k),1) + (-1) * t.Var4(k);
        end
    end
    
end
                B = B(:,1:end-1);
C= B.';
                s=size(B);
                D= zeros (s(2));
                z = [z1 ; z2];
%Define the main matrix A from G,B,C,D
A=[G,B ; C,D];
%Find x by solving A*x=z
x=A\z;
%Take the node voltage part of x
x=x(1:max([t.Var2;t.Var3]),:);


function project_OpeningFcn(hObject, eventdata, handles, varargin)
% Opening Function of GUI
handles.output = hObject;

guidata(hObject, handles);




function varargout = project_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function uitable1_CreateFcn(hObject, eventdata, handles)
% Displays the info in text file in the GUI table
t=readtable('project', 'Delimiter',' ','ReadVariableNames',false);
    for i=1:height(t)
       data(i,:)= {t.Var1{i},t.Var2(i),t.Var3(i),t.Var4(i)};
end
set(hObject,'data',data);



function uitable2_CreateFcn(hObject, eventdata, handles)
%Displays the node voltages on the table in GUI
t=readtable('project', 'Delimiter',' ','ReadVariableNames',false);
data= FindX(t) ;
set(hObject,'data',data);



function uitable3_CreateFcn(hObject, eventdata, handles)
% Changes table size to 1x5
data = get(hObject,'data');
data = data(1,:);
set(hObject,'data',data);

function axes1_CreateFcn(hObject, eventdata, handles)
% function of axes1



function uitable1_CellEditCallback(hObject, eventdata, handles)
%Enables editing on the text info table
data=get(hObject,'data');
t=readtable('project', 'Delimiter',' ','ReadVariableNames',false);
for i=1:height(t)
       t.Var1{i}=data{i,1};
       t.Var2(i)=data{i,2};
       t.Var3(i)=data{i,3};
       t.Var4(i)=data{i,4};
end
data= FindX(t) ;
set(handles.uitable2,'data',data);




function uitable3_CellEditCallback(hObject, eventdata, handles)
%Plots a graph for user specified range of values,element name and preferred node 
data = get(hObject,'data');
t=readtable('project', 'Delimiter',' ','ReadVariableNames',false);
m = [];
if str2num(data{1,5}) >0
for i=1:height(t)
    if data{1,1} ==  t.Var1 {i} 
          for E=str2num(data{1,2}):str2num(data{1,3}):str2num(data{1,4})
                t.Var4(i)= E;
                x=FindX(t);
                m=[m,[x(str2num(data{1,5}),1)]];
        end
    end
end
x=str2num(data{1,2}):str2num(data{1,3}):str2num(data{1,4});
plot(handles.axes1,x,m);

xlabel(data{1,1});
ylabel(['Voltage of node ',data{1,5}]);
title ('Function');
end
