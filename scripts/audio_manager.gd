extends Node

const MIX_RATE := 22050

@onready var rescue_player: AudioStreamPlayer = $RescueSound
@onready var die_player: AudioStreamPlayer = $DieSound
@onready var ability_player: AudioStreamPlayer = $AbilitySound
@onready var victory_player: AudioStreamPlayer = $VictorySound
@onready var failure_player: AudioStreamPlayer = $FailureSound

func _ready() -> void:
	rescue_player.stream = make_tone(880.0, 0.18, 0.6)
	die_player.stream = make_tone(180.0, 0.28, 0.6)
	ability_player.stream = make_tone(660.0, 0.08, 0.5)
	victory_player.stream = make_chord([523.0, 659.0, 784.0], 0.42, 0.55)
	failure_player.stream = make_tone(110.0, 0.55, 0.65)

func make_tone(frequency: float, duration: float, volume: float) -> AudioStreamWAV:
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = MIX_RATE
	stream.stereo = false
	var sample_count := int(duration * MIX_RATE)
	var data := PackedByteArray()
	data.resize(sample_count * 2)
	for i in sample_count:
		var t := float(i) / float(MIX_RATE)
		var env := exp(-3.0 * (t / duration))
		var s := sin(t * frequency * TAU) * env * volume
		data.encode_s16(i * 2, int(clamp(s * 32767.0, -32767.0, 32767.0)))
	stream.data = data
	return stream

func make_chord(frequencies: Array, duration: float, volume: float) -> AudioStreamWAV:
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = MIX_RATE
	stream.stereo = false
	var sample_count := int(duration * MIX_RATE)
	var data := PackedByteArray()
	data.resize(sample_count * 2)
	var n := float(frequencies.size())
	for i in sample_count:
		var t := float(i) / float(MIX_RATE)
		var env := exp(-2.5 * (t / duration))
		var s := 0.0
		for f in frequencies:
			s += sin(t * float(f) * TAU)
		s = (s / n) * env * volume
		data.encode_s16(i * 2, int(clamp(s * 32767.0, -32767.0, 32767.0)))
	stream.data = data
	return stream

func play_rescue() -> void:
	rescue_player.play()

func play_die() -> void:
	die_player.play()

func play_ability() -> void:
	ability_player.play()

func play_victory() -> void:
	victory_player.play()

func play_failure() -> void:
	failure_player.play()
