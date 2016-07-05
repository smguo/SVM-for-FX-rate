function kval = K_gaussian(u,v,param)

nu = size(u,1);
nv = size(v,1);

norm_u = sqrt(sum(u.^2,2));
norm_v = sqrt(sum(v.^2,2));

k1 = u*v';

kval = exp(-0.5*(repmat(norm_u.^2,1,nv)-2*k1+repmat(norm_v'.^2,nu,1))/param^2);

