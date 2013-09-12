(function() {
  $(function() {
    return $.widget("clamz.board", {
      options: {
        templateColumnsId: 'columns-template',
        columnsClass: 'board-column',
        rowsClass: 'board-row',
        rowsWrapper: 'rows-wrapper',
        editableClass: 'editable',
        rowsTemplateId: 'rows-template',
        cellTemplateId: 'cell-template',
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
        this._setupDnd();
        return this._setupContentsEditable();
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
        var cellTemplateId, rowsTemplateId, templateColumnsId;
        templateColumnsId = this.options.templateColumnsId;
        rowsTemplateId = this.options.rowsTemplateId;
        cellTemplateId = this.options.cellTemplateId;
        Handlebars.compile($("#" + rowsTemplateId).html());
        Handlebars.registerPartial("rows", $("#" + rowsTemplateId).html());
        Handlebars.compile($("#" + cellTemplateId).html());
        Handlebars.registerPartial("cell", $("#" + cellTemplateId).html());
        return Handlebars.registerPartial("columns", $("#" + templateColumnsId).html());
      },
      _setupDnd: function() {
        var rowsWrapper;
        rowsWrapper = this.options.rowsWrapper;
        return $('.' + rowsWrapper).sortable({
          connectWith: '.' + rowsWrapper,
          dropOnEmpty: true
        }).disableSelection();
      },
      _setupContentsEditable: function() {
        var editableClass, editableElt;
        editableClass = this.options.editableClass;
        editableElt = $('.' + editableClass);
        return editableElt.click(this, this._onEdit);
      },
      _onEdit: function(e) {
        var boardObj, cancelButton, editableClass, input, okButton, target, targetContent;
        e.preventDefault();
        e.stopPropagation();
        e.stopImmediatePropagation();
        target = $(e.currentTarget);
        boardObj = e.handleObj.data;
        editableClass = boardObj.options.editableClass;
        target.removeClass('editable');
        target.off('click');
        targetContent = target.html();
        input = $('<input>', {
          type: "text",
          value: targetContent
        }).data('oldValue', targetContent);
        target.html(input);
        input.focus().select();
        input.keyup(function(e) {
          if (e.which === 13) {
            boardObj.okEdit(target, input, boardObj);
          }
          if (e.which === 27) {
            return boardObj.cancelEdit(target, input, boardObj);
          }
        });
        okButton = $('<span>', {
          "class": 'ok',
          text: 'Ok'
        });
        cancelButton = $('<span>', {
          "class": 'cancel',
          text: 'X'
        }).data('oldValue', targetContent);
        target.append(okButton);
        target.append(cancelButton);
        okButton.click({
          boardObj: boardObj,
          target: target,
          input: input
        }, boardObj._onOkEdit);
        return cancelButton.click({
          boardObj: boardObj,
          target: target
        }, boardObj._onCancelEdit);
      },
      _onCancelEdit: function(e) {
        var boardObj, editableElt;
        e.preventDefault();
        e.stopPropagation();
        editableElt = e.handleObj.data.target;
        boardObj = e.handleObj.data.boardObj;
        return boardObj.cancelEdit(editableElt, $(this), boardObj);
      },
      cancelEdit: function(editableElt, input, boardObj) {
        var oldValue;
        oldValue = input.data('oldValue');
        editableElt.html(oldValue);
        editableElt.click(boardObj, boardObj._onEdit);
        editableElt.addClass('editable');
        return boardObj._trigger("editCanceled", editableElt, input, boardObj, oldValue);
      },
      _onOkEdit: function(e) {
        var boardObj, editableElt, inputElt;
        e.preventDefault();
        e.stopPropagation();
        editableElt = e.handleObj.data.target;
        inputElt = e.handleObj.data.input;
        boardObj = e.handleObj.data.boardObj;
        return boardObj.okEdit(editableElt, inputElt, boardObj);
      },
      okEdit: function(editableElt, inputElt, boardObj) {
        var newValue;
        newValue = $(inputElt).val();
        editableElt.html(newValue);
        editableElt.click(boardObj, boardObj._onEdit);
        editableElt.addClass('editable');
        return boardObj._trigger("editValidated", editableElt, inputElt, boardObj, newValue);
      }
    });
  });

}).call(this);
