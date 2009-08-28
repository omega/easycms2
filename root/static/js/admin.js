var HB = null;
function admin_onload() {
    connect('open_help_button', 'onclick', toggleHelp);
    HB = new HelpBrowser.HelpBrowser();
    var labels = document.getElementsByTagName('label');
    for (var i = 0; i < labels.length; i++) {
        connect(labels[i], 'onclick', toggleField);
    }
}


function toggleHelp(e) {
    HB.toggle();
}


function showPage(e) {
    HB.showPage(e.src().id);
}


function unescapeHTML(s) {
    return s.replace(/\&amp;/g, "&"
        ).replace(/\&quot;/g, "\""
        ).replace(/\&lt;/g, "<"
        ).replace(/\&gt;/g, ">");
}

/** Category editing function **/

function setDefault() {
    var select = getElement('edit_category_type');
    var type = select.options[select.selectedIndex].value;
    logDebug("Getting default for", type);
    var def = loadJSONDoc(urlbase + "api/json/categorytype_defaults", {'type': type});
    def.addCallbacks(function(res){
        if (res.api_obj) {
            if (res.api_obj.template) {
                getElement("edit_category_index_page").value = res.api_obj.template;
            }
            if (res.api_obj.js) {
                getElement("edit_category_js").value = res.api_obj.js;
            }
            if (res.api_obj.css) {
                getElement("edit_category_css").value = res.api_obj.css;
            }
        } else {
            getElement("edit_category_index_page").value = '';
            getElement("edit_category_js").value = '';
            getElement("edit_category_css").value = '';
        }
        
    },
    function(res){
        logError(res);
    });
}

/** ToggleFunction for HTML::Widget's general layout **/

function toggleField(e) {
    var label = e.src();
    if (e.src() != e.target()) {
        return;
    }
    var field = getElement(label.getAttribute("for"));
    logDebug('nodeName: ' + field.nodeName + " field: " + field)
    if (field.nodeName == 'TEXTAREA') {
        toggle(field, 'blind');
        
    }
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

TextEditor.TextEditor.prototype.create_a = function() {
    this._create_btn("a_btn_click", 'internet-web-browser.png');
};
TextEditor.TextEditor.prototype.a_btn_click= function(e) {
    if (this.a_list) {
        this.toggle(this.a_list);
    }
    if (!this.a_list || this.a_list_shown) {
        var alist = MochiKit.Async.loadJSONDoc(this.options.apibase + "page/links");
        alist.addCallback(this.a_list_return_callback, this);
    }
};
TextEditor.TextEditor.prototype.a_insert = function(e) {
    var val = '"' + MochiKit.DOM.getNodeAttribute(e.src(), 'title') + '":' + 
        MochiKit.DOM.getNodeAttribute(e.src(), 'url');
    this.insertAtCaret(val);
    e.stop();
};
TextEditor.TextEditor.prototype.create_img = function() {
    this._create_btn("img_btn_click", 'image-x-generic.png');
};
TextEditor.TextEditor.prototype.img_btn_click = function(e) {
    if (this.img_list) {
        this.toggle(this.img_list);
    }
    if (!this.img_list || this.img_list_shown) {
        var imglist = MochiKit.Async.loadJSONDoc(this.options.apibase + "media/images");
        imglist.addCallback(this.img_list_return_callback, this);
    }
};
TextEditor.TextEditor.prototype.img_insert = function(e) {
    var val = '!' + this.options.staticbase + MochiKit.DOM.getNodeAttribute(e.src(), 'filename') + '!';
    
    this.insertAtCaret(val);
    e.stop();
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
        enabled: ['img', 'a', 'format'], 
        iconbase: imgbase + '/icons/',
        apibase: urlbase + 'api/json/',
        staticbase: urlbase + 'static/upload/'
    });
}