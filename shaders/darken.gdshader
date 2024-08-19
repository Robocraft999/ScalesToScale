shader_type canvas_item;

uniform float alpha = 0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR = vec4(0,0,0,alpha);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
