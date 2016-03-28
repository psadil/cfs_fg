function listen(debugLevel, string)

% string -- typically either 'enter,' 'space,' or 'return'

if debugLevel > 0
    rob = java.awt.Robot;
    eval([ 'rob.keyPress(java.awt.event.KeyEvent.VK_', upper(string), ');' ]);
    eval([ 'rob.keyRelease(java.awt.event.KeyEvent.VK_', upper(string), ');' ]);
    
end

end