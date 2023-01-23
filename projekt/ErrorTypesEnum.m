classdef ErrorTypesEnum
    
    properties (Constant)
        
        OutOfBoundsUpwards = 1;
        OutOfBoundsDownwards = 2;
        OutOfBoundsLeft = 3;
        OutOfBoundsRight = 4;
        CollidedOccupied = 5;
        CollidedTouching = 6;
        None = 0;
    end
end