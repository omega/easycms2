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





/** PAGE EDITOR STUFF **/
/* Example of overloading */
TextEditor.TextEditor.prototype._position_buttons = function() {
    element = MochiKit.DOM.getElement(this.btn_row);
    relative = MochiKit.DOM.getElement(this.textarea);
    
    var s = MochiKit.Style;
    
    var rel_pos = s.getElementPosition(relative);
    var rel_size = s.getElementDimensions(relative);
    var new_pos = new s.Coordinates(0,0);
    new_pos.x = rel_pos.x + rel_size.w + 2;
    new_pos.y = rel_pos.y;
    if (new_pos.x && new_pos.y) {
        s.setElementPosition(element, new_pos);
    }
    
};
TextEditor.TextEditor.prototype.img_list_return_callback = function (obj, json) {
    var list = json.api_list;
    var ul = MochiKit.DOM.getElement('img_list') || MochiKit.DOM.UL({'id': 'img_list', 'class': 'TextEditor_list'}, null);
    obj.img_list = ul;
    obj.img_list_shown = true;
    for (var media_idx in list) {
        var media = list[media_idx];
        var thumb = MochiKit.DOM.IMG({'src': obj.options.staticbase + media.uri_basename_thumb});
        
        var li = MochiKit.DOM.getElement('f' + media.id) || MochiKit.DOM.LI({
            'filename': media.uri_basename, 
            'class': 'image', 
            'id': "f" + media.id}, [thumb, media.description]);
        MochiKit.DOM.appendChildNodes(ul, li);
        disconnectAll(li);
        connect(li, 'onclick', obj, obj.img_insert);
    }
    MochiKit.DOM.appendChildNodes('admin', ul);
};
TextEditor.TextEditor.prototype.a_list_return_callback = function (obj, json) {
    var list = json.api_list;
    var ul = MochiKit.DOM.getElement('a_list') || MochiKit.DOM.UL({'id': 'a_list', 'class': 'TextEditor_list'}, null);
    obj.a_list = ul;
    obj.a_list_shown = true;
    for (var media_idx in list) {
        var page = list[media_idx];
        var li = MochiKit.DOM.getElement('a' + page.id) || MochiKit.DOM.LI({
            'title': page.title || urlbase + page.uri_base,
            'url': urlbase + page.uri_base, 
            'class': 'page', 
            'id': "a" + page.id}, page.title);
        MochiKit.DOM.appendChildNodes(ul, li);
        disconnectAll(li);
        connect(li, 'onclick', obj, obj.a_insert);
    }
    MochiKit.DOM.appendChildNodes('admin', ul);
};

function page_onload() {
    /* Init the TextEditor for the body-field */
    var TE = new TextEditor.TextEditor('edit_page_body', { 
        enabled: ['img', 'a'], 
        iconbase: imgbase + '/icons/',
        apibase: urlbase + 'api/json/',
        staticbase: urlbase + 'static/upload/'
    });
}