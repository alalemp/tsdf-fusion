function philData2tsdfMatlabData(optimised_data)

folder='/home/aalempij/git/tsdf-fusion_v2/data_ote2/rgbd-frames';

%Global G
G=eye(4,4);
h1=figure;hold off;

for frame=201:size(optimised_data.frame,2)
   
    M=eye(4,4);
    q=[optimised_data.frame(frame).coordinates(6:8),optimised_data.frame(frame).coordinates(5)];
    M(1:3,1:3)=quat2rotm(q);
    M(1:3,4) = optimised_data.frame(frame).coordinates(2:4)';
    
    G=M*G;
    
    fprintf(1,'[%03d-%03d] %6.4f %6.4f %6.4f\n',frame,optimised_data.frame(frame).coordinates(1),M(1:3,4));
    
    depth=readImage(optimised_data.frame(frame).depth_message_segmented);
    depth=uint16(depth*1000);
    rgb=readImage(optimised_data.frame(frame).rgb_message_segmented);
%     figure(h1);imagesc(rgb);colorbar;drawnow;
    
    rgb_filename=sprintf('%s/frame-%06d.color.png',folder,frame);
    depth_filename=sprintf('%s/frame-%06d.depth.png',folder,frame);
    pose_filename=sprintf('%s/frame-%06d.pose.txt',folder,frame);
    
    imwrite(rgb,rgb_filename);
    imwrite(depth,depth_filename);
    
    fid = fopen(pose_filename, 'wt');
    for ii=1:4
        fprintf(fid,'%11.7f %11.7f %11.7f %11.7f\n',M(ii,:));
    end
    fclose(fid);    
    
end


return