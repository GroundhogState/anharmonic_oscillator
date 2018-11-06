function rs_data = resample_fit(y,T,f_samp,trap_freq,interp)
    % Returns:  nlmfit object from fitting downsampled signal with 
    %               a damped sine wave. 
    %           Reconstructed trap frequency               
    % Inputs:   time and position vectors for full motion, 
    %           Sampling frequency
    %           Actual frequency of motion (for auto-Nyquist)
    
    
    t_samp = [min(T),max(T)];
    sample_times = t_samp(1):1/f_samp:t_samp(2);
    [~ ,sample_idxs]= arrayfun(@(x) min(abs(x-T)),sample_times);
    if interp
        sample_values = interp1(T,y,sample_times);
    else
        sample_values = y(sample_idxs,1);
    end
    samp_times = T(sample_idxs);

    %Fitting downsampled data
    N_nyquist = 2*(trap_freq-mod(trap_freq, f_samp/2))/f_samp;
    rs_data.N = N_nyquist;
    f_apparent = abs(trap_freq - (N_nyquist-mod(N_nyquist,2))*f_samp/2);
    ds_guess = [f_apparent,-pi/2,0,0]; %freq phase damp offset
    %Fit downsampled sine wave
    rs_data.ds_fit = fitnlm(samp_times,sample_values,@damped_sine,ds_guess);
    ds_freq = rs_data.ds_fit.Coefficients.Estimate(1);
    rs_data.recon_freq = abs((N_nyquist-mod(N_nyquist,2))*f_samp/2+ds_freq); 
end