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

Class("LinkPanel", {
    does: [TextEditor.AsyncPanel],
    has: {
        id: { init: "links" }
    },
    methods: {
        getJSONUrl: function() {
            // Display throbber while we load the links?
            return "page/links";
            
        },
        renderJSON: function(json) {
            var list = json.api_list;
            
            var ul = MochiKit.DOM.UL({'id': 'a_list', 'class': 'TextEditor_list'}, null);
            for (var media_idx in list) {
                var page = list[media_idx];
                var li = MochiKit.DOM.LI({
                    'title': page.title || urlbase + page.uri_base,
                    'url': urlbase + page.uri_base, 
                    'class': 'page', 
                    'id': "a" + page.id}, page.title);
                MochiKit.Signal.connect(li, 'onclick', this, this.handleClick);
                MochiKit.DOM.appendChildNodes(ul, li);
            }
            return ul;
            
        },
        handleClick: function(e) {
            logDebug("in handleClick: ", this);
            var val = '"' + MochiKit.DOM.getNodeAttribute(e.src(), 'title') + '":' + 
                MochiKit.DOM.getNodeAttribute(e.src(), 'url');
            this.getEditor().insertAtCaret(val);
            e.stop();
            
        }
    }
})

Class("ImagePanel", {
    does: [TextEditor.AsyncPanel],
    has: {
        id: { init: "image" }
    },
    methods: {
        getJSONUrl: function() {
            return "media/images";
        },
        renderJSON: function(json) {
            var list = json.api_list;
            var ul = MochiKit.DOM.UL({'id': 'img_list', 'class': 'TextEditor_list'}, null);
            this.img_list = ul;
            this.img_list_shown = true;
            for (var media_idx in list) {
                var media = list[media_idx];
                var thumb = MochiKit.DOM.IMG({'src': this.getEditor()._options.staticbase + media.uri_basename_thumb});

                var li = MochiKit.DOM.getElement('f' + media.id) || MochiKit.DOM.LI({
                    'filename': media.uri_basename, 
                    'class': 'image', 
                    'id': "f" + media.id}, [thumb, media.description]);
                connect(li, 'onclick', this, this.handleClick);
                MochiKit.DOM.appendChildNodes(ul, li);
            }
            
            return ul;
        },
        handleClick: function(e) {
            var val = '!' + this.getEditor()._options.staticbase + MochiKit.DOM.getNodeAttribute(e.src(), 'filename') + '!';
            this.getEditor().insertAtCaret(val);
            e.stop();
            
        }
    }
})

function page_onload() {
    /* Init the TextEditor for the body-field */
    var TE = new TextEditor.TextEditor('edit_page_body', { 
        iconbase: imgbase + '/icons/',
        apibase: urlbase + 'api/json/',
        staticbase: urlbase + 'static/upload/',
    });
    // need to add some panels:
    // enabled: ['img', 'a', 'format'], 
    TE.addPanel(new TextEditor.FormatPanel());
    TE.addPanel(new LinkPanel());
    TE.addPanel(new ImagePanel());
    
    TE.render();
}