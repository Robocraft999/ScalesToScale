shader_type canvas_item;

uniform float percentage = 0.5;
uniform vec3  overlay_color = vec3(0, 0, 0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 texture_size      = 1.0f / TEXTURE_PIXEL_SIZE;
	vec2 middle_point      = texture_size / 2.0f;
	vec2 distances         = abs(POINT_COORD - middle_point) / texture_size;
	vec2 distance_square   = distances * distances;
	float real_distance    = sqrt(distance_square.x + distance_square.y);
	
	float effective_distance = real_distance;
	if (real_distance > percentage) {
		effective_distance = 0.0f;
	}
	
	COLOR = vec4(
		mix(COLOR.x, overlay_color.x, effective_distance), 
		mix(COLOR.y, overlay_color.y, effective_distance),
		mix(COLOR.z, overlay_color.z, effective_distance),
		effective_distance
	);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
