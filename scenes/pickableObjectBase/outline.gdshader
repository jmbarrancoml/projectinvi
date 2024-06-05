shader_type spatial;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform vec4 outline_color : source_color;
uniform float outline_width = 2.0;

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 pixelatedtext = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec2 pixel_size = 1.0 / VIEWPORT_SIZE;
	ALBEDO = pixelatedtext.rgb;
	
	for (int y = -int(outline_width); y <= int(outline_width); y++) {
		for (int x = -int(outline_width); x <= int(outline_width); x++) {
			vec4 tex = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(float(x), float(y))*pixel_size);
			if (tex.a == 0.0 &&
			SCREEN_UV.x + float(x) * pixel_size.x < 1.0 &&
			SCREEN_UV.x + float(x) * pixel_size.x > 0.0 &&
			SCREEN_UV.y + float(y) * pixel_size.y > 0.0 &&
			SCREEN_UV.y + float(y) * pixel_size.y > 0.0)
			{
				ALBEDO = outline_color.rgb;
				ALPHA = 1.0;
			}
		}
	}
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
