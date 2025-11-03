// Adjusted Version of this shader: https://godotshaders.com/shader/ripple-button-shader/
// using parts of this shader: https://godotshaders.com/shader/transparent-ripples/
shader_type canvas_item;

uniform vec2 ripple_origin = vec2(0.0, 0.0);
uniform float ripple_radius : hint_range(0.0, 1.0) = 0.0;
uniform float ripple_width : hint_range(0.01, 0.1) = 0.05;
uniform vec2 uv_scale = vec2 (1.0,0.5);

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

void fragment() {
    vec2 uv = UV * uv_scale - ripple_origin;
    float dist = length(uv);

    float ripple = smoothstep(ripple_radius, ripple_radius - ripple_width, dist) *
                   smoothstep(ripple_radius + ripple_width, ripple_radius, dist);

	float center_blend = smoothstep(0.0, ripple_radius - ripple_width, dist);


	vec4 background_texture = texture(SCREEN_TEXTURE, SCREEN_UV * ripple);// * sqrt(center_blend);
	float alpha_scalar = (1.0 - min(ripple_radius, 1.0)) * background_texture.x * 2.5; 
	
	background_texture.a *= 1.0 * alpha_scalar * (ripple + background_texture.x * background_texture.y);
	background_texture.a = max(background_texture.a - (background_texture.y * 0.45), 0.0);
	
	COLOR = vec4(background_texture.xyz, background_texture.a);
}
