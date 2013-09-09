$(function() {
    $.widget("clamz.board", {
      options: {
        items: "items",
        layoutRows: "<ul>{{#each rows }}<li>{{name}}</li>{{/each}}</ul>",
        layoutColumns: "<ul>{{#each columns }}<li>{{name}}((((rowstemplate))))</li>{{/each}}</ul>",
        json: {
          columns: [
            {
              name: "test",
              rows: [
                {
                  name: "row1-1"
                }, {
                  name: "row1-2"
                }
              ]
            }, {
              name: "test2",
              rows: [
                {
                  name: "row2-1"
                }, {
                  name: "row2-2"
                }, {
                  name: "row2-3"
                }
              ]
            }
          ]
        }
      },
      _create: function() {
        var element, json, layoutColumns, layoutRows, template;
        element = this.element;
        layoutColumns = this.options.layoutColumns;
        layoutRows = this.options.layoutRows;
        json = this.options.json;
        layoutColumns = layoutColumns.replace("((((rowstemplate))))", layoutRows);
        template = Handlebars.compile(layoutColumns);
        return element.html(template(json));
      }
    });
    return $("#board-container").board();
  });