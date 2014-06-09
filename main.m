%% Find rotation of wheel between frames
% http://stackoverflow.com/questions/24086130/how-to-detect-the-rotation-angle-of-coordinates-in-an-image/24086922#24086922
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

% Find matching keypoints between frames
[kp1, desc1] = vl_sift(grayframes(:,:,1));
[kp2, desc2] = vl_sift(grayframes(:,:,2));
matches = vl_ubcmatch(desc1, desc2);
% Pass keypoints to RansacAffine
[T, inliers1] = ransacfitaffine(kp1, kp2, matches, 0.001);
plotmatches(grayframes(:,:,1), grayframes(:,:,2), kp1, kp2, matches(:,inliers1));

outliers = setdiff(1:length(matches), inliers1);
outlier_matches = matches(:,outliers);

center = [221; 454]; % Manually found on frame1
[R, inliers2] = ransacfitrotation(kp1, kp2, outlier_matches, center, 0.01);
figure;
plotmatches(grayframes(:,:,1), grayframes(:,:,2), kp1, kp2, outlier_matches(:,inliers2));

