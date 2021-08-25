var keydownK1 = [];
var keydownK2 = [];
var keyupK1 = [];
var keyupK2 = [];
var keyup = [];
var keypress = [];
var keyD;
var keyP;
var keyU;

function onkeyDown(x) {
	keyD=x.code.replace("Key","");
	for (var i = 0; i < keydownK1.length; i++) {
		var currentKeys = getKeys(keydownK1,keydownK2,i);
		if (currentKeys.includes(keyD)) {
			keydownHandler.run(i);
		}
	}
}

function onkeyUp(x) {
	keyU=x.code.replace("Key","");
	for (var i = 0; i < keyupK1.length; i++) {
		var currentKeys = getKeys(keyupK1,keyupK2,i);
		if (currentKeys.includes(keyU)) {
			keyupHandler.run(i);
		}
	}
}

function getKeys(x,y,z) {
	return y[x.indexOf(x[z])];
}


function onkeyPress() {
}

function onClick() {
}

function onmousemove() {
}

function onmousepress() {
}

function resize() {
	canvas.height = window.innerHeight;
	canvas.width = window.innerWidth;
	field.fillRect(0,0,canvas.width,canvas.height);
}

onkeyPress.register = function(x,y,z) {
	
}

class delegate {
	constructor() {
		this.functions=[];
		this.params=[];
	}		
	set add(test) {
		console.log("Added delegate: "+test);
		this.functions[this.functions.length]=test;
	}
	set param(test) {
		this.params[this.functions.length-1]=test;
	}
	get current() {
		return this.functions;
	}
	run(x=null) {
		if (x==null) {
		for (var i = 0; i < this.functions.length; i++) {
			window[this.functions[i]](this.params[i]);
		}
		} else {
			window.setTimeout(this.functions[x]+"("+this.params[x]+");",0);
		}
	}
	set remove(test) {
		this.params = this.params.splice(this.functions.indexOf(test),1);
		this.functions = this.functions.splice(this.functions.indexOf(test),1);
		console.log("Removed delegate: "+test);
	}
}
var keydownHandler = new delegate();
var keyupHandler = new delegate();
var keypressHandler = new delegate();

keydownHandler.register = function(x,y) { // x is function to be ran when any of the keys in the array y is pressed
	keydownK1[keydownK1.length]=x;
	keydownHandler.add=x;
	keydownHandler.param="keyD";
	keydownK2[keydownK2.length]=y;
}

keyupHandler.register = function(x,y) { // x is function to be ran when any of the keys in the array y is released
	keyupK1[keyupK1.length]=x;
	keyupHandler.add=x;
	keyupHandler.param="keyU";
	keyupK2[keyupK2.length]=y;
}