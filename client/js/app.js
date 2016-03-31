(function(codeYourAdv) {
  'use strict';

  var userInfo = {};

  codeYourAdv = codeYourAdv || (window.codeYourAdv = {});

  $('#login form').on('submit', function (event){
    event.preventDefault();
    console.log("hi");


    $.ajax({
      url: '/login',
      type: 'POST',
      contentType: 'application/json',
      // data: JSON.stringify({token: userToken}),
      success: function userToken (data){
        // userInfo.token = data.token;

        console.log( data );
      }



    });



  });



  // json.parse



})(window.codeYourAdv);
