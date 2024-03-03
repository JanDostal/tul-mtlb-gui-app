classdef ShipOrientationsEnum < double

    enumeration
        
        Upwards (1) % hodnota v dropdownu v sekci vyber tvych lodi v UI
        Downwards (2) % hodnota v dropdownu v sekci vyber tvych lodi v UI
        Left (3) % hodnota v dropdownu v sekci vyber tvych lodi v UI
        Right (4) % hodnota v dropdownu v sekci vyber tvych lodi v UI
    end

    methods

        function value = getValue(obj)

            value = double(obj);
        end
    end
end