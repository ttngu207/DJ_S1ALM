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
            }
    end
end