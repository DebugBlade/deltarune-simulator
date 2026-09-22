shader_type canvas_item;

uniform float strength: hint_range(0.0, 1.0);
uniform vec3 highlight_color: source_color = vec3(1.0);


void fragment() {
	//float strength = sin(TIME * 6.0) * 0.4 + 0.6;
	COLOR.rgb = mix(COLOR.rgb, highlight_color, strength);
}