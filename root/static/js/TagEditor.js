/**

Can be used to easily implement a tag editor on a given page.

It calls the server to find already present tags, and displays them 
in a toggleable list, and also tries to do completion */

if (typeof(TagEditor) == 'undefined') {
    TagEditor = {};
}

TagEditor.VERSION = "0.1";
TagEditor.NAME = "TagEditor";
try {
    if (typeof(MochiKit.Base) == 'undefined' 
        || typeof(MochiKit.Style) == 'undefined' 
        || typeof(MochiKit.DOM) == 'undefined') {
        throw "";
    }
} catch (e) {
    throw "TagEditor depends on MochiKit.Base, MochiKit.Style and MochiKit.DOM!";
}

TagEditor.__repr__ = function(){
    return "[" + this.NAME + " " + this.VERSION + "]";
};

TagEditor.toString = function(){
    return this.__repr__;
};

/* input: the field you want to load tags from, and store them to later.
  We expect space seperated tags. Tags with spaces can be quoted
  */
TagEditor = function(input, options) {
    this.input = input;
    this.options = update({
    }, options || {});
    
    
};

TagEditor.prototype = {
    
};