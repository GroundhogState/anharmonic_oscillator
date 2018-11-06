function ds_data = downsample_fit(y,T,f_samp,P,jitter)
    % Returns:  nlmfit object from fitting downsampled signal with 
    %               a damped sine wave. 
    %           Reconstructed trap frequency               
    % Inputs:   time and position vectors for full motion, 
    %           Sampling frequency
    %           Actual frequency of motion (for auto-Nyquist)
    
    
    t_samp = [min(T),max(T)];
    sample_times = t_samp(1):1/f_samp:t_samp(2);
    trap_freq = sqrt(P(2)/P(1))/(2*pi);
    s_guess = [trap_freq,-pi/2,0,0];
    if jitter
        sample_times = sample_times + 1.5e-4*randn(size(sample_times));      
    end
    master_fit = fitnlm(T,y,@damped_sine,s_guess);
    sample_values = damped_sine(master_fit.Coefficients.Estimate,sample_times);
    %Fitting downsampled data
    N_nyquist = 2*(trap_freq-mod(trap_freq, f_samp/2))/f_samp;
    ds_data.N = N_nyquist;
    f_apparent = abs(trap_freq - (N_nyquist-mod(N_nyquist,2))*f_samp/2);
    ds_guess = [f_apparent,-pi/2,0,0]; %freq phase damp offset
    %Fit downsampled sine wave
    ds_data.ds_fit = fitnlm(sample_times,sample_values,@damped_sine,ds_guess);
    ds_freq = ds_data.ds_fit.Coefficients.Estimate(1);
    ds_data.recon_freq = abs((N_nyquist-mod(N_nyquist,2))*f_samp/2+ds_freq); 
end