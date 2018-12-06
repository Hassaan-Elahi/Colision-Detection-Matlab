input=VideoReader('vid3.mp4');
frames = VideoReader('vid3.mp4');

%No of frames in the video
frames = ceil(frames.FrameRate*frames.Duration);

i=0;

[y, Fs] = audioread('beep.mp3');
        player = audioplayer(y, Fs);
        
        [y1, Fs1] = audioread('beep1.mp3');
        player1 = audioplayer(y1, Fs1);

while(i<frames-1)
    img=readFrame(input);
  
    thres=graythresh(img);
    i2=~(im2bw(img,thres));
    
    i2 = bwareafilt(i2, 1);
    
    
    

    
    Total_White_Pixels = nnz(i2);
    
    display(Total_White_Pixels);
    
    if(Total_White_Pixels>100000)
        play(player);
    end
    if(Total_White_Pixels>200000)
        play(player1);
    end
    

     imshow(i2);
    i=i+1;
end
