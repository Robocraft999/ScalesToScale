shader_type canvas_item;

uniform float shake_block_size = 4;
uniform float shake_power = 0.02;
uniform float shake_speed = 1.5;
uniform float stop_y = 0.65f;


float random( float seed )
{
	return fract( 543.2543 * sin( dot( vec2( seed, seed ), vec2( 3525.46, -54.3415 ) ) ) );
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 fixed_uv = UV;
	vec2 pixel_size = TEXTURE_PIXEL_SIZE;
	if (UV.y < stop_y){
		fixed_uv.x += round((
			round( ((1.0f - UV.y) / stop_y) * shake_block_size ) / shake_block_size
		) * shake_power * sin(TIME) * shake_speed / pixel_size.x) * pixel_size.x;
	}


	vec4 pixel_color = texture( TEXTURE, fixed_uv, 0.0 );
	COLOR = pixel_color;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
