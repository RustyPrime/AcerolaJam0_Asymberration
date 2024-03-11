/*
Shader from Godot Shaders - the free shader library.
godotshaders.com/shader/pixelate

This shader is under CC0 license. Feel free to use, improve and 
change this shader according to your needs and consider sharing 
the modified result to godotshaders.com.
*/

/*
	Shader modified by RustyPrime to use screen texture instead of inputting a texture,
	also increased the pixel amount from 40 to 225
*/

shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform int pixel_size = 225;

void fragment() {
	vec2 grid_uv = round(UV * float(pixel_size)) / float(pixel_size);
	
	vec4 pixelated_texture = textureLod(screen_texture, grid_uv, 0.0);
	
	COLOR = pixelated_texture;
}