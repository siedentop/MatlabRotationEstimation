run('vlfeat-0.9.18/toolbox/vl_setup.m')
addpath('ransac');
[frames, cmap] = imread('kbGaw.gif');

[w, h, ~, n] = size(frames);
grayframes = single(zeros(w, h, n));
for i=1:size(frames, 4)
    % Convert indexed image to grayscale through RGB.
    rgb = ind2rgb(frames(:,:,:,i), cmap);
    grayframes(:,:,i) = single(rgb2gray(rgb));
end

imshow(grayframes(:,:,1))
arrow = grayframes(305:355,285:335,1);
imshow(arrow);
[kp1, desc1] = vl_sift(arrow);

for i=1:10
    [kp2, desc2] = vl_sift(grayframes(:,:,i));
    matches = vl_ubcmatch(desc1, desc2);
    figure;plotmatches(arrow, grayframes(:,:,i), kp1, kp2, matches);
end
