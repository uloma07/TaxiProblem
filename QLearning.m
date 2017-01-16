%Initialisation of a trail
%State variables: taxiLocation {1, ..., 25}, 
%passengerLocation {1, ..., 5} 
%(i.e. waiting at pickup/drop-off {R,G,B,Y} or in the taxi),
%drop-offLocation {1, ..., 4} (i.e. {R,G,B,Y}).

%%
clear;
clc;
initTaxi = randi([1, 25]); %Taxi is uniformly randomly in any of the 25 grid squares
fixedLocations = [1,4,21,25,initTaxi];
initpsgr = fixedLocations(randi([1, 5])); %passengerLocation is uniformly randomly in one of the 5 passenger states
initDrop = fixedLocations(randi([1, 4])); %dropoffLocation is uniformly randomly one of the 4 drop-off locations
rewards = 1*ones(25,6);%0 + (0.001-0).*rand(25,6); % zeros(25,6); %initialise average reward gotten when each action is taken
inite = 0.6; % probability of exploration
discountFactor = 0.95;
counts =  zeros(25,6); %count of actions at each state or gridlocation 
episodes = 1000;
cummulativeReward = zeros(episodes,1);
totalReward = zeros(episodes,1);
initTaxi  
initDrop 
initpsgr 


%%
for episode=0:1:episodes-1
    taxiLocation = initTaxi;
    dropOffLocation = initDrop;
    psgrlocation = initpsgr;
    passengerDropped = false;
    passengerPicked = false;
    timeLimit = 25*6;
    pickupSteps = 0;    
    e = inite * (.05^episode);
    tr=0;
    
    while passengerDropped == false && timeLimit > 0 
        oldLocation = taxiLocation;
        action = chooseArm(e, rewards(oldLocation,:)); %returns the index of the arm chosen
        count = counts(oldLocation,action); %gets the number of times this arm has been used
        Q = rewards(oldLocation,action); %get the current Q state-action value

        [reward,taxiLocation,pickupSteps,psgrlocation,passengerPicked,passengerDropped] = getReward(action,oldLocation,pickupSteps,psgrlocation,passengerPicked,passengerDropped,dropOffLocation);
        
        
        if passengerPicked
            sprintf('passenger picked, episode: %d',episode)            
        end
        if passengerDropped
            sprintf('passenger Dropped, episode: %d',episode)            
        end
        
        lr = 0.8;%(1/(count+1)); % learning rate
        nextOptimum = max(rewards(taxiLocation,:));
        Qnew = Q + lr *(reward + ((discountFactor*nextOptimum)- Q));
        rewards(oldLocation,action) = Qnew;
        counts(oldLocation,action)= count + 1;
        tr=tr+reward;
        timeLimit = timeLimit - 1; %reduce time limit
    end
    cummreward = sum(rewards,2);
    cummulativeReward(episode+1,1) = mean(cummreward);
    totalReward(episode+1,1)=tr;
end

[maxrewards,policy] = max(rewards,[],2);

