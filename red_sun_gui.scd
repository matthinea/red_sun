//declare buses
(
a = Bus.control(s, 1);
b = Bus.control(s, 1);
c = Bus.control(s, 1);
d = Bus.control(s, 1);
e = Bus.control(s, 1);
h = Bus.control(s, 1);
)
//end declare buses

//ADSR_GUI------------------
//defaults: att = 0.01, dec = 0.3, sus = 0.5, rel = 1;
Window.closeAll;
(
w = Window("Envelope", Rect(750, 450, 300, 350))
.front
.alwaysOnTop_(true);
StaticText(w, Rect(180, 20, 150, 30)).string_("Base Amp");
~slider1 = Slider(w, Rect(20, 20, 150, 30)) //.background_(Color.rand)
.value_(0.5)
.action_({
	arg obj1;
	var attack;
	attack = obj1.value.linlin(0,1,0, 0.3).postln;
	a.set(attack);
});
StaticText(w, Rect(180, 60, 150, 30)).string_("Low C Amp");
~slider2 = Slider(w, Rect(20, 60, 150, 30))
.value_(0.18)
.action_({
	arg obj2;
	var decay;
	decay = obj2.value.linlin(0,1,0, 0.4).postln;
	b.set(decay);
});
StaticText(w, Rect(180, 100, 150, 30)).string_("G Amp");
~slider3 = Slider(w, Rect(20, 100, 150, 30))
.value_(0.5)
.action_({
	arg obj3;
	var sustain;
	sustain = obj3.value.linlin(0,1,0, 3.4).postln;
	c.set(sustain);
});
StaticText(w, Rect(180, 140, 150, 30)).string_("F Amp");
~slider3 = Slider(w, Rect(20, 140, 150, 30))
.value_(1)
.action_({
	arg obj4;
	var release;
	release = obj4.value.linlin(0,1,0, 3.4).postln;
	d.set(release);
});
StaticText(w, Rect(180, 180, 150, 30)).string_("Z Amp");
~slider3 = Slider(w, Rect(20, 180, 150, 30))
.value_(1)
.action_({
	arg obj4;
	var release;
	release = obj4.value.linlin(0,1,0, 1).postln;
	e.set(release);
});
StaticText(w, Rect(180, 220, 150, 30)).string_("PlayBuf Amp");
~slider3 = Slider(w, Rect(20, 220, 150, 30))
.value_(1)
.action_({
	arg obj4;
	var release;
	release = obj4.value.linlin(0,1,0, 2).postln;
	h.set(release);
});
)//end ADSR_GUI


//Envelope code in the synth looks like this:
var att = In.kr(a), dec = In.kr(b), sus = In.kr(c), rel = In.kr(d);
var adsr = Env.adsr(att, dec, sus, rel);
var env = EnvGen.kr(adsr, gate, doneAction: 2);
//end