shader_type canvas_item;

uniform vec2 center;
uniform float force;
uniform float size;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
void fragment() {
	float ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	vec2 scaled = (SCREEN_UV - vec2(0.5, 0))  / vec2(ratio, 1.0) + vec2(0.5, 0);
	float mask = smoothstep(size -0.1, size, length (scaled - center));
	mask = 1.0 - mask;
	mask = mask * smoothstep(size - 0.2, size - 0.1, length(scaled - center));
	vec2 disp = normalize(scaled - center) * force;
	disp = disp * mask;
	//COLOR = vec4(UV - disp, 0, 1);
	COLOR = texture(SCREEN_TEXTURE, SCREEN_UV - disp);
//	COLOR.rgb = vec3(mask);
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
