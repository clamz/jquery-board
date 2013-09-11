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
    _create: ->
      @_compileTemplate()
      @_setupDnd()
      @_setupContentsEditable()

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

    _registerPartials: ->
      templateColumnsId   = @options.templateColumnsId
      rowsTemplateId      = @options.rowsTemplateId
      cellTemplateId      = @options.cellTemplateId
      Handlebars.compile $("#"+rowsTemplateId).html();
      Handlebars.registerPartial "rows", $("#"+rowsTemplateId).html();
      Handlebars.compile $("#"+cellTemplateId).html();
      Handlebars.registerPartial "rows", $("#"+cellTemplateId).html();
      Handlebars.registerPartial("columns", $("#"+templateColumnsId).html());
    
    _setupDnd: ->
      rowsWrapper = @options.rowsWrapper
      $('.'+rowsWrapper).sortable(
        connectWith:      '.'+rowsWrapper
        dropOnEmpty:      true
       
      ).disableSelection();

    _setupContentsEditable: ->
      editableClass = @options.editableClass
      editableElt   = $('.'+editableClass)
      editableElt.click(this,@_onEdit)        

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
      )

      target.html(input)
      input.focus()
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
      target.append(cancelButton)
      target.append(okButton)

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

    _onCancelEdit: (e) ->
      e.preventDefault()
      e.stopPropagation()
      editableElt     = e.handleObj.data.target
      oldValue        = $(this).data('oldValue')
      boardObj        = e.handleObj.data.boardObj

      editableElt.html(oldValue)
      editableElt.click(boardObj,boardObj._onEdit)
      boardObj._trigger( "editCanceled", e, oldValue )

     _onOkEdit: (e) ->
      e.preventDefault()
      e.stopPropagation()
      editableElt     = e.handleObj.data.target
      inputElt        = e.handleObj.data.input
      boardObj        = e.handleObj.data.boardObj
      newValue        = $(inputElt).val()

      editableElt.html(newValue)      
      editableElt.click(boardObj,boardObj._onEdit)
      boardObj._trigger( "editValidated", e, newValue )
      