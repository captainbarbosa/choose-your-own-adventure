(function(codeYourAdv) {
  'use strict';

codeYourAdv = codeYourAdv || (window.codeYourAdv = {});


codeYourAdv.newLiFunc = function newLi (){

$('#stepsList')
.append('<li>')
.find('li:last-child')
.append('<h4>')
  .find('h4')
    .text('Step : ' + codeYourAdv.stepId.step_id)
    .end()
  .append('<form>')
    .find('form')
    .attr('class', 'edit-story-step')
    .append('<input>')
      .find('input')
      .attr({'type':'hidden', 'class': 'story-id', 'value':codeYourAdv.storyId.id})
      .end()
    .append('<fieldset>')
      .find('fieldset')
        .append('<h4>')
          .find('h4')
            .text('Step text:')
            .end()
    .append('<textarea>')
      .find('textarea')
      .attr('class', 'new-step-text')
      .val(codeYourAdv.stepId.text)
      .end()
    .append('<div>')
        .find('div')
          .append('<label>')
            .find('label')
            .attr({'for':'new-step-option-a', 'class': 'story-id'})
            .text('Option A: ')
              .append('<textarea>')
                .find('textarea')
                .attr({'type':'text', 'class': 'new-step-option-a'})
                .val(codeYourAdv.stepId.optionA)
                .end()
          .append('<label>')
            .find('label')
              .attr({'for':'new-step-option-b', 'class': 'story-id'})
              .text('Option B: ')
                .append('<textarea>')
                  .find('textarea')
                  .attr({'type':'text', 'class': 'new-step-option-b'})
                  .val(codeYourAdv.stepId.optionB)
                  .end();
};

            })(window.codeYourAdv);
