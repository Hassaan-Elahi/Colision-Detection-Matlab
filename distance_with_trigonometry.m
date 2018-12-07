
input=VideoReader('vid3.mp4');
frames = VideoReader('vid3.mp4');
frames = ceil(frames.FrameRate*frames.Duration);



while(i<frames-1)
   
    img=readFrame(input);
    img = edge(img,'Canny');
    imshow(img);
    i = i+1;
    
end