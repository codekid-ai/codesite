function log(...args) {
  //args.unshift(new Date().toISOString());
  window.saveLog(args);
}

function logError(...args) {
  //args.unshift(new Date().toISOString());
  window.saveLogError(args);
}

function callDartFunction() {
  window.myDartFunction('hello from JavaScript');
}

function addAvatarHandler(id, funcText) {
  console.log('addAvatarHandler: ' +id+ ' ' + funcText)
  window['user_code'+id] =  eval(funcText);
  //eval(funcText);
  //()=> { console.log('lala');} 
  console.log('registered avatarHandler: ' +id+ ' ' + window['user_code'+id])
}

function callAvatarHandler(id) {  
  console.log('callAvatarHandler: ' + id+ ' ' + window['user_code'+id])
  window['user_code'+id]();
  console.log('callAvatarHandler: done')
}

class Avatar {
  constructor(id, name) {
    this.id = id;
    this.name = name;
  }
  jump;
  left;
  right;
  stop;
}

class AvatarImplementation {
  constructor(id, name) {
    this.id = id;
    this.name = name;
  }
  moveBy(x, y) {
    log('moveBy: ' + x + ' ' + y);
    window.avatar_MoveBy(x,y);
  }
  moveLeft(x) {
    console.log('moveLeft: ' + x);
    window.Object_MoveLeft(this.id, x);
  }
  jump() {
    // log('jumping');
    window.jump();
  }
  left() {
    // log('going left');
    window.left();
  }
  right() {
    // log('going right');
    window.right();
  }
  stop() {
    // log('stop');
    window.stop();
  }
}

var avatar = new AvatarImplementation(1, 'avatar');


function keyEvent(event)  {  
  console.log('keyEvent: ' + event.physicalKey + ', ' + event.logicalKey + ', ' + event.isKeyPressed);

  //window['user_code'+id]();

  if(window.handlers!==undefined) {
    window.handlers.forEach((value, key) => {
      console.log('key: ' + key + ', value: ' + value);
      if(key == event.name) {
        console.log('found key: ' + key);
        value(event)();
      }
      // value(event);
    })
  } else {
    console.log('no handlers');
  }
}

// function registerEvent(key, code)  {  
//   console.log('registerEvent');

//   if(window.handlers === undefined) {
//     window.handlers = new Map();
//   }
//   window.handlers.set(key, eval(code));
//   // window.addEventListener('keydown', ()=>{
//   //   console.log('key down');
//   // });
// }

//from here: https://stackoverflow.com/questions/30202951/dart-create-method-from-string
var FunctionObject = function() {
  this.fun = function (name)
  {
    var text = "var funs = " + 'function(name) { return function() { console.log("Hello " + name); }; }';
    eval(text);
    return funs(name);
  };
};

var createFunc = function(name, body) {
  window[name]=new Function(name, body);
}

