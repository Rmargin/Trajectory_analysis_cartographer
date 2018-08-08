%轨迹精度分析-------matlab 测量程序

%load文件
filename_path = 'G:\采集data\20180103\'  %文件路径
filename_name = '20180103-04_3cm.txt'    %文件名

filename_save_path = 'G:\采集data\20180103\' %存储文件路径
filename_save_name = 'save_filename.txt' %存储文件名字

%合并字符串路径和文件名
save_file =  [filename_save_path filename_save_name]; disp(save_file);%check save file name right?
%合并filename_path filename_name
file_path_name = [filename_path filename_name]
%获取文件目录下文件名
struct_dir_name = dir(filename_path);

%读取指定文件内的数据
for i = 3:length(struct_dir_name)
    %判断找txt文件
    if(strfind(struct_dir_name(i).name,'txt'))
        disp('读取文件成功');
        %打开文件 //scanf(),format,importdata();读取文件数据
        fileID = fopen(file_path_name,'r');
        rawdata = fscanf(fileID,'%c%c ');
        %data = importdata(filepath_name);
        fclose(fileID);
        %关闭文件
    end
end

%筛选出其中空格
index_flage_ = strfind(rawdata ,' ')
%buffer
rawdata_no_have_ = rawdata ;
rawdata_no_have_(index_flage_) = []

% Ok --- go to here rawdata_no_have_ 中没有空格

%解析数据
find_flage_string = 'node'; disp([ 'check here find_flage_string data is right :' find_flage_string] ) %check data

index_num_flage_num = strfind(rawdata_no_have_ , find_flage_string);% check index num data

%check rawdata_no_have
rawdata_no_have_length = length(rawdata_no_have_);disp(['check length_rawdata_no_have size :  ' num2str(rawdata_no_have_length)])

%循环中将数据存入结构体中
chech_length =length(index_num_flage_num); disp(chech_length); %check chech_length 大小 right ?

%stroe data in string array data
count_num = 0
for i = 1 : length(index_num_flage_num)-1
       count_num = count_num + 1;
       disp(count_num)
       string_string_data_one_to_one(count_num).data = rawdata_no_have_( index_num_flage_num(i):index_num_flage_num(i+1)-1 )
end

% check string_string_data_one_to_one have scape char
% for i = 1:length(string_string_data_one_to_one)
%     index  = strfind(string_string_data_one_to_one(i).data, ' ');
%     string_string_data_one_to_one(i).data(index) = [];
% end

pose_count_num = 0 ;
%筛选其timestamp transation rataion
%no have stamptime analysis
for i = 1:length(string_string_data_one_to_one)
        pose_count_num = pose_count_num + 1;   disp(pose_count_num); %check pose_count_num
        %find flage
        index_x = strfind( string_string_data_one_to_one(i).data,  'x:');
        index_y = strfind( string_string_data_one_to_one(i).data,  'y:');
        index_z = strfind( string_string_data_one_to_one(i).data,  'z:');
        index_w = strfind( string_string_data_one_to_one(i).data,  'w:');
        index_z_test = strfind(string_string_data_one_to_one(i).data, 'rotation');
        
        index_z_end = index_z_test - 1;
        index_w_end = length(string_string_data_one_to_one(i).data) - 3;
        %t_x
        string_string_data_one_to_one(i).data( index_x(1) + 2  : index_y(1) - 1) %check data
        struct_time_pose_data(pose_count_num).t_x = str2double( string_string_data_one_to_one(i).data( index_x(1) + 2 : index_y(1) -1 ) );
        %t_y
        struct_time_pose_data(pose_count_num).t_y = str2double( string_string_data_one_to_one(i).data( index_y(1) + 2  : index_z(1) -1 ) );
        %t_z
        struct_time_pose_data(pose_count_num).t_z = str2double( string_string_data_one_to_one(i).data( index_z(1) + 2 : index_z_end - 3 ) );
        %q_x
        struct_time_pose_data(pose_count_num).q_x = str2double( string_string_data_one_to_one(i).data( index_x(2) + 2 : index_y(2) - 1 ) );
        %q_y
        struct_time_pose_data(pose_count_num).q_y = str2double( string_string_data_one_to_one(i).data( index_y(2) + 2 : index_z(2) -1  ) );
        %q_z
        struct_time_pose_data(pose_count_num).q_z = str2double( string_string_data_one_to_one(i).data( index_z(2) + 2 : index_w(1) -1 ) );
        %q_w
        struct_time_pose_data(pose_count_num).q_w = str2double( string_string_data_one_to_one(i).data( index_w(1) + 2 :  index_w_end -5 ) ); %check here maybe have bug , not diff doc file
end

figure
for i = 1:length(struct_time_pose_data)
    plot3(struct_time_pose_data(i).t_x, struct_time_pose_data(i).t_y, struct_time_pose_data(i).t_z, '.r');
    hold on
end

title('cartographer Trajectory');ylabel('y轴');xlabel('x轴');zlabel('z轴')
legend('Trajectory');   %加图例
grid on;    %加网格
axis equal
axis([-100 100 -100 100 -20 50])

%打开save_file name
disp('操作存储文件');
%打开文件 //scanf(),format,importdata();读取文件数据
fileID_save_filename = fopen(save_file,'w');
%format file output test
for i = 1:length(struct_time_pose_data)
    fprintf(fileID_save_filename, '%f %f %f\n' ,struct_time_pose_data(i).t_x, struct_time_pose_data(i).t_y, struct_time_pose_data(i).t_z);
end
disp('数据存储');%check operation
fclose(fileID_save_filename); disp('ok file is close') %stop to do anything
%关闭文件
