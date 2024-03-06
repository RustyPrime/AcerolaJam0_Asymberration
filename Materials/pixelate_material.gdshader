shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform int pixel_size = 2;



void fragment() {
	vec3 col = texture(screen_texture, SCREEN_UV).xyz * 0.16;
    col += texture(screen_texture, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE.x,  SCREEN_PIXEL_SIZE.y)).xyz * 0.15;
    col += texture(screen_texture, SCREEN_UV + vec2(-SCREEN_PIXEL_SIZE.x,-SCREEN_PIXEL_SIZE.y)).xyz * 0.15;
    col += texture(screen_texture, SCREEN_UV + vec2(2.0 * SCREEN_PIXEL_SIZE.x, 2.0 * SCREEN_PIXEL_SIZE.y)).xyz * 0.12;
    col += texture(screen_texture, SCREEN_UV + vec2(2.0 * -SCREEN_PIXEL_SIZE.x, 2.0 * -SCREEN_PIXEL_SIZE.y)).xyz * 0.12;
    col += texture(screen_texture, SCREEN_UV + vec2(3.0 * SCREEN_PIXEL_SIZE.x, 3.0 * SCREEN_PIXEL_SIZE.y)).xyz * 0.09;
    col += texture(screen_texture, SCREEN_UV + vec2(3.0 * -SCREEN_PIXEL_SIZE.x, 3.0 * -SCREEN_PIXEL_SIZE.y)).xyz * 0.09;
    col += texture(screen_texture, SCREEN_UV + vec2(4.0 * SCREEN_PIXEL_SIZE.x, 4.0 * SCREEN_PIXEL_SIZE.y)).xyz * 0.05;
    col += texture(screen_texture, SCREEN_UV + vec2(4.0 * -SCREEN_PIXEL_SIZE.x, 4.0 * -SCREEN_PIXEL_SIZE.y)).xyz * 0.05;
    COLOR.xyz = col;
}