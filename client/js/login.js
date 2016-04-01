(function(codeYourAdv) {
  'use strict';
  codeYourAdv = codeYourAdv || (window.codeYourAdv = {});

  codeYourAdv.userToken = {};
  // login event

  $('#login form').on('submit', function (event){
    event.preventDefault();
    console.log("hi");

    //ajax call to get token

    $.ajax({
      url: '/login',
      type: 'POST',
      dataType: 'json',
      contentType: 'application/json',
      success: function getToken (data){
        codeYourAdv.userToken.token = data.token;
        $('#login').hide();
        $('nav, #story-list').css( "display", "block");
        console.log( codeYourAdv.userToken);

      },
      error: function loginError (xhr){
        console.error(xhr);      }
    });

  });


})(window.codeYourAdv);
