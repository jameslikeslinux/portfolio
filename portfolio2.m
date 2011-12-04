function [stddevs,annrets] = portfolio2()

% Wilshire 5000
% 1971-2010
% Source: http://www.wilshire.com/Indexes/calculator/csv/w500fpidm.csv
w5000rets=[17.64 17.98 -18.53 -28.39 38.49 26.58 -2.63 9.29 25.56 33.65 -3.77 18.70 23.46 3.04 32.55 16.09 2.27 17.93 29.18 -6.18 34.21 8.97 11.29 -0.05 36.43 21.20 31.28 23.44 23.57 -10.89 -10.96 -20.86 31.65 12.49 6.38 15.77 5.62 -37.23 28.30 17.17];
w5000rets=w5000rets-0.24; % Subtract expenses for TCEPX

% MSCI EAFE
% 1970-2010
% Source: http://financeandinvestments.blogspot.com/2011/08/historical-returns-for-msci-eafe-index.html
eaferets=[-11.66 29.59 36.35 -14.92 -23.16 35.39 2.54 18.06 32.62 4.75 22.60 -2.27 -1.86 23.69 7.41 56.14 69.46 24.64 28.26 10.53 -23.45 12.14 -12.18 32.57 7.78 11.21 6.05 1.78 20 26.96 -14.17 -21.44 -15.94 38.59 20.25 13.54 26.34 11.17 -43.38 31.78 7.75];
eaferets=eaferets-0.25; % Subtract expenses for TRIPX

% MSCI EAFE
% 1971-2010
eaferets=eaferets(2:end); 

% Equities
% 1971-2010
% A 50/50 allocation of domestic and international stocks
eqrets=w5000rets*0.5+eaferets*0.5;

% Equities
% 1978-2010
eqrets=eqrets(8:end);

% Equities
% 1996-2010
%eqrets=eqrets(19:end);

% NCREIF
% 1978-2010
% Source: http://www.ncreif.org/property-index-returns.aspx
ncreif=[16.11 20.46 18.09 16.62 9.43 13.13 13.84 11.24 8.30 8.00 9.62 7.77 2.30 -5.59 -4.26 1.38 6.39 7.54 10.31 13.91 16.24 11.36 12.24 7.28 6.74 8.99 14.48 20.06 16.59 15.84 -6.46 -16.86 13.11];

% Wilshire RESI
% 1978-2010
% Source: http://www.wilshire.com/Indexes/calculator/csv/wresfpidm.csv
resi=[13.04 70.81 22.08 7.18 24.47 27.61 20.64 20.14 20.30 -7.86 24.18 2.37 -33.46 20.03 7.40 15.23 1.64 13.65 36.87 19.80 -17.43 -3.17 30.71 10.46 2.66 37.06 34.81 13.83 35.67 -17.67 -39.83 29.19 29.12];

% Vanguard Prime Money Market Fund (VMMXX)
% 1977-2010
% Sources:
%   http://www.editgrid.com/user/philip/Vanguard-Historical-Returns-rev5
%   http://www.bu.edu/hr/files/documents/VANG_PRIME_MM_INV.pdf
vmmxx=[4.4 6.7 10.8 12.8 17.6 13.1 8.9 10.57 8.08 6.61 6.65 7.59 9.39 8.27 6.14 3.74 3.01 4.08 5.82 5.29 5.44 5.38 5.01 6.29 4.17 1.65 0.9 1.11 3.01 4.88 5.14 2.77 0.53 0.06];

% VMMXX
% 1978-2010
vmmxx=vmmxx(2:end);

% REA Composite Index (approximation)
% 1978-2010
% Info: http://www.tiaa-cref.org/public/about/how-we-invest/real-estate/rea_composite_comparison.pdf
reacompidx=ncreif*0.75+vmmxx*0.20+resi*0.05;
reacompidx=reacompidx-1.01; % Subtract expenses for TREA
ncreif=ncreif-1.01;

% REA Composite Index (approximation)
% 1996-2010
%reacompidx=reacompidx(19:end);

% TREA
% 1996-2010
% Source: http://www.tiaa-cref.org/public/performance/retirement/data/index.html
trea=[8.33 10.07 8.07 8.17 10.65 6.29 3.41 7.43 12.54 14.03 13.88 13.76 -14.14 -27.67 13.20];
trea=trea-1.01; % Subtract expenses for TREA

% Extrapolated TREA
% 1978-2010
[a,b]=correct(trea,reacompidx(19:end));
trealong=a*reacompidx+b;

% High Risk
% 1978-2010
hrlong=eqrets*0.8+trealong*0.2;

% High Risk
% 1996-2010
hrshort=eqrets(19:end)*0.8+trea*0.2;

% Barclays Capital US Aggregate Bond Index
% 1976-2010
% Source: http://www.bogleheads.org/wiki/Barclays_Capital_US_Aggregate_Bond_Index
bcbondidx=[15.60 3.00 1.40 1.90 2.70 6.30 32.60 8.40 15.15 22.11 15.26 2.76 7.89 14.53 8.96 16.00 7.40 9.75 -2.92 18.47 3.63 9.65 8.69 -0.82 11.63 8.44 10.26 4.10 4.34 2.43 4.33 6.97 5.24 5.93 6.54];
bcbondidx=bcbondidx-0.28; % Subtract expenses for TBIPX

% Barclays Capital US Aggregate Bond Index
% 1978-2010
bcbondidx=bcbondidx(3:end);

% Barclays Capital US Aggregate Bond Index
% 1996-2010
bcbondidxshort=bcbondidx(19:end);

stddevs=[];
annrets=[];

stddevs2=[];
annrets2=[];

stddevs3=[];
annrets3=[];

stddevs4=[];
annrets4=[];

for i=0:10:100
    rets=(bcbondidx*(100-i) + hrlong*i)./100;
    [ret,risk]=annret(rets);
    stddevs=[stddevs risk];
    annrets=[annrets ret];
end

for i=0:10:100
    rets=(bcbondidxshort*(100-i) + hrshort*i)./100;
    [ret,risk]=annret(rets);
    stddevs2=[stddevs2 risk];
    annrets2=[annrets2 ret];
end

%plot(stddevs, annrets, '-x');
plot(stddevs, annrets, '-x', stddevs2, annrets2, '-x');
%plot(stddevs, annrets, '-x', stddevs2, annrets2, '-x', stddevs3, annrets3, '-x');
%plot(stddevs, annrets, '-x', stddevs2, annrets2, '-x', stddevs3, annrets3, '-x', stddevs4, annrets4, '-x');
xlabel('Standard Deviation');
ylabel('Annualized Returns');
title('High Risk and Bond Fund Allocations for 1978-2010');
text(stddevs(1), annrets(1), 'Bond Fund 1978-');
text(stddevs2(1), annrets2(1), 'Bond Fund 1996-');
text(stddevs(end), annrets(end), 'High Risk 1978-');
text(stddevs2(end), annrets2(end), 'High Risk 1996-');

function [a,b] = correct(real, projected)
[realret,realrisk]=annret(real);
[projret,projrisk]=annret(projected);
a=realrisk/projrisk;
[projret,projrisk]=annret(projected*a);
b=realret-projret;
