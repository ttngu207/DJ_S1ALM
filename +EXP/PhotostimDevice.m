%{
# 
photostim_device            : varchar(20)                   # 
---
excitation_wavelength       : decimal(5,1)                  # (nm)
photostim_device_description: varchar(255)                  # 
%}


classdef PhotostimDevice < dj.Lookup
     properties
        contents = {
            'LaserGem473' 473 'Laser (Laser Quantum, Gem 473)'
            'LED470' 470 'LED (Thor Labs, M470F3 - 470 nm, 17.2 mW (Min) Fiber-Coupled LED)'
            }
    end
end