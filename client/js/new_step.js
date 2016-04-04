(function(codeYourAdv) {
  'use strict';

codeYourAdv = codeYourAdv || (window.codeYourAdv = {});

var stepId = {};

// event handler for new step inputs

codeYourAdv.startValue = function newStep (){
  if ($('#stepsList').find('#newStep').length > 0){
            return false;
  }
  else {
            return true;
  }
};
//
$('.create-story-step').on('submit', function (event){
  event.preventDefault();
  var stepText = $('#new-step-text').val();
  var opAtext = $('#new-step-option-a').val();
  var opBtext = $('#new-step-option-b').val();
  codeYourAdv.startValue();
  console.log(codeYourAdv.startValue());

// ajax call to create step id

$.ajax({
  url: '/new_step',
  type: 'POST',
  dataType: 'JSON',
  contentType: 'application/json',
  data: JSON.stringify({text: stepText, optionA: opAtext, optionB: opBtext, start: codeYourAdv.startValue, end: false}),
  headers: {
    authorization: codeYourAdv.userToken
  },
  success: function newStep (data){
    stepId = data;
    codeYourAdv.stepId = stepId;
    console.log(codeYourAdv.stepId);

// function to display data in list item
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
          .val(codeYourAdv.stepId.text);
        





    // .append('<span>').addClass('step-id');
      // .find('.step-id')
      //   .text(codeYourAdv.stepId.step_id);
      // .find('')
      //   .text(codeYourAdv.stepId.step_id);


  },
    error: function new_stepError (xhr){
      console.error(xhr);
    }

  });

});

})(window.codeYourAdv);
