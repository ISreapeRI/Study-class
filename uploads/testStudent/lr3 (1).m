clc
clear
close all
warning('off')


num=[0 1 -2];
den=[4 5 2 1];
W=tf(num,den);
figure
bode(W)
grid on
figure
step(W)
grid on

%% задание №1
w=linspace(0,2.5,41);
delta_w=w(2)-w(1);

t=0:0.0001:400;

i=2;
u=sin(w(i)*t);
figure
lsim(W,u,t)
grid on

rad = (-0.88)*w(i)
grad = rad*180/pi


figure
[y,t]=lsim(W,u,t);
plot(t,u)
hold on
plot(t,y)
grid on
legend('u(t)','y(t)')

figure
[mag0,phase,w]=bode(W);
mag=20*log10(mag0);
mag=squeeze(mag);
phase=squeeze(phase);
subplot(2,1,1)
semilogx(w,mag)
title('ЛАЧХ и ЛФЧХ')
ylabel('Амплитуда, дБ')
grid on
subplot(2,1,2)
semilogx(w,phase)
xlabel('Частота, рад/с')
ylabel('Фаза, град')
grid on

figure
[Ax,fix,wx]=bode(W);
Ax = reshape(Ax,[1,numel(Ax)]); 
fix = reshape(fix,[1,numel(fix)]); 
fix = fix*pi/180;
subplot(2,1,1) 
plot(wx,Ax)
title('ЛАЧХ и ЛФЧХ')
ylabel('Амплитуда,abs')
grid on
axis([0 2.5 -inf inf])
subplot(2,1,2)
plot(wx,fix)
xlabel('Частота, рад/с')
ylabel('Фаза, град')
grid on
axis([0 2.5 -inf inf])
hold off

w=linspace(0,2.5,41);
A_w = [2.02;2.1;2.24;2.47;2.82;3.3;3.78;3.68;2.96;2.11;1.48;1.14;0.953;0.742;0.616;0.503;0.404;0.373;0.314;0.261;0.219;0.192;0.178;0.153;0.144;0.133;0.115;0.117;0.102;0.088;0.087;0.0795;0.078;0.0731;0.0645;0.0611;0.0598;0.0568;0.0563;0.056]';
fi_w = [172.2454;170.4549;155.7729;140.3747;128.9155;107.4296;85.2275;51.5662;19.3373;-3.5810;-15.7563;-30.0803;-37.2423;-45.1204;-48.3433;-51.5662;-60.8768;-64.4578;-68.0387;-71.6197;-82.7208;-86.6599;-90.5990;-94.5380;-94.0009;-97.7609;-99.1038;-100.2676;-103.8486;-107.4296;-111.0106;-114.5916;-115.8091;-116.8834;-120.3211;-121.1806;-123.2217;-123.8305;-125.6926;-126.0507]';
w_w = w(2:end);
figure
subplot(2,1,1)
plot(w_w,A_w)
grid on
ylabel('Амплитуда,abs')
title('экспериментальные ЛАЧХ и ЛФЧХ')
subplot(2,1,2)
plot(w_w,fi_w)
grid on
ylabel('Фаза,град')
xlabel('Частота, рад/с')



%% задание №2
close all
h=0.7746/5/bandwidth(W);
W_d = c2d(W,h);
q=0.1;
N=4000;
N_w=100;
sys = ss(W_d);
a = sys.a;
b = sys.b;
c = sys.c;
M = 0.1*N;
t_m = M*h;
t=-t_m:h:t_m;

for j=1:N_w
x=[];
y=[];
u=sqrt(q)*randn(1,N);
x=[0 0 0]';

    for i = 1:N-1
        x(:,i+1) = a*x(:,i)+ b*u(i);
        y(i) = c*x(:,i);
    end
y(i+1)=y(i);
Rx = xcorr(u(1,:),u(1,:),M)/N;
Ryx = xcorr(y,u(1,:),M)/N;

Sx = fft(Rx);
Syx = fft(Ryx);

Wj_omega(j,:) = Syx./Sx;

 if j==1
    figure
    plot(t,Rx)
    grid on
    title('Корреляционная функция входного сигнала')
    xlabel('t,c')
    ylabel('R_x(t)')

    figure
    plot(t,Ryx)
    grid on
    title('Корреляционная функция входного и выходного сигнала')
     xlabel('t,c')
    ylabel('R_{yx}(t)')
%     P = real(Wj_omega);
%     Q = imag(Wj_omega);
%     P = P(M+1:end);
%     Q = Q(M+1:end);
 end
end
s=size(Wj_omega);
for i=1:s(2)
Wj_omega_sr(i) = sum(Wj_omega(:,i))/N_w;
end

[re,im]=nyquist(W);
re=squeeze(re);
im=squeeze(im);
Re=real(Wj_omega_sr);
Im=imag(Wj_omega_sr);
figure
plot(Re(1:401),Im(1:401))
hold on
plot(re,im,'g')
grid on
xlabel('Re(W(j\omega))')
ylabel('Im(W(j\omega))')
title('График АФЧХ при усреднении = 100')
legend('Экспериментальная АФЧХ','Теоретическая АФЧХ')
hold off


delta_w = pi/M/h;
w2 = 0:delta_w:M*delta_w;
A2 = sqrt(Re(1:401).^2+ Im(1:401).^2);


figure
subplot(2,1,1)
plot(w2,A2)
grid on
hold on
plot(wx,Ax)
title('График АЧХ при усреднении = 100')
xlabel('\omega,рад/с')
ylabel('А(\omega)')
legend('Экспериментальная АЧХ','Теоретическая АЧХ')
axis([-inf max(w2) -inf inf])
fi2 = unwrap(angle(Wj_omega_sr(1:401)));
subplot(2,1,2)
plot(w2,fi2)
hold on
plot(wx,fix)
grid on
axis([-inf max(w2) -inf inf])
title('График ФЧХ при усреднении = 100')
xlabel('\omega,рад/с')
ylabel('(\phi\omega)')
legend('Экспериментальная ФЧХ','Теоретическая ФЧХ')

hold off


for i=1:M+1
   k(i) = Ryx(M+i)/q/h; 
end

[y,t0]=impulse(W);
figure
plot(t(401:end),k)
grid on
hold on
plot(t0,y)
legend('экспериментальная ИПФ','теоретическая ИПФ')
title('Импульсная переходная функция')
xlabel('t,c')
ylabel('k(t)')


% МНК

n=3;
m=2;
a0=1;
w = 0:h:t_m;
P = Re(1:M+1);
Q = Im(1:M+1);
F=[];
y=[];
for i =1:numel(w)
    F = [F; -Q(i)*w(i) -P(i)*(w(i))^2 Q(i)*(w(i))^3 -1 0 (w(i))^2; P(i)*w(i) -Q(i)*(w(i))^2 -P(i)*(w(i))^3 0 -w(i) 0];
    y = [y;-P(i);-Q(i)];
end
teta = inv(F'*F)*F'*y
Wmnk = tf([teta(6) teta(5) teta(4)],[teta(3) teta(2) teta(1) 1]);

figure
[mag0,phase,w]=bode(Wmnk);
mag=20*log10(mag0);
mag=squeeze(mag);
phase=squeeze(phase);
subplot(2,1,1)
semilogx(w,mag)
title('ЛАЧХ и ЛФЧХ (МНК)')
ylabel('Амплитуда, дБ')
grid on
axis([-inf max(w) -inf inf])
subplot(2,1,2)
semilogx(w,phase)
xlabel('Частота, рад/с')
ylabel('Фаза, град')
axis([-inf max(w) -inf inf])
grid on

figure
[y,t]=step(Wmnk);
plot(t,y)
title('Переходная функция (МНК)')
xlabel('t,c')
ylabel('h(t)')
grid on
