rob = java.awt.Robot;

rob.keyPress(java.awt.event.KeyEvent.VK_1);
rob.keyRelease(java.awt.event.KeyEvent.VK_1);

% peval([ 'rob.keyPress(java.awt.event.KeyEvent.VK_', upper(1), ');' ]);
% eval([ 'rob.keyRelease(java.awt.event.KeyEvent.VK_', upper(1), ');' ]);