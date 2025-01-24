shader_type canvas_item;

// horizontal noise
uniform sampler2D noise1 : repeat_enable;
uniform sampler2D noise2 : repeat_enable;
uniform vec2 scroll1 = vec2(0.1, 0.0);
uniform vec2 scroll2 = vec2(-0.1, 0.0);
uniform float distortion_strength : hint_range(-1,1) = 0.02;

// pixel distortions
uniform sampler2D hologrampixel : repeat_enable, filter_nearest;
uniform sampler2D pixelposition : repeat_enable, filter_nearest;
uniform vec2 scrollpixel = vec2(-0.01, 0.01);

// color
uniform sampler2D gradient;

float rgb2v(vec3 c) {
	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
	vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
	return q.x;
}

void fragment() {
	// noise distortions
	float noise1x = texture(noise1, UV + scroll1 * TIME).r;
	float noise2x = texture(noise2, UV + scroll2 * TIME).r * 0.6;
	float depth = noise1x * noise2x;
	
	// pixel distortions
	vec2 offset = texture(pixelposition, vec2(TIME * 0.2)).rg;
	vec3 pixel_color = texture(hologrampixel, UV * 1.5 + offset + vec2(TIME * -0.07, 0.0)).rgb;
	float has_pixel = 1.0 - rgb2v(pixel_color); // either 1 for a pixel or 0 for white background, use as a mask
	
	// put stuff together
	float strong_distort = texture(hologrampixel, vec2(TIME * 0.02)).r; // either 1 or 0
	float adj_dist_strength = distortion_strength * strong_distort + -0.5 * (1.0 - strong_distort);
	
	vec2 screen_uv = UV
					+ (-0.05 * has_pixel)
					+ adj_dist_strength * vec2(depth, 0) * (1.0 - has_pixel);
	vec4 screen_color = texture(TEXTURE, screen_uv);
	
	// blue tint colorization
	float screen_value = rgb2v(screen_color.rgb);
	vec4 sampled_color = texture(gradient, vec2(screen_value, 0.0));
	sampled_color.a = screen_color.a / 5.0;
	
	COLOR = sampled_color;
}
