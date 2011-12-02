function [ret,risk] = annret(rets)

risk=std(rets,1);
rets=log(1+rets/100);
ret=(exp(sum(rets)/length(rets))-1)*100;
