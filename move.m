function newLocation = move(grdLocation,action)
    if action == 1
        newLocation = grdLocation + 5;
    elseif action == 2
        newLocation = grdLocation - 5;
    elseif action == 3
        newLocation = grdLocation - 1;
    else 
        newLocation = grdLocation + 1;
    end   
end