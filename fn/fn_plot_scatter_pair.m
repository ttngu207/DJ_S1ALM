function fn_plot_scatter_pair (data, n)

for ii_n = 1:n
    for jj_n = 1:n
        subplot(n,n,(ii_n-1)*n + jj_n)
        plot(data(:,ii_n),data(:,jj_n),'.')
        xlabel(sprintf('Score PC %d ',ii_n));
        ylabel(sprintf('Score PC %d ',jj_n));
    end
end