$ ->
  $.widget "clamz.board",
    options:
      items: "items"
      layoutRows: "<ul>{{#each rows }}<li>{{name}}</li>{{/each}}</ul>"
      layoutColumns: "<ul>{{#each columns }}<li>{{name}}((((rowstemplate))))</li>{{/each}}</ul>"
      json: columns: [
          name: "test"
          rows: [
            name: "row1-1"
          ,
            name: "row1-2"
          ]
        ,
          name: "test2"
          rows: [
            name: "row2-1"
          ,
            name: "row2-2"
          ,
            name: "row2-3"
          ]
        ]
    _create: ->
      element       = @element
      layoutColumns = @options.layoutColumns
      layoutRows    = @options.layoutRows
      json          = @options.json

     
      layoutColumns = layoutColumns.replace("((((rowstemplate))))", layoutRows)
      template = Handlebars.compile layoutColumns
      element.html template json

  $("#board-container").board()