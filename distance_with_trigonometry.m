input=VideoReader('vid.mp4');
frames = VideoReader('vid.mp4');

initial_width=366; %pixels
initial_act_width=14;  %inch
initial_act_dist=36;   %inch
alarm1 = 0;
alarm2 = 0;
fontSize = 22;
%No of frames in the video
frames = ceil(frames.FrameRate*frames.Duration);

i=0;

[y, Fs] = audioread('beep_beep.mp3');
warning_lvl_1 = audioplayer(y, Fs);
[y, Fs] = audioread('beep-c.mp3');
warning_lvl_2 = audioplayer(y, Fs);
        
while(i<frames-1)
    
    imgorig=readFrame(input);
    if(i==0)
        %Finding Focal lenght of the camera
        F = (initial_width * initial_act_dist)/initial_act_width; 
    end
        
        img = imgaussfilt(imgorig,4);
        thres=graythresh(imgorig);
        i2=~(im2bw(img,thres));
        i2 = bwareafilt(i2, 1);

        
        %{
        bwareaopen  removes all connected components (objects) 
        that have fewer than P pixels from the 
        binary image BW producing another binary image BW2. This 
        operation is known as an area opening.
        %}
        
        i2 = bwareaopen(i2, 1000);


        i3=i2;

        %applying morphological operatiors
        i2 = bwmorph(i2,'remove');
        i2 = bwmorph(i2,'thicken',1);
        i2 = bwmorph(i2,'diag');

        %Extract objects from binary image by size 1 in parameter shows 
        %the largest object which is ofcourse the main object.
        binaryImage = bwareafilt(i2, 1);

        %Label connected components in 2-D binary image
        labeledImage = bwlabel(binaryImage);


        measurements = regionprops(labeledImage, 'BoundingBox');

        boundingBox = measurements(1).BoundingBox;


        P=boundingBox(3);


        %inserting a bounding box
        imgorig = insertObjectAnnotation(imgorig, 'rectangle', boundingBox, 'obstacle');

        Distance = (initial_act_width * F) / P;


        %Display it
        hImage = subplot(1, 1, 1);
        image(imgorig);
        caption = sprintf('Distance%6.0f inches', Distance);
        title(caption, 'FontSize', fontSize);
        drawnow; % Force it to refresh the window.         


        if(Distance < 18) 
            if(~alarm1)
                play(warning_lvl_1);
                alarm1 = 1;
            end
        end
        if(Distance < 13)
            if(~alarm2)
                stop(warning_lvl_1)
                play(warning_lvl_2);
                alarm2 = 1;
            end
        end

         
         display(Distance);


         i=i+1;
end
