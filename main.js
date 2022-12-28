const icon_state = {'folder':0, 'folder_open':1};
const disp_icon = {0:'folder', 1:'folder_open'};
const text_state = {'none':0, '':1};
const disp_text = {0:'none', 1:''};

function folder_click(groupname) {
    document.getElementById(groupname+'_icon').innerHTML=disp_icon[1-icon_state[document.getElementById(groupname+'_icon').innerHTML]];
    const elem = document.getElementsByClassName(groupname+'_elem');
    const disp = disp_text[1-text_state[elem[0].style.display]];
    for(var i = 0; i < elem.length; ++i) {
        elem[i].style.display = disp;
    }
}