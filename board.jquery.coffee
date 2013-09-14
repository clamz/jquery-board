$ ->
  $.widget "clamz.board",
    options:
      templateColumnsId:  'columns-template'
      columnsClass:       'board-column'
      rowsClass:          'board-row'
      rowsWrapper:        'rows-wrapper'
      boardWrapper:        'board-wrapper'
      editableClass:      'editable'
      rowsTemplateId:     'rows-template'
      columnTemplateId:   'column-template'
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
    addColumnClass: 'add-column'
    addRowClass: 'add-row'
    removeRowClass: 'remove-row'
    removeColumnClass: 'remove-column'
    templateRows: null
    templateCell: null
    templateColumn: null
    _create: ->
      @_registerHelpers()
      @_compileTemplate()
      @_setupDnd()
      @_setupContentsEditable()
      @_setupAddColumn()
      @_setupAddRow()
      @_setupRemoveRow()
      @_setupRemoveColumn()

    # compile template
    # and display the result
    _compileTemplate: ->
      element             = @element
      templateColumnsId   = @options.templateColumnsId
      json                = @options.json

      @_registerPartials()
      template            = Handlebars.compile $("#"+templateColumnsId).html()
      result              = template json

      # display the result
      element.html result
      @_trigger "templateCompiled", element, json, result

    # Register handlebars partials
    _registerPartials: ->
      templateColumnsId   = @options.templateColumnsId
      rowsTemplateId      = @options.rowsTemplateId
      columnTemplateId    = @options.columnTemplateId
      cellTemplateId      = @options.cellTemplateId
      @templateRows = Handlebars.compile $("#"+rowsTemplateId).html();
      Handlebars.registerPartial "rows", $("#"+rowsTemplateId).html();
      @templateCell = Handlebars.compile $("#"+cellTemplateId).html();
      Handlebars.registerPartial "cell", $("#"+cellTemplateId).html();
      Handlebars.registerPartial("columns", $("#"+templateColumnsId).html());
      @templateColumn = Handlebars.compile $("#"+columnTemplateId).html();
      Handlebars.registerPartial "column", $("#"+columnTemplateId).html();
    _registerHelpers: ->
      Handlebars.registerHelper('addColumn', (options) =>
        attrs = for key, value of options.hash
                     "#{key}=\"#{value}\""
        result = '<span class="'+@addColumnClass+'" '+attrs.join(' ')+'>+</span>'

        new Handlebars.SafeString(result)
      )

      Handlebars.registerHelper('addRow', (options) =>
        attrs = for key, value of options.hash
                     "#{key}=\"#{value}\""
        result = '<span class="'+@addRowClass+'" '+attrs.join(' ')+'>+</span>'

        new Handlebars.SafeString(result)
      )

      Handlebars.registerHelper('removeRow', (options) =>
        attrs = for key, value of options.hash
                     "#{key}=\"#{value}\""
        result = '<span class="'+@removeRowClass+'" '+attrs.join(' ')+'>X</span>'

        new Handlebars.SafeString(result)
      )

      Handlebars.registerHelper('removeColumn', (options) =>
        attrs = for key, value of options.hash
                     "#{key}=\"#{value}\""
        result = '<span class="'+@removeColumnClass+'" '+attrs.join(' ')+'>X</span>'

        new Handlebars.SafeString(result)
      )

    # setup the drag and drop feature on rows
    _setupDnd: ->
      rowsWrapper = @options.rowsWrapper
      boardWrapper = @options.boardWrapper
      $('.'+rowsWrapper).sortable(
        connectWith:      '.'+rowsWrapper
        dropOnEmpty:      true
        placeholder: "sortable-placeholder"
      ).disableSelection();

      $('.'+boardWrapper).sortable(
        connectWith:      '.'+boardWrapper
        dropOnEmpty:      true
        axis: 'x'
        placeholder: "sortable-placeholder"
      ).disableSelection();

    # the elements with "editable" class name can be editable
    _setupContentsEditable: ->
      editableClass = @options.editableClass
      editableElt   = $('.'+editableClass)
      boardWrapper = @options.boardWrapper
      $('.'+boardWrapper).on('click','.'+editableClass, this,@_onEdit)


    _setupAddColumn: ->
      _this = this
      @element.on 'click', '.'+@addColumnClass, (e) ->
        json = { 
            name: "Modifier moi"
        }
        result  = _this.templateColumn json
        container = _this.element.find('.board-wrapper:first')

        # add the new line on row wrapper
        newElt = $(result).appendTo container
        _this._setupDnd()
        $(newElt).find('.editable').click()

    _setupAddRow: ->
      _this = this
      boardWrapper = @options.boardWrapper
      $('.'+boardWrapper).on 'click', '.'+@addRowClass, (e) ->
        e.stopPropagation()
        template = Handlebars.compile $("#"+_this.options.cellTemplateId).html()
        json = { }
        result  = template json
        rowWrapper = $(this).parent().parent().find('ul:first')

        # add the new line on row wrapper
        newElt  = $(result).appendTo rowWrapper
        $(newElt).find('.editable').click()

    _setupRemoveRow: ->
      _this = this
      boardWrapper = @options.boardWrapper
      $('.'+boardWrapper).on 'click', '.'+@removeRowClass,(e) ->
        e.preventDefault()
        e.stopPropagation()
        row = $(this).parent()
        _this.confirmDialog
          title: 'Confirmation suppression'
          body: 'Êtes vous sûr de vouloir supprimer ? '
          onOk: -> row.remove()

    _setupRemoveColumn: ->
      _this = this
      boardWrapper = @options.boardWrapper
      $('.'+boardWrapper).on 'click', '.'+@removeColumnClass, (e) ->
        e.preventDefault()
        e.stopPropagation()
        column = $(this).parent().parent()
        _this.confirmDialog
          title: 'Confirmation suppression'
          body: 'Êtes vous sûr de vouloir supprimer ? '
          onOk: -> column.remove()

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

      boardWrapper = boardObj.options.boardWrapper
      $('.'+boardWrapper).on 'keyup', input, (e) ->
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

    confirmDialog: (options) ->
      dialogContainer = $('<div>', 
        class: "confirm-dialog"
      )

      titleContainer = $('<div>',
        class: "dialog-title"
        text: options.title
      )

      bodyContainer = $('<div>',
        class: "dialog-body"
        text: options.body
      )

      footerContainer = $('<div>',
        class: "dialog-footer"
      )

      buttonsContainer = $('<div>',
        class: "dialog-buttons-container"
      )

      okButton = $('<span>',
        class: "dialog-ok-button"
        text: "Ok"
      )

      cancelButton = $('<span>',
        class: 'dialog-cancel-button'
        text: 'Annuler'
      )

      buttonsContainer.append(okButton)
      buttonsContainer.append(cancelButton)

      footerContainer.append(buttonsContainer)

      dialogContainer.append(titleContainer)
      dialogContainer.append(bodyContainer)
      dialogContainer.append(footerContainer)

      dialogContainer.on 'click', '.dialog-ok-button', (e) ->
        options.onOk()
        dialogContainer.remove()
      dialogContainer.on 'click', '.dialog-cancel-button', (e) ->
        options.onCancel if options.cancel?
        dialogContainer.remove()

      $('body').append(dialogContainer)


