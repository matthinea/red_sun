s.boot;

//define synths and patterns
{SinOsc.ar}.play
~out=Bus.audio(s,2);
(
SynthDef(\saturnADSR, {arg freq1, freq2, gate, outbus=~out, cycle=1, att=6,dec=1, sus=1, rel=4, amp_control;
	var out1,out2,env,mul1,mul2, amp;
	amp = In.kr(amp_control);
	mul1=SinOsc.ar(
		LFNoise0.kr(cycle,0.1,0.1),mul:0.35,add:0.5);
	mul2=SinOsc.ar(
		LFNoise0.kr(cycle,0.1,0.1),mul:0.35,add:0.5);
	env=EnvGen.kr(Env.adsr(att,dec,sus,rel),gate:gate,doneAction:2);
	out1=Pan2.ar(SinOsc.ar(freq1,pi,mul1),SinOsc.ar(LFNoise0.kr,mul:0.5));
	out2=Pan2.ar(SinOsc.ar(freq2,0,mul2),SinOsc.ar(LFNoise0.kr,mul:0.5));
	Out.ar(outbus,(out1+out2)*env*amp);
}).add;
SynthDef(\saturnPass,{
	var out;
	out=In.ar(~out);
	out=AllpassN.ar(out, 0.2,0.02+0.20.rand,8);
	8.do{Out.ar(0,out)};
}).add
)

(//write a synth that reads in from a bus and multiplie a signal by a sine oscillator
SynthDef(\sine_filter, {|bus = 16, amp = 1|
	var out;
	out = In.ar(bus,2);
	out = out * SinOsc.ar(7, 0, SinOsc.kr(1/8, 0, 0.5, 0.5),0.5);
	Out.ar(0, out * amp);
	}
).add
)

(
(
g = Routine ( {

	var release = 0.5;
	var quarter_note = 2.5;
	var amplitude = In.kr(c, 1);
	var freq1a = 67.midicps;
	var freq1b = 74.midicps;
	var freq1c = 76.midicps;


	inf.do {
		~a=Synth(\saturnADSR, [
			\freq1,freq1a,\freq2,freq1a,
			\gate,1,
			\amp_control, c, \att,0.1
		]);
		("A".postln);
		release.wait;
		~a.set(\gate,0);
		quarter_note.wait;
		0.1.wait;

		~b=Synth(\saturnADSR, [
			\freq1,freq1b,\freq2,freq1b,
			\gate,1,
			\amp_control, c,\att,0.1
		]);
		("A".postln);
		release.wait;
		~b.set(\gate,0);
		quarter_note.wait;
		0.1.wait;

		~c=Synth(\saturnADSR, [
			\freq1,freq1c,\freq2,freq1c,
			\gate,1,
			\amp_control, c,\att,0.1
		]);
		("A".postln);
		release.wait;
		~c.set(\gate,0);
		quarter_note.wait;
		rand(7, 9).wait;
	}

	}
)
);

(
f = Routine ( {

	var release = 0.5;
	var quarter_note = 2.7;

	var freq1a = 69.midicps;
	var freq1b = 74.midicps;
	var freq1c = 72.midicps;


	inf.do {

		~three=Synth(\saturnADSR, [
			\freq1,freq1c,\freq2,freq1c,
			\gate,1,
			\amp_control, d,\att,0.1,\rel,9
		]);
		("A".postln);
		release.wait;
		~three.set(\gate,0);
		quarter_note.wait;


		~one=Synth(\saturnADSR, [
			\freq1,freq1a,\freq2,freq1a,
			\gate,1,
			\amp_control, d,\att,0.1,\rel,6
		]);
		("A".postln);
		release.wait;
		~one.set(\gate,0);
		quarter_note.wait;

		~two=Synth(\saturnADSR, [
			\freq1,freq1b,\freq2,freq1b,
			\gate,1,
			\amp_control, d,\att,0.1,\rel,6
		]);
		("A".postln);
		release.wait;
		~two.set(\gate,0);
		quarter_note.wait;
		rand(6, 9).wait;


	}

	}
)
)
)
// -----------------------------------------------------------------------------------------------------
s.boot;

//performance
s.stopRecording;
~base = Synth(\saturnADSR,[\freq1,200,\freq2,300,\gate,1,\amp_control, a]);  //GUI?

~lowC = Synth(\saturnADSR, [\freq1,48.midicps,\freq2,60.midicps,\gate,1,\amp_control, b]);
~lowC.set(\freq1, 43.midicps, \freq2, 48.midicps);
~lowC.set(\freq1, 48.midicps, \freq2, 48.midicps);
s.record;
//automate this:
~base.set(\freq1,200, \freq2, 300, \amp, 0.2);
~base.set(\freq1,260, \freq2, 336, \amp, 0.2);
~base.set(\freq1,260*1.5, \freq2, 336*1.5, \amp, 0.25);
~base.free;
//to-do: fix the fucking envelope to actually sound interesting/useful when triggered

f.play;
f.stop;
g.play;
g.stop;

(
~wave = Synth(\saturnADSR, [\outbus, 16, \freq1,74.midicps, \freq2, 74.midicps, \gate,1,\amp_control, e],addAction: 'addToHead');
z = Synth(\sine_filter, [\bus, 16], target:~wave, addAction: \addAfter);
)
z.free;

g.stop;

//end ------------------------------------------------------------------

//field recording

~bufFieldRecording = Buffer.read(s, "/Users/matthewhinea/Documents/samples/red sun tianjin spoken chinese.aiff");

//play through the whole buff, at a low volume the first time, then loop at phrase repeated by man

(
SynthDef(\playRecording, {|startPos=0, trigger=1, amp_control|
	var out, env, loop_trig, amp;
	amp = In.kr(amp_control);
	loop_trig = Impulse.kr(~bufFieldRecording.duration.reciprocal);
	env = EnvGen.kr(Env.linen(6,~bufFieldRecording.duration, 5), loop_trig);
	out = PlayBuf.ar(2, ~bufFieldRecording.bufnum, 1, trigger, startPos, loop:0);
	Out.ar(0, out * env * amp);
	}
).add
)
y = Synth(\playRecording, [\amp_control, h, \startPos, 0, \trigger, 1]);

y.set(\trigger, 0);
y.set(\trigger, 1, \startPos, ~bufFieldRecording.numFrames/3.2);
y.set(\trigger, 1, \startPos, 0);

y.free;

r.play;
(
r = Routine( {
	inf.do {

		var release = 0.05;
		var quarter_note = 1/1.8;
		var amplitude = 0.2;

		2.do {

			var freq1a = 69.midicps;
			var freq1b = 76.midicps;


			a=Synth(\saturnADSR, [
				\freq1,freq1a,\freq2,freq1a,
				\gate,1,
				\amp, amplitude,\att,0.01
			]);
			("A".postln);
			release.wait;
			a.set(\gate,0);
			quarter_note.wait;

			b=Synth(\saturnADSR, [
				\freq1,freq1a,\freq2,freq1a,
				\gate,1,
				\amp, amplitude,\att,0.001
			]);
			release.wait;
			b.set(\gate,0);
			quarter_note.wait;

			c=Synth(\saturnADSR, [
				\freq1,freq1a,\freq2,freq1a,
				\gate,1,
				\amp, amplitude,\att,0.001
			]);
			release.wait;
			c.set(\gate,0);
			quarter_note.wait;

			d=Synth(\saturnADSR, [
				\freq1,freq1a,\freq2,freq1a,
				\gate,1,
				\amp, amplitude,\att,0.001
			]);
			release.wait;
			d.set(\gate,0);
			quarter_note.wait;

			e=Synth(\saturnADSR, [
				\freq1,freq1b,\freq2,freq1b,
				\gate,1,
				\amp, amplitude,\att,0.001
			]);
			release.wait;
			e.set(\gate,0);
			(quarter_note * 4).wait;
		};

		2.do {
			var freq2a = 67.midicps;
			var freq2b = 74.midicps;
			a=Synth(\saturnADSR, [
				\freq1,freq2a,\freq2,freq2a,
				\gate,1,
				\amp, amplitude,\att,0.01
			]);
			("A".postln);
			release.wait;
			a.set(\gate,0);
			quarter_note.wait;

			b=Synth(\saturnADSR, [
				\freq1,freq2a,\freq2,freq2a,
				\gate,1,
				\amp, amplitude,\att,0.001
			]);
			release.wait;
			b.set(\gate,0);
			quarter_note.wait;

			c=Synth(\saturnADSR, [
				\freq1,freq2a,\freq2,freq2a,
				\gate,1,
				\amp, amplitude,\att,0.001
			]);
			release.wait;
			c.set(\gate,0);
			quarter_note.wait;

			d=Synth(\saturnADSR, [
				\freq1,freq2a,\freq2,freq2a,
				\gate,1,
				\amp, amplitude,\att,0.001
			]);
			release.wait;
			d.set(\gate,0);
			quarter_note.wait;

			e=Synth(\saturnADSR, [
				\freq1,freq2b,\freq2,freq2b,
				\gate,1,
				\amp, amplitude,\att,0.001
			]);
			release.wait;
			e.set(\gate,0);
			(quarter_note * 4).wait;
		}
	}
})
)


