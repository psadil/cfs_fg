function [  ] = kludgeStart( varargin )
%kludgeStart Superstititious workaround for VBLSyncTest failures

ip = inputParser;
addParameter(ip,'worked', 0, @isnumeric);
addParameter(ip,'stereoMode', 1, @isnumeric);
addParameter(ip,'winCol', 0, @isnumeric);
parse(ip,varargin{:});
% input = ip.Results;

%%
screenNumber=max(Screen('Screens'));
% screensize=Screen('Rect', screenNumber);

%%
window = Screen('OpenWindow',screenNumber);

% test refresh rate
fps=Screen('FrameRate',window);
if abs(fps - 120) > 2
    instr = 1;
else
    instr = 0;
end

sca;

% if error in refresh rate, correct now
if instr
    errordlg('Please set the refresh rate to 120');
end


end

