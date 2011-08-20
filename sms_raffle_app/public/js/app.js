var user_name,email,phone_number;

jQuery(document).ready(function() {
  $("#results").hide();
  $("input#pick_winner").click(function(){
    $.ajax({
      url: '/get_winner',
      type: 'POST',
      dataType: 'json',
      complete: function(xhr, textStatus) {
        console.log("responseText => " + xhr.responseText);
        winner = $.parseJSON(xhr.responseText);
        if(winner!=null){
          $("#results").show();
          user_name = winner.user_name
          phone_number = winner.phone_number
          email = winner.email
          $("td#user_name").html(user_name);
          $("td#phone").html(phone_number);
          $("td#email").html(email);
        }else{
         $.gritter.add({
            title: "No one left",
            text: "Everyone already won something",
            image: 'images/fail.png'
          });
        
        $("td#user_name").html("-");
        $("td#phone").html("-");
        $("td#email").html("-");
      }
    },
    error: function(xhr, textStatus, errorThrown) {
      console.log("oh shit");
      console.log(xhr);
    }
  });
});
  
  $("input#send_notification").click(function(){
    if(phone_number==null){
      console.log("No one to msg");
      $.gritter.add({
        title: "No one left",
        text: "There isnt anyone left",
        image: 'images/fail.png'
      });
    }else{
      $.ajax({
        url: '/send_notification',
        type: 'POST',
        dataType: 'json',
        data: "phone_number="+phone_number+"&email="+email+"&user_name="+user_name,
        complete: function(xhr, textStatus) {
          console.log(xhr.responseText);
          $.gritter.add({
            title: "Sent alert",
            text: "We have sent an alert to "+user_name,
            image: 'images/success.png'
          });
          $("td#the_winner").hide();
        },
        error: function(xhr, textStatus, errorThrown) {
          console.log("oh shit");
          console.log(xhr);
            $.gritter.add({
              title: "Error",
              text: "oh shit, something bad happened",
              image: 'images/error.png'
            });
        }
      });
    }
  });
});