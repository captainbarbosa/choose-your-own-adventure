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
        storyId.id = data.id;
        console.log(storyId);
        console.log(storyName);
      },
// error function goes here, then display step creation


      });


  });



})(window.codeYourAdv);
