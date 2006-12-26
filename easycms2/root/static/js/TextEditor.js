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
        /* Overloadable */  
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