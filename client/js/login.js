(function(codeYourAdv) {
  'use strict';

  var userToken = {};

  codeYourAdv = codeYourAdv || (window.codeYourAdv = {});

  // login event

  $('#login form').on('submit', function (event){
    event.preventDefault();
    console.log("hi");

    //ajax call to get token

    $.ajax({
      url: '/login',
      type: 'POST',
      dataType: 'JSON',
      contentType: 'application/json',
      success: function getToken (data){
        userToken.token = data.token;
        console.log(userToken.token);
        $('#login').hide();
        $('nav, #story-list').css( "display", "block");
        console.log( userToken);

        // create error, update success, variable to store tokens

      }

    });

  });

  // json.parse

})(window.codeYourAdv);
