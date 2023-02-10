X = 1; V=1;

N = 100;

N=400, c1=0.3, c2=0.3,c3=5,c4=5; A=10, V=10; a = 10; delta = 1;

x = X*randn(3,N);
v = V*randn(3,N);

v_new = v + a * delta;
x_new = x + v_new *delta;
v = v_new;
x = x_new;
plot3(x(1,:),x(2,:),x(3,:),'k+','Markersize',.5);
drawnow;


a1=zeros(3,N)
a2=zeros(3,N)
a3=zeros(3,N)
for n=1:N
    for m=1:N
        if m ~= n
            r = x(:,m)-x(:,n);
            vr = v(:,m)-v(:,n);
            rmag=sqrt(r(1,1)^2+r(2,1)^2+r(3,1)^2);
            a1(:,n) = a1(:,n) - c1*r/rmag^2;
            a2(:,n) = a2(:,n) + c2*r ;
            a3(:,n) = a3(:,n) + c3*vr;
        end
    end
end
a4(:,n) = c4*randn(3,1);

plot3(x(1,:),x(2,:),x(3,:),'k+','Markersize',.5);
drawnow;