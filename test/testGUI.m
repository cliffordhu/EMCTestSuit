function testGUI
f = figure('Visible', 'off', 'Position', [360, 500, 450, 285]);
hbutton = uicontrol('Style', 'pushbutton', 'String', 'Add Point', 'Position', [315, 220, 90, 25]);
ha = axes('Units', 'pixels', 'Position', [50, 60, 200, 185]);
imagesc(ha, [1,2; 3,4])
colormap gray
f.Visible = 'on';
hbutton.Callback = @buttonCallback;
ha.ButtonDownFcn=@AxesCallback;
children=ha.Children;
for n=1:numel(children)
    children(n).ButtonDownFcn=@AxesCallback;
end
handles=struct;handles.f=f;handles.ha=ha;handles.hbutton=hbutton;
handles.waitforbuttonpress=false;%set default
guidata(f,handles)
end
function buttonCallback(h, e)
handles=guidata(h);
handles.hbutton.String = 'Click on image...';
handles.waitforbuttonpress=true;
guidata(handles.f,handles)
end
function pointerPosition = getPointerPosition
currentPoint = get(gca, 'CurrentPoint');
pointerPosition = currentPoint(1, 1:2);
end
function AxesCallback(h,e)
handles=guidata(h);
if ~handles.waitforbuttonpress
    return
end
pointerPosition = getPointerPosition;
if ~any(pointerPosition < 0.5) && ~any(pointerPosition > 2.5)
    hold on
    plot(handles.ha, pointerPosition(1), pointerPosition(2), 'ro')
    hold off
end
handles.hbutton.String = 'Add Point';
handles.waitforbuttonpress=false;
guidata(handles.f,handles)
end