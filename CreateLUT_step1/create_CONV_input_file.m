% det_radius()

function create_CONV_input_file(R)

fid = fopen('conv_input.txt','w');
fprintf(fid,'i\n');
fprintf(fid,'mcml.mco\n');
fprintf(fid,'b\n');
fprintf(fid,'f\n');
fprintf(fid,'1\n');
fprintf(fid,[num2str(R) '\n']);
fprintf(fid,'oc\n');
fprintf(fid,'Rr\n');
fprintf(fid,'out.Rrc\n');
fprintf(fid,'w\n');
fprintf(fid,'q\n');
fprintf(fid,'q\n');
fprintf(fid,'y\n');
