shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform int pixel_size = 200;

void fragment() {
	vec2 grid_uv = round(UV * float(pixel_size)) / float(pixel_size);
	
	vec4 pixelated_texture = textureLod(screen_texture, grid_uv, 0.0);
	
	COLOR = pixelated_texture;
}