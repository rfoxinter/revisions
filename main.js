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

window.addEventListener('DOMContentLoaded', () => {
    document.querySelector('#menu-button').addEventListener('click', function() {
        document.body.style.overflow = "hidden";
        document.body.classList.toggle('open');
    });

    document.querySelector('#close-button').addEventListener('click', function() {
        document.body.style.overflow = "unset";
        document.body.classList.remove('open');
    });

    document.querySelector('#overlay').addEventListener('click', function() {
        document.body.style.overflow = "unset";
        document.body.classList.remove('open');
    });

    const menuButton = document.querySelector('#menu-button');
    const menu = document.querySelector('#close-button');
    const overlay = document.querySelector('#overlay');
    
    menuButton.addEventListener('click', function() {
        menu.classList.toggle('open');
        overlay.style.display = 'block'; /* show the overlay */
        setTimeout(function() {
            overlay.style.opacity = '1'; /* fade in the overlay */
        }, 10);
    });
    
    menu.addEventListener('click', function() {
        menu.classList.remove('open');
        overlay.style.opacity = '0'; /* fade out the overlay */
        setTimeout(function() {
            overlay.style.display = 'none'; /* hide the overlay */
        }, 300);
    });
    
    overlay.addEventListener('click', function() {
        menu.classList.remove('open');
        overlay.style.opacity = '0'; /* fade out the overlay */
        setTimeout(function() {
            overlay.style.display = 'none'; /* hide the overlay */
        }, 300);
    });
});
