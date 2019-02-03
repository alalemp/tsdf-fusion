function philData2tsdfMatlabData(optimised_data)

folder='/home/aalempij/git/tsdf-fusion_v2/data_ote2/rgbd-frames';

%Global G
G=eye(4,4);
h1=figure;hold off;
h2 = figure;hold on;

for frame=1:size(optimised_data.frame,2)
   
    M=eye(4,4);
    q=[optimised_data.frame(frame).coordinates(8),optimised_data.frame(frame).coordinates(5:7)];
    M(1:3,1:3)=quat2rotm(q);
    M(1:3,4) = optimised_data.frame(frame).coordinates(2:4)';
    
%     G=M*G;
    
    fprintf(1,'[%03d-%03d] %6.4f %6.4f %6.4f\n',frame,optimised_data.frame(frame).coordinates(1),M(1:3,4));
    
    depth=readImage(optimised_data.frame(frame).depth_message_segmented);
    depth=uint16(depth*1000);
    rgb=readImage(optimised_data.frame(frame).rgb_message_segmented);
%     figure(h1);hold off; imagesc(depth);colorbar;drawnow;
    figure(h2);plot3(M(1,4),M(2,4),M(3,4),'b.');hold on;
%     plotCamera('Location',[M(1,4),M(2,4),M(3,4)],'Orientation',M(1:3,1:3),'Opacity',0,'Size',0.02);
%     drawnow();

    PlotSetOfG2oTransforms([M(1,4),M(2,4),M(3,4)], M(1:3,1:3) , h2, 0.2);


    rgb_filename=sprintf('%s/frame-%06d.color.png',folder,frame);
    depth_filename=sprintf('%s/frame-%06d.depth.png',folder,frame);
    pose_filename=sprintf('%s/frame-%06d.pose.txt',folder,frame);
    
%     imwrite(rgb,rgb_filename);
%     imwrite(depth,depth_filename);
%     
    fid = fopen(pose_filename, 'wt');
    for ii=1:4
        fprintf(fid,'%11.7f %11.7f %11.7f %11.7f\n',M(ii,:));
    end
    fclose(fid);    
    
end


end

function PlotSetOfG2oTransforms(t, R , figure_number, scale)


       % Determine the axes as they will be plotted
       %H = [R, t'; 0 0 0 1];
       H_x_axis = [t;t+R(:,1)'/norm(R(:,1)')*scale];
       H_y_axis = [t;t+R(:,2)'/norm(R(:,2)')*scale];
       H_z_axis = [t;t+R(:,3)'/norm(R(:,3)')*scale];

       % Plot
       figure(figure_number); hold on;
       plot3(H_x_axis(:,1),H_x_axis(:,2),H_x_axis(:,3),'r');
       plot3(H_y_axis(:,1),H_y_axis(:,2),H_y_axis(:,3),'g');
       plot3(H_z_axis(:,1),H_z_axis(:,2),H_z_axis(:,3),'b');

end