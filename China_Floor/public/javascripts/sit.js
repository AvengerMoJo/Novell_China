
var Sits = {

  addSit: function( event, obj ) {
    $('sit_x').value = Event.pointerX(event) - obj.offsetLeft - 5; 
    $('sit_y').value = Event.pointerY(event) - obj.offsetTop - 5;
    if( $('new_sit_image') == null ) { 
      var new_sit = document.createElement('div'); 
      new_sit.id = "new_sit_image"; 
      new_sit.style.position = "absolute" ; 
      var new_image = document.createElement('img');
      new_image.src = "/sitimage/new.png";
      new_sit.appendChild(new_image);
    } else { 
        var new_sit = $('new_sit_image');
    }
    obj.appendChild( new_sit );
    Sits.showSit( $('sit_x').value , $('sit_y').value, new_sit );
    //setInterval ( "Sits.blinking( $('new_sit_image') );" , 700 );
  },
 
  showSit: function( x, y, obj ) { 
    obj.style.position = 'absolute';
    obj.style.left = Number(obj.parentNode.offsetLeft) + Number(x) +"px";
    obj.style.top =  Number(obj.parentNode.offsetTop) + Number(y) + "px";
  }, 

  editSit: function( event, obj, id ) {
    $('sit_x').value = Event.pointerX(event) - obj.offsetLeft - 5; 
    $('sit_y').value = Event.pointerY(event) - obj.offsetTop - 5;
    Sits.showSit( $('sit_x').value, $('sit_y').value, $('sit'+id) );
  },

  blinking: function (obj){ 
    if( obj != null )
    obj.style.visibility = obj.style.visibility == 'hidden' ? 'visible' : 'hidden';
  }
}


    //alert(  'sit$id' ).style )
    //$( 'sit$id' ).style.position = 'fixed';
    //$( 'sit$id' ).style.left = $( 'sit$id' ).parent.offsetLeft + x;
    //$( 'sit$id' ).style.top =  $( 'sit$id' ).parent.offsetTop + y;
