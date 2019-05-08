clear all
clc

data_happy_dir = '.\AffectNet\data_happy\';
data_sad_dir = '.\AffectNet\data_sad\';

happy_train = zeros(32,32,300);
sad_train = zeros(32,32,300);

happy_test = zeros(32,32,130);
sad_test = zeros(32,32,130);

for i=1:300
    
   fname_happy = strcat(data_happy_dir,int2str(i),'.jpg');
   fname_sad = strcat(data_sad_dir,int2str(i),'.jpg');
   
   im_happy = imread(fname_happy);
   im_sad = imread(fname_sad);
   
   if length(size(im_happy))==3
       im_happy = rgb2gray(im_happy);
   end
   
   if length(size(im_sad))==3
       im_sad = rgb2gray(im_sad);
   end
   
   im_happy = double(im_happy); 
   happy_train(:,:,i) = im_happy;
   
   im_sad = double(im_sad); 
   sad_train(:,:,i) = im_sad;
   
end

for j=1:130
    
   fname_happy = strcat(data_happy_dir,int2str(300+j),'.jpg');
   fname_sad = strcat(data_sad_dir,int2str(300+j),'.jpg');
   
   im_happy = imread(fname_happy);
   im_sad = imread(fname_sad);
   
   if length(size(im_happy))==3
       im_happy = rgb2gray(im_happy);
   end
   
   if length(size(im_sad))==3
       im_sad = rgb2gray(im_sad);
   end
   
   im_happy = double(im_happy); 
   happy_test(:,:,j) = im_happy;
   
   im_sad = double(im_sad); 
   sad_test(:,:,j) = im_sad;
   
end

happy_train = reshape(happy_train,[32*32,300]);
sad_train = reshape(sad_train,[32*32,300]);

happy_test = reshape(happy_test,[32*32,130]);
sad_test = reshape(sad_test,[32*32,130]);

mu_happy = mean(happy_train,2);
mu_sad = mean(sad_train,2);

cov_happy = cov(happy_train');
cov_sad = cov(sad_train');


[a, b] = Core(mu_happy, mu_sad, cov_happy, cov_sad);

