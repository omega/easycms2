


if (typeof(HelpBrowser) == 'undefined') {
    HelpBrowser = {};
}

HelpBrowser.VERSION = "0.1";
HelpBrowser.NAME = "HelpBrowser";
try {
    if (typeof(MochiKit.Base) == 'undefined' 
        || typeof(MochiKit.Style) == 'undefined' 
        || typeof(MochiKit.DOM) == 'undefined') {
        throw "";
    }
} catch (e) {
    throw "HelpBrowser depends on MochiKit.Base, MochiKit.Style and MochiKit.DOM!";
}

HelpBrowser.__repr__ = function(){
    return "[" + this.NAME + " " + this.VERSION + "]";
};

HelpBrowser.toString = function(){
    return this.__repr__;
};


/* We need a cache to cache help-pages etc */

HelpBrowser.__object = null;

HelpBrowser.HelpBrowser = function(options) {
    
    /* Very simple singelton implementation */
    
    if (HelpBrowser.__object) {
        return HelpBrowser.__object;
    }
    
    this.__init__(options);
    
    HelpBrowser.__object = this;
};

HelpBrowser.__cache = {};

HelpBrowser.HelpBrowser.prototype = {
    /*** 
     *** An HelpBrowser lets you browse a portion of the site with ajax,
     *** which hopefully provides a better way to work with help stuff
     ***/
     
     __init__: function(options) {

         this.options = MochiKit.Base.update({
             baseUrl: '/help/',
             appendTo: 'admin'
         }, options || {});
         this.browserElement = this._build_browser();
         
         this.hide();
         
         this.showPage('index');
     },
     _build_browser: function() {
        var browserElement = DIV({'id': 'helpbrowser_window'},
            [
                DIV({'id': 'helpbrowser_menubar'}, [
                    A({'id': 'index'}, 'Index')
                ]), 
                DIV({'id': 'helpbrowser_content'}, 'testcontent')
            ]
        );

        MochiKit.DOM.appendChildNodes(this.options.appendTo, browserElement);

        /* connect signals */
        
        var links = browserElement.getElementsByTagName('a');
//        logDebug('found links: ' + links.length)
        for (var i = 0; i < links.length; i++) {
            var link = links[i];
            if (link.id) {
                connect(link, 'onclick', showPage);
            }
        }
        
        return browserElement;
     },
     renderPage: function(page) {
//         logDebug("rendering", page.title);
         var p = P({'id': 'helpbrowser_content_p'} );
         p.innerHTML = page.body;
         var help_content = DIV({'class': 'help_page'}, [H1({}, page.title), p]);
//         logDebug("returning", help_content);
         return help_content;
     },
     showPage: function(pageId) {
         /* show throbber */
         /* fetch the page */
         this.getPage(pageId, this.showPageCallback);
     },
     showPageCallback: function(obj, page) {
         /* display the page */
         
         var renderedPage = obj.renderPage(page);
         MochiKit.DOM.replaceChildNodes('helpbrowser_content', renderedPage);

         /* connect signals */
         var links = renderedPage.getElementsByTagName('a');
         for (var i = 0; i < links.length; i++) {
             var link = links[i];
             if (link.id) {
                 connect(link, 'onclick', showPage);
             }
         }
         /* hide throbber */
     },
     /* Gets a page async */
     getPage: function(pageId, callback) {
/*         if (HelpBrowser.__cache[pageId]) {
             callback(HelpBrowser.__cache[pageId]);
         }
*/
         /* Need to get the page */
         var page = MochiKit.Async.loadJSONDoc(this.options.baseUrl + pageId);    
         page.addCallback(this.getPageCallback, callback, this);
     },
     getPageCallback: function(callback, obj, page) {
         /* store the page in the cache */
//         HelpBrowser.__cache[pageId] = page.help_doc;
//         logDebug('cache updated, calling callback');
         callback(obj, page.help_doc);
     },
     show: function() {
         this.toggled = true;
         MochiKit.Style.showElement(this.browserElement);
     },
     hide: function() {
         this.toggled = false;
         MochiKit.Style.hideElement(this.browserElement);
     },
     toggle: function() {
         if (this.toggled) {
             this.hide();
         } else {
             this.show();
         }
     }
}