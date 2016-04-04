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
    codeYourAdv.newLiFunc();
    $( ".create-story-step" ).append('<input>' ).attr({'type':'checkbox', 'class': 'end', 'value': true}).val('This is the last step');
    console.log(codeYourAdv.stepId);


        // .append('<input>')
        //   .find('input')
        //     .attr({'type':'checkbox', 'class': 'end', 'value': true})
        //     .end()



  },
    error: function new_stepError (xhr){
      console.error(xhr);
    }

  });

});

})(window.codeYourAdv);
