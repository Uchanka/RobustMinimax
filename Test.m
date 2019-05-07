File_1 = fopen('Cluster1.txt','r');
formatSpec = '%d %d';
size = [2 Inf];
Cluster_1 = fscanf(File_1,formatSpec,size);

File_2 = fopen('Cluster2.txt','r');
Cluster_2 = fscanf(File_2,formatSpec,size);

cov_c1 = cov(Cluster_1(1,:),Cluster_1(2,:));
cov_c2 = cov(Cluster_2(1,:),Cluster_2(2,:));

mu_c1 = mean(Cluster_1,2);
mu_c2 = mean(Cluster_2,2);
[a, b] = Core(mu_c1, mu_c2, cov_c1, cov_c2);


scatter(Cluster_1(1,:),Cluster_1(2,:),5,'m','filled')
hold on
scatter(Cluster_2(1,:),Cluster_2(2,:),5,'g','filled')

min_x = min([Cluster_1(1,:),Cluster_2(1,:)]);
max_x = max([Cluster_1(1,:),Cluster_2(1,:)]);
x = linspace(min_x,max_x, 1000);
y = (b-a(1)*x)/a(2);
plot(x,y,'b');