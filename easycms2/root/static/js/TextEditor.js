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
            enabled: ['img', 'a'],
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
    _position_butons: function() {
        /* Overloadable */  
    },
    create_a: function() {
        this._create_btn("a_btn_click", 'internet-web-browser.png');
    },
    a_btn_click: function(e) {
        if (this.a_list) {
            this.toggle(this.a_list);
        }
        if (!this.a_list || this.a_list_shown) {
            var alist = MochiKit.Async.loadJSONDoc(this.options.apibase + "page/links");
            alist.addCallback(this.a_list_return_callback, this);
        }
    },
    a_list_return_callback: function(obj, list) {
        logError('a_list_return_callback needs to be overridden');
    },
    a_insert: function(e) {
        var val = '"' + MochiKit.DOM.getNodeAttribute(e.src(), 'title') + '":' + 
            MochiKit.DOM.getNodeAttribute(e.src(), 'url');
            this._insertAtCaret(val);
            e.stop();
    },
    create_img: function() {
        this._create_btn("img_btn_click", 'image-x-generic.png');
    },
    img_btn_click: function(e) {
        if (this.img_list) {
            this.toggle(this.img_list);
        }
        if (!this.img_list || this.img_list_shown) {
            var imglist = MochiKit.Async.loadJSONDoc(this.options.apibase + "media/images");
            imglist.addCallback(this.img_list_return_callback, this);
        }
    },
    img_list_return_callback: function(obj, list){
        logError('img_list_return_callback needs to be overridden!');
        /* I'm thinking this should be overridden pr application using it? */
    },
    img_insert: function(e) {
        var val = '!' + this.options.staticbase + MochiKit.DOM.getNodeAttribute(e.src(), 'filename') + '!';
        
        this._insertAtCaret(val);
        e.stop();
    },
    _create_btn: function(callback, icon) {
        var btn = MochiKit.DOM.BUTTON({'class': this.options.button_class, 'type': "button"}, null);
        connect(btn, "onclick", this, callback);
        
        this.btn_row.appendChild(btn);
        var icn = MochiKit.DOM.IMG({'src': this.options.iconbase + icon, "alt": "Image", 'title': 'Insert image at cursor' });
        btn.appendChild(icn);
    },
    _insertAtCaret: function(myValue) {
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