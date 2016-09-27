
function login_tabs(evn, to){
    var i, auth_tab, tablinks;
        auth_tab = document.getElementsByClassName("auth_tab");
        for (i = 0; i < auth_tab.length; i++) {
            auth_tab[i].style.display = "none";
        }
        tablinks = document.getElementsByClassName("tablinks");
        for (i = 0; i < tablinks.length; i++) {
            tablinks[i].className = tablinks[i].className.replace(" active", "");
        }
        document.getElementById(to).style.display = "block";
        evt.currentTarget.className += " active";
}
