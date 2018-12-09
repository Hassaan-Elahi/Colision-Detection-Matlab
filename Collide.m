input=VideoReader('vid3.mp4');
frames = VideoReader('vid3.mp4');

initial_width=0; %pixels
initial_act_width=14;  %inch
initial_act_dist=36;   %inch

%No of frames in the video
frames = ceil(frames.FrameRate*frames.Duration);

i=0;

[y, Fs] = audioread('beep.mp3');
player = audioplayer(y, Fs);
[y1, Fs1] = audioread('beep1.mp3');
player1 = audioplayer(y1, Fs1);
        
while(i<frames-1)
    imgorig=readFrame(input);
    img = imgaussfilt(imgorig,4);   %smoothing the image

    thres=graythresh(img);
    i2=~(im2bw(img,thres));

    i2 = bwareafilt(i2, 1);

    Total_White_Pixels = nnz(i2);  %white pixels in image

    if(Total_White_Pixels>250000)
        play(player);
    end
    if(Total_White_Pixels>270000)
        play(player1);
    end

    i3=i2;   %image without boundary

    i2 = bwmorph(i2,'remove');       %creating boundary
    i2 = bwmorph(i2,'thicken',1);    %fixing boundary
    i2 = bwmorph(i2,'diag');         %fixing boundary

    i2 = bwareafilt(i2, 1);    %filtering image with 1 object
    i2 = bwlabel(i2);
    measurements = regionprops(i2, 'BoundingBox');
    bbox = measurements(1).BoundingBox;     %creating boundingbox on object

    if(i==0)
        initial_width=bbox(3);   %finding object width from the first frame
    end    
    
    imgorig = insertObjectAnnotation(imgorig, 'rectangle', bbox, 'object');
    imshowpair(imgorig,i2,'montage');

    i=i+1;
end
