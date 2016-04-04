(function(codeYourAdv) {
  'use strict';

codeYourAdv = codeYourAdv || (window.codeYourAdv = {});

var storyId = {};

// event handler for new story creation
  $('.create-story').on('click', function (event){
    event.preventDefault();
    $('#create-story').css( "display", "block");
    $('nav').hide();
    console.log("hi");
  });

// story name input event & ajax call to give name, get id
  $('#create-story form').on('submit', function (event){
    event.preventDefault();
    var storyName = $('#new-story-name').val();
    console.log(storyName);


    $.ajax({
      url: '/new_adventure',
      type: 'POST',
      dataType: 'JSON',
      contentType: 'application/json',
      data: JSON.stringify({adventure_name: storyName}),
      headers: {
        authorization: codeYourAdv.userToken
      },
      success: function newStory (data){
        storyId = data;
        $('#create-story').hide();
        $('#edit-story').css("display", "block");
        $('#currentSteps').hide();
        $('.story-name').text(storyName);
        codeYourAdv.storyId = storyId;
        console.log(codeYourAdv.storyId);

      },

        error: function new_adventureError (xhr){
          console.error(xhr);
      }

    });

  });

})(window.codeYourAdv);
