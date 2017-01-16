function [newLocation,reward] = attemptMove(grdLocation,action)
    if action == 3 && ~isempty(find(grdLocation == [1 6 11 16 21 7 2 23 18 9 4],1)) 
        newLocation = grdLocation;
        reward = -1;
    elseif action == 2 && ~isempty(find(grdLocation == [1 2 3 4 5],1))
        newLocation = grdLocation;
        reward = -1;
    elseif action == 4 && ~isempty(find(grdLocation == [5 10 15 20 25 6 1 22 17 8 3],1)) 
        newLocation = grdLocation;
        reward = -1;
    elseif action == 1 && ~isempty(find(grdLocation == [21 22 23 24 25],1))
        newLocation = grdLocation;
        reward = -1;
    else 
        newLocation = move(grdLocation,action);        
        reward = 0;
    end
end