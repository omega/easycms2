var HB = null;
function admin_onload() {
    connect('open_help_button', 'onclick', toggleHelp);
    HB = new HelpBrowser.HelpBrowser();
}


function toggleHelp(e) {
    HB.toggle();
}


function showPage(e) {
    HB.showPage(e.src().id);
}