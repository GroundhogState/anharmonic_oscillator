function dX = trap_DE(t,X,p)
    dX(1) = X(2) - 2*p(3)*X(1);
    dX(2) = (-p(2)*X(1) - (p(4)*X(1)^2)/2 - (p(5)*X(1)^3)/6)/p(1);
    dX = dX';
end %function