#@codekit-prepend "picoModal"
###
Copyright (c) 2012 ElevenBlack
Written by Ciocanel Razvan (chocksy.com)
###

###
A self-contained loader library
###
window.widgetLoader = ((window,document) ->
  "use strict"

  defaults=
    path:  '/api/v1/errors/add_error' # the contact form to load
    domain:         '//epiclogger.com'
    email:   false
    modal_width:    false
    modal_height:   false
    iframe_widget:  false
    iframe_width:   "100%"
    iframe_height:  "100%"
    side_btn:       true 
    

  cssNumber=
    "columnCount": true,
    "fillOpacity": true,
    "flexGrow": true,
    "flexShrink": true,
    "fontWeight": true,
    "lineHeight": true,
    "opacity": true,
    "order": true,
    "orphans": true,
    "widows": true,
    "zIndex": true,
    "zoom": true

  elements= 
    side_btn_content:     '<div id="WDG_sideBtn_ctn"><a href="#" id="WDG_sideBtn">Errors Widget</a></div>'
    side_btn:             "#WDG_sideBtn"

  # ---- assignModal Method
  # -- assign modal method to element class
  assignModal= ->
    $s('.el-modal').on 'click',(e)=>
      e.preventDefault()
      element = e.currentTarget 
      widget_token = element.getAttribute('data-widget')
      moduleInfo = JSON.stringify({url:widget_token})
      loadModule({data:moduleInfo})


  # ---- loadModule Method
  # -- we use this method as a way to verify if we need to open a new window or a modal
  # -- depending by the browser type. This is also called by the iframe in case of displaying
  # -- a new step.
  loadModule= (e)->
    openModal()
    addReporterrorListeners()
    return
  # ---- openModal Method
  # -- we use this method to initialize the modal and add the iframe to it
  openModal= ()->
    current_height = make().getWindow('height')
    current_width = make().getWindow('width')
    widget_width = if window.ELopts.modal_width then window.ELopts.modal_width else current_width/1.2
    widget_height = if window.ELopts.modal_height then window.ELopts.modal_height else current_height/1.6
    emailAddress = if window.ELopts.email then window.ELopts.email else ''
    outerWidth = if typeof widget_width=="number" then current_width-widget_width else (current_width*parseInt(widget_width)/100)
    outerHeight= if typeof widget_height=="number" then current_height-widget_height else (current_height*parseInt(widget_height)/100)
    picoModal(
      content: """
      <style>
        /**/
        /* normal state */
        /**/
        .epic-form .button {
          background-color: #cc3d3d;
        }


        /**/
        /* hover state */
        /**/
        .epic-form .input:hover input,
        .epic-form .textarea:hover textarea {
          border-color: #dc9596;
        }

        /**/
        /* focus state */
        /**/
        .epic-form .input input:focus,
        .epic-form .textarea textarea:focus { 
          border-color: #cc3d3d;
        }

        /**/
        /* font */
        /**/
        @import url(http://fonts.googleapis.com/css?family=Open+Sans:300,400,700);


        /**/
        /* defaults */
        /**/
        .epic-form {
          margin: 0;
          outline: none;
          box-shadow: 0 0 20px rgba(0,0,0,.3);
          font: 13px/1.55 'Open Sans', Helvetica, Arial, sans-serif;
          color: #666;
        }
        .epic-form * {
          margin: 0;
          padding: 0;
        }
        .epic-form header {
          display: block;
          padding: 20px 30px; 
          border-bottom: 1px solid rgba(0,0,0,.1);
          background: rgba(248,248,248,.9);
          font-size: 25px;
          font-weight: 300;
          color: #232323;
        }
        .epic-form fieldset {
          display: block; 
          padding: 25px 30px 5px;
          border: none;
          background: rgba(255,255,255,.9);
        }
        .epic-form fieldset + fieldset {
          border-top: 1px solid rgba(0,0,0,.1);
        }
        .epic-form section {
          margin-bottom: 20px;
        }
        .epic-form footer {
          display: block;
          padding: 15px 30px 25px;
          border-top: 1px solid rgba(0,0,0,.1);
          background: rgba(248,248,248,.9);
        }
        .epic-form footer:after {
          content: '';
          display: table;
          clear: both;
        }
        .epic-form a {
          color: #2da5da;
        }
        .epic-form .label {
          display: block;
          margin-bottom: 6px;
          line-height: 19px;
        }
        .epic-form .label.col {
          margin: 0;
          padding-top: 10px;
        }

        .epic-form .input,
        .epic-form .textarea,
        .epic-form .button {
          position: relative;
          display: block;
        }
        .epic-form .input input,
        .epic-form .textarea textarea {
          display: block;
          box-sizing: border-box;
          -moz-box-sizing: border-box;
          width: 100%;
          height: 39px;
          padding: 8px 10px;
          outline: none;
          border-width: 2px;
          border-style: solid;
          border-radius: 0;
          background: #fff;
          font: 15px/19px 'Open Sans', Helvetica, Arial, sans-serif;
          color: #404040;
          appearance: normal;
          -moz-appearance: none;
          -webkit-appearance: none;
        }

        /**/
        /* buttons */
        /**/
        .epic-form .button {
          float: right;
          height: 39px;
          overflow: hidden;
          margin: 10px 0 0 20px;
          padding: 0 25px;
          outline: none;
          border: 0;
          font: 300 15px/39px 'Open Sans', Helvetica, Arial, sans-serif;
          text-decoration: none;
          color: #fff;
          cursor: pointer;
        }

        /**/
        /* grid */
        /**/
        .epic-form .row {
          margin: 0 -15px;
        }
        .epic-form .row:after {
          content: '';
          display: table;
          clear: both;
        }
        .epic-form .col {
          float: left;
          min-height: 1px;
          padding-right: 15px;
          padding-left: 15px;
          box-sizing: border-box;
          -moz-box-sizing: border-box;
        }
        .epic-form .col-1 {
          width: 8.33%;
        }
        .epic-form .col-2 {
          width: 16.66%;
        }
        .epic-form .col-3 {
          width: 25%;
        }
        .epic-form .col-4 {
          width: 33.33%;
        }
        .epic-form .col-5 {
          width: 41.66%;
        }
        .epic-form .col-6 {
          width: 50%;
        }
        .epic-form .col-8 {
          width: 66.67%;
        }
        .epic-form .col-9 {
          width: 75%;
        }
        .epic-form .col-10 {
          width: 83.33%;
        }
        @media screen and (max-width: 600px) {
          .epic-form .col {
            float: none;
            width: 100%;
          }
        }

        /**/
        /* normal state */
        /**/
        .epic-form .input input,
        .epic-form .textarea textarea {
          border-color: #e5e5e5;
          transition: border-color 0.3s;
          -o-transition: border-color 0.3s;
          -ms-transition: border-color 0.3s;
          -moz-transition: border-color 0.3s;
          -webkit-transition: border-color 0.3s;
        }
      
        .epic-form .button {
          background-color: #2da5da;
          opacity: 0.8;
          transition: opacity 0.2s;
          -o-transition: opacity 0.2s;
          -ms-transition: opacity 0.2s;
          -moz-transition: opacity 0.2s;
          -webkit-transition: opacity 0.2s;
        }
        .epic-form .button.button-secondary {
          background-color: #b3b3b3;
        }

        /**/
        /* hover state */
        /**/
        .epic-form .input:hover input,
        .epic-form .textarea:hover textarea {
          border-color: #8dc9e5;
        }
        
        .epic-form .button:hover {
          opacity: 1;
        }


        /**/
        /* focus state */
        /**/
        .epic-form .input input:focus,
        .epic-form .textarea textarea:focus {
          border-color: #2da5da;
        }

        /**/
        /* error state */
        /**/
        .epic-form .state-error input,
        .epic-form .state-error textarea{
          background: #fff0f0;
        }
        
        .epic-form .toggle.state-error input:checked + i {
          background: #fff0f0;
        }
        .epic-form .state-error{
          color: #B82222;
        }
      
        /**/
        /* success state */
        /**/
        .epic-form .state-success input,
        .epic-form .state-success textarea {
          background: #f0fff0;
        }
        .epic-form .state-success {
          color: #6fb679;
        }

        /**/
        /* submited state */
        /**/
        .epic-form .message {
          display: none;
          color: #6fb679;
        }
        .epic-form .message i {
          display: block;
          margin: 0 auto 20px;
          width: 81px;
          height: 81px;
          border: 1px solid #6fb679;
          border-radius: 50%;
          font-size: 30px;
          line-height: 81px;
        }
        .epic-form.submited .message {
          display: block;
          padding: 10px 30px 25px;
          background: rgba(255,255,255,.9);
          font: 300 18px/27px 'Open Sans', Helvetica, Arial, sans-serif;
          text-align: center;
        }

        /**/
        /* modal */
        /**/
        .epic-form-modal {
          position: fixed;
          z-index: 1;
          display: none;
          width: 400px;
        }
        .epic-form-modal-overlay {
          position: fixed;
          top: 0;
          left: 0;
          display: none;
          width: 100%;
          height: 100%;
          background: rgba(0,0,0,0.7);
        }
        html, body {
          margin: 0;
          padding: 0;
          background-attachment: fixed;
          background-position: 50% 50%;
          background-size: cover;
        }
        .modal {
          padding: 25px 30px;
          background: rgba(255,255,255,0.9);
          font: 13px/1.55 'Open Sans', Helvetica, Arial, sans-serif;
          color: #666;
        }
        .modal a {
          color: #2da5da;
        }

        @media screen and (max-width: 600px) {
          .body {
            padding: 20px;
          }
        }
      </style>
      <div class="body">      
        <form action="" class="epic-form" id="contact-form">
          <header>We are sorry that you landed on this error page.
            Let us know and we will get back to you once we fix the issue.</header>
          <fieldset>
            <section>
              <label class="label" for="InputEmail">Your Email</label>
              <label class="input">
                <input type="email" id="InputEmail" name="InputEmail" placeholder="Enter your email" value="#{emailAddress}" required/>
            </section>
          </fieldset>
          <fieldset>
            <section>
              <label>
                <span>Do you wish to receive notification?</span>
                <input type="checkbox" id="InputNotification" name="InputNotification" />
            </section>
          </fieldset>
          <div id="contact-response" class="message"></div>
          <footer>
            <button type="submit" class="button" id="btn-submit">Submit Error</button>
          </footer>
        </form>
      </div>"""
      overlayStyles:
        backgroundColor: "#333"
        opacity: "0.3"
      modalStyles: 
        width: widget_width
        height: widget_height
        top: "13%"
        background: "#fff"
        boxShadow: "0px 0px 7px #444"
        border: "1px solid #444"
        borderRadius: "3px"
        marginLeft: -outerWidth/2+"px"
        overflowY: "scroll"
    )

  # ---- addWidget Method
  # -- we add the iframe widget to the element specified when initializing the plugin
  addWidget= ()->
    url = defaults.domain + "?id="+window.ELopts.user_id
    widget_iframe_html = '<iframe id="iframe_widget" src="'+url+'" class="iframe-class" style="width:100%;height:100%;position:fixed;top:0;left:0" frameborder="0" allowtransparency="true"></iframe>'
    $el = $s(window.ELopts.widget_container)
    $el.append(widget_iframe_html)

  # ---- isMobile Method
  # -- check if the browser is a mobile browser
  isMobile= ->
    /iphone|ipad|ipod|android|blackberry|mini|windows\sce|palm/i.test(navigator.userAgent.toLowerCase())

  # ---- $s Method
  # -- we are making below an utility section to get and manipulate DOM
  $s = (a, b) ->
    a = a.match(/^(\W)?(.*)/)
    elem = (b or document)["getElement" + ((if a[1] then (if a[1] is "#" then "ById" else "sByClassName") else "sByTagName"))] a[2]
    fas = 
      elem: elem
      data : (dataAttr) ->
        elem.getAttribute("data-"+dataAttr)

      # Sets the HTML
      html: (content) ->
        elem.innerHTML = content
        fas

      # Adds a class name
      clazz: (clazz) ->
        elem.className += clazz
        fas

      # Applies a set of styles to an element
      stylize: (styles)->
        styles = styles or {}
        styles.filter = "alpha(opacity=" + (styles.opacity * 100) + ")"  if typeof styles.opacity isnt "undefined"
        for prop of styles
          if styles.hasOwnProperty(prop)
            type = typeof styles[prop]
            if type=="number" and !cssNumber[prop]
              styles[prop] += "px"
            elem.style[prop] = styles[prop] 
        fas

      append : (html)->
        c = document.createElement("p")
        c.innerHTML = html
        el = elem
        el = elem[0] if elem.length # we append just to first element
        el.appendChild c.firstChild
        fas

      # Removes this element from the DOM
      destroy: ->
        document.body.removeChild elem unless !elem
        fas
      on   : (eventName,handler)->
        if elem.length # we add handler just to first element
          elements = elem
        else
          elements = [elem]
        if elements.length>0
          i = 0
          while i < elements.length
            el = elements[i]
            if el.addEventListener
              el.addEventListener eventName, handler
            else if el.attachEvent
              el.attachEvent "on" + eventName, ->
                handler.call elem
            i++
        return
    fas

  # ---- make Method
  # -- below is the utility method that we use to manipulate data
  make = ()->
    fas = 
      extend : (out) ->
        out = out or {}
        i = 1

        while i < arguments.length
          obj = arguments[i]
          continue  unless obj
          for key of obj
            if obj.hasOwnProperty(key)
              if typeof obj[key] is "object"
                extend out[key], obj[key]
              else
                out[key] = obj[key]
          i++
        out

      getWindow: (type)->
        w = window
        d = document
        e = d.documentElement
        g = d.getElementsByTagName('body')[0]
        x = w.innerWidth || e.clientWidth || g.clientWidth
        y = w.innerHeight|| e.clientHeight|| g.clientHeight
        return x if type=='width'
        return y if type=='height'
    fas
  
  # ---- addWidgetListeners Method
  # -- we listen to the widget actions and make the actions acordingly
  # -- and example would be clicking on the submit button and loading the next step iframe 
  # -- into a modal
  addWidgetListeners= ()->
    trace "adding listener for selecting the date for showing time"
    eventMethod = (if window.addEventListener then "addEventListener" else "attachEvent")
    eventer = window[eventMethod]
    messageEvent = (if eventMethod is "attachEvent" then "onmessage" else "message")

    # Listen to message from child window
    eventer messageEvent, ((e)=> loadModule(e) ), false

  trace = (s) ->
    window.console.log "widgetLoader: " + s  if window["console"] isnt `undefined`
  error = (s) ->
    window.console.error "widgetLoader: " + s  if window["console"] isnt `undefined`

  onSubmitComplete = (error) ->
    iframe = $s('#iframe_widget').elem.contentDocument
    contactBtn = $s('#btn-submit', iframe)
    contactResponse = $s('#contact-response', iframe)

    contactBtn.disabled = false;
    if error
      contactResponse.elem.innerHTML = '<div class="state-error">Sorry. Could not submit the error report.</div>'
    else
      contactResponse.elem.innerHTML = '<div class="state-success">Thanks for submitting your error report!</div>'
    return

  addReporterrorListeners = () -> 
    iframe = $s('#iframe_widget').elem.contentDocument
    contactBtn = $s('#btn-submit', iframe)
    contactBtn.elem.addEventListener 'click',(e) ->
      e.preventDefault()
      contactEmail = $s('#InputEmail', iframe).elem.value
      contactNotification = $s('#InputNotification', iframe).elem.checked
      info =
        email: contactEmail
        notification: contactNotification
        url_path: window.location.href
      submitError(info)
    return

  submitError = (infoObject) ->
    img = document.createElement('img')
    src = 'http:' + defaults.domain + defaults.path + '?error=' + encodeURIComponent(JSON.stringify(infoObject)) + '&app_id=' + _lopts.app_id + '&app_key=' + _lopts.app_key
    img.crossOrigin = 'anonymous';
    img.onload = (data) ->
      onSubmitComplete() unless window.ELopts.ignore_modal
    img.onerror = img.onabort = (error) ->
      onSubmitComplete(error) unless window.ELopts.ignore_modal
    img.src = src


  # A function for easily displaying a modal with the given content
  (options) ->
    window.ELopts = make().extend({}, defaults,options)
    trace "constructor"
    if not window.ELopts.ignore_modal
      addWidget()
      addWidgetListeners()
      loadModule()
      event.preventDefault()
    else
      infoObject =
        url_path: window.location.href
      if window.ELopts.email
        infoObject['email'] = window.ELopts.email
        infoObject['notification'] = true
      submitError(infoObject)
    assignModal()
    false

)(window,document)

window.onload = ()->
  if _lopts.widget_container is undefined
    _lopts.widget_container = 'body'
  widgetLoader(_lopts)