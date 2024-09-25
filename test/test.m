function test
global g
g.num=0;
%f=figure('ButtonDownFcn',@esd_location)
f=figure('units','pixels','outerposition',[100 100 800 600]);
ax=gca;
img=imread('dut.jpg');
h=imshow(img);
set(h,'ButtonDownFcn',@esd_location);

end
function esd_location(h,eventdata)
global g
switch  eventdata.Button
    case 1
            g.num=g.num+1;
            ax=gca;
            ax.Units='pixels'
            g.mtextbox(g.num)=uicontrol('style','text','ButtonDownFcn',@deleteself);
            g.mtextbox(g.num).String=num2str(g.num);
            x=ax.CurrentPoint(1,1)+ax.Position(1)-7.5;
            y=ax.Position(4)-ax.CurrentPoint(1,2)+ax.Position(2)-7.5;
            g.mtextbox(g.num).Units='pixels';
            g.mtextbox(g.num).Position=[ x y 15 15];
end
            
end



function deleteself(h,eventdata)
switch eventdata.Source.Parent.SelectionType
    case 'alt'
    delete(h);
end

end




