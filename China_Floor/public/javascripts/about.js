function about() {
  if (Element.empty('about-content')) {
    new Ajax.Updater('about-content', 'rails/info/properties', {
        method:     'get',
        onFailure:  function() {Element.classNames('about-content').add('failure')},
        onComplete: function() {new Effect.BlindDown('about-content', {duration: 0.25})}
    });
  } else {
    new Effect[Element.visible('about-content') ? 
        'BlindUp' : 'BlindDown']('about-content', {duration: 0.25});
  }
}

function ops_team (show) {
  if (Element.empty('team-id-list')) {
    $('team-id-list').innerHTML ="Loading .... <img src='/images/loading.gif' />";
    if( show ) 
      new Effect.BlindDown('team-id-list', {duration: 0.25});
    new Ajax.Updater('team-id-list', '/team/namelogin/', {
        method:     'get',
        onFailure:  function() {Element.classNames('team-id-list').add('failure')},
        onComplete:  function() {
            $('team-id-table').onmousedown =function(event) {
                $('sit_user').value = event.target.parentNode.id; 
            }
        }
    });
  } else {
    if( show ) {
       new Effect['BlindDown']('team-id-list', {duration: 0.25});
    } else { 
       new Effect['BlindUp']('team-id-list', {duration: 0.25});
    }
  }
}

function person_info( show, userid, event ) {
  if (event === "undefined") { event = null; }

  if( show )  {
    $('user-info').style.width = "350px";
    $('user-info').style.height = "300px";
    
    $('user-info').style.left = ( (Event.pointerX(event) - 450) > 0 ) ? (Event.pointerX(event) - 450) + "px" : "10px"
    $('user-info').style.top =  (Event.pointerY(event) - 200) > 0 ? (Event.pointerY(event) - 200) + "px" : "10px"
    // $('user-info').style.top =  (Event.pointerY(event) - 200) + "px";
    // if ( $('user-info').style.left < 0 ) $('user-info').style.left = '10px'; 
    // if ( $('user-info').style.top < 0 ) $('user-info').style.top = '10px'; 
    $('user-info').innerHTML ="Loading .... <img src='/images/loading.gif' /><img id=user-info-close-icon src='/images/close.png' onclick='person_info(false);'/>";

    new Effect.BlindDown('user-info', {duration: 0.25});
    new Ajax.Updater('user-info', '/suseuser/'+userid , {
        method:     'get',
        onFailure:  function() {Element.classNames('user-info').add('failure')}
    });
  } else { 
    new Effect['BlindUp']('user-info', {duration: 0.25});
  }
}
