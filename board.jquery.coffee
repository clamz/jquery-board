$ ->
  $.widget "clamz.board",
    options:
      templateColumnsId:  'columns-template'
      columnsClass:       'board-column'
      rowsClass:          'board-row'
      rowsWrapper:        'rows-wrapper'
      editableClass:      'editable'
      rowsTemplateId:     'rows-template'
      cellTemplateId:     'cell-template'
      json: columns: [
          name: "test"
          rows: [
            name: "row1-1"
          ,
            name: "row1-2"
          ]
        ,
          name: "test2"
          columns: [
            name: "row2-1"
            rows: [
                name: "test"
              ,
                name: "test2"
            ]
          ,
            name: "row2-2"
          ,
            name: "row2-3"
          ]
        ]
    addRowClass: 'add-row'
    _create: ->
      @_registerHelpers()
      @_compileTemplate()
      @_setupDnd()
      @_setupContentsEditable()
      @_setupAddRow()

    # compile template
    # and display the result
    _compileTemplate: ->
      element             = @element
      templateColumnsId   = @options.templateColumnsId
      json                = @options.json
      template            = Handlebars.compile $("#"+templateColumnsId).html()
      @_registerPartials()
      result              = template json

      # display the result
      element.html result
      @_trigger "templateCompiled", element, json, result

    # Register handlebars partials
    _registerPartials: ->
      templateColumnsId   = @options.templateColumnsId
      rowsTemplateId      = @options.rowsTemplateId
      cellTemplateId      = @options.cellTemplateId
      Handlebars.compile $("#"+rowsTemplateId).html();
      Handlebars.registerPartial "rows", $("#"+rowsTemplateId).html();
      Handlebars.compile $("#"+cellTemplateId).html();
      Handlebars.registerPartial "cell", $("#"+cellTemplateId).html();
      Handlebars.registerPartial("columns", $("#"+templateColumnsId).html());

    _registerHelpers: ->
      Handlebars.registerHelper('addRow', (options) =>
        attrs = for key, value of options.hash
                     "#{key}=\"#{value}\""
        result = '<span class="'+@addRowClass+'" '+attrs.join(' ')+'>+</span>'

        new Handlebars.SafeString(result)
      )

    # setup the drag and drop feature on rows
    _setupDnd: ->
      rowsWrapper = @options.rowsWrapper
      $('.'+rowsWrapper).sortable(
        connectWith:      '.'+rowsWrapper
        dropOnEmpty:      true
        placeholder: "sortable-placeholder"
      ).disableSelection();

    # the elements with "editable" class name can be editable
    _setupContentsEditable: ->
      editableClass = @options.editableClass
      editableElt   = $('.'+editableClass)
      $('.'+@options.columnsClass).on('click','.'+editableClass, this,@_onEdit)


    _setupAddRow: ->
      _this = this
      $('.'+@addRowClass).click (e) ->
        template = Handlebars.compile $("#"+_this.options.cellTemplateId).html();
        json = { }
        result  = template json
        rowWrapper = $(this).parent().parent().find('ul:first')

        # add the new line on row wrapper
        newElt  = $(result).appendTo rowWrapper
        $(newElt).find('.editable').click()

    # on edit element editable
    # replace the text by an input text
    _onEdit: (e) ->
      e.preventDefault()
      e.stopPropagation()
      e.stopImmediatePropagation()
      target          = $(e.currentTarget)
      boardObj = e.handleObj.data
      editableClass = boardObj.options.editableClass
      target.removeClass('editable')
      # remove the click event
      target.off('click')

      # set
      targetContent   = target.html()
      input = $('<input>',
        type: "text"
        value: targetContent
      ).data('oldValue',targetContent)

      target.html(input)
      input.focus().select()
      input.keyup (e) ->
        boardObj.okEdit(target, input, boardObj) if e.which == 13
        boardObj.cancelEdit(target, input, boardObj) if e.which == 27
      #Create ok and cancel buttons
      okButton = $('<span>',
        class: 'ok'
        text: 'Ok'
      )

      cancelButton = $('<span>',
        class: 'cancel'
        text: 'X'
      ).data('oldValue',targetContent)

      # add the buttons on container
      target.append(okButton)
      target.append(cancelButton)


      # add the clicks events on buttons
      okButton.click(
         boardObj : boardObj,
         target: target,
         input: input
        ,
        boardObj._onOkEdit
      )

      cancelButton.click(
         boardObj : boardObj,
         target: target
        ,
        boardObj._onCancelEdit
      )

    # Called when the edit was canceled
    _onCancelEdit: (e) ->
      e.preventDefault()
      e.stopPropagation()
      editableElt     = e.handleObj.data.target
      boardObj        = e.handleObj.data.boardObj
      boardObj.cancelEdit(editableElt, $(this), boardObj)

    cancelEdit: (editableElt, input, boardObj) ->
      oldValue        = input.data('oldValue')
      editableElt.html(oldValue)
      editableElt.click(boardObj,boardObj._onEdit)
      editableElt.addClass('editable')
      boardObj._trigger( "editCanceled", editableElt, input, boardObj, oldValue )

    # Called when the edit was validated
    _onOkEdit: (e) ->
      e.preventDefault()
      e.stopPropagation()
      editableElt     = e.handleObj.data.target
      inputElt        = e.handleObj.data.input
      boardObj        = e.handleObj.data.boardObj
      boardObj.okEdit editableElt, inputElt, boardObj

    okEdit: (editableElt, inputElt, boardObj) ->
      newValue        = $(inputElt).val()
      editableElt.html(newValue)
      editableElt.click(boardObj,boardObj._onEdit)
      editableElt.addClass('editable')
      boardObj._trigger( "editValidated", editableElt, inputElt, boardObj, newValue )
