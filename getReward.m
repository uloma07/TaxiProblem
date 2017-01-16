function [reward,taxiLocation,pickupSteps,psgrlocation,passengerPicked,passengerDropped] = getReward(action,taxiLocation,pickupSteps,psgrlocation,passengerPicked,passengerDropped,dropOffLocation)

    reward = 0;
    %Reward is 0, except in the following cases:
    if action == 5 & taxiLocation == psgrlocation & ~passengerPicked  % 1 for a successful pick-up
        reward = 1;
        passengerPicked = true; 
        passengerDropped = false;
        psgrlocation = taxiLocation;
    elseif action == 5 & (taxiLocation ~= psgrlocation || passengerPicked)   % -1 for an attempted pick-up at the wrong location (or if the passenger is already in the taxi)
        reward = -1;
    elseif action == 6 & taxiLocation == dropOffLocation & passengerPicked %10/(number of steps since pick-up) for a successful drop-off,
        reward = 10/(pickupSteps+1);
        passengerDropped = true;
        passengerPicked = false;
        psgrlocation = taxiLocation;
    elseif action == 6 & (taxiLocation ~= dropOffLocation || ~passengerPicked) %-1 for an attempted drop-off with no passenger or at the wrong location
        reward = -1;    
    elseif action < 5 % move        
        [taxiLocation,reward] = attemptMove(taxiLocation,action);    
        if reward == 0 & passengerPicked
            pickupSteps = pickupSteps+1;
            psgrlocation = taxiLocation;
        end
    end
end