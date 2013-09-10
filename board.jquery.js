(function() {
  $(function() {
    return $.widget("clamz.board", {
      options: {
        templateColumnsId: 'columns-template',
        columnsClass: 'board-column',
        rowsClass: 'board-row',
        rowsWrapper: 'rows-wrapper',
        rowsTemplateId: 'rows-template',
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
              columns: [
                {
                  name: "row2-1",
                  rows: [
                    {
                      name: "test"
                    }, {
                      name: "test2"
                    }
                  ]
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
        this._compileTemplate();
        return this._setupDnd();
      },
      _compileTemplate: function() {
        var element, json, result, template, templateColumnsId;
        element = this.element;
        templateColumnsId = this.options.templateColumnsId;
        json = this.options.json;
        template = Handlebars.compile($("#" + templateColumnsId).html());
        this._registerPartials();
        result = template(json);
        element.html(result);
        return this._trigger("templateCompiled", element, json, result);
      },
      _registerPartials: function() {
        var rowsTemplateId, templateColumnsId;
        templateColumnsId = this.options.templateColumnsId;
        rowsTemplateId = this.options.rowsTemplateId;
        Handlebars.compile($("#" + rowsTemplateId).html());
        Handlebars.registerPartial("rows", $("#" + rowsTemplateId).html());
        return Handlebars.registerPartial("columns", $("#" + templateColumnsId).html());
      },
      _setupDnd: function() {
        var rowsWrapper;
        rowsWrapper = this.options.rowsWrapper;
        return $('.' + rowsWrapper).sortable({
          connectWith: '.' + rowsWrapper,
          dropOnEmpty: true
        }).disableSelection();
      }
    });
  });

}).call(this);
