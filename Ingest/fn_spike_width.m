function [wav,spk_width,xwave] = fn_spike_width (avgWave)
wav=[];
spk_width=[];
xwave=[];
if ~isempty(avgWave)
    if numel(avgWave)==123
        wav=avgWave(41:82); %avgWave(41:82);
        xwave = 1000.*(1:numel(wav))./25000;
        [temp max_idx] = max(wav);
        [temp min_idx] = min(wav(max_idx:end));
    elseif numel(avgWave)==51
        wav=avgWave(5:46); % to make consistent with the shorter wave of the format above
        xwave = 1000.*(1:numel(wav))./25000;
        [temp max_idx] = max(wav);
        [temp min_idx] = min(wav(max_idx:end));
    end
    spk_width = min_idx*mean(diff(xwave));
end
