function timeStretch(DAFx_in, fs, ratio, startTime, endTime)
% function timeStretch(fileName, ratio)
%     (based on DAFx Book, ch08/VX_tstretch_real_pv.m)
%===== this program performs time stretching 
%===== using the FFT-IFFT approach, 
%===== for real ratio, and using
%===== w1 and w2 windows (analysis and synthesis)
%===== WLen is the length of the windows
%===== n1 and n2: steps (in samples) for the analysis and synthesis

if (nargin < 2) || (ratio <= 0)
	error('usage: timeStretch(fileName, ratio)');
end

%----- user data -----
n2           = 512;
n1           = round(n2 / ratio);
WLen         = 2048;
w1           = hanningz(WLen);
w2           = w1;
%[DAFx_in, fs] = wavread(fileName);
if size(DAFx_in, 2) > 1
	DAFx_in = mean(DAFx_in,2);
end
DAFx_in      = DAFx_in(startTime*fs:endTime*fs);

L            = length(DAFx_in);
DAFx_in      = [zeros(WLen, 1); DAFx_in; ...
   zeros(WLen-mod(L,n1),1)] / max(abs(DAFx_in));

%----- initializations -----
tstretch_ratio = n2/n1;
DAFx_out = zeros(WLen+ceil(length(DAFx_in)*tstretch_ratio),1);
omega    = 2*pi*n1*[0:WLen-1]'/WLen;
phi0     = zeros(WLen,1);
psi      = zeros(WLen,1);

%tic
%UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
pin  = 0;
pout = 0;
pend = length(DAFx_in)-WLen;
while pin<pend
	grain = DAFx_in(pin+1:pin+WLen).* w1;
%===========================================
	f     = fft(fftshift(grain));
	r     = abs(f);
	phi   = angle(f);
	delta_phi= omega + princarg(phi-phi0-omega);
	phi0  = phi;
	psi   = princarg(psi+delta_phi*tstretch_ratio);
	ft    = (r.* exp(i*psi));
	grain = fftshift(real(ifft(ft))).*w2;
	% plot(grain);drawnow;
% ===========================================
	DAFx_out(pout+1:pout+WLen) = ...
	   DAFx_out(pout+1:pout+WLen) + grain;
	pin  = pin + n1;
	pout = pout + n2;
end

DAFx_out = DAFx_out(WLen+1:length(DAFx_out))/max(abs(DAFx_out));


sound(DAFx_out, fs)
%UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
%toc
%{
%----- listening and saving the output -----
%DAFx_in  = DAFx_in(WLen+1:WLen+L);
DAFx_out = DAFx_out(WLen+1:length(DAFx_out))/max(abs(DAFx_out));
% soundsc(DAFx_out, FS);
outName = [fileName(1:end-4) sprintf('%3.1f', ratio) '.wav'];
wavwrite(DAFx_out, FS, outName);
system(['play --silent ' outName]);
%}
