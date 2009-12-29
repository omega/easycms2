Module("TextEditor", function(module) {
    Class("TextArea", {
        has: {
            textarea: {}
        },
        methods: {
            justify_selection_left: function() {
                this.justify_select('<');
            },
            justify_selection_right: function() {
                this.justify_select('>');
            },
            justify_selection_center: function() {
                this.justify_select('=');
            },
            justify_selection_justify: function() {
                this.justify_select('<>');
            },
            justify_select: function(type) {
                var selectedText = this.getSelection();

                var paragraphs = selectedText.split("\n\n");
                var newText = "\n";
                var par;
                for (par in paragraphs) {
                    var parText = paragraphs[par].replace(/^\s+/, "");
                    logDebug("paragraph #", par, " is: '" + parText + "'");
                    newText = newText + "p" + type + ". " + parText + "\n\n";
                }
                newText = newText.replace(/\s$/, "");
                this.setSelection(newText);
            },
            format_selection_bold: function() {
                this.format_selection('*');
            },
            format_selection_italic: function() {
                this.format_selection('_');
            },
            format_selection_underline: function() {
                this.format_selection('+');
            },
            format_selection_strikethrough: function() {
                this.format_selection('-');
            },
            format_selection: function(pre, post) {
                if (post == undefined) {
                    post = pre;
                }
                if (document.selection) {
                    this.textarea.focus();
                    sel = document.selection.createRange();
                    var selectedText = sel.text;
                    sel.text = pre + selectedText + post;
                    sel.select();
                    this.textarea.focus();
                } else if (this.textarea.selectionStart || this.textarea.selectionStart == '0') {
                    var startPos = this.textarea.selectionStart;
                    var endPos = this.textarea.selectionEnd;
                    var scrollTop = this.textarea.scrollTop;

                    this.textarea.value = this.textarea.value.substring(0, startPos)
                        + pre
                        + this.textarea.value.substring(startPos, endPos)
                        + post
                        + this.textarea.value.substring(endPos, this.textarea.value.length);

                    this.textarea.focus();
                    this.textarea.selectionStart = startPos;
                    this.textarea.selectionEnd = endPos + type.length * 2;
                    this.textarea.scrollTop = scrollTop;
                } else {
                    this.textarea.value += type + type;
                    this.textarea.focus();
                }
            },
            getSelection: function() {
                var selectedText;
                if (document.select) {
                    this.textarea.focus();
                    selectedText = document.selection.createRange();
                } else if (this.textarea.selectionStart || this.textarea.selectionStart == '0') {
                    var startPos = this.textarea.selectionStart;
                    var endPos = this.textarea.selectionEnd;

                    selectedText = this.textarea.value.substring(startPos, endPos);
                }
                return selectedText; 
            },
            setSelection: function(newText) {
                if (document.selection) {
                    this.textarea.focus();
                    sel = document.selection.createRange();
                    var selectedText = sel.text;
                    sel.text = newText;
                    sel.select();
                    this.textarea.focus();
                }
                else if (this.textarea.selectionStart || this.textarea.selectionStart == '0') {
                    var startPos = this.textarea.selectionStart;
                    var endPos = this.textarea.selectionEnd;
                    var scrollTop = this.textarea.scrollTop;

                    this.textarea.value = this.textarea.value.substring(0, startPos)
                    + newText
                    + this.textarea.value.substring(endPos, this.textarea.value.length);

                    this.textarea.focus();
                    this.textarea.selectionStart = startPos;
                    this.textarea.selectionEnd = startPos + newText.length;
                    this.textarea.scrollTop = scrollTop;
                }
            },
            insertAtCaret: function(myValue) {
                /* Based on:                 JS QuickTags version 1.2
                Copyright (c) 2002-2005 Alex King http://www.alexking.org/
                Licensed under the LGPL license http://www.gnu.org/copyleft/lesser.html */
                //IE support
                if (document.selection) {
                    this.textarea.focus();
                    sel = document.selection.createRange();
                    sel.text = myValue;
                    sel.select();
                    this.textarea.focus();
                }
                //MOZILLA/NETSCAPE support
                else if (this.textarea.selectionStart || this.textarea.selectionStart == '0') {
                    var startPos = this.textarea.selectionStart;
                    var endPos = this.textarea.selectionEnd;
                    var scrollTop = this.textarea.scrollTop;
                    this.textarea.value = this.textarea.value.substring(0, startPos)
                    + myValue 
                    + this.textarea.value.substring(endPos, this.textarea.value.length);
                    this.textarea.focus();
                    this.textarea.selectionStart = startPos + myValue.length;
                    this.textarea.selectionEnd = startPos + myValue.length;
                    this.textarea.scrollTop = scrollTop;
                } else {
                    this.textarea.value += myValue;
                    this.textarea.focus();
                }  
            }
        }
    });
    Class("TextEditor", {
        has: {
            _panels: {
                init: function () { return []; },
            },
            _options: {},
            _textarea: { isa: TextEditor.TextArea, handles: "*" }
        },
        methods: {
            addPanel: function(panel) {

                if (typeof(panel) == "string") {
                    // need to create a panel-object for this
                    logDebug(" Trying to instancate an object of this type");
                    throw "We can't convert a string to a panel. Please create object of the right class";
                    panel = new panel;
                }
                if (!panel.meta.does(module.BasePanel)) {
                    throw("We cannot add a panel that does not do the TextEditor.Panel role: " + panel.meta.roles);
                }
                this._panels.push(panel);
                panel.setEditor(this);
            },
            getPanel: function(id) {
                for (var i = 0; i < this._panels.length; i++) {
                    var p = this._panels[i];
                    if (p.id == id) {
                        return p;
                    }
                }
                return null;
            },
            
            render: function(target) {
                if (typeof(target) == "undefined") {
                    // lets just put it into body then
                    target = this._options.label;
                }
                var panels = MochiKit.DOM.UL({
                    'class': this._options.panel_list_class
                }, null);
                // For each panel, generate a button, add them to a toolbar, and
                // append it to the damn DOM.
                for (var i = 0; i < this._panels.length; i++) {
                    var p = this._panels[i];
                    var panel = p.getContent();
                    
                    MochiKit.DOM.appendChildNodes(panels, panel);
                    
                    if (i == 0) {
                        // We toggle the first panel active
                        p.activate();
                    }
                }
                
                MochiKit.DOM.insertSiblingNodesBefore(this._options.label, panels);
            },
            switchPanel: function(e) {
                var p = this.getPanel(e.src().id);
                if (p == null) {
                    throw "Attempting to switch to non-existing panel " + e.src().id;
                }
                this.deactivateAllPanels();
                
                p.activate();
            },
            deactivateAllPanels: function() {
                for (var i = 0; i < this._panels.length; i++) {
                    this._panels[i].deactivate();
                }
            },
            fetchJSON: function(url) {
                return MochiKit.Async.loadJSONDoc(this._options.apibase + url);
            }
        },
        after: {
            initialize: function(textarea, options) {
                var ta = new TextEditor.TextArea();
                ta.textarea = getElement(textarea);
                this._textarea = ta;
                this._options = MochiKit.Base.update({
                    label: MochiKit.DOM.getFirstElementByTagAndClassName('label', 
                        null, this._textarea.textarea.parentNode),
                    button_list_class: 'TextEditor_buttons',
                    panel_list_class: 'TextEditor_panels',
                    iconbase: '/img/icons/',
                    staticbase: '/img/uploads/'
                }, options || {} );
            }
        }
    });
    

    Role("BasePanel", {
        has: {
            editor: { is: "rw" },
            element: {},
            content: {}
        },
        methods: {
            getButton: function() {
                var btn = MochiKit.DOM.DIV({
                    id: this.id,
                    type: "button",
                    'class': "button"
                });
                
                // connect the btn's click to a general panel switcher
                MochiKit.Signal.connect(btn, "onclick", this.getEditor(), this.getEditor().switchPanel);
                
                return btn;
            },
            getContent: function() {
                if (typeof(this.element) != "undefined" && this.element != null) {
                    return this.element;
                }
                var p = MochiKit.DOM.LI({'class': 'panel', 'id': this.id});
                this.element = p;
                appendChildNodes(this.element, this.getButton());
                this.content = MochiKit.DOM.DIV({'class': 'panel_content'}, this.getInnerContent());
                appendChildNodes(this.element, this.content);
                return this.element;
            },
            
            activate: function() {
                if (!MochiKit.DOM.hasElementClass(this.element, "active")) {
                    MochiKit.DOM.addElementClass(this.element, "active");
                }
            },
            deactivate: function() {
                if (MochiKit.DOM.hasElementClass(this.element, "active")) {
                    MochiKit.DOM.removeElementClass(this.element, "active");
                }
            }
        }  
    })
    
    Role("Panel", {
        does: [module.BasePanel],
        requires: ["getInnerContent"],

    });
    
    Role("AsyncPanel", {
        does: [module.BasePanel],
        requires: ["getJSONUrl", "renderJSON"],
        methods: {
            getInnerContent: function() {
                // XXX: Show throbber
                
                // Start JSON request (via this.getJSON())
                var def = this.getEditor().fetchJSON(this.getJSONUrl());
                // Render JSON content (via this.renderJSON() )
                def.addCallback(bind(this.handleJSON, this));
                return MochiKit.DOM.P({}, "Loading " + this.id + "...");
            },
            handleJSON: function(e) {
                // this should replace the content of this panel with what gets rendered
                var content = this.renderJSON(e);
                replaceChildNodes(this.content, content);
            }
        }
    });
    
    Class("FormatPanel", {
        does: [module.Panel],
        has: {
            id: { init: "format" },
        },
        methods: {
            getInnerContent: function() {
                var E = this.getEditor();
                
                var format_text_style = MochiKit.DOM.DIV({'class': 'TextEditor_button_row'});
                
                var bold_button = MochiKit.DOM.BUTTON({'id': 'format_text_bold', 'type': 'button'});
                var italic_button = MochiKit.DOM.BUTTON({'id': 'format_text_italic', 'type': 'button'});
                var underline_button = MochiKit.DOM.BUTTON({'id': 'format_text_underline', 'type': 'button'});
                var strikethrough_button = MochiKit.DOM.BUTTON({'id': 'format_text_strikethrough', 'type': 'button'});

                MochiKit.Signal.connect(bold_button, 'onclick', E, E.format_selection_bold);
                
                
                MochiKit.Signal.connect(italic_button, 'onclick', E, E.format_selection_italic);
                MochiKit.Signal.connect(underline_button, 'onclick', E, E.format_selection_underline);
                MochiKit.Signal.connect(strikethrough_button, 'onclick', E, E.format_selection_strikethrough);

                MochiKit.DOM.appendChildNodes(format_text_style, [bold_button, italic_button, underline_button, strikethrough_button]);
                
                
                var format_block_style = MochiKit.DOM.DIV({'class': 'TextEditor_button_row'});

                var left_button = MochiKit.DOM.BUTTON({'id': 'format_justify_left', 'type' : 'button'});
                var right_button = MochiKit.DOM.BUTTON({'id': 'format_justify_right', 'type' : 'button'});
                var center_button = MochiKit.DOM.BUTTON({'id': 'format_justify_center', 'type' : 'button'});
                var justify_button = MochiKit.DOM.BUTTON({'id': 'format_justify_justify', 'type' : 'button'});

                MochiKit.Signal.connect(left_button, 'onclick', E, E.justify_selection_left);
                MochiKit.Signal.connect(right_button, 'onclick', E, E.justify_selection_right);
                MochiKit.Signal.connect(center_button, 'onclick', E, E.justify_selection_center);
                MochiKit.Signal.connect(justify_button, 'onclick', E, E.justify_selection_justify);
                MochiKit.DOM.appendChildNodes(format_block_style, [left_button, right_button, center_button, justify_button]);

                return [format_text_style, format_block_style];
            }
        }
    });
    
    
});
/*
if (typeof(TextEditor) == 'undefined') {
    TextEditor = {};
}

TextEditor.VERSION = "0.1";
TextEditor.NAME = "TextEditor";
try {
    if (typeof(MochiKit.Base) == 'undefined' 
        || typeof(MochiKit.Style) == 'undefined' 
        || typeof(MochiKit.DOM) == 'undefined') {
        throw "";
    }
} catch (e) {
    throw "TextEditor depends on MochiKit.Base, MochiKit.Style and MochiKit.DOM!";
}

TextEditor.__repr__ = function(){
    return "[" + this.NAME + " " + this.VERSION + "]";
};

TextEditor.toString = function(){
    return this.__repr__;
};


TextEditor.Register = {};

TextEditor.TextEditor = function(textarea, options){
    var id = textarea;
    if (typeof(textarea) != "string") {
        id = getNodeAttribute(textarea, "id");
    }
    if (TextEditor.Register[id]) {
        return TextEditor.Register[id];
    }
     
    this.__init__(textarea, options);
    
    TextEditor.Register[id] = this;
}

TextEditor.TextEditor.prototype = {
    
    __init__: function(textarea, options) {
        var b = MochiKit.Base;
        var d = MochiKit.DOM;
        var s = MochiKit.Style;
        
        this.textarea = d.getElement(textarea);
        this.options = b.update({
            enabled: [],
            label: this.textarea.parentNode,
            button_row_class: 'TextEditor_buttons',
            button_class: 'TextEditor_button',
            iconbase: '/img/icons/',
            staticbase: '/img/uploads/'
        }, options || {} );
                
        this._extend_label();
    },
    
    _extend_label: function() {
        var d = MochiKit.DOM;
        var l = this.options.label;
        
        var btn_row = d.DIV({'class': this.options.button_row_class}, null);
        this.btn_row = btn_row;
        l.appendChild(btn_row);
                
        for (var btn_idx in this.options.enabled) {
            var btn = "create_" + this.options.enabled[btn_idx];
            if (this[btn]) {
                this[btn]();
            }
        }
        this._position_buttons();
    },
    create_format: function() {
        var format_window = MochiKit.DOM.DIV({'id': 'format_window', 'class': 'TextEditor_panel'}, null);
        
        var format_text_style = MochiKit.DOM.DIV({'class': 'TextEditor_button_row'});
        var bold_button = MochiKit.DOM.BUTTON({'id': 'format_text_bold', 'type': 'button'}, this.icon('format-text-bold.png'));
        var italic_button = MochiKit.DOM.BUTTON({'id': 'format_text_italic', 'type': 'button'}, this.icon('format-text-italic.png'));
        var underline_button = MochiKit.DOM.BUTTON({'id': 'format_text_underline', 'type': 'button'}, this.icon('format-text-underline.png'));
        var strikethrough_button = MochiKit.DOM.BUTTON({'id': 'format_text_strikethrough', 'type': 'button'}, this.icon('format-text-strikethrough.png'));
        
        MochiKit.Signal.connect(bold_button, 'onclick', this, this.format_selection_bold);
        MochiKit.Signal.connect(italic_button, 'onclick', this, this.format_selection_italic);
        MochiKit.Signal.connect(underline_button, 'onclick', this, this.format_selection_underline);
        MochiKit.Signal.connect(strikethrough_button, 'onclick', this, this.format_selection_strikethrough);
        MochiKit.DOM.appendChildNodes(format_text_style, [bold_button, italic_button, underline_button, strikethrough_button]);
        
        var format_block_style = MochiKit.DOM.DIV({'class': 'TextEditor_button_row'});
        
        var left_button = MochiKit.DOM.BUTTON({'id': 'format_justify_left', 'type' : 'button'}, this.icon('format-justify-left.png'));
        var right_button = MochiKit.DOM.BUTTON({'id': 'format_justify_right', 'type' : 'button'}, this.icon('format-justify-right.png'));
        var center_button = MochiKit.DOM.BUTTON({'id': 'format_justify_center', 'type' : 'button'}, this.icon('format-justify-center.png'));
        var justify_button = MochiKit.DOM.BUTTON({'id': 'format_justify_justify', 'type' : 'button'}, this.icon('format-justify-fill.png'));
        
        MochiKit.Signal.connect(left_button, 'onclick', this, this.justify_selection_left);
        MochiKit.Signal.connect(right_button, 'onclick', this, this.justify_selection_right);
        MochiKit.Signal.connect(center_button, 'onclick', this, this.justify_selection_center);
        MochiKit.Signal.connect(justify_button, 'onclick', this, this.justify_selection_justify);
        MochiKit.DOM.appendChildNodes(format_block_style, [left_button, right_button, center_button, justify_button]);
        
        MochiKit.DOM.appendChildNodes(format_window, [format_text_style, format_block_style]);
        this.format_window = format_window;
        this.format_window_shown = true;
        this.toggle(format_window);
        this._create_btn('format_button_click','format-text-bold.png', {'title': 'Format text'});
        
        MochiKit.DOM.appendChildNodes('admin', format_window);
    },
    format_button_click: function() {
        if (this.format_window) {
            this.toggle(this.format_window);
        }
    },
    justify_selection_left: function() {
        this.justify_select('<');
    },
    justify_selection_right: function() {
        this.justify_select('>');
    },
    justify_selection_center: function() {
        this.justify_select('=');
    },
    justify_selection_justify: function() {
        this.justify_select('<>');
    },
    justify_select: function(type) {
        var selectedText = this.getSelection();
        
        var paragraphs = selectedText.split("\n\n");
        var newText = "\n";
        var par;
        for (par in paragraphs) {
            var parText = paragraphs[par].replace(/^\s+/, "");
            logDebug("paragraph #", par, " is: '" + parText + "'");
            newText = newText + "p" + type + ". " + parText + "\n\n";
        }
        newText = newText.replace(/\s$/, "");
        this.setSelection(newText);
    },
    format_selection_bold: function() {
        this.format_selection('*');
    },
    format_selection_italic: function() {
        this.format_selection('_');
    },
    format_selection_underline: function() {
        this.format_selection('+');
    },
    format_selection_strikethrough: function() {
        this.format_selection('-');
    },
    format_selection: function(pre, post) {
        if (post == undefined) {
            post = pre;
        }
        if (document.selection) {
            this.textarea.focus();
            sel = document.selection.createRange();
            var selectedText = sel.text;
            sel.text = pre + selectedText + post;
            sel.select();
            this.textarea.focus();
        } else if (this.textarea.selectionStart || this.textarea.selectionStart == '0') {
            var startPos = this.textarea.selectionStart;
            var endPos = this.textarea.selectionEnd;
            var scrollTop = this.textarea.scrollTop;
            
            this.textarea.value = this.textarea.value.substring(0, startPos)
                + pre
                + this.textarea.value.substring(startPos, endPos)
                + post
                + this.textarea.value.substring(endPos, this.textarea.value.length);

            this.textarea.focus();
            this.textarea.selectionStart = startPos;
            this.textarea.selectionEnd = endPos + type.length * 2;
            this.textarea.scrollTop = scrollTop;
        } else {
            this.textarea.value += type + type;
            this.textarea.focus();
        }
    },
    _position_butons: function() {
        // Overloadable
    },
    _create_btn: function(callback, icon, icon_options) {
        var btn = MochiKit.DOM.BUTTON({'class': this.options.button_class, 'type': "button"}, null);
        connect(btn, "onclick", this, callback);
        
        this.btn_row.appendChild(btn);
        btn.appendChild(this.icon(icon, icon_options));
    },
    icon: function(icon, options) {
        options = MochiKit.Base.update({
            'alt': '',
            'title': '',
            'src': this.options.iconbase + icon
        }, options);
        return MochiKit.DOM.IMG(options);
    },
    getSelection: function() {
        var selectedText;
        if (document.select) {
            this.textarea.focus();
            selectedText = document.selection.createRange();
        } else if (this.textarea.selectionStart || this.textarea.selectionStart == '0') {
            var startPos = this.textarea.selectionStart;
            var endPos = this.textarea.selectionEnd;

            selectedText = this.textarea.value.substring(startPos, endPos)
        }
        return selectedText; 
    },
    setSelection: function(newText) {
        if (document.selection) {
            this.textarea.focus();
            sel = document.selection.createRange();
            var selectedText = sel.text;
            sel.text = newText;
            sel.select();
            this.textarea.focus();
        }
        else if (this.textarea.selectionStart || this.textarea.selectionStart == '0') {
            var startPos = this.textarea.selectionStart;
            var endPos = this.textarea.selectionEnd;
            var scrollTop = this.textarea.scrollTop;
            
            this.textarea.value = this.textarea.value.substring(0, startPos)
                + newText
                + this.textarea.value.substring(endPos, this.textarea.value.length);

            this.textarea.focus();
            this.textarea.selectionStart = startPos;
            this.textarea.selectionEnd = startPos + newText.length;
            this.textarea.scrollTop = scrollTop;
        }
    },
    insertAtCaret: function(myValue) {
        /* Based on: 
         JS QuickTags version 1.2
        
         Copyright (c) 2002-2005 Alex King
         http://www.alexking.org/
        
         Licensed under the LGPL license
         http://www.gnu.org/copyleft/lesser.html
        */
 /*       
    	//IE support
    	if (document.selection) {
    		this.textarea.focus();
    		sel = document.selection.createRange();
    		sel.text = myValue;
    		sel.select();
    		this.textarea.focus();
    	}
    	//MOZILLA/NETSCAPE support
    	else if (this.textarea.selectionStart || this.textarea.selectionStart == '0') {
    		var startPos = this.textarea.selectionStart;
    		var endPos = this.textarea.selectionEnd;
    		var scrollTop = this.textarea.scrollTop;
    		this.textarea.value = this.textarea.value.substring(0, startPos)
    		              + myValue 
                          + this.textarea.value.substring(endPos, this.textarea.value.length);
    		this.textarea.focus();
    		this.textarea.selectionStart = startPos + myValue.length;
    		this.textarea.selectionEnd = startPos + myValue.length;
    		this.textarea.scrollTop = scrollTop;
    	} else {
    		this.textarea.value += myValue;
    		this.textarea.focus();
    	}  
    },
    toggle: function(elem) {
        if (this[elem.id + "_shown"]) {
            MochiKit.Style.hideElement(elem);
            this[elem.id + "_shown"] = false;
        } else {
            MochiKit.Style.showElement(elem);
            this[elem.id + "_shown"] = true;
        }
    },
    toString: function() {
        return "TextEditor " + this.textarea.id;
    }
}
*/