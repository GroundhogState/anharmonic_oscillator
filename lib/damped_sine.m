function y = damped_sine(p,t) %freq phase damp offset
if length(p) >4
    y = p(5)*exp(-abs(p(3))*t).*sin(2*pi*p(1)*t-p(2))+p(4);
else
    y = exp(-abs(p(3))*t).*sin(2*pi*p(1)*t-p(2))+p(4);
end
end