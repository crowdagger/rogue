shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float blur: hint_range(0.0, 5.0);
uniform vec4 rect_color: source_color;

void fragment() {
	vec4 bg_color = textureLod(screen_texture, SCREEN_UV, blur);
	vec4 color = texture(TEXTURE, UV);
	COLOR =  mix(rect_color, bg_color, 0.5);
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
