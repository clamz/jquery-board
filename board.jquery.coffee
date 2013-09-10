$ ->
  $.widget "clamz.board",
    options:
      templateColumnsId:  'columns-template'
      columnsClass:       'board-column'
      rowsClass:          'board-row'
      rowsWrapper:        'rows-wrapper'
      rowsTemplateId:     'rows-template'
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
      Handlebars.compile $("#"+rowsTemplateId).html();
      Handlebars.registerPartial "rows", $("#"+rowsTemplateId).html();
      Handlebars.registerPartial("columns", $("#"+templateColumnsId).html());
    
    _setupDnd: ->
      rowsWrapper = @options.rowsWrapper
      $('.'+rowsWrapper).sortable(
        connectWith:      '.'+rowsWrapper
        dropOnEmpty:      true
       
      ).disableSelection();
