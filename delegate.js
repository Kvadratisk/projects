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
			window[this.functions[x]](this.params[x]);
		}
	}
	set remove(test) {
		this.params = this.params.splice(this.functions.indexOf(test),1);
		this.functions = this.functions.splice(this.functions.indexOf(test),1);
		console.log("Removed delegate: "+test);
	}
}
