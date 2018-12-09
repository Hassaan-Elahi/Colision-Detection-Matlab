input=VideoReader('vid3.mp4');
frames = VideoReader('vid3.mp4');

initial_width=366; %pixels
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
        img = imgaussfilt(imgorig,4);

        thres=graythresh(img);
        i2=~(im2bw(img,thres));

        i2 = bwareafilt(i2, 1);

        Total_White_Pixels = nnz(i2);

        %display(Total_White_Pixels);

        if(Total_White_Pixels>250000)
            play(player);
        end
        if(Total_White_Pixels>270000)
            play(player1);
        end

        i2 = bwareaopen(i2, 1000);


    i3=i2;

    i2 = bwmorph(i2,'remove');
    i2 = bwmorph(i2,'thicken',1);
    i2 = bwmorph(i2,'diag');

    binaryImage = bwareafilt(i2, 1);
    labeledImage = bwlabel(binaryImage);
    measurements = regionprops(labeledImage, 'BoundingBox');
    boundingBox = measurements(1).BoundingBox;

    if(i==0)
        d=boundingBox;
    end

    imgorig = insertObjectAnnotation(imgorig, 'rectangle', boundingBox, 'object');

         imshowpair(imgorig,i3,'montage');

        i=i+1;
end
