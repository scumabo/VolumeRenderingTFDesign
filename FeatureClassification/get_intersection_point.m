function [x, y] = get_intersection_point( f1, f2 )
%returns intersection point if found, otherwise returns 0


%n_els = max(size(f1,1), size(f2,2));

n_start = find( f1==0 ) + 1;
n_end = find( f2==0 ) - 1;

x = 0;
y = 0;

for n = n_start:n_end
    % forward in x-direction, ax, cx = n; bx, dx = n+1;
    
    ay = f1(n);
    by = f1(n+1);
    
    cy = f2(n);
    dy = f2(n+1);  
        
    if ((cy > ay) && (by > dy))
        
        x = n;
        y = f1(n);
        
        return;
    end
    
end