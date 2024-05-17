shader_type canvas_item;

uniform sampler2D noise;
uniform vec2 distortion_scale;
uniform float intensity;
uniform float speed;

void fragment() {
	//COLOR.rgb = vec3(1,1,1);
	float delta = sin(TIME*speed);
	delta -= floor(delta);
	delta = delta / 5.0;
	
	float dist = texture(noise, UV*distortion_scale +delta).x;
	//float dist = texture(noise, UV*distortion_scale + TIME*speed).x;
	dist -= 0.5;
	dist *= intensity;
	dist = abs(dist);
	dist = clamp(dist, 0.0, 1.0);
	vec2 new_uv = vec2(UV.x * 8.0, UV.y * 6.0);
	new_uv = new_uv - floor(new_uv);
	new_uv += dist;
	new_uv = clamp(new_uv, 0.0, 1.0);
	new_uv.x = new_uv.x / 8.0;
	new_uv.y = new_uv.y / 6.0;
	new_uv.y += 2.0/6.0;
	COLOR.rgb = texture(TEXTURE,new_uv).rgb;
	//COLOR = texture(TEXTURE, new_uv);//vec3(new_uv.x, new_uv.x, new_uv.x); //texture(TEXTURE, new_uv).rgb;
	//COLOR.rgb = texture(TEXTURE, UV).rgb - dist;
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
