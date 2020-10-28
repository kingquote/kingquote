function area(inp::Circle)
    r = inp.radius
    a = π*(r^2)
    return(a)
end
function area(inp::Square)
    s = inp.side
    a = s^2
    return(a)
end